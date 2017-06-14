/********************** 版权声明 *************************
 * 文件名: proController.java
 * 包名: com.hlframe.modules.dc.metadata.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：hgw   创建时间：2017年3月27日 下午7:13:13
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.metadata.entity.Pro;
import com.hlframe.modules.dc.metadata.service.ProService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;

/** 
 * @类名: com.hlframe.modules.dc.metadata.web.proController.java 
 * @职责说明: TODO
 * @创建者: hgw
 * @创建时间: 2017年3月27日 下午7:13:13
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/properties")
public class ProController extends BaseController {
	@Autowired
	private ProService proService;
	
	@RequestMapping(value = {"proList", ""})
	public String proList(Model model){
		return "modules/dc/metaData/dcObjectMain/proList";
	}
	
	@ResponseBody		
	@RequestMapping(value="save")
	public AjaxJson save(Pro pro){
		AjaxJson ajaxJson = new AjaxJson();
		String dirPath = DcPropertyUtils.class.getResource("/").getPath();
		DcPropertyUtils.writerProperties(dirPath+"dc_config.properties",pro.getKey(),pro.getValue());
		return ajaxJson;
	}
	
	@ResponseBody
	@RequestMapping(value="ajaxlist")
	public DataTable ajaxlist(Pro proper, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Pro> page = proService.findProList(new Page<Pro>(request), proper);
		DataTable a = new DataTable();
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		a.setRecordsTotal((int)page.getCount());
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(page.getList()));
		return a;
	}
}
