/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.sys.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.sys.entity.Area;
import com.hlframe.modules.sys.service.AreaService;
import com.hlframe.modules.sys.utils.DictUtils;
import com.hlframe.modules.sys.utils.UserUtils;

/**
 * 区域Controller
 * @author hlframe
 * @version 2013-5-15
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/area")
public class AreaController extends BaseController {

	@Autowired
	private AreaService areaService;
	
	
	@ModelAttribute("area")
	public Area get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return areaService.get(id);
		}else{
			return new Area();
		}
	}
	
	@RequiresPermissions("sys:area:index")
	@RequestMapping(value = {"index"})
	public String index(Area area, Model model) {
		return "modules/sys/areaIndex";
	}

	
	@RequestMapping(value = {"list", ""})
	public String list(Area area, Model model) {
		List<Area> list = areaService.findListBy(area);
//		List<Area> list = areaService.findList(area);
		model.addAttribute("list",list );
		//model.addAttribute("list", areaService.findAll());
		return "modules/sys/areaList";
	}

	
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(Area area, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Area> page = areaService.findArea(new Page<Area>(request), area);
        //model.addAttribute("page", page);
		List<Area> list = page.getList();
		//转换类型
		for (Area area2 : list) {
			area2.setType(DictUtils.getDictLabel(area2.getType(), "sys_area_type", ""));
		}
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
		//a.setStart(start);
		//a.setDraw(draw);
		return a;
	}
	
	@RequiresPermissions(value={"sys:area:view","sys:area:add","sys:area:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(Area area, Model model) {
		if (area.getParent()==null||area.getParent().getId()==null){
			area.setParent(UserUtils.getUser().getOffice().getArea());
		}else{
			area.setParent(areaService.get(area.getParent().getId()));
		}
		
//		// 自动获取排序号
//		if (StringUtils.isBlank(area.getId())){
//			int size = 0;
//			List<Area> list = areaService.findAll();
//			for (int i=0; i<list.size(); i++){
//				Area e = list.get(i);
//				if (e.getParent()!=null && e.getParent().getId()!=null
//						&& e.getParent().getId().equals(area.getParent().getId())){
//					size++;
//				}
//			}
//			area.setCode(area.getParent().getCode() + StringUtils.leftPad(String.valueOf(size > 0 ? size : 1), 4, "0"));
//		}
		model.addAttribute("area", area);
		return "modules/sys/areaForm";
	}
	
	@RequiresPermissions(value={"sys:area:add","sys:area:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(Area area, Model model, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/area";
		}
		if (!beanValidator(model, area)){
			return form(area, model);
		}
		areaService.save(area);
		addMessage(redirectAttributes, "保存区域'" + area.getName() + "'成功");
		return "redirect:" + adminPath + "/sys/area/";
	}
	
	@RequiresPermissions("sys:area:del")
	@RequestMapping(value = "delete")
	public String delete(Area area, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/area";
		}
//		if (Area.isRoot(id)){
//			addMessage(redirectAttributes, "删除区域失败, 不允许删除顶级区域或编号为空");
//		}else{
			areaService.delete(area);
			addMessage(redirectAttributes, "删除区域成功");
//		}
		return "redirect:" + adminPath + "/sys/area/";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<Area> list = areaService.findAll();
		for (int i=0; i<list.size(); i++){
			Area e = list.get(i);
			if (StringUtils.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)){
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getName());
				mapList.add(map);
			}
		}
		return mapList;
	}
	
	@ResponseBody
	@RequestMapping(value = "deleteA")
	public AjaxJson deleteA(Area area, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		areaService.delete(area);
		ajaxJson.setMsg("删除区域成功");
		return ajaxJson;
	}
	
	/**
	 * 保存区域 ajax
	 */
	@ResponseBody
	@RequestMapping(value = "saveA")
	public AjaxJson saveA(Area area, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		if (!beanValidator(model, area)){
			ajaxJson.setMsg("数据验证失败！");
		}
		areaService.save(area);
		ajaxJson.setMsg("保存区域'" + area.getName() + "'成功");
		return ajaxJson;
	}
	
}
