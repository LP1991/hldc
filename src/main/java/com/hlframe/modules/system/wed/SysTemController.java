/**
 * 
 */
package com.hlframe.modules.system.wed;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;

import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.system.entity.SysTem;
import com.hlframe.modules.system.service.SysTemService;





/**
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/system/systems")
public class SysTemController  extends BaseController{
	@Autowired
	private SysTemService systemservice;
	
	
	
	
	
	
	@RequestMapping(value = { "index" })
	public String index(SysTem systems, HttpServletRequest request, HttpServletResponse response, Model model) {

		if(null!= systems && StringUtils.isNotEmpty( systems.getId())){
			 systems = systemservice.get( systems.getId());
		}else{
			 systems = new SysTem();
		}
		model.addAttribute("systems", systems);//查询
		return "modules/dc/system/sysTemList";       
	}
	/*
	 * ajax查
	 */
	
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(SysTem systems, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<SysTem> page = systemservice.findPage(new Page<SysTem>(request), systems);
		List<SysTem> list = page.getList();
		DataTable a = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(list));
		return a;
	}
	
	
	/**
	 * 
	 * @方法名称: form 
	 * @实现功能: 增加，编辑表单页面
	 * @param dcSearchLabel
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:50:46
	 */
	@RequiresPermissions(value={"dc:systems:add","dc:systems:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(SysTem systems, Model model) {
	if(	(systems.getId()) != null){
		model.addAttribute("systems",systemservice.get(systems.getId()));
	}else{
		model.addAttribute("systems",systems);
	}
		
		return "modules/dc/system/sysTemForm";
	}
	
	/**
	 * 
	 * @方法名称: view 
	 * @实现功能: 查看表单页面
	 * @param dcSearchLabel
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:51:00
	 */
	@RequiresPermissions(value={"dc:systems:view"})
	@RequestMapping(value = "view")
	public String view(SysTem systems, Model model) {
		model.addAttribute("systems",systemservice.get(systems.getId()));
		return "modules/dc/system/sysTemView";
	}

	/**
	 * 
	 * @方法名称: deleteA 
	 * @实现功能: ajax删除
	 * @param dcTaskMain
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:57
	 */
	@ResponseBody
	@RequestMapping(value = "deleteA")
	public AjaxJson deleteA(SysTem systems, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		systemservice.delete(systems);
		ajaxJson.setMsg("删除任务成功");
		return ajaxJson;
	}
	/**
	 * 
	 * @方法名称: saveA 
	 * @实现功能: ajax保存
	 * @param dcTaskMain
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:01:08
	 */
	@ResponseBody
	@RequestMapping(value = "saveA")
	public AjaxJson saveA(SysTem systems, HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			systemservice.save(systems);// 保存
			ajaxJson.setMsg("保存" + systems.getName()+ "成功");

		} catch (Exception e) {
			ajaxJson.setMsg("保存失败");
			logger.error("DctaskMain.saveA()", e);
		}
		return ajaxJson;
	}
}
