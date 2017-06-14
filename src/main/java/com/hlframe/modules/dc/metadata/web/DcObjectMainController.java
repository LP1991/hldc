/********************** 版权声明 *************************
 * 文件名: DcDataSourceController.java
 * 包名: com.hlframe.modules.dc.metadata.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月7日 下午1:55:49
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.web;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabelRef;
import com.hlframe.modules.dc.datasearch.service.DcSearchLabelService;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.entity.DcSysObjm;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.sys.utils.UserUtils;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @类名: com.hlframe.modules.dc.metadata.web.DcObjectMainController.java
 * @职责说明: 元数据对象 统一控制类
 * @创建者: peijd
 * @创建时间: 2016年11月8日 下午2:42:00
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcObjectMain")
public class DcObjectMainController extends BaseController {
	@Autowired
	private DcSearchLabelService labelService; // 数据标签关系Service
	@Autowired
	private DcObjectMainService objMainService;
	@Autowired
	private DcObjectAuService authService;
	/**
	 * @方法名称: get
	 * @实现功能: 每次请求 构建对象
	 * @param id
	 * @return
	 * @create by peijd at 2016年11月16日 上午9:56:30
	 */
	@ModelAttribute("dcObjectMain")
	public DcObjectMain get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return objMainService.get(id);
		} else {
			return new DcObjectMain();
		}
	}

	/**
	 * @方法名称: list
	 * @实现功能: 元数据对象列表
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月8日 下午3:33:02
	 */
	@RequiresPermissions("dc:metadata:dcObjectMain:list")
	@RequestMapping(value = { "list", "" })
	public String list(DcObjectMain obj, Model model) {
		List<DcObjectMain> list = objMainService.findList(obj);
		model.addAttribute("list", list);
		model.addAttribute("objectMain", obj);
		return "modules/dc/metaData/dcObjectMain/dcObjectMainList";
	}

	/**
	 * @方法名称: configDetail
	 * @实现功能: 设置对象明细
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月8日 下午8:33:30
	 */
	@RequiresPermissions(value = { "dc:metadata:dcObjectMain:configDetail" })
	@RequestMapping(value = "configDetail")
	public String configDetail(DcObjectMain obj, Model model) {
		model.addAttribute("objectMain", obj);
		return "modules/dc/metaData/dcObjectMain/dcConfigDetail";
	}

	/**
	 * @方法名称: ajaxlist
	 * @实现功能: ajax分页列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月8日 下午4:25:08
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcObjectMain obj, HttpServletRequest request, HttpServletResponse response, Model model) {
		obj.setObjType(DcObjectMain.OBJ_TYPE_TABLE);//只显示数据表
		
		Page<DcObjectMain> page = objMainService.findPage(new Page<DcObjectMain>(request), obj);

		List<DcObjectMain> list = page.getList();
		String curUserId = UserUtils.getUser().getId();
		//查询权限列表
		List<DcSysObjm> accreList = authService.getAccreList(curUserId, null);
		List<String> hlist = new ArrayList<String>();
		for (DcSysObjm map : accreList) {
			if (StringUtils.isNotBlank(map.getObjMainId()))
				hlist.add(map.getObjMainId());
		}
		for(DcObjectMain aaa:list){
			//如果是当前用户创建, 则拥有所有权限  baog gang
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
		
		// 转换类型
		// for (DcObjectMain item : list) {
		// item.setDataScope(DictUtils.getDictLabel(role2.getDataScope(),
		// "sys_data_scope", ""));
		// }
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
		return a;
	}

	/**
	 * @方法名称: view
	 * @实现功能: 查看数据对象或数据表对象
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月8日 下午4:36:43
	 */
	@RequiresPermissions(value = { "dc:metadata:dcObjectMain:view" })
	@RequestMapping(value = "dataView")
	public String view(DcObjectMain obj, Model model, HttpServletRequest request) {

		DcObjectMain list = objMainService.tnadmin(obj.getId());
		model.addAttribute("objectMais", list);
		model.addAttribute("objectMain", obj);
		return "modules/dc/metaData/dcObjectMain/dcObjectMainView"; // 查看页面
	}

	/**
	 * 
	 * @方法名称: getAu
	 * @实现功能: 发起权限申请
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月19日 下午2:26:29
	 */
	@ResponseBody
	@RequestMapping(value = "getAu")
	public AjaxJson getAu(DcObjectMain obj, RedirectAttributes redirectAttributes) {
		objMainService.getAu(obj);
		AjaxJson ajaxJson = new AjaxJson();
		ajaxJson.setMsg("已向管理员申请该模型设置权限，请等待管理员审核!");
		return ajaxJson;
	}

	/**
	 * @方法名称: ajaxDelete
	 * @实现功能: ajax删除对象
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2016年11月8日 下午4:39:50
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDelete")
	public AjaxJson ajaxDelete(DcObjectMain obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			objMainService.delete(obj);
			ajaxJson.setMsg("删除数据对象成功!");

		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg(e.getMessage());
			logger.error("-->ajaxDelete:", e);
		}
		return ajaxJson;
	}


	/**
	 * @方法名称: updateView
	 * @实现功能: 标签对象分页
	 * @param mainId
	 * @param request
	 * @param dcSearchLabel
	 * @return
	 * @create by hgw at 2016年11月8日 下午4:36:43
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxLabel")
	public AjaxJson ajaxLabel(String mainId, HttpServletRequest request, DcSearchLabel dcSearchLabel) {
		dcSearchLabel.setId(mainId);
		Page<DcSearchLabel> page = objMainService.findLabelList(new Page<DcSearchLabel>(request), dcSearchLabel);
		List<DcSearchLabel> list = page.getList();
		DataTable a = new DataTable();
		a.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
		a.setRecordsTotal((int) page.getCount());
		a.setRecordsFiltered((int) page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson", gson.toJson(list));
		return a;
	}

	/**
	 * @方法名称: deleteLabel
	 * @实现功能: 删除标签对象
	 * @param id
	 * @param redirectAttributes
	 * @return
	 * @create by hgw at 2017年3月16日 下午4:36:43
	 */
	@ResponseBody
	@RequestMapping(value = "deleteLabel")
	public AjaxJson deleteLabel(String id, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		DcSearchLabelRef dcSearchLabelRef = new DcSearchLabelRef();
		dcSearchLabelRef.setLabelId(id);
		try {
			objMainService.Labeldelete(dcSearchLabelRef);
			ajaxJson.setMsg("删除标签成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("删除签失败!");
		}
		return ajaxJson;
	}

	/**
	 * @方法名称: editLabel
	 * @实现功能: 添加标签界面
	 * @param obj
	 * @param model
	 * @return
	 * @create by hgw at 2016年11月8日 下午4:36:43
	 */
	/* @RequiresPermissions(value={"dc:metadata:dcObjectMain:updateView"}) */
	@RequestMapping(value = "editLabel")
	public String editLabel(DcObjectMain obj, Model model, HttpServletRequest request, HttpServletResponse response) {
		// 所有标签

		DcSearchLabel dcSearchLabel = new DcSearchLabel();

		List<DcSearchLabel> AllList = labelService.findList(dcSearchLabel);
		model.addAttribute("AllList", AllList);
		// 选择标签
		List<DcSearchLabel> selectList = labelService.findLabelListByObjId(dcSearchLabel.getId());
		model.addAttribute("selectList", selectList);
		//
		List<String> ids = new ArrayList<String>();
		for (int i = 0; i < AllList.size(); i++) {
			DcSearchLabel d = AllList.get(i);
			for (int j = 0; j < selectList.size(); j++) {
				DcSearchLabel d2 = selectList.get(j);
				if (d.getId().equals(d2.getId())) {
					ids.add(d.getId());
				}
			}
		}
		model.addAttribute("ids", ids);
		model.addAttribute("dcObjectMain", obj);

		return "modules/dc/metaData/dcObjectMain/dcObjectMainUpdate"; // 查看页面
	}

	/**
	 * 查看我的申請的方法
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlists")
	public DataTable ajaxlists(DcObjectMain qid, HttpServletRequest request, HttpServletResponse response,
			Model model) {

		List<DcObjectMain> list = objMainService.quanglist(qid);
		DataTable b = new DataTable();
		// 绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		b.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
		b.setRecordsTotal(list.size());
		Gson gson = new Gson();
		b.put("gson", gson.toJson(list));
		return b;
	}

	/*
	 * 查我的收藏的方法
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxliste")
	public DataTable ajaxlistr(DcObjectMain sid, HttpServletRequest request, HttpServletResponse response,
			Model model) {

		List<DcObjectMain> list = objMainService.shochanlist(sid);
		DataTable c = new DataTable();
		// 绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		c.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
		c.setRecordsTotal(list.size());
		Gson gson = new Gson();
		c.put("gson", gson.toJson(list));
		return c;
	}

	/**
	 * 
	 * @方法名称: form
	 * @实现功能: 编辑标签表单页面
	 * @param dcSearchLabel
	 * @param model
	 * @return
	 * @create bao gang 2016年11月12日 上午11:50:46
	 */
	@RequiresPermissions(value = { "dc:searchLabel:add", "dc:searchLabel:edit" }, logical = Logical.OR)
	@RequestMapping(value = "forms")
	public String form(DcSearchLabel dcSearchLabel, Model model) {
	DcSearchLabel t = labelService.get(dcSearchLabel.getId());
			model.addAttribute("dcSearchLabel", t);
	
	
		return "modules/dc/metaData/dcObjectMain/dcObjectForm";
	}
	//添加标签
	//@RequiresPermissions(value={"dc:searchLabel:add","dc:searchLabel:edit"},logical=Logical.OR)
	@RequestMapping(value = "adds")
	public String add(DcSearchLabel dcSearchLabel, Model model) {
		model.addAttribute("dcSearchLabel", dcSearchLabel);
		
		return "modules/dc/metaData/dcObjectMain/dcObjectAdd";
	}

	/**
	 * 
	 * @方法名称: save
	 * @实现功能: 保存
	 * @param dcSearchLabel
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * @create bao cgang 2017年4月7日 上午9:51:11
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSaveTab")
	public AjaxJson save(DcSearchLabel dcSearchLabel, Model model, RedirectAttributes redirectAttributes)
			throws Exception {
		AjaxJson ajaxJson = new AjaxJson();

		if (!dcSearchLabel.getIsNewRecord()) {// 编辑表单保存
			DcSearchLabel t = labelService.get(dcSearchLabel.getId());// 从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcSearchLabel, t);// 将编辑表单中的非NULL值覆盖数据库记录中的值
			try {

				labelService.saveLabelRef(dcSearchLabel.getId(), dcSearchLabel.getLabelName());//进行校验
				labelService.save(t);// 保存
				ajaxJson.setMsg("保存成功!");
			} catch (Exception e) {
				ajaxJson.setMsg("保存失败! </br>" + e.getMessage());
				ajaxJson.setSuccess(false);
				logger.error("-->ajaxSaveLabelRef", e);
			}
		}
		return ajaxJson;
	}
	/**
	 * 
	 * @方法名称: save
	 * @实现功能: 保存关联标签
	 * @param dcSearchLabel
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * @create bao cgang 2017年4月11日 上午1:51:11
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSaveLabeladd")
	public AjaxJson ajaxSaveLabeladd(DcSearchLabel dcSearchLabel, Model model, RedirectAttributes redirectAttributes)
			throws Exception {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			labelService.saveLabelRef(dcSearchLabel.getId(), dcSearchLabel.getLabelName());//判断关联标签是否以存在
			ajaxJson.setMsg("保存成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("保存失败! </br>"+e.getMessage());
			ajaxJson.setSuccess(false);
			logger.error("-->ajaxSaveLabelRef", e);
		}
		
		return ajaxJson;
	}
	/**
	 * @方法名称: view
	 * @实现功能: 查看文件和文件夹对象
	 * @param obj
	 * @param model
	 * @return
	 * @create by  bao gang at 2017年4月20日 下午3:36:43
	 */
	@RequiresPermissions(value = { "dc:metadata:dcObjectMain:view" })
	@RequestMapping(value = "dataVie")
	public String vie(DcObjectMain obj, Model model, HttpServletRequest request) {

		DcObjectMain list = objMainService.tnadmin(obj.getId());
		model.addAttribute("objectMais", list);
		model.addAttribute("objectMain", obj);
		return "modules/dc/metaData/dcObjectMain/dcObjectMainDcoView"; // 查看页面
	}

	/**
	 * @方法名称: updateDco
	 * @实现功能:文件 文件夹对象修改界面
	 * @param obj
	 * @param model
	 * @return
	 * @create by bao gang at 2017年4月20日 下午3:36:43
	 */
	@RequestMapping(value = "updateDco")
	public String updateDco(DcObjectMain obj, Model model) {

		// 添加标签信息 modify by bao gnag d 0327
		List<DcSearchLabel> labelList = labelService.findLabelListByObjId(obj.getId());
		model.addAttribute("objLabelList", labelList);
		model.addAttribute("objectTable", obj);
		return "modules/dc/metaData/dcObjectMain/dcObjectMainDcoUpdate"; // 查看页面
	}

	/**
	 * @方法名称: ajaxDele
	 * @实现功能: ajax删除对象
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by bao gang at 2017年4月20日 下午4:39:50
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDele")
	public AjaxJson ajaxDele(DcObjectMain obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			objMainService.delete(obj);
			ajaxJson.setMsg("删除文件对象成功!");

		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg(e.getMessage());
			logger.error("-->ajaxDelete:", e);
		}
		return ajaxJson;
	}
}
