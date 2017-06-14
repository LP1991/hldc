/********************** 版权声明 *************************
 * 文件名: DcDbController.java
 * 包名: com.hlframe.modules.dc.metadata.web.linkdb
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月21日 下午7:26:52
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.web.linkdb;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.metadata.service.linkdb.DbHandleService;

/** 
 * @类名: com.hlframe.modules.dc.metadata.web.linkdb.DcDbController.java 
 * @职责说明: TODO
 * @创建者: peijd
 * @创建时间: 2016年11月21日 下午7:26:52
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/db")
public class DcDbController extends BaseController {


	@Autowired
	private DbHandleService dbHandleService;
	
	/**
	 * @方法名称: schemaTreeData 
	 * @实现功能: 获取数据库中 schema列表
	 * @param extId
	 * @param type
	 * @param grade
	 * @param isAll
	 * @param request
	 * @return
	 * @create by peijd at 2016年11月22日 下午2:51:00
	 */
	@ResponseBody
	@RequestMapping(value = "schemaTreeData")
	public List<Map<String, Object>> schemaTreeData(@RequestParam(required=false) String extId, @RequestParam(required=false) String type,
			@RequestParam(required=false) Long grade, @RequestParam(required=false) Boolean isAll, HttpServletRequest request) {
		
		//获取数据源连接
		String fromLinkId = (String) request.getParameter("otherParam1");
		
		return dbHandleService.queryschemaNameTree(fromLinkId);
	}
	

	/**
	 * @方法名称: tableTreeData 
	 * @实现功能: 获取数据库中  table/view列表
	 * @param extId
	 * @param type
	 * @param grade
	 * @param isAll
	 * @param response
	 * @return
	 * @create by peijd at 2016年11月21日 下午3:11:39
	 */
	@ResponseBody
	@RequestMapping(value = "tableTreeData")
	public List<Map<String, Object>> tableTreeData(@RequestParam(required=false) String extId, @RequestParam(required=false) String type,
			@RequestParam(required=false) Long grade, @RequestParam(required=false) Boolean isAll, HttpServletRequest request) {
		
		//获取数据源连接
		String fromLinkId = (String) request.getParameter("otherParam1");
		String schema = (String) request.getParameter("otherParam2");
		
		return dbHandleService.queryTableNameTree(fromLinkId, schema);
	}
	
	/**
	 * @方法名称: tableFieldData 
	 * @实现功能: 获取数据库中  table/view列表
	 * @param extId
	 * @param type
	 * @param grade
	 * @param isAll
	 * @param request
	 * @return
	 * @create by peijd at 2016年11月22日 上午11:38:28
	 */
	@ResponseBody
	@RequestMapping(value = "tableFieldData")
	public List<Map<String, Object>> tableFieldData(@RequestParam(required=false) String extId, @RequestParam(required=false) String type,
			@RequestParam(required=false) Long grade, @RequestParam(required=false) Boolean isAll, HttpServletRequest request) {
		
		//获取数据源连接
		String fromLinkId = (String) request.getParameter("otherParam1");
		String schema = (String) request.getParameter("otherParam2");
		String tableName = (String) request.getParameter("otherParam3");
		
		return dbHandleService.queryTableFieldTree(fromLinkId, schema, tableName);
	}
}
