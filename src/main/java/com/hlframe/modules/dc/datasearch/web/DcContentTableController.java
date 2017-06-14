/********************** 版权声明 *************************
 * 文件名: DcContentTableController.java
 * 包名: com.hlframe.modules.dc.datasearch.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月9日 上午11:27:38
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.metadata.service.DcObjectMainService;

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

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.datasearch.entity.DcContentTable;
import com.hlframe.modules.dc.datasearch.service.DcContentTableService;
import com.hlframe.modules.dc.datasearch.service.DcSearchContentService;
import com.hlframe.modules.dc.metadata.entity.DcObjectTable;
import com.hlframe.modules.dc.metadata.service.DcObjectCataRefService;

import java.util.List;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.web.DcContentTableController.java 
 * @职责说明: 分类管理controller
 * @创建者: yuzh
 * @创建时间: 2016年11月9日 上午11:27:38
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataSearch/dcContentTable")
public class DcContentTableController extends BaseController{

	@Autowired
	private DcContentTableService dcContentTableService;
	@Autowired
	private DcObjectCataRefService dcObjectCataRefService;
	@Autowired
	private DcSearchContentService dcSearchContentService;
	@Autowired
	private DcObjectMainService dcObjectMainService;

	@ModelAttribute
	public DcContentTable get(@RequestParam(required=false) String id) {
		DcContentTable entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcContentTableService.get(id);
		}
		if (entity == null){
			entity = new DcContentTable();
		}
		return entity;
	}
	
	/**
	 * 
	 * @方法名称: list 
	 * @实现功能: 列表页面
	 * @param dcContentTable
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:36:02
	 */
	@RequiresPermissions("dc:contentTable:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcContentTable dcContentTable, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcContentTable> page = dcContentTableService.findPage(new Page<DcContentTable>(request, response), dcContentTable); 
		model.addAttribute("page", page);
		
		return "modules/dc/dataSearch/dcContentTableList";
		
	}

	/**
	 * 
	 * @方法名称: ajaxlist 
	 * @实现功能: 列表页面
	 * @param dcContentTable
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by hgw at 2017年4月12日 下午5:02:51
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcContentTable dcContentTable, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcContentTable> page = dcContentTableService.findPage(new Page<DcContentTable>(request), dcContentTable);
		List<DcContentTable> list = page.getList();
		//转换类型
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
		a.put("gson",gson.toJson(list));
		return a;
	}
	
	/**
	 * 
	 * @方法名称: form 
	 * @实现功能: 增加，编辑表单页面
	 * @param dcContentTable
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:36:21
	 */
	@RequiresPermissions(value={"dc:contentTable:add","dc:contentTable:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcContentTable dcContentTable, Model model) {
		model.addAttribute("dcContentTable", dcContentTable);
		
		return "modules/dc/dataSearch/dcContentTableForm";
	}

	/**
	 * 
	 * @方法名称: view 
	 * @实现功能: 查看表单页面
	 * @param dcContentTable
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:36:33
	 */
	@RequiresPermissions(value={"dc:contentTable:view"})
	@RequestMapping(value = "view")
	public String view(DcContentTable dcContentTable, Model model) {
		model.addAttribute("dcContentTable", dcContentTable);
		return "modules/dc/dataSearch/dcContentTableView";
	}

	/**
	 * 
	 * @方法名称: save 
	 * @实现功能: 保存
	 * @param dcContentTable
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * @create by yuzh at 2016年11月12日 上午11:36:46
	 */
	@RequiresPermissions(value={"dc:contentTable:add","dc:contentTable:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcContentTable dcContentTable, Model model, RedirectAttributes redirectAttributes) throws Exception{
		if (!beanValidator(model, dcContentTable)){
			return form(dcContentTable, model);
		}
		if(!dcContentTable.getIsNewRecord()){//编辑表单保存
			DcContentTable t = dcContentTableService.get(dcContentTable.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcContentTable, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			dcContentTableService.save(t);//保存
		}else{//新增表单保存
			String parentId = dcContentTableService.saveAndGetId(dcContentTable);//保存 
			String cataId = dcSearchContentService.newObject(parentId);//新建默认分类
			dcObjectCataRefService.firstInsert(cataId);
			//更新全部的obj信息
			dcObjectMainService.updateData2Es();
		}
		addMessage(redirectAttributes, "分类保存成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcContentTable/?repage";
	}
	
	/**
	 * 异步保存分类数据
	 * @param dcContentTable
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcContentTable dcContentTable, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			if(!dcContentTable.getIsNewRecord()){//编辑表单保存
				DcContentTable t = dcContentTableService.get(dcContentTable.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(dcContentTable, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				dcContentTableService.save(t);//保存
			}else{//新增表单保存
				String parentId = dcContentTableService.saveAndGetId(dcContentTable);//保存 
				String cataId = dcSearchContentService.newObject(parentId);//新建默认分类
				dcObjectCataRefService.firstInsert(cataId);
				//更新全部的obj信息
				dcObjectMainService.updateData2Es();
			}
			ajaxJson.setMsg("分类保存成功");
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg(e.getMessage());
			logger.error(e.getMessage());
		}
		return ajaxJson;
	}
	/**
	 * 
	 * @方法名称: delete 
	 * @实现功能: 删除
	 * @param dcContentTable
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:36:55
	 */
	@RequiresPermissions("dc:contentTable:del")
	@RequestMapping(value = "delete")
	public String delete(DcContentTable dcContentTable, RedirectAttributes redirectAttributes) {
		dcContentTableService.delete(dcContentTable);
//		List<DcObjectMain> list = dcObjectMainService.findList(new DcObjectMain());
		//删除大类，更新全部对象
		dcObjectMainService.updateData2Es();
		addMessage(redirectAttributes, "分类删除成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcContentTable/?repage";
	}
	
	/**
	 * 
	 * @方法名称: deleteAll 
	 * @实现功能: 批量删除
	 * @param ids
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:37:06
	 */
	@RequiresPermissions("dc:contentTable:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] = ids.split(",");
		for(String id : idArray){
			dcContentTableService.delete(dcContentTableService.get(id));
		}
//		List<DcObjectMain> list = dcObjectMainService.findList(new DcObjectMain());
		//删除大类，更新全部对象
		dcObjectMainService.updateData2Es();
		addMessage(redirectAttributes, "分类删除成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcContentTable/?repage";
	}
	
    /**
     * @方法名称: addDataToDataSearch 
     * @实现功能: 把这个业务分类添加到数据搜索页面
     * @param ids
     * @param redirectAttributes
     * @return
     * @create by cdd at 2017年1月23日 下午1:42:59
     */
	@RequiresPermissions("dc:contentTable:index")
	@RequestMapping(value = "addDataToDataSearch")
	public String addDataToDataSearch(String ids, RedirectAttributes redirectAttributes) {
		
	  //根据id，将这个业务分类的状态status改为1
		dcContentTableService.addDataToDataSearch(dcContentTableService.get(ids));
      //  json.setMsg("添加到数据搜索页面成功");
        addMessage(redirectAttributes, "添加到数据搜索页面成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcContentTable/?repage";
	}
	
	/**
	 * @方法名称: delDataToDataSearch 
	 * @实现功能: 取消业务分类在数据搜索页面的显示
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 * @create by cdd at 2017年1月23日 下午3:53:16
	 */
	@RequiresPermissions("dc:contentTable:index")
	@RequestMapping(value = "delDataToDataSearch")
	public String delDataToDataSearch(String ids, RedirectAttributes redirectAttributes) {

	  //根据id，将这个业务分类的状态status改为1
		dcContentTableService.delDataToDataSearch( dcContentTableService.get(ids));
		
        addMessage(redirectAttributes, "取消在数据搜索页面显示成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcContentTable/?repage";
	}
	
	/**
	 * 
	 * @方法名称: checkItemName 
	 * @实现功能: 判断分类项目名否已存在
	 * @param oldItemName
	 * @param itemName
	 * @return
	 * @create by hgw at 2017年3月30日 下午1:48:40
	 */
	@ResponseBody
	@RequestMapping(value = "checkItemName")
	public String checkItemName(String oldItemName, String itemName) {
		if (itemName !=null && itemName.equals(oldItemName)) {
			return "true";
		} else if (itemName !=null && dcContentTableService.findUniqueByProperty("item_name", itemName) == null) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * 
	 * @方法名称: checkCodeName 
	 * @实现功能: 判断分类编号名是否已存在
	 * @param oldCodeName
	 * @param codeName
	 * @return
	 * @create by hgw at 2017年3月30日 下午1:48:56
	 */
	@ResponseBody
	@RequestMapping(value = "checkCodeName")
	public String checkCodeName(String oldItemCode, String itemCode) {
		if (itemCode !=null && itemCode.equals(oldItemCode)) {
			return "true";
		} else if (itemCode !=null && dcContentTableService.findUniqueByProperty("item_code", itemCode) == null) {
			return "true";
		}
		return "false";
	}
}
