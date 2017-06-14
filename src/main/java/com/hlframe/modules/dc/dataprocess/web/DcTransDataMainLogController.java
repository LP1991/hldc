/********************** 版权声明 *************************
 * 文件名: DcTransDataMainLogController.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年12月3日 下午3:26:45
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataMainLog;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSubLog;
import com.hlframe.modules.dc.dataprocess.service.DcTransDataMainLogService;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcTransDataMainLogController.java 
 * @职责说明: 转换过程日志
 * @创建者: peijd
 * @创建时间: 2016年12月3日 下午3:26:45
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/transLog")
public class DcTransDataMainLogController extends BaseController {

	@Autowired
	DcTransDataMainLogService transLogService;
	

	/**
	 * @方法名称: latestProLog 
	 * @实现功能: 转换过程日志
	 * @param log	  日志对象
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月3日 下午3:32:29
	 */
	@RequestMapping(value = "latestProLog")
	public String latestProLog(DcTransDataSubLog log , Model model) {
		//Id不为空 转换为对象  
		if(StringUtils.isNotEmpty(log.getSubId())){
			log = transLogService.getLatestProLog(log.getSubId());
		}
		model.addAttribute("proLog", log);
		return "modules/dc/dataProcess/dcTransData/dcTransProcessLog";       //查看页面
	}
	
	/**
	 * @方法名称: latestTaskLog 
	 * @实现功能: 转换任务日志
	 * @param log
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月3日 下午6:08:50
	 */
	@RequestMapping(value = "latestTaskLog")
	public String latestTaskLog(DcTransDataMainLog log , Model model) {
		//Id不为空 转换为对象  
		if(StringUtils.isNotEmpty(log.getJobId())){
			log = transLogService.getLatestTaskLog(log.getJobId());
		}
		model.addAttribute("taskLog", log);
		return "modules/dc/dataProcess/dcTransData/dcTransTaskLog";       //查看页面
	}
}
