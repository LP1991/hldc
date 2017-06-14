/********************** 版权声明 *************************
 * 文件名: DcSearchContentController.java
 * 包名: com.hlframe.modules.dc.datasearch.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月7日 下午2:31:15
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
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

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.datasearch.entity.DcContentTable;
import com.hlframe.modules.dc.datasearch.entity.DcSearchContent;
import com.hlframe.modules.dc.datasearch.service.DcContentTableService;
import com.hlframe.modules.dc.datasearch.service.DcSearchContentService;

/**
 * @类名: com.hlframe.modules.dc.datasearch.web.DcSearchContentController.java
 * @职责说明: 分类明细树controller
 * @创建者: yuzh
 * @创建时间: 2016年11月7日 下午2:31:15
 */

@Controller
@RequestMapping(value = "${adminPath}/dc/dataSearch/dcSearchContent")
public class DcSearchContentController extends BaseController {

	@Autowired
	private DcSearchContentService dcSearchContentService;
	@Autowired
	private DcContentTableService dcContentTableService;
	@Autowired
	private DcObjectMainService dcObjectMainService;

	@ModelAttribute("dcSearchContent")
	public DcSearchContent get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return dcSearchContentService.get(id);
		} else {
			return new DcSearchContent();
		}
	}

	/**
	 * 
	 * @方法名称: index 
	 * @实现功能: 加载左侧树
	 * @param dcSearchContent
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:58:58
	 */
	@RequiresPermissions("dc:searchContent:index")
	@RequestMapping(value = { "index" })
	public String index(DcSearchContent dcSearchContent, Model model, HttpServletRequest request,
			HttpServletResponse response) {
		String id = request.getParameter("id");
		model.addAttribute("parentId", id);
		return "modules/dc/dataSearch/dcSearchContentIndex";
	}

	/**
	 * 
	 * @方法名称: list 
	 * @实现功能: 加载右侧列表
	 * @param dcSearchContent
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:59:15
	 */
	@RequestMapping(value = { "list", "" })
	public String list(DcSearchContent dcSearchContent, Model model) {
		List<DcSearchContent> list = dcSearchContentService.findListBy(dcSearchContent);
		// List<DcSearchContent> list =
		// dcSearchContentService.findList(dcSearchContent);
		model.addAttribute("list", list);
		model.addAttribute("cataItemId", dcSearchContent.getCataItemId());
		// model.addAttribute("list", dcSearchContentService.findAll());
		return "modules/dc/dataSearch/dcSearchContentList";
	}

	/**
	 * 
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax加载列表
	 * @param dcSearchContent
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:59:29
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcSearchContent dcSearchContent, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<DcSearchContent> page = dcSearchContentService.findDcSearchContent(new Page<DcSearchContent>(request),
				dcSearchContent);
		// model.addAttribute("page", page);
		List<DcSearchContent> list = page.getList();
		// 转换类型
		/*
		 * for (DcSearchContent dcSearchContent2 : list) {
		 * dcSearchContent2.setType(DictUtils.getDictLabel(dcSearchContent2.
		 * getType(), "sys_dcSearchContent_type", "")); }
		 */
		DataTable a = new DataTable();
		// 绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
		// 必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int) page.getCount());
		// 必要，过滤后的记录数 不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int) page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson", gson.toJson(list));
		// a.setStart(start);
		// a.setDraw(draw);
		return a;
	}

	/**
	 * 
	 * @方法名称: form 
	 * @实现功能: 新增修改页面
	 * @param dcSearchContent
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:59:55
	 */
	@RequiresPermissions(value = { "dc:searchContent:add",
			"dc:searchContent:edit" }, logical = Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcSearchContent dcSearchContent, Model model) {

		// // 自动获取排序号
		// if (StringUtils.isBlank(dcSearchContent.getId())){
		// int size = 0;
		// List<DcSearchContent> list = dcSearchContentService.findAll();
		// for (int i=0; i<list.size(); i++){
		// DcSearchContent e = list.get(i);
		// if (e.getParent()!=null && e.getParent().getId()!=null
		// &&
		// e.getParent().getId().equals(dcSearchContent.getParent().getId())){
		// size++;
		// }
		// }
		// dcSearchContent.setCode(dcSearchContent.getParent().getCode() +
		// StringUtils.leftPad(String.valueOf(size > 0 ? size : 1), 4, "0"));
		// }
		model.addAttribute("dcSearchContent", dcSearchContent);
		return "modules/dc/dataSearch/dcSearchContentForm";
	}

	/**
	 * 
	 * @方法名称: view 
	 * @实现功能: 查看页面
	 * @param dcSearchContent
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:03:48
	 */
	@RequiresPermissions(value={"dc:searchContent:view"})
	@RequestMapping(value = "view")
	public String view(DcSearchContent dcSearchContent, Model model) {
		model.addAttribute("dcSearchContent", dcSearchContent);
		return "modules/dc/dataSearch/dcSearchContentView";
	}
	
	/**
	 * 
	 * @方法名称: save 
	 * @实现功能: 保存
	 * @param dcSearchContent
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:15
	 */
	@RequiresPermissions(value = { "dc:searchContent:add", "dc:searchContent:edit" }, logical = Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcSearchContent dcSearchContent, Model model, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/dc/dataSearch/dcSearchContent";
		}
		if (!beanValidator(model, dcSearchContent)) {
			return form(dcSearchContent, model);
		}
		dcSearchContentService.save(dcSearchContent);
		addMessage(redirectAttributes, "保存分类'" + dcSearchContent.getName() + "'成功");
		return "redirect:" + adminPath + "/dc/dataSearch/dcSearchContent/";
	}

	/**
	 * 
	 * @方法名称: delete 
	 * @实现功能: 删除
	 * @param dcSearchContent
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:23
	 */
	@RequiresPermissions("dc:searchContent:del")
	@RequestMapping(value = "delete")
	public String delete(DcSearchContent dcSearchContent, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/dc/dataSearch/dcSearchContent";
		}
		// if (DcSearchContent.isRoot(id)){
		// addMessage(redirectAttributes, "删除分类失败, 不允许删除顶级分类或编号为空");
		// }else{
		List<DcObjectMain> ids = new ArrayList<>();
		dcSearchContentService.delete(dcSearchContent,ids);
		if(ids.size()>0){
			dcObjectMainService.updateData2Es(ids);
		}
		addMessage(redirectAttributes, "删除分类成功");
		// }
		return "redirect:" + adminPath + "/dc/dataSearch/dcSearchContent/";
	}

	/**
	 * 
	 * @方法名称: treeData 
	 * @实现功能: 加载拼接树
	 * @param extId
	 * @param response
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:34
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required = false) String extId,
			HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<DcSearchContent> list = dcSearchContentService.findAll();
		DcContentTable tableName = new DcContentTable();
		tableName = dcContentTableService.get(extId);

		Map<String, Object> map = Maps.newHashMap();
		map.put("id", extId);
		map.put("name", tableName.getItemName());
		mapList.add(map);

		for (int i = 0; i < list.size(); i++) {
			DcSearchContent e = list.get(i);
			if (StringUtils.isNotBlank(extId) && e.getParentIds().indexOf(extId + ",") != -1) {
				map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getCataName());
				mapList.add(map);
			}
		}
		return mapList;
	}

	/**
	 * 
	 * @方法名称: deleteA 
	 * @实现功能: ajax删除
	 * @param dcSearchContent
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:57
	 */
	@ResponseBody
	@RequestMapping(value = "deleteA")
	public AjaxJson deleteA(DcSearchContent dcSearchContent, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();

		if (Global.isDemoMode()) {
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		List<DcObjectMain> ids = new ArrayList<>();
		dcSearchContentService.delete(dcSearchContent,ids);
		if(ids.size()>0){
			dcObjectMainService.updateData2Es(ids);
		}
		ajaxJson.setMsg("删除分类成功");
		return ajaxJson;
	}

	/**
	 * 
	 * @方法名称: saveA 
	 * @实现功能: ajax保存
	 * @param dcSearchContent
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:01:08
	 */
	@ResponseBody
	@RequestMapping(value = "saveA")
	public AjaxJson saveA(DcSearchContent dcSearchContent, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if (Global.isDemoMode()) {
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		if (!beanValidator(model, dcSearchContent)) {
			ajaxJson.setMsg("数据验证失败！");
		}
		if (dcSearchContent.getCataItemId().equals(dcSearchContent.getParent().getId())) {
			dcSearchContentService.saveTop(dcSearchContent);
			return ajaxJson;
		} else {
			dcSearchContentService.save(dcSearchContent);
			ajaxJson.setMsg("保存分类'" + dcSearchContent.getCataName() + "'成功");
			return ajaxJson;
		}
	}
	/**
	 * 
	 * @方法名称: checkItemName 
	 * @实现功能: 判断分类项目名否已存在
	 * @param oldItemName
	 * @param cataName
	 * @return
	 * @create bao gang 2017年4月10日 下午17:48:40
	 */
	@ResponseBody
	@RequestMapping(value = "checkItemName")
	public String checkItemName(String oldItemName, String cataName,String cataItemId) {
		if (cataName !=null && cataName.equals(oldItemName)) {
			return "true";
		} else if (cataName !=null && dcSearchContentService.findUniqueByPr("cata_name", "'"+cataName+"'","'"+cataItemId+"'") == null) {
			return "true";
		}
		return "false";
	}

	

	/**
	 * 
	 * @方法名称: checkCodeName 
	 * @实现功能: 判断分类编吗是否已存在
	 * @param oldCodeName
	 * @param cataCode
	 * @return
	 * @create  bao gang  2017年3月30日 下午17:48:40
	 */
	@ResponseBody
	@RequestMapping(value = "checkCodeName")
	public String checkCodeName(String oldItemCode, String cataCode ,String cataItemId) {
		if (cataCode !=null && cataCode.equals(oldItemCode)) {
			return "true";
		} else if (cataCode !=null && dcSearchContentService.findUniqueByPr("cata_code", "'"+cataCode+"'","'"+cataItemId+"'") == null) {
			return "true";
		}
		return "false";
	}
}
