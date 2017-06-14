/********************** 版权声明 *************************
 * 文件名: DcTransDataMainController.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月30日 下午4:04:08
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.web;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.dataprocess.service.DcTransEngineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.common.DcConstants;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataMain;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSub;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSubLog;
import com.hlframe.modules.dc.dataprocess.service.DcTransDataMainService;
import com.hlframe.modules.dc.dataprocess.service.DcTransDataSubService;
import com.hlframe.modules.dc.metadata.entity.DcDataSource;
import com.hlframe.modules.dc.metadata.service.DcDataSourceService;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcTransDataMainController.java 
 * @职责说明: 数据转换任务/过程Controller
 * @创建者: peijd
 * @创建时间: 2016年11月30日 下午4:04:08 
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/transData")
public class DcTransDataMainController extends BaseController {

	@Autowired
	private DcTransDataMainService dcTransDataMainService;
	@Autowired
	private DcTransDataSubService dcTransDataSubService;
	@Autowired
	private DcDataSourceService dcDataSourceService;

	@Autowired
	private DcTransEngineService engineService;
	
	/**
	 * @方法名称: list 
	 * @实现功能: 查询列表 
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:20:10
	 */
	@RequestMapping(value = "list")
	public String list(DcTransDataMain obj, Model model) {
		model.addAttribute("jobInfo", obj);
		return "modules/dc/dataProcess/dcTransData/dcTransDataList";
	}
	
	/**
	 * @方法名称: form 
	 * @实现功能: 填充编辑表单内容
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:19:48
	 */
	@RequestMapping(value = "form")
	public String form(DcTransDataMain obj, Model model) {	
		//Id不为空 转换为对象  
		if(StringUtils.isNotEmpty(obj.getId())){
			obj = dcTransDataMainService.get(obj.getId());
		}
		model.addAttribute("jobInfo", obj);
		//数据源列表  下拉列表中显示数据源类别
		return "modules/dc/dataProcess/dcTransData/dcTransDataForm";
	}

	/**
	 * @方法名称: showScriptParam
	 * @实现功能: 显示脚本变量参数页面
	 * @param model
	 * @return  java.lang.String
	 * @create by peijd at 2017/5/18 10:25
	 */
	@RequestMapping(value = "showScriptParam")
	public String showScriptParam(Model model){
		//获取脚本变量参数列表
		model.addAttribute("paramList", dcTransDataSubService.getParamRegexMap());
		return "modules/dc/dataProcess/dcTransData/dcShowScriptParam";
	}
	
	/**
	 * @方法名称: checkJobName 
	 * @实现功能: 检测Job是否存在
	 * @param oldJobName
	 * @param jobName
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:19:34
	 */
	@ResponseBody
	@RequestMapping(value = "checkJobName")
	public String checkJobName(String oldJobName, String jobName) {	
		if (jobName !=null && jobName.equals(oldJobName)) {
			return "true";
		} else if (jobName !=null && dcTransDataMainService.getJobName(jobName) == null) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax方式查询列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:18:53
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcTransDataMain obj, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcTransDataMain> page = dcTransDataMainService.findPage(new Page<DcTransDataMain>(request), obj);
		List<DcTransDataMain> list = page.getList();
		
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
	 * @方法名称: view 
	 * @实现功能: 查看数据明细 TODO
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:18:43
	 */
	@RequestMapping(value = "dataView")
	public String view(DcTransDataMain obj , Model model) {
		//Id不为空 转换为对象  
		if(StringUtils.isNotEmpty(obj.getId())){
			obj = dcTransDataMainService.get(obj.getId());
		}
		model.addAttribute("jobInfo", obj);
		return "modules/dc/dataProcess/dcTransData/dcTransDataView";       //查看页面
	}
	
	/**
	 * @方法名称: cfgProcess 
	 * @实现功能: 数据转换过程设计
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月1日 上午9:19:56
	 */
	@RequestMapping(value = "cfgProcess")
	public String cfgProcess(DcTransDataMain obj , Model model) {
		//获取过程信息
		obj = dcTransDataMainService.get(obj.getId());
		model.addAttribute("jobInfo", obj);
		
		//获取过程列表
		DcTransDataSub param = new DcTransDataSub();
		param.setJobId(obj.getId());
		List<DcTransDataSub> processList = dcTransDataSubService.findList(param);
		model.addAttribute("proList", processList);
		
		return "modules/dc/dataProcess/dcTransData/dcCfgProcess";       //数据转换过程页面
	}
	
	/**
	 * @方法名称: ajaxDelete 
	 * @实现功能: ajax删除对象
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2016年11月16日 下午9:30:04
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDelete")
	public AjaxJson ajaxDelete(DcTransDataMain obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcTransDataMainService.delete(obj);
			ajaxJson.setMsg("删除数据对象成功!");
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("删除数据对象失败! "+e.getMessage());
			logger.error("-->ajaxDelete", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: ajaxSave 
	 * @实现功能:  ajax方式保存数据对象 TODO
	 * @param obj
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:18:21
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcTransDataMain obj, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcTransDataMainService.save(obj);
			ajaxJson.setMsg("保存数据对象'" + obj.getJobName() + "'成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("保存数据对象失败!");
			logger.error("-->ajaxSave", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: jobTest 
	 * @实现功能: 测试任务 TODO
	 * @param jobId
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:18:11
	 */
	@ResponseBody
	@RequestMapping(value = "jobTest")
	public AjaxJson jobTest(String jobId, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			DcDataResult result = dcTransDataMainService.runTask(jobId);
			ajaxJson.setMsg(result.getRst_flag()?result.getRst_std_msg():result.getRst_err_msg());
		} catch (Exception e) {
			ajaxJson.setMsg("任务运行失败!</br>"+e.getMessage());
			logger.error("-->DcTransDataMainController.testTask", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: transProcess 
	 * @实现功能: 转换过程配置
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月1日 下午3:36:03
	 */
	@RequestMapping(value = "transProcess")
	public String transProcess(DcTransDataMain obj, Model model) {
		//Id不为空 转换为对象  
		if(StringUtils.isNotEmpty(obj.getId())){
			obj = dcTransDataMainService.get(obj.getId());
		}
		DcTransDataSub param = new DcTransDataSub();
		param.setJobId(obj.getId());
		//过程列表
//		List<DcTransDataSub> list = dcTransDataSubService.findList(param);
//		model.addAttribute("list", list);
		model.addAttribute("jobInfo", obj);
		return "modules/dc/dataProcess/dcTransData/dcCfgProcess";
	}
	
	/**
	 * @方法名称: processList 
	 * @实现功能: 查询转换过程列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月1日 下午3:15:25
	 */
	@ResponseBody
	@RequestMapping(value = "processList")
	public DataTable processList(DcTransDataSub obj, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcTransDataSub> page = dcTransDataSubService.findPage(new Page<DcTransDataSub>(request), obj);
		List<DcTransDataSub> list = page.getList();
		
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
	 * @方法名称: processTest 
	 * @实现功能: 测试转换过程
	 * @param processId
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月1日 上午10:47:04
	 */
	@ResponseBody
	@RequestMapping(value = "processTest")
	public AjaxJson processTest(String processId, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();		
		StringBuilder rst = new StringBuilder(64);
		try {
			DcTransDataSubLog log  = dcTransDataSubService.runProcess(processId);
			if(DcConstants.DC_RESULT_FLAG_TRUE.equalsIgnoreCase(log.getStatus())){
				rst.append("转换过程运行成功!");
			}else{
				rst.append("转换过程运行失败!</br>");
				rst.append("明细:").append(log.getRemarks());
			}
		} catch (Exception e) {
			rst.append("转换过程运行失败!</br>");
			rst.append("明细:").append(e.getMessage());
			logger.error("-->DcTransDataMainController.testProcess", e);
		}
		ajaxJson.setMsg(rst.toString());
		return ajaxJson;
	}
	
	/**
	 * @方法名称: processView 
	 * @实现功能: 查看转换过程
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月1日 上午10:57:02
	 */
	@RequestMapping(value = "processView")
	public String processView(DcTransDataSub obj , Model model) {
		//Id不为空 转换为对象  
		if(StringUtils.isNotEmpty(obj.getId())){
			obj = dcTransDataSubService.get(obj.getId());
		}
		//还原换行符
		if(StringUtils.isNotEmpty(obj.getTransSql())){
			obj.setTransSql(obj.getTransSql().replaceAll(DcConstants.DC_TRANSLATE_SWAPLINE, "\r\n"));
		}
		model.addAttribute("proInfo", obj);
		return "modules/dc/dataProcess/dcTransData/dcTransProcessView";       //查看页面
	}
	
	/**
	 * @方法名称: processForm 
	 * @实现功能: 转换过程表单编辑
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月1日 下午1:30:00
	 */
	@RequestMapping(value = "processForm")
	public String processForm(DcTransDataSub obj, Model model) {	
		//Id不为空 编辑页面  
		if(StringUtils.isNotEmpty(obj.getId())){
			obj = dcTransDataSubService.get(obj.getId());
			//根据转换关系, 生成对应转换脚本
//			obj.setTransSql(dcTransDataSubService.buildTransSql(obj));
			/*还原换行符*/
			if(StringUtils.isNotEmpty(obj.getTransSql())){
				obj.setTransSql(obj.getTransSql().replaceAll(DcConstants.DC_TRANSLATE_SWAPLINE, "\r\n"));
			}
		}else{
			//新增页面 自动设置sortNum  获取转换过程数
			obj.setSortNum((1+dcTransDataSubService.queryTransNum(obj.getJobId()))*10);
		}
		
		//数据源选择列表
		model.addAttribute("dataSourceList", dcDataSourceService.buildSelectList(new DcDataSource()));
		model.addAttribute("proInfo", obj);
		return "modules/dc/dataProcess/dcTransData/dcTransProcessForm";
	}
	
	/**
	 * @方法名称: processSave 
	 * @实现功能: 保存数据转换过程
	 * @param obj
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月1日 下午2:15:32
	 */
	@ResponseBody
	@RequestMapping(value = "processSave")
	public AjaxJson processSave(DcTransDataSub obj, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			obj.setTransType(DcTransDataSub.TRANS_TYPE_TRANSLATE);	//数据转换类型
			dcTransDataSubService.saveProcess(obj);
			ajaxJson.setMsg("保存数据对象'" + obj.getTransName() + "'成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("保存数据对象失败!");
			logger.error("-->ajaxSave", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: processDelete 
	 * @实现功能: 删除转换任务
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2016年12月3日 下午4:29:01
	 */
	@ResponseBody
	@RequestMapping(value = "processDelete")
	public AjaxJson processDelete(DcTransDataSub obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcTransDataSubService.deleteByLogic(obj);
			ajaxJson.setMsg("删除转换过程成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("删除转换过程失败!");
			logger.error("-->DcTransDataMainController.processDelete", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: checkProName 
	 * @实现功能: 检查过程名称是否重复
	 * @param oldProName 原名称
	 * @param jobId		任务Id
	 * @param transName	过程名称
	 * @return
	 * @create by peijd at 2016年12月1日 下午2:17:11
	 */
	@ResponseBody
	@RequestMapping(value = "checkProName")
	public String checkProName(String oldProName, String jobId, String transName) {	
		if (transName !=null && transName.equals(oldProName)) {
			return "true";
		} else if (transName !=null && dcTransDataSubService.getProName(transName, jobId) == null) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * @方法名称: scheduleForm 
	 * @实现功能: 添加调度任务
	 * @param obj
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:17:52
	 */
	@ResponseBody
	@RequestMapping(value = "add2Schedule")
	public AjaxJson add2Schedule(String jobId, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			String msg = dcTransDataMainService.add2Schedule(jobId);
			ajaxJson.setMsg(msg);
		} catch (Exception e) {
			ajaxJson.setMsg("调度任务添加失败!</br>"+e.getMessage());
			logger.error("DcTransDataMainController.testTask", e);
		}
		return ajaxJson;
	}
}
