
package com.hlframe.modules.dc.metadata.web;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.metadata.entity.DcObjectAu;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.metadata.service.SetNameBySourceService;
import com.hlframe.modules.sys.utils.DictUtils;


/**
 * 
 * @类名: com.hlframe.modules.dc.metadata.web.DcObjectAuController.java 
 * @职责说明: dc权限管理控制台
 * @创建者: yuzh
 * @创建时间: 2016年11月19日 下午3:15:19
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcObjectAu")
public class DcObjectAuController extends BaseController {

	@Autowired
	private DcObjectAuService dcObjectAuService;
	@Autowired
	private SetNameBySourceService setNameBySourceService;
	
	/**
	 * 
	 * @方法名称: get 
	 * @实现功能: 每次请求 构建对象
	 * @param id
	 * @return
	 * @create by yuzh at 2016年11月19日 下午3:18:41
	 */
	@ModelAttribute("dcObjectAu")
	public DcObjectAu get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return dcObjectAuService.get(id);
		}else{
			return new DcObjectAu();
		}
	}

	/**
	 * 
	 * @方法名称: list 
	 * @实现功能: 元数据对象列表
	 * @param obj
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月19日 下午3:18:54
	 */
	@RequiresPermissions("dc:metadata:dcObjectAu:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcObjectAu obj, Model model) {
		List<DcObjectAu> list = dcObjectAuService.findList(obj);
		model.addAttribute("list", list);
		model.addAttribute("objectAu", obj);
		return "modules/dc/metaData/dcObjectMain/dcObjectAuList";
	}
	
	
	
	/**
	 * 
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax分页列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月19日 下午3:19:04
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcObjectAu obj, HttpServletRequest request, HttpServletResponse response, Model model) {
		obj.setStatus("未处理");
 		Page<DcObjectAu> page = dcObjectAuService.findPage(new Page<DcObjectAu>(request), obj);
		List<DcObjectAu> list = page.getList();
		List<DcObjectAu> fin = new ArrayList<DcObjectAu>();
		
		//转换类型
		for (DcObjectAu aaa : list){
				setNameBySourceService.setNameBySource(aaa);
				aaa.setFrom(DictUtils.getDictLabel(aaa.getFrom(), "toGetAu", ""));
				fin.add(aaa);
		}
//		for (DcObjectAu item : list) {
//			item.setDataScope(DictUtils.getDictLabel(role2.getDataScope(), "sys_data_scope", ""));
//		}
		DataTable a = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(fin));
		return a;
	}
	
	/**
	 * 
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax分页列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月19日 下午3:19:04
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist1")
	public DataTable ajaxlist1(DcObjectAu obj, HttpServletRequest request, HttpServletResponse response, Model model) {
		obj.setStatus("已通过");
 		Page<DcObjectAu> page = dcObjectAuService.findPage(new Page<DcObjectAu>(request), obj);
		List<DcObjectAu> list = page.getList();
		List<DcObjectAu> fin = new ArrayList<DcObjectAu>();
		//转换类型
		for (DcObjectAu aaa : list){
				setNameBySourceService.setNameBySource(aaa);
			aaa.setFrom(DictUtils.getDictLabel(aaa.getFrom(), "toGetAu", ""));
			fin.add(aaa);
		}
//		for (DcObjectAu item : list) {
//			item.setDataScope(DictUtils.getDictLabel(role2.getDataScope(), "sys_data_scope", ""));
//		}
		DataTable b = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		b.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		b.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		b.setRecordsFiltered((int)page.getCount());
		b.setLength(page.getPageSize());
		Gson gson = new Gson();
		b.put("gson",gson.toJson(fin));
		return b;
	}
	
	/**
	 * 
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax分页列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月19日 下午3:19:04
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist2")
	public DataTable ajaxlist2(DcObjectAu obj, HttpServletRequest request, HttpServletResponse response, Model model) {
		obj.setStatus("已撤回");
 		Page<DcObjectAu> page = dcObjectAuService.findPage(new Page<DcObjectAu>(request), obj);
		List<DcObjectAu> list = page.getList();
		List<DcObjectAu> fin = new ArrayList<DcObjectAu>();
		//转换类型
		for (DcObjectAu aaa : list){
			setNameBySourceService.setNameBySource(aaa);
			aaa.setFrom(DictUtils.getDictLabel(aaa.getFrom(), "toGetAu", ""));
			fin.add(aaa);
		}
//		for (DcObjectAu item : list) {
//			item.setDataScope(DictUtils.getDictLabel(role2.getDataScope(), "sys_data_scope", ""));
//		}
		DataTable c = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		c.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		c.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		c.setRecordsFiltered((int)page.getCount());
		c.setLength(page.getPageSize());
		Gson gson = new Gson();
		c.put("gson",gson.toJson(fin));
		return c;
	}
	
	/**
	 * 
	 * @方法名称: pass 
	 * @实现功能: 权限添加
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月19日 下午4:11:44
	 */
	@ResponseBody
	@RequestMapping(value = "pass")
	public AjaxJson pass(String id, RedirectAttributes redirectAttributes) {
		DcObjectAu obj = dcObjectAuService.getById(id);
		dcObjectAuService.pass(obj);
		AjaxJson ajaxJson = new AjaxJson();
		ajaxJson.setMsg("权限已添加!");
		return ajaxJson;
	}
	
	/**
	 * 
	 * @方法名称: nopass 
	 * @实现功能: 申请撤回
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月19日 下午4:11:49
	 */
	@ResponseBody
	@RequestMapping(value = "nopass")
	public AjaxJson nopass(String id, RedirectAttributes redirectAttributes) {
		DcObjectAu obj = dcObjectAuService.getById(id);
		dcObjectAuService.nopass(obj);
		AjaxJson ajaxJson = new AjaxJson();
		ajaxJson.setMsg("申请已撤回!");
		return ajaxJson;
	}
	
	/**
	 * 批量删除用户
	 */
	@ResponseBody
	@RequiresPermissions("dc:metadata:dcObjectAu:edit")
	@RequestMapping(value = "approveRow")
	public AjaxJson approveRow(String ids, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		
		String idArray[] =ids.split(",");
		for(String id : idArray){
			DcObjectAu obj = dcObjectAuService.getById(id);
			dcObjectAuService.pass(obj);
		}
		ajaxJson.setMsg("权限已添加!");
		return ajaxJson;
	}
	
	/**
	 * 批量删除用户
	 */
	@ResponseBody
	@RequiresPermissions("dc:metadata:dcObjectAu:edit")
	@RequestMapping(value = "denyRow")
	public AjaxJson denyRow(String ids, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		
		String idArray[] =ids.split(",");
		for(String id : idArray){
			DcObjectAu obj = dcObjectAuService.getById(id);
			dcObjectAuService.nopass(obj);
		}
		ajaxJson.setMsg("申请已撤回!");
		return ajaxJson;
	}
	
}
