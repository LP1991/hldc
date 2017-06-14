/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.dc.dataprocess.service;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ConnectException;
import java.net.ServerSocket;
import java.net.URI;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.hlframe.modules.dc.metadata.dao.DcObjectMainDao;
import com.hlframe.modules.dc.utils.Des;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.service.CrudService;
import com.hlframe.common.service.ServiceException;
import com.hlframe.common.utils.IdGen;
import com.hlframe.common.utils.PropertiesLoader;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.dao.DcJobHdfslogDao;
import com.hlframe.modules.dc.dataprocess.dao.DcJobTransFileDao;
import com.hlframe.modules.dc.dataprocess.dao.DcJobTransFileHdfsDao;
import com.hlframe.modules.dc.dataprocess.entity.DcJobHdfslog;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransFile;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransFileHdfs;
import com.hlframe.modules.dc.metadata.entity.DcObjectFile;
import com.hlframe.modules.dc.metadata.entity.DcObjectFolder;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.service.DcMetadataStroeService;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.service.DcTaskMainService;
import com.hlframe.modules.dc.schedule.service.task.DcTaskService;
import sun.net.ftp.FtpClient;

/**
 * 采集传输文件Service
 * @author phy
 * @version 2016-11-23
 */
@Service
@Transactional(readOnly = true)
public class DcJobTransFileService extends CrudService<DcJobTransFileDao, DcJobTransFile> implements DcTaskService {

	@Autowired
	private DcTaskMainService taskMainService;
	@Autowired
	private DcJobHdfslogDao dcJobHdfslogDao;
	@Autowired
	private DcJobTransFileHdfsDao dcJobTransFileHdfsDao;
	@Autowired	//元数据存储Service
	private DcMetadataStroeService dcMetadataStroeService;
	@Autowired //源数据service
	private DcObjectMainDao dcObjectMainDao;
	public DcJobTransFile get(String id) {
		return super.get(id);
	}

	public List<DcJobTransFile> findList(DcJobTransFile dcJobTransFile) {
		return super.findList(dcJobTransFile);
	}


	public Page<DcJobTransFile> findPage(Page<DcJobTransFile> page, DcJobTransFile dcJobTransFile) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		dcJobTransFile.getSqlMap().put("dsf", dataScopeFilter(dcJobTransFile.getCurrentUser(),"o","u"));
		// 设置分页参数
		dcJobTransFile.setPage(page);
		// 执行分页查询
		page.setList(dao.findList(dcJobTransFile));
		return super.findPage(page, dcJobTransFile);
	}

	/**
	 * Override
	 * @方法名称: save
	 * @实现功能: TODO 保存文件 元数据  测试
	 * @param dcJobTransFile
	 * @create by peijd at 2017年3月4日 下午6:54:50
	 */
	@Transactional(readOnly = false)
	public void save(DcJobTransFile dcJobTransFile) {
		//更新标记
		boolean updateFlag = StringUtils.isNotBlank(dcJobTransFile.getId());
		//设置记录默认状态
		if(StringUtils.isBlank(dcJobTransFile.getStatus()) ){
			dcJobTransFile.setStatus(dcJobTransFile.TASK_STATUS_EDIT);
		}
		super.save(dcJobTransFile);
		String jobId = StringUtils.isNotBlank(dcJobTransFile.getId())?dcJobTransFile.getId():IdGen.uuid();
		//保存从表对象  peijd
		DcJobTransFileHdfs job = dcJobTransFile.getDcJobTransFileHdfs();
		job.setJobId(dcJobTransFile.getId());
		if(updateFlag){
			dcJobTransFileHdfsDao.update(job);
		}else{
			dcJobTransFileHdfsDao.insert(job);
		}

		//保存文件采集源对象   元数据  peijd
		DcObjectMain objMain = new DcObjectMain();
		DcObjectMain pser= new DcObjectMain();

		pser.setJobId(jobId);
		pser.setJobSrcFlag("N");
		objMain = dcObjectMainDao.get(pser);
		if(null==objMain){
			objMain = new DcObjectMain();
			objMain.setId(IdGen.uuid());
		}

		//hdfs采集任务 元数据
		objMain.setObjCode(jobId);
		objMain.setObjName(dcJobTransFile.getJobname());
		objMain.setObjDesc(dcJobTransFile.getDescription());
		objMain.setObjType(objMain.OBJ_TYPE_FOLDER);
		objMain.setJobId(jobId);
		objMain.setJobType(objMain.JOB_TYPE_EXTRACT_FILE);
		objMain.setJobSrcFlag(objMain.JOB_SRC_FLAG_NO);	//FTP文件 元数据
		dcJobTransFile.setId(jobId);
		//hdfs目录信息
		DcObjectFolder objFolder = new  DcObjectFolder();
		objFolder.setObjId(objMain.getId());
		objFolder.setFolderName(job.getPathname());
		objFolder.setFolderUrl(job.getPathname());

		dcMetadataStroeService.obj2MySQL(objMain, objFolder, new ArrayList<DcObjectFile>(), false);
	}

	/**
	 * Override
	 * @方法名称: delete
	 * @实现功能: 删除之前验证, 是否添加任务
	 * @param dcJobTransFile
	 * @create by peijd at 2017年3月10日 上午10:32:05
	 */
	@Transactional(readOnly = false)
	public void delete(DcJobTransFile entity) {

		Assert.hasText(entity.getId());
		entity = dao.get(entity.getId());
		Assert.notNull(entity);
		// 判断任务状态 如果是调度任务  则不可删除
		if(DcJobTransFile.TASK_STATUS_TASK.equals(entity.getStatus())){
			throw new ServiceException("该任务已添加调度任务, 不可删除!");
		}
		super.delete(entity);
	}

	public List<DcJobHdfslog> getHdfslogs(DcJobHdfslog dcJobHdfslog) {
		List<DcJobHdfslog> dcJobHdfslogs =dcJobHdfslogDao.findList(dcJobHdfslog);
		return dcJobHdfslogs;
	}


	/**
	 * 递归文件夹内所有文件
	 * TODO
	 */
	public static void listAllFiles(FTPClient ftpClient, String pathname, List<FTPFile> fileList, int rootLength) throws IOException  {
/*		boolean f = ftpClient.changeWorkingDirectory(pathname);
		for (FTPFile file : ftpClient.listFiles()){
			if (file.isDirectory()){
				listAllFiles(ftpClient, pathname+"/"+file.getName(), fileList, rootLength);
			}else{
				if(pathname.length()>rootLength){
					file.setName((pathname.substring(rootLength+1)+"*"+file.getName()).replace("/", "*"));
					fileList.add(file);
					}else{
						fileList.add(file);
					}
			}
		}*/
		String dir = null;
		if(pathname.startsWith("/")){
			dir = pathname.replaceFirst("/","./");
			dir = new String(dir.getBytes("utf-8"),"iso-8859-1");
		}
		boolean fp =  ftpClient.changeWorkingDirectory(dir);
		for (FTPFile file : ftpClient.listFiles()){
			if (file.isDirectory()){
				fileList.add(file);
				if(pathname.equals("/")){
					listAllFiles(ftpClient, pathname+file.getName(), fileList, rootLength);
					ftpClient.changeToParentDirectory();
				}else{
					listAllFiles(ftpClient, pathname+"/"+file.getName(), fileList, rootLength);
					ftpClient.changeToParentDirectory();
				}
			}else{
				if(pathname.length()>rootLength){
					file.setName((pathname+"*"+file.getName()).replace("/", "*"));
					fileList.add(file);
				}else{
					fileList.add(file);
				}
			}
		}
	}



	/**
	 * @方法名称: ftpUploadToHDFS
	 * @实现功能: 从ftp中下载文件上传至hdfs
	 * @param id
	 * @create by yuzh at 2016年11月24日 下午5:40:20
	 * @update by peijd 实现调度任务接口,
	 */
	@Transactional(readOnly = false)
	public DcDataResult runTask(String id) throws Exception {
		DcDataResult taskResult = new DcDataResult();
		DcJobTransFileHdfs dcJobTransFileHdfs = dcJobTransFileHdfsDao.get(id);
		DcJobTransFile dcJobTransFile = dao.get(id);
		String indexName = dcJobTransFile.getJobname();
		//dcJobTransFileHdfs.setPathname(dcJobTransFileHdfs.getPathname().replaceFirst("/","./"));
/*		if(dcJobTransFileHdfs.getPathname().endsWith("/")){ // / ./  ./ggg  /ggg
			if(!"./".equals(dcJobTransFileHdfs.getPathname())){
				dcJobTransFileHdfs.setPathname(dcJobTransFileHdfs.getPathname().substring(0,dcJobTransFileHdfs.getPathname().length()-1));
			}
		}*/
		if(dcJobTransFileHdfs.getPathname().endsWith("/")){
			if(!"/".equals(dcJobTransFileHdfs.getPathname())){
				dcJobTransFileHdfs.setPathname(dcJobTransFileHdfs.getPathname().substring(0,dcJobTransFileHdfs.getPathname().length()-1));
			}
		}
		DcJobHdfslog dcjobHdfslog = new DcJobHdfslog();

		SimpleDateFormat time = new SimpleDateFormat("yyyyMMddHHmmss");//设置日期格式
		String hdfsLog = "";//上传hdfs日志字段
		FTPClient ftpClient = new FTPClient();
		try {
			// 连接FTP服务器
			ftpClient.connect(dcJobTransFileHdfs.getIp(), dcJobTransFileHdfs.getPort());
			//设置utf-8编码
			ftpClient.setControlEncoding("utf-8");
			// 登录FTP服务器
			ftpClient.login(dcJobTransFileHdfs.getAccount(), Des.strDec(dcJobTransFileHdfs.getPassword()));
			// 验证FTP服务器是否登录成功
			int replyCode = ftpClient.getReplyCode(); //530用户或密码错误
			if(replyCode==530){
				hdfsLog = "账号或密码错误，请检查！\n\r";
				taskResult.setRst_flag(false);
				taskResult.setRst_err_msg(hdfsLog);
				dcjobHdfslog.setStatus("失败!");
				return taskResult;
			}

			String p =null;
			if(dcJobTransFileHdfs.getPathname().startsWith("/")){
				p=dcJobTransFileHdfs.getPathname().replaceFirst("/","./");
			}
			boolean flag = ftpClient.changeWorkingDirectory(p);
			if(!flag){
				hdfsLog = "目录异常，目录不存在！\n\r";
				taskResult.setRst_flag(false);
				taskResult.setRst_err_msg(hdfsLog);
				dcjobHdfslog.setStatus("失败!");
				return taskResult;
			}
			replyCode = ftpClient.getReplyCode();
			String status = ftpClient.getStatus(dcJobTransFileHdfs.getPathname());
			if(status!=null||status==null){
				taskResult.setRst_flag(false);
				taskResult.setRst_err_msg("1");
				dcjobHdfslog.setStatus("失败!");
				return taskResult;
			}
			// 切换FTP目录
			//boolean f  = ftpClient.changeWorkingDirectory(dcJobTransFileHdfs.getPathname());
			//通过获取listAllFiles方法  递归获取ftp目录下所有文件信息
			List<FTPFile> allFiles = new ArrayList<FTPFile>();
			int rootLength = dcJobTransFileHdfs.getPathname().length();  //./  ./test
			listAllFiles(ftpClient, dcJobTransFileHdfs.getPathname(), allFiles,rootLength);
			//创建hdfs连接
			FileSystem fs = null;
			//初始化
			PropertiesLoader loader = new PropertiesLoader("dc_config.properties");
			String address=loader.getProperty("hadoop.main.address");
			fs = FileSystem.get(new URI("hdfs://"+address), new Configuration(), "hdfs"); //hdfs配置信息在dc_config中配置
			String createTime = time.format(new Date());//创建开始任务时间
			/*
			 * 测试用删除根目录下所有文件
			 *
			boolean flag1 = fs.delete(new Path("/hldc"),true);//如果是删除路径 把参数换成路径即可"/a/test4"
			//第二个参数true表示递归删除，如果该文件夹下还有文件夹或者内容 ，会变递归删除，若为false则路径下有文件则会删除不成功
			//boolean flag2 = fs.delete(new Path("/log12345.log"),true);
			//boolean flag3 = fs.delete(new Path("/jdk"),true);
			System.out.println("删除文件 or 路径");
			System.out.println("delete?"+flag1);//删除成功打印true
			 */
			String hdfsPath = "/hldc/" + indexName + "/" + createTime;
			try {
				for (FTPFile file : allFiles) {
					//如果是文件，直接创建文件夹
					if(file.isDirectory()){
						fs.mkdirs(new Path(hdfsPath+ "/" + file.getName()));
						continue;
					}
					hdfsLog = hdfsLog + time.format(new Date()) + "----" + file.getName() + "----开始读取\n\r";
					ftpClient.enterLocalPassiveMode();
					//InputStream in = ftpClient.retrieveFileStream(dcJobTransFileHdfs.getPathname() + "/" + file.getName().replace("*", "/"));// 从ftp中读取文件写入流中
					String path = dcJobTransFileHdfs.getPathname() ;
					if(path.startsWith("/")){
						path = path.replaceFirst("/","./");
					}
					//boolean f  = ftpClient.changeWorkingDirectory(path);
					String s = ftpClient.printWorkingDirectory();
					System.out.println(file.getName().replace("*", "/"));
					String fileName  = file.getName().replace("*","/");

					int t =fileName.lastIndexOf("/");
					String firhh = null;
					String lashh = null;
					InputStream in = null;
					if(t!=-1){
						firhh  = fileName.substring(0,fileName.lastIndexOf("/"));
						lashh = fileName.substring(fileName.lastIndexOf("/")+1,fileName.length());
						ftpClient.changeWorkingDirectory(firhh);
						in = ftpClient.retrieveFileStream(lashh);// 从ftp中读取文件写入流中
					}else{
						in = ftpClient.retrieveFileStream(file.getName().replace("*", "/"));// 从ftp中读取文件写入流中
					}
					//in = ftpClient.retrieveFileStream( file.getName().replace("*", "/"));// 从ftp中读取文件写入流中
					hdfsLog = hdfsLog + time.format(new Date()) + "----" + fileName + "----读取成功\n\r";
					hdfsLog = hdfsLog + time.format(new Date()) + "----" + fileName + "----开始上传\n\r";
					OutputStream os = fs.create(new Path(hdfsPath+ "/" + fileName));// 创建上传流
					IOUtils.copyBytes(in, os, 1024, true);// 从ftp中上传文件到HDFS, 1024缓存
					hdfsLog = hdfsLog + time.format(new Date()) + "----" + fileName + "----上传成功！\n\r-------------------\n\r";
					os.close();// 关闭流
					in.close();// 关闭流
					ftpClient.completePendingCommand();// 手动完成ftpClient服务, 不然无法再次调用ftpClient服务
				}
				//TODO: 保存目录/文件元数据信息 ftp端只存储目录元数据
				saveTransMetaData(dcJobTransFileHdfs, dcJobTransFile, hdfsPath, allFiles);

				// 完成日志文件写入hdfs
				hdfsLog = hdfsLog + "上传完成！----共" + allFiles.size() + "个文件----";
				byte[] buff = hdfsLog.getBytes("utf-8");// 想要输入内容
				Path path = new Path(hdfsPath + "/" + createTime + ".log");// 日志文件存放路径及文件名称
				FSDataOutputStream outputStream = fs.create(path);
				outputStream.write(buff, 0, buff.length);
				outputStream.close();
				taskResult.setRst_flag(true);
				taskResult.setRst_std_msg(hdfsLog);
				dcjobHdfslog.setStatus("成功!");

			}catch(Exception e){
				//中断情况下 写入日志文件到hdfs
				hdfsLog = hdfsLog+"操作失败，传输中断，请检查！\n\r";
				byte[] buff=hdfsLog.getBytes("utf-8");//想要输入内容
				Path path=new Path(hdfsPath+"/"+createTime+".log");//日志文件存放路径及文件名称
				FSDataOutputStream outputStream=fs.create(path);
				outputStream.write(buff, 0, buff.length);
				outputStream.close();
				taskResult.setRst_flag(false);
				taskResult.setRst_err_msg(hdfsLog+"明细: "+e.getMessage());
				dcjobHdfslog.setStatus("失败!");
			}
			dcjobHdfslog.setJobId(id);
			dcjobHdfslog.setUploadTime(createTime);
			dcjobHdfslog.setFullpath(hdfsPath+"/"+createTime+".log");

			dcJobHdfslogDao.insert(dcjobHdfslog);

			//更新任务状态
			if(DcJobTransFile.TASK_STATUS_EDIT.equals(dcJobTransFile.getStatus())){
				DcJobTransFile updateJob = new DcJobTransFile();
				updateJob.setStatus(DcJobTransFile.TASK_STATUS_TEST);
				updateJob.setId(id);
				updateJob.preUpdate();
				dao.update(updateJob);
			}


		}catch(ConnectException e){
			hdfsLog = "IP或端口连接失败，请检查！\n\r";
			taskResult.setRst_flag(false);
			taskResult.setRst_err_msg(hdfsLog);
			dcjobHdfslog.setStatus("失败!");
		} catch (Exception e) {
			logger.error("-->extract file from ftp : ", e);
			taskResult.setRst_flag(false);
			taskResult.setRst_err_msg(e.getMessage());
		} finally {
			if (ftpClient.isConnected()) {
				try {
					ftpClient.logout();
				} catch (IOException e) {
					logger.error("-->ftpClient.logout error: ", e);
				}
			}
		}

		return taskResult;
	}


	/**
	 * @方法名称: saveTransMetaData
	 * @实现功能: 更新上传文件元数据信息
	 * @param transHdfs	采集配置信息
	 * @param job		job任务信息
	 * @param fs		hdfs文件配置
	 * @param allFiles	文件列表
	 * @create by peijd at 2017年3月4日 上午10:44:08
	 */
	private void saveTransMetaData(DcJobTransFileHdfs transFile, DcJobTransFile job, String hdfsPath, List<FTPFile> allFiles) {

		DcObjectMain objMain = new DcObjectMain();
		DcObjectFolder objFolder = new  DcObjectFolder();
		List<DcObjectFile> fileList = new ArrayList<DcObjectFile>();

		//hdfs采集任务 元数据
		objMain.setId(IdGen.uuid());
		objMain.setObjCode(job.getId());
		objMain.setObjName(job.getJobname());
		objMain.setObjDesc(job.getDescription());
		objMain.setObjType(objMain.OBJ_TYPE_FILE);
		objMain.setJobId(job.getId());
		objMain.setJobType(objMain.JOB_TYPE_EXTRACT_FILE);
		objMain.setJobSrcFlag(objMain.JOB_SRC_FLAG_YES);	//hdfs文件 元数据

		//hdfs目录信息
		objFolder.setObjId(objMain.getId());
		objFolder.setFolderName(StringUtils.substringAfterLast(hdfsPath, "/"));	//
		objFolder.setFolderUrl(hdfsPath);
		DcObjectFile objFile = null;
		//hdfs文件列表
		for(FTPFile file: allFiles){
			objFile = new DcObjectFile();
			objFile.setId(IdGen.uuid());
			objFile.setFileName(file.getName());
			objFile.setFileUrl(hdfsPath+"/"+file.getName());
			fileList.add(objFile);
		}

		//保存文件元数据信息
		dcMetadataStroeService.obj2MySQL(objMain, objFolder, fileList, true);
	}

	/**
	 * @方法名称: getJobName
	 * @实现功能: 验证jobname不重复
	 * @param jobName
	 * @return
	 * @create by yuzh at 2016年11月25日 下午4:34:26
	 */
	public Object getJobName(String jobname) {
		return dao.getJobName(jobname);
	}

	/**
	 * @方法名称: add2Schedule
	 * @实现功能: 添加至调度任务
	 * @param jobId
	 * @return
	 * @create by peijd at 2016年12月27日 下午8:46:08
	 */
	@Transactional(readOnly = false)
	public String add2Schedule(String jobId) {
		Assert.hasText(jobId);
		//检查调度任务是否存在
		DcTaskMain taskMain = taskMainService.get(jobId);
		Assert.isTrue(null==taskMain || StringUtils.isBlank(taskMain.getId()), "该调度任务已存在!");

		DcJobTransFile transJob = dao.get(jobId);
		String taskName = "文件采集_"+transJob.getJobname();
		//调度任务
		taskMain = new DcTaskMain();
		//ID
		taskMain.setId(jobId);
		//任务名称
		taskMain.setTaskName(taskName);
		//调用方法
		taskMain.setMethodName("runTask");
		//任务描述
		taskMain.setTaskDesc(transJob.getDescription());
		//任务来源
		taskMain.setTaskPath(DcTaskMain.TASK_FROMTYPE_EXTRACT_FILE);
		//优先级
		taskMain.setPriority("1");
		//任务状态
		taskMain.setStatus(taskMain.TASK_STATUS_EDIT);
		//参数
		taskMain.setParameter(jobId);
		//调用方法
		taskMain.setClassName(this.getClass().getName());
		//内部类
		taskMain.setTaskType(DcTaskMain.TASK_TYPE_INNERCLASS);
		taskMainService.insert(taskMain);

		//更新记录状态
		DcJobTransFile updateObj = new DcJobTransFile();
		//	updateObj.preUpdate();//
		updateObj.preInsert();//bao gang 2017.4.24  9:30
		updateObj.setId(jobId);
		updateObj.setStatus(updateObj.TASK_STATUS_TASK);	//更新为调度状态
		dao.update(updateObj);

		return "添加调度任务["+taskName+"]成功!";
	}

	/**
	 * @方法名称: updateStatus
	 * @实现功能: 更新对象状态
	 * @param id
	 * @param taskStatusEdit
	 * @create by peijd at 2017年3月10日 下午2:46:54
	 */
	@Transactional(readOnly = false)
	public void updateStatus(String objId, String status){
		Assert.hasText(objId);
		status = StringUtils.isEmpty(status)?DcJobTransFile.TASK_STATUS_EDIT:status;
		DcJobTransFile obj = new DcJobTransFile();
		obj.setId(objId);
		obj.setStatus(status);
		obj.preUpdate();
		dao.update(obj);
	}

	/**
	 * @实现功能: ftp树
	 * @param ip
	 * @param port
	 * @param account
	 * @param password
	 * @Author hgw data 2017 5 9
	 */
	public List<Map<String,Object>> treeData(String ip,String port,String account,String password){
		FTPClient ftpClient = new FTPClient();
		try{
			ftpClient.setDefaultPort(Integer.parseInt(port));
			ftpClient.connect(ip);
			ftpClient.setControlEncoding("utf-8");
			ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
			ftpClient.login(account, Des.strDec(password));
			//ftpClient.changeWorkingDirectory(dcJobTransFile.getDcJobTransFileHdfs().getPathname());
			ftpClient.enterLocalActiveMode();
			String file = ftpClient.getStatus();
			List<Map<String,Object>> ftpList=new ArrayList<Map<String,Object>>();
			dgMap(ftpClient,"/","0",true,"/",ftpList);
			return  ftpList;
		}catch(Exception e){
			return null;
		}
	}

	public void dgMap(FTPClient ftpClient,String path,String parent,boolean isDir,String gname,List<Map<String,Object>> ftpList) throws Exception{
		String dir = null; // / /dd
		//拼接文件夹路径
		if(path.equals("/")){
			path="/";
		}else{
			path=parent+gname;
			dir = parent+gname;
		}
		if(path.startsWith("/")){
			dir = path.replaceFirst("/","./");
		}
		Map<String,Object> map = null;
		if(isDir){
			map = new HashMap<String,Object>();
			map.put("id", path);
			map.put("pId", parent);
			map.put("name", gname);
			map.put("isParent", true);
			ftpList.add(map);
			FTPFile[] filelist = ftpClient.listDirectories(dir);
			for(int i=0;i<filelist.length;i++){
				FTPFile ftpFile = filelist[i];

				boolean flag = ftpFile.isDirectory();
				System.out.println(ftpFile.getName()+"___");
				dgMap(ftpClient,ftpFile.getName(),path,flag,ftpFile.getName(),ftpList);
			}
		}
	}

	//判断路径是否存在
	public boolean isDirExist(FTPClient ftpClient, String dir){
		boolean flag = false;
		try{
			//ftpClient
		}catch(Exception e){
			return flag;
		}
		return flag;
	}

	//递归所有文件夹
/*	public void getDirList(FTPClient ftpClient,String path,boolean isDir,List<String> pathList) throws Exception{
		if(isDir) {
			FTPFile[] filelist = ftpClient.listDirectories(path);
			for (int i = 0; i < filelist.length; i++) {
				FTPFile ftpFile = filelist[i];
				ftpFile.getName();
				boolean flag = ftpFile.isDirectory();
				System.out.println(ftpFile.getName() + "___");
				getDirList(ftpClient, pp, isdir);
			}
		}
	}*/
}