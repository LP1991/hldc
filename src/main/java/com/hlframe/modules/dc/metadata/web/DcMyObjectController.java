/**
 * 
 */
package com.hlframe.modules.dc.metadata.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
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
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.datasearch.entity.DcContentTable;
import com.hlframe.modules.dc.datasearch.entity.DcSearchContent;
import com.hlframe.modules.dc.datasearch.service.DcContentTableService;
import com.hlframe.modules.dc.datasearch.service.DcSearchContentService;
import com.hlframe.modules.dc.metadata.entity.DcObjectAu;
import com.hlframe.modules.dc.metadata.entity.DcObjectCataRef;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.metadata.service.DcObjectCataRefService;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.dc.metadata.service.SetNameBySourceService;
import com.hlframe.modules.sys.utils.DictUtils;
import com.hlframe.modules.sys.utils.UserUtils;

/**
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcMyObject")
public class DcMyObjectController extends  BaseController {
	@Autowired
	private DcObjectAuService dcObjectAuService;
	@Autowired
	private SetNameBySourceService setNameBySourceService;
	//数据对象Service
	@Autowired
	private DcObjectMainService dcObjectMainService;
	//数据分类Service
	@Autowired
	private DcSearchContentService dcSearchContentService;
	
	//分类项目Service
	@Autowired
	private DcContentTableService dcContentTableService;
	
	@Autowired
	private DcObjectCataRefService dcObjectCataRefService;
	
	
	
	
	@RequestMapping(value = {"index"})
	public String index(DcObjectMain obj, Model model) {
		
		List<Map<String, String>> cataItemList = new LinkedList<Map<String, String>>();
		String defaultItem = null;
		Map<String, String> cataMap = null;
		for(DcContentTable cataItem: dcContentTableService.findList(new DcContentTable())){
			if(StringUtils.isEmpty(defaultItem)){
				defaultItem = cataItem.getId();
			}
			cataMap = new HashMap<String, String>();
			cataMap.put("id", cataItem.getId());			//项目ID
			cataMap.put("name", cataItem.getItemName());	//项目名称
			cataMap.put("code", cataItem.getItemCode());	//项目编码
			cataItemList.add(cataMap);
		}
		//分类项列表
		model.addAttribute("cataItemList", cataItemList);
		//当前分类项
		if(StringUtils.isEmpty(defaultItem)){
			defaultItem = "null";
		}
		model.addAttribute("curCataItem", defaultItem);
		return "modules/dc/metaData/dcObjectMain/dcObjectMainIndex";
	}
	/**
	 * @方法名称: buildCataTree 
	 * @实现功能: 构建分类/目录树
	 * @param extId	分类项目ID
	 * @param response
	 * @return
	 * @create by peijd at 2016年11月9日 下午3:13:11
	 */
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> buildCataTree(@RequestParam(required=false) String itemId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		if(StringUtils.isNotBlank(itemId)){
			DcContentTable cataItem = dcContentTableService.get(itemId);
			//设置根节点
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", itemId);
//			map.put("pId", "-1");  //根目录 不能设置pId
			map.put("name", cataItem.getItemName());
		
			mapList.add(map);
			
			DcSearchContent param = new DcSearchContent();
			param.setCataItemId(itemId);
			//获取分类树  逐个添加
			List<DcSearchContent> cataList = dcSearchContentService.findListBy(param);
			if(CollectionUtils.isNotEmpty(cataList)){
				for(DcSearchContent cataDetail: cataList){
					map = Maps.newHashMap();
					map.put("id", cataDetail.getId());
					map.put("pId", cataDetail.getParentId());
					map.put("name", cataDetail.getCataName());
					mapList.add(map);
				}
			}
		}
		return mapList;
	}
	/**
	 * @方法名称: list 
	 * @实现功能: 数据对象列表
	 * @param area
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月9日 下午2:06:27
	 */
	@RequestMapping(value = {"list"})
	public String list(DcObjectMain obj, Model model) {
		obj.setObjType("apply");
		model.addAttribute("objectMain",obj );		
		return "modules/dc/metaData/dcObjectMain/dcMyObjectAuList";
	
	}
	
	/**
	 * 查询我的数据
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist1")
	public DataTable ajaxlist1(DcObjectMain obj, HttpServletRequest request, HttpServletResponse response, Model model) {
		//获取数据类型， 默认获取我的申请  apply-我申请的数据； collect-我收藏的数据
		String dataType = StringUtils.isNotBlank(obj.getObjCata())?obj.getObjCata():"apply";
		obj.setObjCata(null);
 		Page<DcObjectMain> page = new Page<DcObjectMain>(request);
 		obj.setPage(page);
 		//List<DcObjectMain> list = obj.setPage(page);
		obj.setCreateBy(UserUtils.getUser());
		//查看我得申请
		if("apply".equals(dataType)){
			page.setList(dcObjectAuService.queryMyDataList(obj));
			
		}else if("collect".equals(dataType)){
			page.setList(dcObjectAuService.colleCtDataList(obj));
		}
	
		DataTable b = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		b.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		b.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		b.setRecordsFiltered((int)page.getCount());
		b.setLength(page.getPageSize());
		Gson gson = new Gson();
		b.put("gson",gson.toJson(page.getList()));
		return b;
	}

/*
 * 删除
 */
	@ResponseBody
	@RequestMapping(value = "nopass")
	public AjaxJson nopass(String id, RedirectAttributes redirectAttributes) {
		DcObjectMain obj = dcObjectMainService.get(id);
		dcObjectMainService.delete(obj);
		AjaxJson ajaxJson = new AjaxJson();
		ajaxJson.setMsg("删除成功");
		return ajaxJson;
	}


	/*
	 * 查看
	 */
	//@RequiresPermissions(value={"dc:metadata:dcObjectMain:view"})
	@RequestMapping(value = "dataView")
	public String view(String id , Model model) {
		model.addAttribute("objectMain", dcObjectAuService.getById(id));		
		return "modules/dc/metaData/dcObjectMain/dcObjectAuView";       //查看页面
	}
	
	@ResponseBody
	@RequestMapping(value = "saveChange")
	public AjaxJson saveChange(String ids,String cataId,String oldCataId){
		AjaxJson ajaxJson = new AjaxJson();
		String idArray[] =ids.split(",");
		for(String id : idArray){
			DcObjectCataRef dcObjectCataRef = new DcObjectCataRef();
			dcObjectCataRef.setObjId(id);
			dcObjectCataRef.setCataId(cataId);
			dcObjectCataRef.setOldCataId(oldCataId);
			dcObjectCataRefService.update(dcObjectCataRef);
		}
		ajaxJson.setMsg("分类保存成功");
		return ajaxJson;
	}	
	@ResponseBody
	@RequestMapping(value = "ajaxlists")
	public DataTable ajaxlists(DcObjectMain obj, HttpServletRequest request, HttpServletResponse response, Model model) {
		
 		Page<DcObjectMain> page = new Page<DcObjectMain>(request);
 		obj.setPage(page);
 		//List<DcObjectMain> list = obj.setPage(page);
		obj.setCreateBy(UserUtils.getUser());
  
		page.setList(dcObjectAuService.queryMyDataList(obj));
		
		page.setList(dcObjectAuService.colleCtDataList(obj));
	
		DataTable b = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		b.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		b.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		b.setRecordsFiltered((int)page.getCount());
		b.setLength(page.getPageSize());
		Gson gson = new Gson();
		b.put("gson",gson.toJson(page.getList()));
		return b;
	}

}
