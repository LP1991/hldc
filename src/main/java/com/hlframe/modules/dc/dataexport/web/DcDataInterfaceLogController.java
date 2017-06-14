/********************** 版权声明 *************************
 * 文件名: DcDataInterfaceLogController.java
 * 包名: com.hlframe.modules.dc.dataexport.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年2月23日 下午5:06:04
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataexport.web;

import com.google.gson.Gson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataexport.entity.DcDataInterfaceLog;
import com.hlframe.modules.dc.dataexport.service.DcDataInterfaceLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;


/** 
 * @类名: com.hlframe.modules.dc.dataexport.web.DcDataInterfaceLogController.java 
 * @职责说明: 元数据接口访问日志 controller
 * @创建者: peijd
 * @创建时间: 2017年5月4日 下午5:00:04
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataExport/interfaceLog")
public class DcDataInterfaceLogController extends BaseController {
	@Autowired
	private DcDataInterfaceLogService intfLogService;
	
	/**
	 * @方法名称: list 
	 * @实现功能: 配置列表
	 * @param log
	 * @param model
	 * @return
	 * @create by peijd at 2017/5/4 17:18
	 */
	@RequestMapping(value = "list")
	public String list(DcDataInterfaceLog log , Model model) {
		model.addAttribute("intfLog", log);
		return "modules/dc/dataexport/interfaceLogList";
	}
	
	/**
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax 翻页查询
	 * @param log
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2017/5/4 17:26:46
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcDataInterfaceLog log, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcDataInterfaceLog> page = intfLogService.findPage(new Page<DcDataInterfaceLog>(request), log);
		List<DcDataInterfaceLog> list = page.getList();
		DataTable a = new DataTable();
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		a.setRecordsTotal((int)page.getCount());
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(list));
		return a;
	}
	
	/**
	 * @方法名称: view 
	 * @实现功能: 查看数据导出配置
	 * @param log
	 * @param model
	 * @return
	 * @create by peijd at 2017/5/4 17:31:03
	 */
	@RequestMapping(value = "view")
	public String view(DcDataInterfaceLog log, Model model) {
		model.addAttribute("intfLog", log);
		return "modules/dc/dataexport/interfaceLogView";       //查看页面
	}
}
