/********************** 版权声明 *************************
 * 文件名: DcDataMapController.java
 * 包名: com.hlframe.modules.dc.datasearch.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月9日 下午1:56:12
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.metadata.entity.DcSysObjm;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
import com.hlframe.modules.dc.metadata.service.DcObjectCataRefService;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.dc.metadata.service.SetNameBySourceService;
import com.hlframe.modules.sys.utils.DictUtils;
import com.hlframe.modules.sys.utils.UserUtils;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.web.DcDataMapController.java 
 * @职责说明: 数据地图接入类
 * @创建者: peijd
 * @创建时间: 2016年11月9日 下午1:56:12
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/datasearch/dataMap")
public class DcDataMapController extends BaseController {
	

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
	@Autowired
	private DcObjectAuService authService;
	/**
	 * @方法名称: index 
	 * @实现功能: 数据地图首页
	 * @param area
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月9日 下午1:58:36
	 */
	@RequiresPermissions("dc:datasearch:dataMap:index")
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
		return "modules/dc/dataSearch/dataMap/datamapIndex";
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
		if(StringUtils.isNotEmpty(itemId)){
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
		model.addAttribute("objectMain",obj );		
		return "modules/dc/dataSearch/dataMap/dataList";
	}
	
	/**
	 * @方法名称: ajaxlist 
	 * @实现功能: 根据分类/目录  查询数据对象分页列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月9日 下午2:35:35
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcObjectMain obj, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcObjectMain> page = dcObjectMainService.findPageByCata(new Page<DcObjectMain>(request), obj);
		List<DcObjectMain> list = page.getList();
		String curUserId = UserUtils.getUser().getId();
		//查询权限列表
		List<DcSysObjm> accreList = authService.getAccreList(curUserId, null);
		List<String> hlist = new ArrayList<String>();
		for (DcSysObjm map : accreList) {
			if (StringUtils.isNotBlank(map.getObjMainId()))
				hlist.add(map.getObjMainId());
		}
		for (DcObjectMain aaa : list) {
			//如果是当前用户创建, 则拥有所有权限 modify by  bao gang
			if(curUserId.equals(aaa.getCreateBy().getId())){
				aaa.setAccre(1);
			
			}else{	//申请过权限的
				for(String str :hlist){
					if(StringUtils.isNotBlank(aaa.getId()) && aaa.getId().equals(str)){
						aaa.setAccre(1);
					}
				}
			}
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
		return a;
	}
	
	@RequiresPermissions("dc:datasearch:dataMap:edit")
	@RequestMapping(value = "editSort")
	public String editSort(String ids,String cataId,String oldCataId,Model model) {
		model.addAttribute("cataId" , cataId);
		model.addAttribute("ids" , ids);
		model.addAttribute("oldCataId",oldCataId);
		return "modules/dc/dataSearch/dataMap/dataEditForm";
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
		dcObjectMainService.updateData2Es(idArray);
		ajaxJson.setMsg("分类保存成功");
		return ajaxJson;
	}

}
