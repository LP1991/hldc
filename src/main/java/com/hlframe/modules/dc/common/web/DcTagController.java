/********************** 版权声明 *************************
 * 文件名: DcTagController.java
 * 包名: com.hlframe.modules.dc.common.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月21日 下午10:02:15
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.common.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hlframe.modules.sys.web.TagController;

/** 
 * @类名: com.hlframe.modules.dc.common.web.DcTagController.java 
 * @职责说明: 数据中心标签选择 控制器
 * @创建者: peijd
 * @创建时间: 2016年11月21日 下午10:02:15
 */
@Controller
@RequestMapping(value = "${adminPath}/dctag")
public class DcTagController extends TagController {

	/**
	 * @方法名称: dcTreeselect 
	 * @实现功能: 数据中心 树选择控件, 增加5个额外参数,用于扩展
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月21日 下午10:06:49
	 */
	@RequestMapping(value = "dcTreeselect")
	public String dcTreeselect(HttpServletRequest request, Model model) {
		
//		model.addAttribute("dbSourceId", request.getParameter("dbSourceId"));	// 数据源连接
//		model.addAttribute("schema", request.getParameter("schema"));			// 数据库schema
		
		//用于扩展
		model.addAttribute("otherParam1", request.getParameter("otherParam1"));			// 自定义参数1
		model.addAttribute("otherParam2", request.getParameter("otherParam2"));			// 自定义参数2
		model.addAttribute("otherParam3", request.getParameter("otherParam3"));			// 自定义参数3
		model.addAttribute("otherParam4", request.getParameter("otherParam4"));			// 自定义参数4
		model.addAttribute("otherParam5", request.getParameter("otherParam5"));			// 自定义参数5
		
		model.addAttribute("clearItem", request.getParameter("clearItem"));			// 清除选择项
		//添加其他参数
		super.treeselect(request, model);
		//返回到定制页面 
		return "modules/dc/common/dcTagTreeselect";
	}
	
	/**
	 * 
	 * @方法名称: dcTreeselect 
	 * @实现功能: 返回到定制页面
	 * @param request
	 * @param model
	 * @return
	 * @create by hgw at 2017年4月21日 上午11:54:18
	 */
	@RequestMapping(value = "dcTreeselect2")
	public String dcTreeselect2(HttpServletRequest request, Model model) {
		
//		model.addAttribute("dbSourceId", request.getParameter("dbSourceId"));	// 数据源连接
//		model.addAttribute("schema", request.getParameter("schema"));			// 数据库schema
		
		//用于扩展
		model.addAttribute("otherParam1", request.getParameter("otherParam1"));			// 自定义参数1
		model.addAttribute("otherParam2", request.getParameter("otherParam2"));			// 自定义参数2
		model.addAttribute("otherParam3", request.getParameter("otherParam3"));			// 自定义参数3
		model.addAttribute("otherParam4", request.getParameter("otherParam4"));			// 自定义参数4
		model.addAttribute("otherParam5", request.getParameter("otherParam5"));			// 自定义参数5
		
		model.addAttribute("clearItem", request.getParameter("clearItem"));			// 清除选择项
		//添加其他参数
		super.treeselect(request, model);
		//返回到定制页面 
		return "modules/dc/common/dcTagTreeselect2";
	}
}
