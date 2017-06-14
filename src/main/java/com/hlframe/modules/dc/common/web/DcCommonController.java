package com.hlframe.modules.dc.common.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.utils.DcCommonUtils;
import com.hlframe.modules.sys.utils.FileUtil;

/**
 * @类名: com.hlframe.modules.dc.common.web.DcCommonController.java 
 * @职责说明:一些公有方法
 * @创建者: cdd
 * @创建时间: 2017年1月24日 下午4:02:18
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/common")
public class DcCommonController extends BaseController{
	
	/**
	 * @方法名称: getFieldByField
	 * @实现功能: 根据某一个字段获取一张表的一个字段
	 * @param oldFieldName
	 * @param fieldValue
	 * @param tableName
	 * @param newFieldName
	 * @return
	 * @create by cdd at 2016年12月1日 下午3:51:44
	 */
	@ResponseBody
	@RequestMapping(value = "getFieldByField")
	public String getFieldByField(String oldFieldName, String fieldValue, String tableName, String newFieldName) {
		return DcCommonUtils.getFieldByField(oldFieldName, fieldValue, tableName, newFieldName);// 根据某一个字段获取某张表的一个字段
	}
	
	/**
	 * @方法名称: loadTomcatInformation
	 * @实现功能: 下载tomcat最近500行的日志
	 * @return
	 * @create by cdd at 2016年12月1日 下午3:52:15
	 */
	@ResponseBody
	@RequestMapping(value = "loadTomcatInformation")
	public void loadTomcatInformation(HttpServletRequest request, HttpServletResponse response) {
		try {
			FileUtil.LoadTomcatInformation(request, response);// 下载tomcat最近500行的日志
		} catch (Exception e) {
			// return "下载失败";
			logger.error("FileUtil.LoadTomcatInformation()" + e);
		}
	}
}
