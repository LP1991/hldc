
/********************** 版权声明 *************************
 * 文件名: DcHiveDatabaseController.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2017年1月10日 下午3:56:40
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.web;

import java.util.List;
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

import com.google.gson.Gson;
import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.BaseEntity;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.IdGen;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveDatabase;
import com.hlframe.modules.dc.dataprocess.service.DcHiveDatabaseService;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.service.DcMetadataStroeService;
import com.hlframe.modules.dc.utils.RegExpValidatorUtils;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcHiveDatabaseController.java 
 * @职责说明: 表空间管理控制台
 * @创建者: yuzh
 * @创建时间: 2017年1月10日 下午3:56:40
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/dcHiveDatabase")
public class DcHiveDatabaseController extends BaseController {

	@Autowired
	private DcHiveDatabaseService dcHiveDatabaseService;
	
	@Autowired
	private DcMetadataStroeService dcMetadataStroeService;

	@ModelAttribute("dcHiveDatabase")
	public DcHiveDatabase get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			DcHiveDatabase dcHiveDatabase = new DcHiveDatabase();
			dcHiveDatabase.setId(id);
			dcHiveDatabase.setDelFlag(BaseEntity.DEL_FLAG_NORMAL);
			return dcHiveDatabaseService.get(dcHiveDatabase);
		} else {
			return new DcHiveDatabase();
		}
	}

	/**
	 * 
	 * @方法名称: list 
	 * @实现功能: 加载列表
	 * @param dcHiveDatabase
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:59:15
	 */
	@RequestMapping(value = { "list", "" })
	public String list(DcHiveDatabase dcHiveDatabase, Model model) {
		List<DcHiveDatabase> list = dcHiveDatabaseService.findList(dcHiveDatabase);
		model.addAttribute("list", list);
		return "modules/dc/dataProcess/dcHiveDatabase/dcHiveDatabaseList";
	}

	/**
	 * 
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax加载列表
	 * @param dcHiveDatabase
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:59:29
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcHiveDatabase dcHiveDatabase, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<DcHiveDatabase> page = dcHiveDatabaseService.findDcHiveDatabase(new Page<DcHiveDatabase>(request),
				dcHiveDatabase);
		// model.addAttribute("page", page);
		List<DcHiveDatabase> list = page.getList();
		// 转换类型
		/*
		 * for (DcHiveDatabase dcHiveDatabase2 : list) {
		 * dcHiveDatabase2.setType(DictUtils.getDictLabel(dcHiveDatabase2.
		 * getType(), "sys_dcHiveDatabase_type", "")); }
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
	 * @param dcHiveDatabase
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:59:55
	 */
	@RequiresPermissions(value = { "dc:hiveDatabase:add",
			"dc:hiveDatabase:edit" }, logical = Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcHiveDatabase dcHiveDatabase, Model model) {
		if(StringUtils.isNotEmpty(dcHiveDatabase.getId())){
		dcHiveDatabase.setDelFlag(BaseEntity.DEL_FLAG_NORMAL);
		}
		model.addAttribute("dcHiveDatabase", dcHiveDatabase);
		return "modules/dc/dataProcess/dcHiveDatabase/dcHiveDatabaseForm";
	}

	/**
	 * 
	 * @方法名称: view 
	 * @实现功能: 查看页面
	 * @param dcHiveDatabase
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:03:48
	 */
	@RequiresPermissions(value={"dc:hiveDatabase:view"})
	@RequestMapping(value = "view")
	public String view(DcHiveDatabase dcHiveDatabase, Model model) {
		model.addAttribute("dcHiveDatabase", dcHiveDatabase);
		return "modules/dc/dataProcess/dcHiveDatabase/dcHiveDatabaseView";
	}
	
	/**
	 * 
	 * @方法名称: delete 
	 * @实现功能: 删除
	 * @param dcHiveDatabase
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:23
	 */
	@RequiresPermissions("dc:hiveDatabase:del")
	@RequestMapping(value = "delete")
	public String delete(DcHiveDatabase dcHiveDatabase, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/dc/dataProcess/dcHiveDatabase/dcHiveDatabase";
		}
		// if (DcHiveDatabase.isRoot(id)){
		// addMessage(redirectAttributes, "删除空间失败, 不允许删除顶级空间或编号为空");
		// }else{
		dcHiveDatabaseService.delete(dcHiveDatabase);
		addMessage(redirectAttributes, "删除空间成功");
		// }
		return "redirect:" + adminPath + "/dc/dataProcess/dcHiveDatabase/dcHiveDatabase/";
	}


	/**
	 * 
	 * @方法名称: deleteA 
	 * @实现功能: ajax删除
	 * @param dcHiveDatabase
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:57
	 */
	@ResponseBody
	@RequestMapping(value = "deleteA")
	public AjaxJson deleteA(String id, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();

		if (Global.isDemoMode()) {
			ajaxJson.setMsg("演示模式，不允许操作！");
			return ajaxJson;
		}
		DcHiveDatabase dcHiveDatabase = new DcHiveDatabase();
		dcHiveDatabase.setId(id);
		dcHiveDatabase.setDelFlag(BaseEntity.DEL_FLAG_DELETE);
		//dcHiveDatabaseService.del(dcHiveDatabase);
		DcObjectMain dcObjectMain = new DcObjectMain();
		dcObjectMain.setId(id);
		dcMetadataStroeService.deObj2MySQL(dcObjectMain, dcHiveDatabase);
		ajaxJson.setMsg("删除空间成功");
		return ajaxJson;
	}

	/**
	 * 
	 * @方法名称: saveA 
	 * @实现功能: ajax保存
	 * @param dcHiveDatabase
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:01:08
	 */
	@ResponseBody
	@RequestMapping(value = "saveA")
	public AjaxJson saveA(DcHiveDatabase dcHiveDatabase, HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if (Global.isDemoMode()) {
			ajaxJson.setMsg("演示模式，不允许操作！");
			ajaxJson.setSuccess(false);
			return ajaxJson;
		}
		if (!beanValidator(model, dcHiveDatabase)) {
			ajaxJson.setMsg("数据验证失败！");
			ajaxJson.setSuccess(false);
			return ajaxJson;
		}else if(dcHiveDatabaseService.getDatabaseName(dcHiveDatabase.getDatabase())!=null&&"".equals(dcHiveDatabase.getId())){
			ajaxJson.setMsg("数据库名称已存在！");
			ajaxJson.setSuccess(false);
			return ajaxJson;
		}else{
			//如果是增加
			String result = null;
			DcObjectMain dcObjectMain = new DcObjectMain();
			boolean flag = true;
			if("".equals(dcHiveDatabase.getId())){
				dcObjectMain.setId(IdGen.uuid());
				dcHiveDatabase.setId(dcObjectMain.getId());
				flag = true;
				//result = dcHiveDatabaseService.executeMetaSqlInsert(dcHiveDatabase);
			}else{
				//修改
				flag = false;
				dcObjectMain.setId(dcHiveDatabase.getId());
			}
			result = dcHiveDatabaseService.executeMetaSql(dcHiveDatabase);
			if(result.equals("success")){
				if(flag){
					DcHiveDatabase db = dcHiveDatabaseService.byDatabaseGet(dcHiveDatabase);//如果数据库不存在该记录
					if(db==null){
						dcObjectMain.setObjCode(dcHiveDatabase.getId());
						dcObjectMain.setObjName(dcHiveDatabase.getDatabase());
						dcObjectMain.setObjType(DcObjectMain.OBJ_TYPE_DATABASE);
						dcObjectMain.setJobType(DcObjectMain.JOB_TYPE_HIVE);
						dcObjectMain.setJobSrcFlag(DcObjectMain.JOB_SRC_FLAG_NO);
						dcMetadataStroeService.obj2MySQL(dcObjectMain,dcHiveDatabase);
						//dcHiveDatabaseService.save(dcHiveDatabase);
					}
				}else{
					dcObjectMain.setObjCode(dcHiveDatabase.getId());
					dcObjectMain.setObjName(dcHiveDatabase.getDatabase());
					dcObjectMain.setObjType(DcObjectMain.OBJ_TYPE_DATABASE);
					dcObjectMain.setJobType(DcObjectMain.JOB_TYPE_HIVE);
					dcObjectMain.setJobSrcFlag(DcObjectMain.JOB_SRC_FLAG_NO);
					dcMetadataStroeService.obj2MySQL(dcObjectMain,dcHiveDatabase);
				}
				ajaxJson.setMsg("保存空间'" + dcHiveDatabase.getDatabase() + "'成功");
				ajaxJson.setSuccess(true);
				return ajaxJson;
			}else{
				ajaxJson.setMsg("保存空间'" + dcHiveDatabase.getDatabase() + "'失败"+result);
				ajaxJson.setSuccess(false);
				logger.error("-->executeMetaSql:",result);
				return ajaxJson;
			}
		}
	}

	/**
	 * 
	 * @方法名称: checkDatabase 
	 * @实现功能: 校验数据库名字命名规则
	 * @param database
	 * @return
	 * @create by hgw at 2017年4月12日 下午2:58:43
	 */
	@ResponseBody
	@RequestMapping(value = "checkDatabase")
	public String checkDatabase(String database) {	
		if (RegExpValidatorUtils.isDTable(database)) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * 
	 * @方法名称: checkJobName 
	 * @实现功能: TODO
	 * @param oldJobName
	 * @param jobName
	 * @return
	 * @create by hgw at 2017年4月12日 下午3:02:42
	 */
	@ResponseBody
	@RequestMapping(value = "checkDatabaseName")
	public String checkDatabaseName(String oldDatabase, String database) {	
		if (database !=null && database.equals(oldDatabase)) {
			return "true";
		} else if (database !=null && dcHiveDatabaseService.getDatabaseName(database) == null) {
			return "true";
		}
		return "false";
	}
	
}