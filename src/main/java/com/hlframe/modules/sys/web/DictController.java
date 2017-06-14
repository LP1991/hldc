/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.sys.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import com.hlframe.common.utils.CacheUtils;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.sys.dao.DictDao;
import com.hlframe.modules.sys.entity.Dict;
import com.hlframe.modules.sys.service.DictService;
import com.hlframe.modules.sys.utils.DictUtils;

/**
 * 字典Controller
 * @author hlframe
 * @version 2014-05-16
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/dict")
public class DictController extends BaseController {

	@Autowired
	private DictService dictService;
	
	@ModelAttribute
	public Dict get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return dictService.get(id);
		}else{
			return new Dict();
		}
	}
	
	/*@RequiresPermissions("sys:dict:index")
	@RequestMapping(value = {"list", ""})
	public String list(Dict dict, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Dict> page = dictService.findDict(new Page<Dict>(request, response), dict);
        model.addAttribute("page", page);
		return "modules/sys/dictList";
	}*/
	@RequiresPermissions("sys:dict:index")
	@RequestMapping(value = {"list", ""})
	public String list(Dict dict, HttpServletRequest request, HttpServletResponse response, Model model,@RequestParam(required=false) String type) {
		List<String> typeList = dictService.findTypeList();
		model.addAttribute("typeList", typeList);
        Page<Dict> page = dictService.findPage(new Page<Dict>(request, response), dict); 
        model.addAttribute("page", page);
		/*List<Dict> list = dictService.findAll();
		model.addAttribute("list",list );*/
		return "modules/sys/dictList";
	}

	@RequiresPermissions(value={"sys:dict:view","sys:dict:add","sys:dict:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(Dict dict, Model model) {
		if (dict.getParent()==null||dict.getParent().getId()==null){
			dict.setParent(new Dict("0"));
		}
		//设置父节点ID
		dict.setParentId(dict.getParent().getId());
//		dict.setParent(dictService.getDict(dict.getParent().getId()));
		// 获取排序号，最末节点排序号+30
		if (StringUtils.isBlank(dict.getId())){
			List<Dict> list = Lists.newArrayList();
			List<Dict> sourcelist = dictService.findList(dict);
			dictService.sortList(list, sourcelist, dict.getParent().getId(), false);
			if (list.size() > 0){
				dict.setSort(list.get(list.size()-1).getSort() + 30);
			}
		}
		model.addAttribute("dict", dict);
		return "modules/sys/dictForm";
	}

	@RequiresPermissions(value={"sys:dict:add","sys:dict:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")//@Valid 
	public String save(Dict dict, Model model, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/dict/?repage&type="+dict.getType();
		}
		/*if (!beanValidator(model, dict)){
			return form(dict, model);
		}*/
		dictService.save(dict);
		addMessage(redirectAttributes, "保存字典'" + dict.getLabel() + "'成功");
		return "redirect:" + adminPath + "/sys/dict/?repage&type="+dict.getType();
	}
	
	@RequiresPermissions("sys:dict:del")
	@RequestMapping(value = "delete")
	public String delete(Dict dict, Model model, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/dict/?repage";
		}
		dictService.delete(dict);
		model.addAttribute("dict", dict);
		addMessage(redirectAttributes, "删除字典成功");
		return "redirect:" + adminPath + "/sys/dict/?repage&type="+dict.getType();
	}
	
	
	/**
	 * 批量删除角色
	 */
	@RequiresPermissions("sys:role:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/dict/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			Dict dict = dictService.get(id);
			dictService.delete(dict);
		}
		addMessage(redirectAttributes, "删除字典成功");
		return "redirect:" + adminPath + "/sys/dict/?repage";
	}

	
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String type, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		Dict dict = new Dict();
		dict.setType(type); 
		List<Dict> list = dictService.findAllTypeList();
		for (int i=0; i<list.size(); i++){
			Dict e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("label", e.getValue());
			map.put("type", e.getType());
			map.put("pId", e.getParentId());
			map.put("name", e.getLabel());
			mapList.add(map);
		}
		return mapList;
	}
	//备份
/*	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String type, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		Dict dict = new Dict();
		dict.setType(type);
		List<Dict> list = dictService.findList(dict);
		for (int i=0; i<list.size(); i++){
			Dict e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("pId", e.getParentId());
			map.put("name", StringUtils.replace(e.getLabel(), " ", ""));
			mapList.add(map);
		}
		return mapList;
	}
*/	
	@ResponseBody
	@RequestMapping(value = "listData")
	public List<Dict> listData(@RequestParam(required=false) String type) {
		Dict dict = new Dict();
		dict.setType(type);
		return dictService.findList(dict);
	}

	@RequiresPermissions("sys:dict:index")
	@RequestMapping(value = {"index"})
	public String index(Dict dict, Model model) {
		return "modules/sys/dictIndex";
	}


	@ResponseBody
	@RequestMapping(value = "addType")
	public String addType( HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		String name=request.getParameter("name");
		String pid=request.getParameter("pid");
		String id=UUID.randomUUID().toString();
		Dict dict = new Dict();
		dict.setId(UUID.randomUUID().toString());
		dict.setName(name);
		dict.setParentId(pid);
		dictService.save(dict);
		return id;
	}
	@ResponseBody
	@RequestMapping(value = "editType")
	public String editType(@RequestParam(required=false) String id) {
		Dict dict = new Dict();
		//dict.setType(type);
		//dict.setCreateBy(createBy);
		return "true";
	}
	@ResponseBody
	@RequestMapping(value = "deleteType")
	public String deleteType(@RequestParam(required=false) String id) {
		Dict dict = new Dict();
		//dict.setType(type);
		return "true";
	}
	
	@RequestMapping(value = "typeForm")
	public String typeForm(Dict dict, Model model) {
		model.addAttribute("dict", dict);
		return "modules/sys/dictTypeForm";
	}
	
	/**
	 * 保存字典 ajax
	 */
	@ResponseBody
	@RequestMapping(value = "saveA")
	public AjaxJson saveA(Dict dict,  Model model,String flag) {
		AjaxJson ajaxJson = new AjaxJson();
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		
			
		
		try {
			if (dict.getParent() != null && StringUtils.isBlank(dict.getParentId()) ){
				dict.setParentId(dict.getParent().getId());
			}
			if (dict.getParent() != null &&  !"0".equals(dict.getParentId()) &&  "add".equals(flag) ){
				dict.setType(dict.getType()+"_"+dict.getValue());
			}
			dictService.save(dict);
			ajaxJson.setMsg("保存字典成功");
		} catch (Exception e) {
			ajaxJson.setMsg("保存字典失败");
			ajaxJson.setSuccess(false);
		}
		return ajaxJson;
	}
	
	@ResponseBody
	@RequestMapping(value = "deleteA")
	public AjaxJson deleteA(Dict dict, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		dictService.delete(dict);
		ajaxJson.setMsg("删除字典成功");
		return ajaxJson;
	}
	
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(Dict dict, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Dict> page = dictService.findPage(new Page<Dict>(request), dict); 
        //model.addAttribute("page", page);
		List<Dict> list = page.getList();
		DataTable a = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		if("".equals(dict.getParent().getId())||dict.getParent().getId()==null){
			a.put("gson",gson.toJson(new ArrayList()));
		}else{
			a.put("gson",gson.toJson(list));
		}
		return a;
	}
	
	/**
	 * 批量删除字典
	 */
	@ResponseBody
	@RequestMapping(value = "deleteAllByA")
	public AjaxJson deleteAllByA(String ids, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			Dict dict = dictService.get(id);
			dictService.delete(dict);
		}
		ajaxJson.setMsg("删除字典成功");
		return ajaxJson;
		
	}
	//字典
	@ResponseBody
	@RequestMapping(value = "getDictLabel")
	public String getDictLabel(String value, String type, String defaultValue){
		return DictUtils.getDictLabel(value, type, defaultValue);
		/* 原有方法多次查询,效率太低 调整为根据缓存获取 peijd 2017-2-21
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(value)){
			List<Dict> list= dictDao.findAllList(new Dict());
			for (Dict dict : list){
				if (dict.getType().indexOf(type+"_")>-1 && value.equals(dict.getValue())){
					return dict.getLabel();
				}
			}
		}
		return defaultValue;*/
	}
	
	
	public static List<Dict> getDictList(String type){
		@SuppressWarnings("unchecked")
		Map<String, List<Dict>> dictMap = (Map<String, List<Dict>>)CacheUtils.get(CACHE_DICT_MAP);
		if (dictMap==null){
			dictMap = Maps.newHashMap();
			for (Dict dict : dictDao.findAllList(new Dict())){
				List<Dict> dictList = dictMap.get(dict.getType());
				if (dictList != null){
					dictList.add(dict);
				}else{
					dictMap.put(dict.getType(), Lists.newArrayList(dict));
				}
			}
			CacheUtils.put(CACHE_DICT_MAP, dictMap);
		}
		List<Dict> dictList = dictMap.get(type);
		if (dictList == null){
			dictList = Lists.newArrayList();
		}
		return dictList;
	}
	
	private static DictDao dictDao = SpringContextHolder.getBean(DictDao.class);

	public static final String CACHE_DICT_MAP = "dictMap";
	
	/*
	 * 远程验证value键值是否重的实现
	 * bao  gabg
	 * 2017,4,25 18:53
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkValue")
	public String checkName(String oldValue, String value,String parentId) {

		if (value!=null && value.equals(oldValue)) {
			return "true";
	} else if (value!=null && dictService.getRoleByValue(value,parentId)== null) {
			return "true";
		}
		return "false";
	}
	
	/** 远程验证label标签是否重的实现
	 * bao  gabg
	 * 2017,4,25 18:53
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkLabel")
	public String checkLabel(String oldLabel, String label,String parentId ) {
		if (label!=null && label.equals(oldLabel)) {
			return "true";
	} else if (label!=null && dictService.getRoleByLable(label,parentId)== null) {
			return "true";
		}
		return "false";
	}
	/**
	 * 远程验证树的标签
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "Labelval")
	public String Labelval(String oldLabel, String label ) {
		if (label!=null && label.equals(oldLabel)) {
			return "true";
		} else if (label!=null && dictService.getlabel(label)==null) {
			return "true";
		}
		return "false";
	}
}
