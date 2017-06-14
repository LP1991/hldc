package com.hlframe.modules.dc.dataprocess.web;


import java.util.List;
import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveDatabase;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveTable;
import com.hlframe.modules.dc.dataprocess.service.DcHiveTableService;
import com.hlframe.modules.dc.dataprocess.service.DcQueryHiveService;

/**
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcQueryHiveController.java 
 * @职责说明: 关于QueryHive的操作
 * @创建者: cdd
 * @创建时间: 2017年1月24日 下午3:56:43
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/queryHive")
public class DcQueryHiveController  extends BaseController{
	@Autowired
	private DcHiveTableService dcHiveTableService;
	@Autowired
	private DcQueryHiveService dcQueryHiveService;
	
	/**
	 * @方法名称: list
	 * @实现功能: 页面首页
	 * @param obj
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月10日 下午7:40:57
	 */
	@RequiresPermissions("dc:queryHive:list")
	@RequestMapping(value = { "list", "" })
	public String list(DcHiveTable obj, Model model) {
		List<DcHiveDatabase> dbList = dcHiveTableService.getHiveDatabase();// 获得hive表空间
		//显示所有数据库列表
		model.addAttribute("dbList", dbList);
		List<Map<String,Object>> hisList = dcHiveTableService.getHistoryMsg();
		model.addAttribute("hisList", hisList);
		return "modules/dc/dataProcess/QueryHive/queryHiveList";
	}
	
	
	/**
	 * @方法名称: getAllHiveTableNames 
	 * @实现功能: 获得某个表空间下所有的表名
	 * @param dbName
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月17日 上午9:02:31
	 */
	@ResponseBody
	@RequestMapping(value = "getAllHiveTableNames")
	public AjaxJson getAllHiveTableNames(String dbName,Model model) {
		AjaxJson ajaxJson = new AjaxJson();
		//返回的是由数据库查出的表信息
		List<Map<String,Object>> tableList  = dcQueryHiveService.getAllHiveTableNames(dbName);//导入hive数据表信息
		ajaxJson.put("tableNames", tableList);
		return ajaxJson;
	}
	
	/**
	 * @方法名称: runSql 
	 * @实现功能: 执行sql语句
	 * @param sql
	 * @param dbName
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月18日 下午2:58:01
	 */
	@ResponseBody
	@RequestMapping(value = "runSql")
	public AjaxJson runSql(String sql,String dbName,Model model) {
		AjaxJson ajaxJson = new AjaxJson();
		List<Map<String,Object>> dataList  = dcQueryHiveService.runSql(sql,dbName);//导入hive数据表信息
		ajaxJson.put("dataList", dataList);
		return ajaxJson;
	}
	
	/**
	 * @方法名称: hiveDS 
	 * @实现功能: 数据同步
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月18日 下午2:58:38
	 */
	@ResponseBody
	@RequestMapping(value = "hiveDS")
	public AjaxJson hiveDS(Model model) {
		AjaxJson ajaxJson = new AjaxJson();
		try{
		 dcQueryHiveService.hiveDS();//导入hive数据表信息
		 ajaxJson.setMsg("同步成功");
		}catch(Exception e){
			ajaxJson.setMsg("同步失败");
		}
		return ajaxJson;
	}
	
	/**
	 * 查询hive历史信息
	 */
	@ResponseBody
	@RequestMapping(value = "getHistory")
	public AjaxJson getHistory(){
		AjaxJson ajaxJson = new AjaxJson();
		List<Map<String,Object>> dataList = dcHiveTableService.getHistoryMsg();
		ajaxJson.put("dataList", dataList);
		return ajaxJson;
	}
}
