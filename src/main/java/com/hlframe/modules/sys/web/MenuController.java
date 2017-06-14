/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.sys.web;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
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
import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.mapper.JsonMapper;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.sys.entity.Menu;
import com.hlframe.modules.sys.service.SystemService;
import com.hlframe.modules.sys.utils.UserUtils;

/**
 * 菜单Controller
 * @author hlframe
 * @version 2013-3-23
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/menu")
public class MenuController extends BaseController {

	@Autowired
	private SystemService systemService;
	
	@ModelAttribute("menu")
	public Menu get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return systemService.getMenu(id);
		}else{
			return new Menu();
		}
	}

	@RequiresPermissions("sys:menu:list")
	@RequestMapping(value = {"list", ""})
	public String list(Model model) {
		List<Menu> list = Lists.newArrayList();
		List<Menu> sourcelist = systemService.findAllMenu();
		Menu.sortList(list, sourcelist, Menu.getRootId(), true);
        model.addAttribute("list", list);
		return "modules/sys/menuList";
	}

	@RequiresPermissions(value={"sys:menu:add","sys:menu:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(Menu menu, Model model) {
		if (menu.getParent()==null||menu.getParent().getId()==null){
			menu.setParent(new Menu(Menu.getRootId()));
		}
		menu.setParent(systemService.getMenu(menu.getParent().getId()));
		// 获取排序号，最末节点排序号+30
		if (StringUtils.isBlank(menu.getId())){
			List<Menu> list = Lists.newArrayList();
			List<Menu> sourcelist = systemService.findAllMenu();
			Menu.sortList(list, sourcelist, menu.getParentId(), false);
			if (list.size() > 0){
				menu.setSort(list.get(list.size()-1).getSort() + 30);
			}
		}
		model.addAttribute("menu", menu);
		return "modules/sys/menuForm";
	}
	
	@RequiresPermissions(value={"sys:menu:view"})
	@RequestMapping(value = "menuView")
	public String view(Menu menu, Model model) {
		model.addAttribute("menu", menu);
		return "modules/sys/menuView";       //新增查看页面
	}
	
	@RequiresPermissions(value={"sys:menu:add","sys:menu:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(Menu menu, Model model, RedirectAttributes redirectAttributes) {
		if(!UserUtils.getUser().isAdmin()){
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
			return "redirect:" + adminPath + "/sys/role/?repage";
		}
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/menu/";
		}
		if (!beanValidator(model, menu)){
			return form(menu, model);
		}
		systemService.saveMenu(menu);
		addMessage(redirectAttributes, "保存菜单'" + menu.getName() + "'成功");
		return "redirect:" + adminPath + "/sys/menu/list?repage";
	}
	
	@RequiresPermissions("sys:menu:del")
	@RequestMapping(value = "delete")
	public String delete(Menu menu, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/menu/";
		}
//		if (Menu.isRoot(id)){
//			addMessage(redirectAttributes, "删除菜单失败, 不允许删除顶级菜单或编号为空");
//		}else{
			systemService.deleteMenu(menu);
			addMessage(redirectAttributes, "删除菜单成功");
//		}
		return "redirect:" + adminPath + "/sys/menu/";
	}

	@RequiresPermissions("sys:menu:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/menu/";
		}
//		if (Menu.isRoot(id)){
//			addMessage(redirectAttributes, "删除菜单失败, 不允许删除顶级菜单或编号为空");
//		}else{
		String idArray[] =ids.split(",");
		for(String id : idArray){
			Menu menu = systemService.getMenu(id);
			if(menu != null){
				systemService.deleteMenu(systemService.getMenu(id));
			}
		}
			
		addMessage(redirectAttributes, "删除菜单成功");
//		}
		return "redirect:" + adminPath + "/sys/menu/";
	}
	@RequiresPermissions("user")
	@RequestMapping(value = "tree")
	public String tree() {
		return "modules/sys/menuTree";
	}

	@RequiresPermissions("user")
	@RequestMapping(value = "treeselect")
	public String treeselect(String parentId, Model model) {
		model.addAttribute("parentId", parentId);
		return "modules/sys/menuTreeselect";
	}
	
	
	
	/**
	 * isShowHide是否显示隐藏菜单
	 * @param extId
	 * @param isShowHidden
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId,@RequestParam(required=false) String isShowHide, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<Menu> list = systemService.findAllMenu();
		for (int i=0; i<list.size(); i++){
			Menu e = list.get(i);
			if (StringUtils.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)){
				if(isShowHide != null && isShowHide.equals("0") && e.getIsShow().equals("0")){
					continue;
				}
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getName());
				mapList.add(map);
			}
		}
		return mapList;
	}
	
	/**
	 * 云桌面返回：用户权限菜单
	 */
	@ResponseBody
	@RequestMapping(value = "getPrimaryMenuForWebos")
	public AjaxJson getPrimaryMenuForWebos() {
		AjaxJson j = new AjaxJson();
		//将菜单加载到Session，用户只在登录的时候加载一次
		//Object getPrimaryMenuForWebos =  ContextHolderUtils.getSession().getAttribute("getPrimaryMenuForWebos");
		/*if(oConvertUtils.isNotEmpty(getPrimaryMenuForWebos)){
			j.setMsg(getPrimaryMenuForWebos.toString());
		}else{*/
		Menu menu = UserUtils.getTopMenu();
			//String PMenu = ListtoMenu.getWebosMenu(getFunctionMap(ResourceUtil.getSessionUserName()));
			//ContextHolderUtils.getSession().setAttribute("getPrimaryMenuForWebos", PMenu);
		String PMenu =getWebosMenu(menu);
		j.setMsg(PMenu);
		//}
		return j;
	}
	
	/**
	 * 拼装webos头部菜单
	 * @param ms
	 * @param functions
	 * @return
	 */
	public static String getWebosMenu(Menu map) {
		StringBuffer menuString = new StringBuffer();
		StringBuffer DeskpanelString = new StringBuffer();
		StringBuffer dataString = new StringBuffer();
		String menu = "";
		String desk = "";
		String data = "";
		
		//menu的全部json，这里包括对菜单的展示及每个二级菜单的点击出详情
//		menuString.append("[");
		menuString.append("{");
		//绘制data.js数组，用于替换data.js中的app:{//桌面1 'dtbd':{ appid:'2534',,······
		dataString.append("{app:{");
		//绘制Deskpanel数组，用于替换webos-core.js中的Icon1:['dtbd','sosomap','jinshan'],······
		DeskpanelString.append("{");
		
	
		int n = 1;
		for (Menu m : map.getChildren()) {
		
			//绘制一级菜单
//			menuString.append("{ ");
			menuString.append("\""+ m.getId() + "\":");
			menuString.append("{\"id\":\""+m.getId()+"\",\"name\":\""+m.getName()
					+"\",\"path\":\""+m.getIcon()+"\",\"level\":\"1\",");
			menuString.append("\"child\":{");

			//绘制Deskpanel数组
			DeskpanelString.append("Icon"+n+":[");
			
			//绘制二级菜单
			if(m.getChildren()!=null&&m.getChildren().size()>0){
//				menuString.append(getWebosChild(m, 1, map));
				DeskpanelString.append(getWebosDeskpanelChild(m, 1));
				dataString.append(getWebosDataChild(m, 1));
			}
			DeskpanelString.append("],");
			menuString.append("}},");
			n++;
		}

		menu = menuString.substring(0, menuString.toString().length()-1);
//		menu += "]";
		menu += "}";
		
		data = dataString.substring(0, dataString.toString().length()-1);
		data += "}}";
		
		desk = DeskpanelString.substring(0, DeskpanelString.toString().length()-1);
		desk += "}";
		
		//初始化为1，需减少一个个数。
		n = n-1;
		
//		System.out.println("-------------------");
//		System.out.println(menu+"$$"+desk+"$$"+data+"$$"+"{\"total\":"+n+"}");
		return menu+"$$"+desk+"$$"+data+"$$"+n;
	}
	
	private static String getWebosDeskpanelChild(Menu parent,int level){
		StringBuffer DeskpanelString = new StringBuffer();
		String desk = "";
		if(parent.getChildren()==null||parent.getChildren().size()==0){
			return "";
		}
		for (Menu function : parent.getChildren()) {
			DeskpanelString.append("'"+function.getId()+"',");
		}
		desk = DeskpanelString.substring(0, DeskpanelString.toString().length()-1);
		return desk;
	}
	private static String getWebosDataChild(Menu parent,int level){
		StringBuffer dataString = new StringBuffer();
		String data = "";
		if(parent.getChildren()==null||parent.getChildren().size()==0){
			return "";
		}
		for (Menu function : parent.getChildren()) {
				dataString.append("'"+function.getId()+"':{ ");
				dataString.append("appid:'"+function.getId()+"',");
				dataString.append("url:'"+function.getHref()+"',");

//				dataString.append(getIconandName(function.getFunctionName()));
				//dataString.append(getIconAndNameForDesk(function));
				String colName = function.getIcon() == null||function.getIcon().equals("") ? "/sliding/icon/default.png" : function.getIcon();
				dataString.append("icon:'" + colName + "',");
				dataString.append("name :'"+function.getName()+ "',");
				dataString.append("asc :"+function.getSort());
				dataString.append(" },");
		}
//		data = dataString.substring(0, dataString.toString().length()-1);
		data = dataString.toString();
		return data;
	}
	
	/**
	 * @Title: top
	 * @author:gaofeng
	 * @Description: shortcut头部菜单一级菜单列表，并将其用ajax传到页面，实现动态控制一级菜单列表
	 * @return AjaxJson
	 * @throws
	 */
    @RequestMapping(value = "primaryMenu")
    @ResponseBody
	public String getPrimaryMenu() {
    	Menu menu = UserUtils.getTopMenu();
        String floor = "";

        if (menu == null) {
            return floor;
        }

        for (Menu function : menu.getChildren()) {
        	String lang_key = function.getName();
        	String lang_context = lang_key;
        	lang_context=lang_context.trim();
            //其他的为默认通用的图片模式
        	String s="";
            if(lang_context.length()>=5 && lang_context.length()<7){
                s = "<div style='width:67px;position: absolute;top:40px;text-align:center;color:#909090;font-size:12px;'><span style='letter-spacing:-1px;'>"+ lang_context +"</span></div>";
            }else if(lang_context.length()<5){
                s = "<div style='width:67px;position: absolute;top:40px;text-align:center;color:#909090;font-size:12px;'>"+ lang_context +"</div>";
            }else if(lang_context.length()>=7){
                s = "<div style='width:67px;position: absolute;top:40px;text-align:center;color:#909090;font-size:12px;'><span style='letter-spacing:-1px;'>"+ lang_context.substring(0, 6) +"</span></div>";
            }
            floor += " <li style='position: relative;'><img class='imag1' src='static/login/images/default.png' /> "
                    + " <img class='imag2' src='static/login/images/default_up.png' style='display: none;' />"
                    + s +"</li> ";
        }

		return floor;
	}
    
    /**
	 * 修改菜单排序
	 */
    @ResponseBody
	@RequestMapping(value = "updateSort")
	public AjaxJson updateSort(String ids, String sorts, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		Menu menu = new Menu(ids);
		menu.setSort(Integer.parseInt(sorts));
		systemService.updateMenuSort(menu);
		ajaxJson.setMsg("保存菜单排序成功!");
		return ajaxJson;
	}
    
    @ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(Menu menu, HttpServletRequest request, HttpServletResponse response, Model model) throws JsonGenerationException, JsonMappingException, IOException {
    	Page<Menu> page  = systemService.findMenu(new Page<Menu>(request), menu); 
        //model.addAttribute("page", page);
		List<Menu> list = page.getList();
		//转换类型
		/*for (Menu menu2 : list) {
			menu2.setIsShow(DictUtils.getDictLabel(menu2.getIsShow(), "menu_type", ""));
		}*/
		DataTable a = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		//Gson gson1= new GsonBuilder().setExclusionStrategies(new SpecificClassExclusionStrategy (null, Menu.class)).create();
		String b=JsonMapper.toJsonString(list);
		a.put("gson",b);
		return a;
	}
    
    /**
	 * 保存字典 ajax
	 */
	@ResponseBody
	@RequestMapping(value = "saveA")
	public AjaxJson saveA(Menu menu,  Model model) {
		AjaxJson ajaxJson = new AjaxJson();
		if(!UserUtils.getUser().isAdmin()){
			ajaxJson.setMsg("越权操作，只有超级管理员才能添加或修改数据！");
			return ajaxJson;
		}
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		if (!beanValidator(model, menu)){
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("验证失败！");
			return ajaxJson;
		}
		try {
			systemService.saveMenu(menu);
			ajaxJson.setMsg("保存菜单成功");
		} catch (Exception e) {
			ajaxJson.setMsg("保存菜单失败");
			ajaxJson.setSuccess(false);
		}
		return ajaxJson;
	}
	
	
	
	
	@ResponseBody
	@RequestMapping(value = "deleteA")
	public AjaxJson deleteA(Menu menu, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		systemService.deleteMenu(menu);
		ajaxJson.setMsg("删除菜单成功");
		return ajaxJson;
	}
	
	@ResponseBody
	@RequestMapping(value = "deleteAllByA")
	public AjaxJson deleteAllByA(String ids, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if(Global.isDemoMode()){
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
//		if (Menu.isRoot(id)){
//			addMessage(redirectAttributes, "删除菜单失败, 不允许删除顶级菜单或编号为空");
//		}else{
		String idArray[] =ids.split(",");
		for(String id : idArray){
			Menu menu = systemService.getMenu(id);
			if(menu != null){
				systemService.deleteMenu(systemService.getMenu(id));
			}
		}
			
		ajaxJson.setMsg("删除菜单成功");
//		}
		return ajaxJson;
	}
	
}
