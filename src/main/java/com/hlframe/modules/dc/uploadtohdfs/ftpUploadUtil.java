package com.hlframe.modules.dc.uploadtohdfs;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IOUtils;



public class ftpUploadUtil {
	
	
	
	public void getDirectoryFromHdfs() throws IllegalArgumentException, IOException{
		FileSystem fs = null;
		//初始化 
		try {
			fs = FileSystem.get(new URI("hdfs://10.1.20.137"), new Configuration(), "hdfs");
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		} 
		FileStatus[] filelist = fs.listStatus(new Path("/hldc/"));
		for(int i = 0; i<filelist.length; i++){
		System.out.println("***********");
		FileStatus fileStatus = filelist[i];
		System.out.println("Name:"+fileStatus.getPath().getName());
		System.out.println("Size:"+fileStatus.getLen());
		System.out.println("***********");
		}
		}

	/**
	 * 上传文件（可供Action/Controller层使用）
	 * 
	 * @param hostname
	 *            FTP服务器地址
	 * @param port
	 *            FTP服务器端口号
	 * @param username
	 *            FTP登录帐号
	 * @param password
	 *            FTP登录密码
	 * @param pathname
	 *            FTP服务器保存目录
	 * @param fileName
	 *            上传到FTP服务器后的文件名称
	 * @param inputStream
	 *            输入文件流
	 * @return
	 */
	public static boolean uploadFile(String hostname, int port, String username, String password, String pathname,
			String fileName, InputStream inputStream) {
		boolean flag = false;
		FTPClient ftpClient = new FTPClient();
		ftpClient.setControlEncoding("UTF-8");
		try {
			// 连接FTP服务器
			ftpClient.connect(hostname, port);
			// 登录FTP服务器
			ftpClient.login(username, password);
			// 是否成功登录FTP服务器
			int replyCode = ftpClient.getReplyCode();
			if (!FTPReply.isPositiveCompletion(replyCode)) {
				return flag;
			}

			ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
			ftpClient.makeDirectory(pathname);
			ftpClient.changeWorkingDirectory(pathname);
			ftpClient.storeFile(fileName, inputStream);
			inputStream.close();
			ftpClient.logout();
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ftpClient.isConnected()) {
				try {
					ftpClient.disconnect();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return flag;
	}

	/**
	 * 上传文件（可对文件进行重命名）
	 * 
	 * @param hostname
	 *            FTP服务器地址
	 * @param port
	 *            FTP服务器端口号
	 * @param username
	 *            FTP登录帐号
	 * @param password
	 *            FTP登录密码
	 * @param pathname
	 *            FTP服务器保存目录
	 * @param filename
	 *            上传到FTP服务器后的文件名称
	 * @param originfilename
	 *            待上传文件的名称（绝对地址）
	 * @return
	 */
	public static boolean uploadFileFromProduction(String hostname, int port, String username, String password,
			String pathname, String filename, String originfilename) {
		boolean flag = false;
		try {
			InputStream inputStream = new FileInputStream(new File(originfilename));
			flag = uploadFile(hostname, port, username, password, pathname, filename, inputStream);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	/**
	 * 上传文件（不可以进行文件的重命名操作）
	 * 
	 * @param hostname
	 *            FTP服务器地址
	 * @param port
	 *            FTP服务器端口号
	 * @param username
	 *            FTP登录帐号
	 * @param password
	 *            FTP登录密码
	 * @param pathname
	 *            FTP服务器保存目录
	 * @param originfilename
	 *            待上传文件的名称（绝对地址）
	 * @return
	 */
	public static boolean uploadFileFromProduction(String hostname, int port, String username, String password,
			String pathname, String originfilename) {
		boolean flag = false;
		try {
			String fileName = new File(originfilename).getName();
			InputStream inputStream = new FileInputStream(new File(originfilename));
			flag = uploadFile(hostname, port, username, password, pathname, fileName, inputStream);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	/**
	 * 删除文件
	 * 
	 * @param hostname
	 *            FTP服务器地址
	 * @param port
	 *            FTP服务器端口号
	 * @param username
	 *            FTP登录帐号
	 * @param password
	 *            FTP登录密码
	 * @param pathname
	 *            FTP服务器保存目录
	 * @param filename
	 *            要删除的文件名称
	 * @return
	 */
	public static boolean deleteFile(String hostname, int port, String username, String password, String pathname,
			String filename) {
		boolean flag = false;
		FTPClient ftpClient = new FTPClient();
		try {
			// 连接FTP服务器
			ftpClient.connect(hostname, port);
			// 登录FTP服务器
			ftpClient.login(username, password);
			// 验证FTP服务器是否登录成功
			int replyCode = ftpClient.getReplyCode();
			if (!FTPReply.isPositiveCompletion(replyCode)) {
				return flag;
			}
			// 切换FTP目录
			ftpClient.changeWorkingDirectory(pathname);
			ftpClient.dele(filename);
			ftpClient.logout();
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ftpClient.isConnected()) {
				try {
					ftpClient.logout();
				} catch (IOException e) {

				}
			}
		}
		return flag;
	}

	/**
	 * 下载文件
	 * 
	 * @param hostname
	 *            FTP服务器地址
	 * @param port
	 *            FTP服务器端口号
	 * @param username
	 *            FTP登录帐号
	 * @param password
	 *            FTP登录密码
	 * @param pathname
	 *            FTP服务器文件目录
	 * @param filename
	 *            文件名称
	 * @param localpath
	 *            下载后的文件路径
	 * @return
	 */
	public static boolean downloadFile(String hostname, int port, String username, String password, String pathname,
			String filename, String localpath) {
		boolean flag = false;
		FTPClient ftpClient = new FTPClient();
		try {
			// 连接FTP服务器
			ftpClient.connect(hostname, port);
			// 登录FTP服务器
			ftpClient.login(username, password);
			// 验证FTP服务器是否登录成功
			int replyCode = ftpClient.getReplyCode();
			if (!FTPReply.isPositiveCompletion(replyCode)) {
				return flag;
			}
			// 切换FTP目录
			ftpClient.changeWorkingDirectory(pathname);
			FTPFile[] ftpFiles = ftpClient.listFiles();
			for (FTPFile file : ftpFiles) {
				if (filename.equalsIgnoreCase(file.getName())) {
					File localFile = new File(localpath + "/" + file.getName());
					OutputStream os = new FileOutputStream(localFile);
					ftpClient.retrieveFile(file.getName(), os);
					os.close();
				}
			}
			ftpClient.logout();
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ftpClient.isConnected()) {
				try {
					ftpClient.logout();
				} catch (IOException e) {

				}
			}
		}
		return flag;
	}
	
	
	/**
	 * 递归文件夹内所有文件
	 * TODO
	 */
	public static void listAllFiles(FTPClient ftpClient, String pathname, List<FTPFile> fileList, int rootLength) throws IOException  {
		ftpClient.changeWorkingDirectory(pathname);
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
		}
	}
	
	/**
	 * 
	 * @方法名称: uploadFileToHDFS 
	 * @实现功能: 将ftp中文件上传至hdfs
	 * @param hostname
	 * @param port
	 * @param username
	 * @param password
	 * @param pathname
	 * @return
	 * @create by yuzh at 2016年11月24日 下午3:40:27
	 */
	public static boolean uploadFileToHDFS(String hostname, int port, String username, String password, String pathname) {
		boolean flag = false;
		SimpleDateFormat time = new SimpleDateFormat("yyyyMMddHHmmss");//设置日期格式
		String hdfsLog = "";//上传hdfs日志字段
		FTPClient ftpClient = new FTPClient();
		try {
			// 连接FTP服务器
			ftpClient.connect(hostname, port);
			// 登录FTP服务器
			ftpClient.login(username, password);
			// 验证FTP服务器是否登录成功
			int replyCode = ftpClient.getReplyCode();
			if (!FTPReply.isPositiveCompletion(replyCode)) {
				return flag;
			}
			// 切换FTP目录
			ftpClient.changeWorkingDirectory(pathname);
			//通过获取listAllFiles方法  递归获取ftp目录下所有文件信息
			List<FTPFile> allFiles = new ArrayList<FTPFile>();
			int rootLength = pathname.length();
			//listAllFiles(ftpClient, pathname, allFiles,rootLength);
			//创建hdfs连接
			FileSystem fs = null;
			//初始化 
			fs = FileSystem.get(new URI("hdfs://10.1.20.137"), new Configuration(), "hdfs"); //hdfs配置信息在dc_config中配置
			String createTime = time.format(new Date());//创建开始任务时间
			
			boolean flag1 = fs.delete(new Path("/hldc"),true);//如果是删除路径 把参数换成路径即可"/a/test4" 
			//第二个参数true表示递归删除，如果该文件夹下还有文件夹或者内容 ，会变递归删除，若为false则路径下有文件则会删除不成功 
			//boolean flag2 = fs.delete(new Path("/log12345.log"),true); 
			//boolean flag3 = fs.delete(new Path("/jdk"),true); 
			System.out.println("删除文件 or 路径"); 
			System.out.println("delete?"+flag1);//删除成功打印true 
			
			/*try{
			for (FTPFile file : allFiles) {
					hdfsLog = hdfsLog+time.format(new Date())+"----"+file.getName()+"----开始读取\n";
					InputStream in = ftpClient.retrieveFileStream("/"+file.getName().replace("*", "/"));//从ftp中读取文件写入流中
					hdfsLog = hdfsLog+time.format(new Date())+"----"+file.getName()+"----读取成功\n";
					hdfsLog = hdfsLog+time.format(new Date())+"----"+file.getName()+"----开始上传\n";
					String path = "/hldc/"+createTime+"/"+file.getName();//设置上传路径
					OutputStream os = fs.create(new Path(path));//创建上传流
					IOUtils.copyBytes(in, os, 1024, true);//从ftp中上传文件到HDFS  1024缓存
					hdfsLog = hdfsLog+time.format(new Date())+"----"+file.getName()+"----上传成功！\n-------------------\n";
					os.close();//关闭流
					in.close();//关闭流
					ftpClient.completePendingCommand();//手动完成ftpClient服务 不然无法再次调用ftpClient服务
				}
			//完成日志文件写入hdfs
			hdfsLog = hdfsLog+"上传完成！----共"+allFiles.size()+"个文件----";
			byte[] buff=hdfsLog.getBytes();//想要输入内容 
			Path path=new Path("/hldc/"+createTime+"/"+createTime+".txt");//日志文件存放路径及文件名称 
			FSDataOutputStream outputStream=fs.create(path); 
			outputStream.write(buff, 0, buff.length); 
			outputStream.close();
			}catch(Exception e){
				//中断情况下 写入日志文件到hdfs
				hdfsLog = hdfsLog+"操作失败，传输中断，请检查！\n";
				byte[] buff=hdfsLog.getBytes();//想要输入内容 
				Path path=new Path("/hldc/"+createTime+"/"+createTime+".txt");//日志文件存放路径及文件名称 
				FSDataOutputStream outputStream=fs.create(path); 
				outputStream.write(buff, 0, buff.length); 
				outputStream.close();
				}*/
			ftpClient.logout();
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ftpClient.isConnected()) {
				try {
					ftpClient.logout();
				} catch (IOException e) {
				}
			}
		}
		return flag;
	}
	
	
	public static boolean getFileNameList(String hostname, int port, String username, String password, String pathname) {
		boolean flag = false;
		FTPClient ftpClient = new FTPClient();
		try {
			// 连接FTP服务器
			ftpClient.connect(hostname, port);
			// 登录FTP服务器
			ftpClient.login(username, password);
			// 验证FTP服务器是否登录成功
			int replyCode = ftpClient.getReplyCode();
			if (!FTPReply.isPositiveCompletion(replyCode)) {
				return flag;
			}
			ftpClient.changeWorkingDirectory(pathname);
			String[] nameList = ftpClient.listNames();
			System.out.println("------>start");
			for(String fileName:nameList){
				System.out.println(fileName);
			}
			System.out.println("------>end");
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ftpClient.isConnected()) {
				try {
					ftpClient.logout();
				} catch (IOException e) {

				}
			}
		}
		return flag;
	}

}
