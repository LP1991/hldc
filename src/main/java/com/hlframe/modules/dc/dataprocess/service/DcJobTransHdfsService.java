/********************** 版权声明 *************************
 * 文件名: DcJobTransHdfsService.java
 * 包名: com.hlframe.modules.dc.dataprocess.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月16日 下午9:00:57
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.service;

import java.net.URI;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.service.CrudService;
import com.hlframe.common.service.ServiceException;
import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.utils.IdGen;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.dao.DcJobTransHdfsDao;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransHdfs;
import com.hlframe.modules.dc.metadata.entity.DcObjectFile;
import com.hlframe.modules.dc.metadata.entity.DcObjectFolder;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.service.DcMetadataStroeService;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.service.DcTaskMainService;
import com.hlframe.modules.dc.schedule.service.task.DcTaskService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.dc.metadata.dao.DcObjectMainDao;
import net.neoremind.sshxcute.core.ConnBean;
import net.neoremind.sshxcute.core.SSHExec;
import net.neoremind.sshxcute.task.CustomTask;
import net.neoremind.sshxcute.task.impl.ExecCommand;

/**
 * @类名: com.hlframe.modules.dc.dataprocess.service.DcJobTransHdfsService.java
 * @职责说明: 数据转换任务 Service
 * @创建者: peijd
 * @创建时间: 2016年11月16日 下午9:00:57
 */
@Service
@Transactional(readOnly = true)
public class  DcJobTransHdfsService extends CrudService<DcJobTransHdfsDao, DcJobTransHdfs> implements DcTaskService {

	@Autowired
	private DcHdfsFileService hdfsService;
	@Autowired
	private DcMetadataStroeService dcMetadataStroeService;
	@Autowired
	private DcTaskMainService taskMainService;
	@Autowired //源数据service
	private DcObjectMainDao dcObjectMainDao;

	private DcJobTransDataService dcJobTransDataService;

	/**
	 * @实现功能: 数据权限过滤
	 * @create by yuzh at 2016年12月15日 15:30:29
	 */
	public Page<DcJobTransHdfs> findPage(Page<DcJobTransHdfs> page, DcJobTransHdfs dcJobTransHdfs) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		dcJobTransHdfs.getSqlMap().put("dsf", dataScopeFilter(dcJobTransHdfs.getCurrentUser(),"o","u"));
		// 设置分页参数
		dcJobTransHdfs.setPage(page);
		// 执行分页查询
		page.setList(dao.findList(dcJobTransHdfs));
		return super.findPage(page, dcJobTransHdfs);
	}

	/**
	 * Override
	 * @方法名称: save
	 * @实现功能: 保存hdfs采集对象  及元数据信息
	 * @param entity
	 * @create by peijd at 2017年3月6日 下午1:50:37
	 */
	@Override
	@Transactional(readOnly = false)
	public void save(DcJobTransHdfs transHdfsJob) {
		Assert.notNull(transHdfsJob);
		//设置记录默认状态
		if(StringUtils.isBlank(transHdfsJob.getStatus()) ){
			transHdfsJob.setStatus(transHdfsJob.TASK_STATUS_EDIT);
		}
		super.save(transHdfsJob);
		String jobId = StringUtils.isNotBlank(transHdfsJob.getId())?transHdfsJob.getId():IdGen.uuid();

		//元数据 主体对象
		DcObjectMain pser= new DcObjectMain();
		DcObjectMain objMain = new DcObjectMain();
		pser.setJobId(jobId);
		pser.setJobSrcFlag("N");
		objMain = dcObjectMainDao.get(pser);
		if(null==objMain){
			objMain = new DcObjectMain();
			objMain.setId(IdGen.uuid());
		}


		//hdfs采集任务 元数据
		//objMain.setId(IdGen.uuid());
		objMain.setObjCode(jobId);
		objMain.setObjName(transHdfsJob.getSrcHdfsDir());
		objMain.setObjDesc(transHdfsJob.getJobDesc());
		if(transHdfsJob.getSqr().equals("true")) {
			objMain.setObjType(objMain.OBJ_TYPE_FOLDER);
			objMain.setJobId(jobId);
			objMain.setJobType(objMain.JOB_TYPE_EXTRACT_HDFS);
			objMain.setJobSrcFlag(objMain.JOB_SRC_FLAG_NO);	//FTP文件 元数据
			transHdfsJob.setId(jobId);
			//hdfs目录信息
			DcObjectFolder objFolder = new  DcObjectFolder();
			objFolder.setObjId(objMain.getId());
			objFolder.setFolderName(transHdfsJob.getSrcHdfsDir());
			objFolder.setFolderUrl("hdfs://"+transHdfsJob.getSrcHdfsAddress()+transHdfsJob.getSrcHdfsDir());
			dcMetadataStroeService.obj2MySQL(objMain, objFolder, new ArrayList<DcObjectFile>(), false);
		}else{
			objMain.setObjType(objMain.OBJ_TYPE_FILE);
			objMain.setJobId(jobId);
			objMain.setJobType(objMain.JOB_TYPE_EXTRACT_HDFS);
			objMain.setJobSrcFlag(objMain.JOB_SRC_FLAG_NO);	//FTP文件 元数据
			transHdfsJob.setId(jobId);
			//hdfs文件信息
			DcObjectFile file = new DcObjectFile();
			file.setObjId(objMain.getId());
			file.setFileName(transHdfsJob.getSrcHdfsDir());
			file.setFileUrl("hdfs://"+transHdfsJob.getSrcHdfsAddress()+transHdfsJob.getSrcHdfsDir());
			dcMetadataStroeService.obj2MySQL(objMain, file);
		}

		try {
			saveTransMetaData(transHdfsJob, false);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * @方法名称: runTask
	 * @实现功能: 运行采集任务
	 * @param jobId
	 * @throws Exception
	 * @create by peijd at 2016年11月27日 下午2:10:28
	 * @update by peijd at 2017-02-16 实现调度任务接口
	 */
	@Transactional(readOnly = false)
	public DcDataResult runTask(String jobId) throws Exception {
		Assert.hasText(jobId);
		DcDataResult taskResult = new DcDataResult();
		StringBuilder result = new StringBuilder(1024);
		//构建数据对象
		DcJobTransHdfs job = dao.get(jobId);
		Assert.notNull(job);

		StringBuilder taskScript = new StringBuilder(200);
		if(StringUtils.isBlank(job.getRemarks())){
			taskScript.append("sudo -u hdfs hadoop distcp -update -skipcrccheck ");
			//是否覆盖
			if("1".equalsIgnoreCase(job.getIsOverride())){
				taskScript.append(" -overwrite ");
			}
			//设置线程数
			if(job.getCopyNum()>0){
				taskScript.append(" -m ").append(job.getCopyNum());
			}
			//设置hdfs来源数据
			taskScript.append(" ").append("2".equals(job.getSrcHdfsVersion())?"hdfs":"hftp").append(":// ").append(job.getSrcHdfsAddress()).append(job.getSrcHdfsDir());
			//设置hdfs存储目录
			taskScript.append(" ").append(job.getOutPutDir());
		}else{
			taskScript.append(job.getRemarks());
		}

		//sqoop客户端连接
		String sqoopServer = DcPropertyUtils.getProperty("distcp.client.address");
		String sqoopUser = DcPropertyUtils.getProperty("distcp.client.loginUser");
		String sqoopPswd = DcPropertyUtils.getProperty("distcp.client.loginPswd");
		try {
			Date beginDate = new Date();	//开始执行时间
			/** 创建ssh连接实例 **/
			ConnBean cb = new ConnBean(sqoopServer, sqoopUser, sqoopPswd);
			SSHExec ssh = SSHExec.getInstance(cb);
			// 连接到hdfs
			ssh.connect();
			logger.debug("--> hdfs script: "+taskScript.toString());
			CustomTask sampleTask2 = new ExecCommand(taskScript.toString());
			net.neoremind.sshxcute.core.Result res = ssh.exec(sampleTask2);
			ssh.disconnect();

			//更新转换元数据信息
			saveTransMetaData(job, true);
			job.setLogDir(hdfsService.buildBizLoggerPath(job.getId(), "extract_HDFS_"+beginDate.getTime()));

			//记录日志
			result.append("-->任务名称: ").append(job.getJobName());
			result.append("<br>-->开始时间: ").append(DateUtils.formatDateTime(beginDate));
			result.append("<br>-->结束时间: ").append(DateUtils.formatDateTime(new Date()));
			result.append("<br>-->调用结果: ").append(res.rc==0?"成功":"失败");
			result.append("<br>-->简要日志: <br>  ").append(res.sysout);
			result.append("<br>-->详细日志: <br>  ").append(res.error_msg);
			//保存日志路径
			DcJobTransHdfs updateJob = new DcJobTransHdfs();
			updateJob.setId(jobId);
			updateJob.setLogDir(hdfsService.buildBizLoggerPath(jobId, "extract_hdfs_"+beginDate.getTime()));
			//更新任务状态
			if(updateJob.TASK_STATUS_EDIT.equals(job.getStatus())){
				updateJob.setStatus(updateJob.TASK_STATUS_TEST);
			}
			updateJob.preUpdate();
			dao.update(updateJob);

			//写入业务日志
			hdfsService.writeData2Hdfs(job.getLogDir(), result.toString().replaceAll("<br>", "\r\n"));

			taskResult.setRst_flag(true);
			taskResult.setRst_std_msg(result.toString());

		} catch (Exception e) {
			logger.error("-->DcJobTransHdfsService: runTask", e);
			taskResult.setRst_flag(false);
			taskResult.setRst_err_msg(e.getMessage());
		}
		return taskResult;
	}

	/**
	 * @方法名称: saveTransMetaData
	 * @实现功能: 保存hdfs采集元数据信息
	 * @param jobId
	 * @param job
	 * @param updateFile	是否更新子文件
	 * @throws Exception
	 * @create by peijd at 2017年3月6日 下午1:53:25
	 */
	private void saveTransMetaData(DcJobTransHdfs transHdfsJob, boolean updateFile) throws Exception {
		//插入目标对象元数据
		DcObjectMain dcObjectMain = new DcObjectMain();


		dcObjectMain.setId(transHdfsJob.getId());
		dcObjectMain.setJobId(transHdfsJob.getId());
		dcObjectMain.setJobSrcFlag(dcObjectMain.JOB_SRC_FLAG_YES);		//非源对象
		dcObjectMain.setJobType(dcObjectMain.JOB_TYPE_EXTRACT_HDFS);	//采集任务
		dcObjectMain.setObjName(transHdfsJob.getJobName());	// TODO: 目录、文件名
		dcObjectMain.setObjDesc(transHdfsJob.getJobDesc());

		if(transHdfsJob.getSqr().equals("true")){	//保存目录
			dcObjectMain.setObjType(dcObjectMain.OBJ_TYPE_FOLDER);

			DcObjectFolder dcObjectFolder = new DcObjectFolder();
			dcObjectFolder.setId(transHdfsJob.getId());
			dcObjectFolder.setFolderName(transHdfsJob.getOutPutDir().substring(transHdfsJob.getOutPutDir().lastIndexOf("/")+1));
			System.out.println(dcObjectFolder);
			dcObjectFolder.setFolderUrl(transHdfsJob.getOutPutDir());

			try {
				List<DcObjectFile> fileList = new ArrayList<DcObjectFile>();
				if(updateFile) {
					List<FileStatus> tmpAllFile = new ArrayList<FileStatus>();
					hdfsService.listFiles(transHdfsJob.getSrcHdfsDir(), tmpAllFile);
					for (FileStatus files : tmpAllFile) {
						DcObjectFile dcObjectFile = new DcObjectFile();
						dcObjectFile.setId(transHdfsJob.getId());
						dcObjectFile.setFileName(files.getPath().getName());	//TODO: 文件全路径
						dcObjectFile.setFileUrl(files.getPath().toString());
						fileList.add(dcObjectFile);
					}
				}
				dcMetadataStroeService.obj2MySQL(dcObjectMain, dcObjectFolder, fileList, true);
			} catch (Exception e) {
				logger.error("-->saveTransMetaData: ", e);
			}
		}else{
			dcObjectMain.setObjType(DcObjectMain.OBJ_TYPE_FILE);
			//保存文件对象
			DcObjectFile file = new DcObjectFile();
			file.setObjId(transHdfsJob.getId());
			file.setFileName(transHdfsJob.getSrcHdfsDir());
			file.setFileUrl("hdfs://"+transHdfsJob.getSrcHdfsAddress()+transHdfsJob.getSrcHdfsDir());
			try{
				dcMetadataStroeService.obj2MySQL(dcObjectMain, file);
			}catch (Exception e){
				logger.error("-->saveTransMetaData: ", e);
			}
		}



	}


	/**
	 * @方法名称: getJobName
	 * @实现功能: 验证jobname不重复
	 * @param jobName
	 * @return
	 * @create by yuzh at 2016年11月25日 下午1:46:48
	 */
	public Object getJobName(String jobName) {
		// TODO Auto-generated method stub
		return dao.getJobName(jobName);
	}

	/**
	 * @方法名称: add2Schedule
	 * @实现功能: 添加至调度任务
	 * @param jobId
	 * @return
	 * @create by peijd at 2016年12月27日 下午8:41:25
	 */
	@Transactional(readOnly = false)
	public String add2Schedule(String jobId) {
		Assert.hasText(jobId);
		//检查调度任务是否存在 
		DcTaskMain taskMain = taskMainService.get(jobId);
		Assert.isTrue(null==taskMain || StringUtils.isBlank(taskMain.getId()), "该调度任务已存在!");

		DcJobTransHdfs transJob = dao.get(jobId);
		String taskName = "HDFS文件采集_"+transJob.getJobName();
		//调度任务
		taskMain = new DcTaskMain();
		//ID
		taskMain.setId(jobId);
		//任务名称
		taskMain.setTaskName(taskName);
		//调用方法
		taskMain.setMethodName("runTask");
		//任务描述
		taskMain.setTaskDesc(transJob.getJobDesc());
		//任务来源
		taskMain.setTaskPath(DcTaskMain.TASK_FROMTYPE_EXTRACT_HDFS);
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
		DcJobTransHdfs updateObj = new DcJobTransHdfs();
		updateObj.setId(jobId);
		updateObj.setStatus(updateObj.TASK_STATUS_TASK);	//更新为调度状态
		updateObj.preUpdate();
		dao.update(updateObj);

		return "添加调度任务["+taskName+"]成功!";
	}

	/**
	 * Override
	 * @方法名称: delete
	 * @实现功能: 删除数据
	 * @param entity
	 * @create by peijd at 2017年3月10日 上午10:47:06
	 */
	@Override
	@Transactional(readOnly = false)
	public void delete(DcJobTransHdfs entity) {

		Assert.hasText(entity.getId());
		entity = dao.get(entity.getId());
		Assert.notNull(entity);
		// 判断任务状态 如果是调度任务  则不可删除
		if(DcJobTransHdfs.TASK_STATUS_TASK.equals(entity.getStatus())){
			throw new ServiceException("该任务已添加调度任务, 不可删除!");
		}
		super.delete(entity);
		//DcCommonService.deleteEsByIndex( entity.getId(), "1");
	}

	/**
	 * @方法名称: updateStatus
	 * @实现功能: 更新业务状态
	 * @param id
	 * @param taskStatusEdit
	 * @create by peijd at 2017年3月10日 下午2:48:49
	 */
	@Transactional(readOnly = false)
	public void updateStatus(String objId, String status){
		Assert.hasText(objId);
		status = StringUtils.isEmpty(status)?DcJobTransHdfs.TASK_STATUS_EDIT:status;
		DcJobTransHdfs obj = new DcJobTransHdfs();
		obj.setId(objId);
		obj.setStatus(status);
		obj.preUpdate();
		dao.update(obj);
	}

	/**
	 *
	 * @方法名称: hdfsCheshi
	 * @实现功能: 测试时存储路径树
	 * @param address
	 * @create by hgw at 2017年4月8日 上午11:00:40
	 */
	public void hdfsCheshi(String srcHdfsAddress) throws Exception{
		Configuration conf = new Configuration();
		conf.set("dfs.socket.timeout", "3000");
		conf.set("dfs.datanode.socket.read.timeout", "3000");
		FileSystem fs = FileSystem.get(new URI("hdfs://"+srcHdfsAddress),conf, "hdfs");//hdfs配置信息在dc_config中配置
		boolean f = fs.exists(new Path("/"));
		if(!f){
			throw new Exception();
		}



	}

	public void dgMap(String address,FileSystem fs,String path,String parent,boolean isDir,String gname,List<Map<String,Object>> hdfsList) throws Exception{
		Map<String,Object> map = null;
		if(isDir){
			map = new HashMap<String,Object>();
			map.put("id", path);
			map.put("pId", parent);
			//map.put("pIds", "");
			map.put("name", gname);
			map.put("isParent", true);
			hdfsList.add(map);
			FileStatus[] filelist = fs.listStatus(new Path(path));
			for(int i=0;i<filelist.length;i++){
				FileStatus fileStatus = filelist[i];
				String p = fileStatus.getPath().toString().
						replaceFirst("hdfs://"+address, "");
				String pa = fileStatus.getPath().getParent().toString().
						replaceFirst("hdfs://"+address, "");
				String name = fileStatus.getPath().getName().toString();
				boolean flag = fileStatus.isDirectory();
				dgMap(address,fs,p,pa,flag,name,hdfsList);
			}
		}else{
			map = new HashMap<String,Object>();
			map.put("id", path);
			map.put("pId", parent);
			//map.put("pIds", "");
			map.put("name", gname);
			map.put("isParent", false);
			hdfsList.add(map);
		}
	}

	public List<Map<String,Object>> treeData(String srcHdfsAddress){
		try {
			//String srcHdfsAddress="10.1.70.200:8020";
			System.out.println(srcHdfsAddress);
			List<Map<String,Object>> hdfsList=new ArrayList<Map<String,Object>>();
			FileSystem fs = FileSystem.get(new URI("hdfs://"+srcHdfsAddress),new Configuration(), "hdfs");//hdfs配置信息在dc_config中配置
			dgMap(srcHdfsAddress,fs,"/","0",true,"/",hdfsList);
			return hdfsList;
		} catch (Exception e) {
			return null;
		}
	}

	public List<Map<String,Object>> treeData2(String srcHdfsAddress){
		try{
			//String srcHdfsAddress="10.1.70.200:8020";
			System.out.println(srcHdfsAddress);
			List<Map<String,Object>> hdfsList=new ArrayList<Map<String,Object>>();
			FileSystem fs = FileSystem.get(new URI("hdfs://"+srcHdfsAddress),new Configuration(), "hdfs");//hdfs配置信息在dc_config中配置
			dgMapTwo(srcHdfsAddress,fs,"/","0",true,"/",hdfsList);
			return hdfsList;
		}catch(Exception e){
			return null;
		}
	}

	public void dgMapTwo(String address,FileSystem fs,String path,String parent,boolean isDir,String gname,List<Map<String,Object>> hdfsList) throws Exception{
		Map<String,Object> map = null;
		if(isDir){
			map = new HashMap<String,Object>();
			map.put("id", path);
			map.put("pId", parent);
			//map.put("pIds", "");
			map.put("name", gname);
			map.put("isParent", true);
			hdfsList.add(map);
			FileStatus[] filelist = fs.listStatus(new Path(path));
			for(int i=0;i<filelist.length;i++){
				FileStatus fileStatus = filelist[i];
				String p = fileStatus.getPath().toString().
						replaceFirst("hdfs://"+address, "");
				String pa = fileStatus.getPath().getParent().toString().
						replaceFirst("hdfs://"+address, "");
				String name = fileStatus.getPath().getName().toString();
				boolean flag = fileStatus.isDirectory();
				dgMapTwo(address,fs,p,pa,flag,name,hdfsList);
			}
		}
	}
}

