/********************** 版权声明 *************************
 * 文件名: DcHdfsFileController.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月23日 下午3:40:49
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.web;

import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataprocess.entity.DcHdfsFile;
import com.hlframe.modules.dc.dataprocess.entity.DcJobDb2Hdfs;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransHdfs;
import com.hlframe.modules.dc.dataprocess.service.DcHdfsFileService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransDataService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransHdfsService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.dc.utils.HbaseClientUtils;
import com.hlframe.modules.dc.utils.HiveClientUtils;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcHdfsFileController.java 
 * @职责说明: hdfs文件处理Controller
 * @创建者: peijd
 * @创建时间: 2016年11月23日 下午3:40:49
 */

@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/hdfs")
public class DcHdfsFileController extends BaseController{
	
	@Autowired
	private DcHdfsFileService dcHdfsFileService;

	@Autowired
	private DcJobTransDataService dcJobTransDataService;
	
	@Autowired
	private DcJobTransHdfsService dcJobTransHdfsService;
	
	/**
	 * @方法名称: listHdfsFile 
	 * @实现功能: 查看Hdfs文件列表
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月24日 下午3:46:25
	 */
	@RequestMapping(value = "listHdfsFile")
	public String listHdfsFile(DcJobTransData obj, Model model) {
		//配置信息
		DcJobDb2Hdfs hdfs = dcJobTransDataService.buildJobData(obj.getId());
		model.addAttribute("dcJob", hdfs);
		
		//如果数据类型为hive  构建hive数据
		if(DcJobTransData.TOLINK_HIVE.equals(hdfs.getToLink())) {
			List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
			try {//可以根据序列字段/时间倒序显示 (order by 字段 desc), 但是要通过job计算, 影响查看效率
				dataList = HiveClientUtils.buildHiveMeteMap("select * from "+hdfs.getOutputTable());
			} catch (Exception e) {
				logger.error("-->listHdfsFile", e);
			}
			model.addAttribute("columnList", dataList);
			model.addAttribute("message", "默认显示"+DcPropertyUtils.getProperty("queryHive.result.dataLimit","20")+"条记录!");
			return "modules/dc/dataProcess/dcJobTransData/dcJobDataStoreHive";
			
		// 如果数据类型为Hbase 构建Hbase数据	
		}else if(DcJobTransData.TOLINK_HBASE.equals(hdfs.getToLink())){
			List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
			try {
				dataList = HbaseClientUtils.buildHbaseMeteMap(hdfs.getOutputTable());
			} catch (Exception e) {
				logger.error("-->listHdfsFile", e);
			}
			model.addAttribute("columnList", dataList);
			model.addAttribute("message", "Hbase数据预览!");
			return "modules/dc/dataProcess/dcJobTransData/dcJobDataStoreHbase";
		}
		
		//默认显示hdfs文件列表
		List<DcHdfsFile> list = dcHdfsFileService.listFileByDir(hdfs.getOutputDir());
		model.addAttribute("list", list);
		return "modules/dc/dataProcess/dcJobTransData/dcJobDataStoreList";
	}
	
	/**
	 * @方法名称: listHdfsFileByHdfsJob 
	 * @实现功能: 根据hdfs采集Job 查看结果列表
	 * @param fileDir
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月27日 下午2:29:03
	 */
	@RequestMapping(value = "listHdfsFileByHdfsJob")
	public String listHdfsFileByHdfsJob(DcJobTransHdfs fileDir, Model model) {
		fileDir = dcJobTransHdfsService.get(fileDir.getId());
		//文件列表
		List<DcHdfsFile> list = dcHdfsFileService.listFileByDir(fileDir.getOutPutDir());
		model.addAttribute("list", list);
		DcJobDb2Hdfs hdfs = new DcJobDb2Hdfs();
		hdfs.setJobName(fileDir.getJobName());
		hdfs.setOutputDir(fileDir.getOutPutDir());
		model.addAttribute("dcJob", hdfs);
		return "modules/dc/dataProcess/dcJobTransData/dcJobDataStoreList";
	}
	
	
	/**
	 * @方法名称: viewContent 
	 * @实现功能: 查看hdfs文件内容 
	 * @param file	hdfs文件
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月24日 下午5:50:24
	 */
	@RequestMapping(value = "viewContent")
	public String viewContent(DcHdfsFile file,String line, Model model) {
		//加载文件内容
		dcHdfsFileService.loadFileContent(file, line);
		model.addAttribute("hdfsFile", file);
		return "modules/dc/dataProcess/dcJobTransData/dcHdfsFileContent";
	}
	
	/**
	 * @方法名称: exportHdfsFile 
	 * @实现功能: 导出Hdfs文件内容
	 * @param file
	 * @param request
	 * @param response
	 * @throws Exception
	 * @create by peijd at 2016年11月24日 下午8:00:46
	 */
	@RequestMapping("exportHdfsFile")  
	public void exportHdfsFile(DcHdfsFile file, String line ,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			//加载文件内容
			dcHdfsFileService.loadFileContent(file , line);
			//构建导出数据
			byte[] data = file.getContent().getBytes("UTF-8"); 
			response.reset();
			response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getFileName() + ".txt\"");
			response.addHeader("Content-Length", "" + data.length);
			response.setContentType("application/octet-stream;charset=UTF-8");
			OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
			outputStream.write(data);
			outputStream.flush();
			outputStream.close();
			response.flushBuffer();
			
		} catch (Exception e) {
			logger.error("--->exportHdfsFile", e);
		}
	}
	
}
