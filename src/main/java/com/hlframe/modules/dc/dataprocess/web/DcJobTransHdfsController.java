package com.hlframe.modules.dc.dataprocess.web;

/********************** 版权声明 *************************
 * 文件名: DcJodTransHdfsDataController.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：cdd   创建时间：2016年11月26日 下午5:06:08
 * 文件版本：V1.0 
 *
 *******************************************************/


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.common.service.DcCommonService;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransHdfs;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransHdfsService;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.dc.utils.RegExpValidatorUtils;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcJodTransHdfsDataController.java 
 * @职责说明: 数据转换任务Controller 
 * @创建者: peijd
 * @创建时间: 2016年11月16日 下午9:03:08
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/hdfsJob")
public class DcJobTransHdfsController extends BaseController {  

	@Autowired
	private DcJobTransHdfsService dcJobTransHdfsService;
	
	@Autowired
	private DcTaskTimeService dcTaskTimeService;

	@Autowired
	private DcCommonService dcCommonService;

	/**
	 * 
	 * @方法名称: list 
	 * @实现功能: Hdfs数据采集主页
	 * @param obj
	 * @param model
	 * @return
	 * @create by cdd at 2016年11月27日 上午10:03:23
	 */
	@RequiresPermissions("dc:dataProcess:hdfsJob:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcJobTransHdfs obj, Model model) {
//		List<DcJobTransHdfs> list = dcJobTransHdfsService.findList(obj);
//		model.addAttribute("list", list);
		if(StringUtils.isNotEmpty(obj.getId())){
			obj = dcJobTransHdfsService.get(obj.getId());
		}else{
			obj = new DcJobTransHdfs();
		}
		model.addAttribute("dcJobTransHdfs", obj);
		return "modules/dc/dataProcess/dcJobTransHdfs/dcJobTransHdfsList";
	}
	

	/**
	 * @方法名称: form 
	 * @实现功能: 编辑表单
	 * @param obj
	 * @param model
	 * @return
	 * @create by cdd at 2016年11月26日 下午9:28:21
	 */
	@RequiresPermissions(value={"dc:dataProcess:dcJobTransHdfs:add","dc:dataProcess:dcJobTransHdfs:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcJobTransHdfs obj, Model model) {
		if (StringUtils.isNotBlank(obj.getId())) {
			model.addAttribute("hdfsJob", dcJobTransHdfsService.get(obj.getId()));
		} else {
			obj.setCopyNum(1);
			model.addAttribute("hdfsJob",obj);
		}
		return "modules/dc/dataProcess/dcJobTransHdfs/dcJobTransHdfsForm";
	}
	
	@ResponseBody
	@RequestMapping(value = "checkJobName")
	public String checkJobName(String oldJobName, String jobName) {	
		if (jobName !=null && jobName.equals(oldJobName)) {
			return "true";
		} else if (jobName !=null && dcJobTransHdfsService.getJobName(jobName) == null) {
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
	 * @create by cdd at 2016年11月26日 下午9:28:30
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcJobTransHdfs obj, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcJobTransHdfs> page = dcJobTransHdfsService.findPage(new Page<DcJobTransHdfs>(request), obj);
		List<DcJobTransHdfs> list = page.getList();
		
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
	 * @实现功能: 查看数据明细
	 * @param obj
	 * @param model
	 * @return
	 * @create by cdd at 2016年11月26日 下午9:28:48
	 */
	@RequiresPermissions(value={"dc:dataProcess:dcJodTransHdfs:view"})
	@RequestMapping(value = "dataView")
	public String view(DcJobTransHdfs obj , Model model) {
		try {
			dcCommonService.initLoadDataToEs();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		model.addAttribute("hdfsJob", dcJobTransHdfsService.get(obj.getId()));		
		return "modules/dc/dataProcess/dcJobTransHdfs/dcJobTransHdfsView";       //查看页面
	}
	
	/**
	 * @方法名称: ajaxDelete 
	 * @实现功能: ajax删除对象
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create bycdd at 2016年11月26日 下午9:30:04
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDelete")
	public AjaxJson ajaxDelete(DcJobTransHdfs obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcJobTransHdfsService.delete(obj);
			ajaxJson.setMsg("删除数据对象成功!");
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("删除数据对象失败!"+e.getMessage());
			logger.error("-->ajaxDelete: ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * 
	 * @方法名称: ajaxSave 
	 * @实现功能:  ajax方式保存数据对象
	 * @param obj
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by cdd at 2016年11月27日 下午1:03:32
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcJobTransHdfs obj, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcJobTransHdfsService.save(obj);
			ajaxJson.setMsg("保存数据对象'" + obj.getJobName() + "'成功!");

		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("保存数据对象'" + obj.getJobName() + "'失败!");
			logger.error("--> ajaxSave! ", e );





		}
		return ajaxJson;
	}
	
	/**
	 * 
	 * @方法名称: runTask 
	 * @实现功能: 测试任务
	 * @param jobId
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by cdd at 2016年11月27日 下午1:03:47
	 */
	@ResponseBody
	@RequestMapping(value = "runTask")
	public AjaxJson runTask(String jobId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			DcDataResult result = dcJobTransHdfsService.runTask(jobId);
			ajaxJson.setMsg( result.getRst_flag()?result.getRst_std_msg():result.getRst_err_msg() );
			
		} catch (Exception e) {
			ajaxJson.setMsg("任务执行异常!");
			logger.error("dcJodTransHdfsDataService.runTask", e);
		}
		return ajaxJson;
	}
	
	/**
	 * 
	 * @方法名称: schedule
	 *
	 *
	 *
	 *
	 *
	 *
	 *
	 *
	 *
	 *
	 * @实现功能: 调度设置表单
	 * @param obj
	 * @param request
	 * @param model
	 * @return
	 * @create by cdd at 2016年11月27日 下午1:04:01
	 */
	@RequestMapping(value = "scheduleForm")
	public String scheduleForm(DcJobTransHdfs obj, HttpServletRequest request, Model model) {
		//任务表单明细
		obj = dcJobTransHdfsService.get(obj.getId());
		
		DcTaskTime param  = new DcTaskTime();
		//根据分类和ID查找  调度设置
		param.setTaskfromid(obj.getId());
		param.setTaskfromtype(DcTaskMain.TASK_FROMTYPE_EXTRACT_HDFS);
		List<DcTaskTime> taskList = dcTaskTimeService.findList(param);
		
		//没有对象则新建, 否则编辑
		if(CollectionUtils.isEmpty(taskList)){
			param.setScheduleName("HDFS数据采集任务_"+obj.getJobName());	//任务名
			param.setScheduleDesc("HDFS数据采集任务_"+obj.getJobDesc());	//描述
			param.setTaskfromname(obj.getJobDesc());					//任务描述
		}else{
			param = taskList.get(0);
		}
		//采集任务表单
		model.addAttribute("formData", param);
		return "modules/dc/dataProcess/dcJobTransData/dcJobSchedule";
	}


	
	/**
	 * 
	 * @方法名称: editExpress 
	 * @实现功能: 编辑表达式
	 * @param model
	 * @param request
	 * @return
	 * @create by cdd at 2016年11月27日 下午1:04:15
	 */
	@RequestMapping(value = "editExpress")
	public String editExpress(Model model, HttpServletRequest request) {
		//调度表达式 传值
		String cronExpr = StringUtils.isNotEmpty(request.getParameter("cronExpr"))?request.getParameter("cronExpr"):"* * * * * ?";
		model.addAttribute("cronExpr", cronExpr);			
		return "modules/dc/schedule/cronExpDesign";       //数据预览页面
	}
	
	/**
	 * 
	 * @方法名称: jobMonitor 
	 * @实现功能:  查看hadoop-job日志
	 * @param jobId
	 * @param request
	 * @param model
	 * @return
	 * @create by cdd at 2016年11月27日 下午1:04:31
	 */
	@ResponseBody
	@RequestMapping(value = "jobMonitor")
	public AjaxJson jobMonitor(String jobId, HttpServletRequest request, Model model) {
		
		String hdfsIp = DcPropertyUtils.getProperty("hadoop.main.address");
		String hdfsPort = DcPropertyUtils.getProperty("hadoop.cluster.port", "8088");
		AjaxJson ajaxJson = new AjaxJson();
		StringBuilder monirotUrl = new StringBuilder(64);
//		monirotUrl.append("http://10.1.20.137:19888/jobhistory/");
		monirotUrl.append("http://").append(hdfsIp).append(":").append(hdfsPort).append("/cluster");
		ajaxJson.setMsg(monirotUrl.toString());
		return ajaxJson;       //数据预览页面
	}
	
	/**
	 * @方法名称: add2Schedule 
	 * @实现功能: 添加至调度任务
	 * @param jobId
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月27日 下午8:44:59
	 */
	@ResponseBody
	@RequestMapping(value = "add2Schedule")
	public AjaxJson add2Schedule(String jobId, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			String msg = dcJobTransHdfsService.add2Schedule(jobId);
			ajaxJson.setMsg(msg);
		} catch (Exception e) {
			ajaxJson.setMsg("调度任务创建失败!</br>"+e.getMessage());
			logger.error("-->add2Schedule", e);
		}
		return ajaxJson;
	}
	
	@ResponseBody
	@RequestMapping(value = "checkSrcHdfsAddress")
	public String checkSrcHdfsAddress(String srcHdfsAddress) {	
		if (RegExpValidatorUtils.isIPAndPort(srcHdfsAddress)) {
			return "true";
		}
		return "false";
	}
	
	@ResponseBody
	@RequestMapping(value = "checkSrcHdfsDir")
	public String checkSrcHdfsDir(String srcHdfsDir) {	
		if (RegExpValidatorUtils.isDirPath(srcHdfsDir)) {
			return "true";
		}
		return "false";
	}
	
	@ResponseBody
	@RequestMapping(value = "checkOutPutDir")
	public String checkOutPutDir(String outPutDir) {	
		if (RegExpValidatorUtils.isDirPath(outPutDir)) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * 
	 * @方法名称: testTransFile 
	 * @实现功能: 测试连接是否正确
	 * @param 
	 * @return
	 * @create by hgw at 2017年4月8日 上午10:54:09
	 */
	@ResponseBody
	@RequestMapping(value = "cheshi")
	public AjaxJson cheshi(String srcHdfsAddress){
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			dcJobTransHdfsService.hdfsCheshi(srcHdfsAddress);;
			ajaxJson.setMsg("测试连接成功");
		} catch (Exception e) {
			ajaxJson.setMsg("测试连接失败!</br>");
			logger.error("-->cheshi", e);
		}
		return ajaxJson;
	}

	/**
	 * 	源文件路径
	 * @param params
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "HdfsPathTreeData")
	public List<Map<String,Object>> HdfsPathTreeData(String params){
		return dcJobTransHdfsService.treeData(params);
	}

	/**
	 *目标路径
	 * @param
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "HdfsPathTreeData2")
	public List<Map<String,Object>> HdfsPathTreeData2(String params){
		params = DcPropertyUtils.getProperty("hadoop.main.address");
		return dcJobTransHdfsService.treeData2(params);
	}
}
