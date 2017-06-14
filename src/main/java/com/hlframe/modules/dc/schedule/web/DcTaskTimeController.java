/********************** 版权声明 *************************
 * 文件名: DcTaskTimeController.java
 * 包名: com.hlframe.modules.dc.schedule.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：cdd  创建时间：2016年11月14日 下午2:31:46
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.schedule.web;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskMainService;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;
import com.hlframe.modules.dc.task.TaskInfo;
import com.hlframe.modules.dc.utils.QuartzUtil;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.quartz.SchedulerException;
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
import java.text.ParseException;
import java.util.List;

/**
 * @类名: com.hlframe.modules.dc.schedule.web.DcTaskTimeController.java
 * @职责说明: TODO
 * @创建者: cdd
 * @创建时间: 2016年11月14日 下午2:31:46
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/schedule/dcTaskTime")
public class DcTaskTimeController extends BaseController {
	@Autowired
	private DcTaskTimeService dcTaskTimeService;
	@Autowired
	private DcTaskMainService dcTaskMainService;

	@ModelAttribute("dcTaskTime")
	public DcTaskTime get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return dcTaskTimeService.get(id);
		} else {
			return new DcTaskTime();
		}
	}

	// @RequiresPermissions("dc:schedule:index")
	@RequestMapping(value = { "index" })
	public String index(DcTaskTime dcTaskTime, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<DcTaskTime> list = dcTaskTimeService.findList(dcTaskTime);
		model.addAttribute("list", list);// 列表
		model.addAttribute("dcTaskTime", dcTaskTime);// 查询
		return "modules/dc/schedule/dcTaskTimeList";
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
	public DataTable ajaxlist(DcTaskTime dcTaskTime, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcTaskTime> page = dcTaskTimeService.findPage(new Page<DcTaskTime>(request), dcTaskTime);
		List<DcTaskTime> list = page.getList();
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

	@RequiresPermissions(value = { "dc:dcTaskTime:add", "dc:dcTaskTime:edit" }, logical = Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcTaskTime dcTaskTime, Model model) {
		model.addAttribute("dcTaskTime", dcTaskTime);
		return "modules/dc/schedule/dcTaskTimeForm";
	}

	/**
	 *
	 * @方法名称: save
	 * @实现功能: TODO
	 * @param dcTaskTime
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * @create by cdd at 2016年11月15日 下午4:53:18
	 */
	@RequiresPermissions(value = { "dc:dcTaskTime:add", "dc:dcTaskTime:edit" }, logical = Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcTaskTime dcTaskTime, Model model, RedirectAttributes redirectAttributes) throws Exception {
		if (!beanValidator(model, dcTaskTime)) {
			return form(dcTaskTime, model);
		}
		dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_INIT);
		if (!dcTaskTime.getIsNewRecord()) {// 编辑表单保存
			DcTaskTime t = dcTaskTimeService.get(dcTaskTime.getId());// 从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcTaskTime, t);// 将编辑表单中的非NULL值覆盖数据库记录中的值
			dcTaskTimeService.save(t);// 保存
		} else {// 新增表单保存

			dcTaskTimeService.save(dcTaskTime);// 保存
		}

		addMessage(redirectAttributes, "调度任务保存成功");
		return "redirect:" + adminPath + "/dc/schedule/dcTaskTime/index";
	}

	/**
	 *
	 * @方法名称: saveA
	 * @实现功能: 异步保存数据
	 * @param dcTaskTime
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by cdd at 2016年11月30日 下午8:18:59
	 */
	@ResponseBody
	@RequestMapping(value = "saveA")
	public AjaxJson saveA(DcTaskTime dcTaskTime, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcTaskTimeService.save(dcTaskTime);// 保存
			ajaxJson.setMsg("保存" + dcTaskTime.getScheduleName() + "成功");

		} catch (Exception e) {
			ajaxJson.setMsg("保存失败");
			logger.error("DctaskTime.saveA()", e);
		}
		return ajaxJson;
	}

	@ResponseBody
	@RequestMapping(value = "checkTaskName")
	public String checkScheduleName(String oldScheduleName, String scheduleName) {
		if (scheduleName != null && scheduleName.equals(oldScheduleName)) {
			return "true";
		} else if (scheduleName != null && dcTaskTimeService.getScheduleName(scheduleName) == null) {
			return "true";
		}

		return "false";
	}

	/**
	 *
	 * @方法名称: view
	 * @实现功能: 查看表单页面
	 * @param dcTaskTime
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:51:00
	 */
	@RequiresPermissions(value = { "dc:dcTaskTime:view" })
	@RequestMapping(value = "view")
	public String view(DcTaskTime dcTaskTime, Model model) {
//		DcTaskContent taskContent = null;
//		if (null != dcTaskTime && StringUtils.isNotEmpty(dcTaskTime.getId())) {
//			dcTaskTime = dcTaskTimeService.buildTaskContent(dcTaskTime.getId());
//		} else {
//			taskContent = new DcTaskContent();
//			// 默认线程数4个
//			// taskContent.setSortNum(4);
//		}
		// model.addAttribute("dcTaskTime",
		// dcTaskTimeService.get(dcTaskTime.getId()));
		model.addAttribute("dcTaskTime", dcTaskTime);
		return "modules/dc/schedule/dcTaskTimeView";
	}

	/**
	 *
	 * @方法名称: deleteA
	 * @实现功能: ajax删除调度任务
	 * @param dcTaskMain
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:57
	 */
	@ResponseBody
	@RequestMapping(value = "deleteA")
	public AjaxJson deleteA(DcTaskTime dcTaskTime, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			//如果是运行状态, 先停止任务 peijd
			if(DcTaskTime.TASK_STATUS_RUNNING.equals(dcTaskTime.getStatus())){
				QuartzUtil.deleteJob(dcTaskTime.getId());
			}
			dcTaskTimeService.delete(dcTaskTime);
			ajaxJson.setMsg("删除调度任务成功!");

		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("删除调度任务异常!");
			logger.error("-->deleteA: ", e);
		}
		return ajaxJson;
	}

	/*
	 * 批量删除
	 */
	@ResponseBody
	@RequestMapping(value = "deleteAllBy")
	public AjaxJson deleteAllBy(String ids, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();

		String idArray[] =ids.split(",");
		for(String id : idArray){
			DcTaskTime dcTaskTime = dcTaskTimeService.get(id);
			if(dcTaskTime != null){
				dcTaskTimeService.delete(dcTaskTimeService.get(id));
			}
		}
			
		ajaxJson.setMsg("删除成功");

		return ajaxJson;
	}

	/**
	 * @方法名称: delete
	 * @实现功能: 删除
	 * @param dcTaskTime
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月11日 下午4:20:20
	 *//*
		 * @RequiresPermissions("dc:dcTaskTime:del")
		 * 
		 * @RequestMapping(value = "delete") public String delete( DcTaskTime
		 * dcTaskTime, RedirectAttributes redirectAttributes) {
		 * dcTaskTimeService.delete(dcTaskTime); addMessage(redirectAttributes,
		 * "调度任务删除成功"); return
		 * "redirect:"+adminPath+"/dc/dataSearch/dcTaskTime/?repage"; }
		 */

	/**
	 * 修改状态
	 * 
	 * @param id
	 * @param status
	 * @return
	 */
	public int updateStatus(String id, String status) {
		int result = 0;

		DcTaskTime dcTaskTime = new DcTaskTime();
		dcTaskTime.setId(id);
		dcTaskTime.setStatus(status);
		dcTaskTimeService.updateStatus(dcTaskTime);

		return result;
	}

	@ResponseBody
	@RequestMapping(value = "addJobA")
	public AjaxJson addJobA(DcTaskTime dcTaskTime, RedirectAttributes redirectAttributes, Model model) throws ParseException {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			// 验证任务验证是否开启
			if (QuartzUtil.checkExistsJob(dcTaskTime.getId())) {
				addMessage(redirectAttributes, "任务正在执行，不能多次启动！");
				ajaxJson.setMsg("任务正在执行，不能多次启动！");
			} else {
				// 执行任务
				doTask(dcTaskTime);
			}
		} catch (Exception e) {
			dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_ERROR);// 将其状态改为异常
			dcTaskTimeService.updateStatus(dcTaskTime);

			addMessage(redirectAttributes, "任务执行失败");
			ajaxJson.setMsg("任务执行失败");
		}
		return ajaxJson;
	}

	/**
	 * 执行任务
	 *
	 * @param dcTaskTime
	 * @throws SchedulerException
	 */
	private void doTask(DcTaskTime dcTaskTime) throws SchedulerException {
		try {

			// 以下几种分类都属于TaskType.CLASS，所以全部废弃
			// if ("01".equalsIgnoreCase(dcTaskTime.getTaskfromtype())) { //
			// 来自DB数据采集的任务
			// taskInfo.setTaskTpye(TaskType.CLASS); // 任务的类型
			// taskInfo.setClassName("com.hlframe.modules.dc.dataprocess.service.DcJobTransDataService");
			// // 需要执行的类名
			// taskInfo.setMethodName("runTask"); // 需要执行的方法名
			// taskInfo.setProgramTpye("java.lang.String"); // 参数类型
			// taskInfo.setPrograms(dcTaskTime.getTaskfromid()); // 参数
			// } else if ("02".equalsIgnoreCase(dcTaskTime.getTaskfromtype())) {
			// // 来自任务管理的任务
			//
			// } else if ("03".equalsIgnoreCase(dcTaskTime.getTaskfromtype())) {
			// // 来自HDFS数据采集的任务
			// taskInfo.setTaskTpye(TaskType.CLASS); // 任务的类型
			// taskInfo.setClassName("com.hlframe.modules.dc.dataprocess.service.DcJobTransHdfsService");
			// // 需要执行的类名
			// taskInfo.setMethodName("runTask"); // 需要执行的方法名
			// taskInfo.setProgramTpye("java.lang.String"); // 参数类型
			// taskInfo.setPrograms(dcTaskTime.getTaskfromid()); // 参数
			// } else if ("04".equalsIgnoreCase(dcTaskTime.getTaskfromtype())) {
			// // 来自接口数据采集的任务
			// taskInfo.setTaskTpye(TaskType.CLASS); // 任务的类型
			// taskInfo.setClassName("com.hlframe.modules.dc.dataprocess.service.DcJobTransInterfaceService");
			// // 需要执行的类名
			// taskInfo.setMethodName("runTask"); // 需要执行的方法名
			// taskInfo.setProgramTpye("java.lang.String"); // 参数类型
			// taskInfo.setPrograms(dcTaskTime.getTaskfromid()); // 参数
			// } else if ("05".equalsIgnoreCase(dcTaskTime.getTaskfromtype())) {
			// // 来自文件数据采集的任务
			// taskInfo.setTaskTpye(TaskType.CLASS); // 任务的类型
			// taskInfo.setClassName("com.hlframe.modules.dc.dataprocess.service.DcJobTransFileService");
			// // 需要执行的类名
			// taskInfo.setMethodName("runTask"); // 需要执行的方法名
			// taskInfo.setProgramTpye("java.lang.String"); // 参数类型
			// taskInfo.setPrograms(dcTaskTime.getTaskfromid()); // 参数
			// } else if ("99".equalsIgnoreCase(dcTaskTime.getTaskfromtype())) {
			// // 来自调度管理的任务
			// // TODO 开启此任务时需要重新设计，需要设计主从表，所有被执行的任务都作为子项，有顺序关系
			// } else {
			// throw new SchedulerException("未知的调度任务来源！调度任务ID为： " +
			// dcTaskTime.getId());
			// }

			// TODO 需要加强边界验证 暂时仅支持单个String或多个String参数
			TaskInfo taskInfo = dcTaskTimeService.buildTaskInfo(dcTaskTime);
			QuartzUtil.doTaskProcess(taskInfo);

			dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_RUNNING); // 将其状态改为执行中
			dcTaskTimeService.updateStatus(dcTaskTime);
		} catch (Exception e) {
			dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_ERROR); // 将其状态改为失败
			dcTaskTimeService.updateStatus(dcTaskTime);
			logger.error("-->doTask: ", e);
			throw new SchedulerException("执行任务失败！" + e.getMessage());
		}
	}

	/**
	 *
	 * @方法名称: deleteJob
	 * @实现功能: 终止调度任务
	 * @param dcTaskMain
	 * @param redirectAttributes
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "deleteJob")
	public AjaxJson deleteJob(DcTaskTime dcTaskTime, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();

		QuartzUtil.deleteJob(dcTaskTime.getId());

		dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_INIT);
		dcTaskTimeService.save(dcTaskTime);
		ajaxJson.setMsg("停止调度任务成功");
		return ajaxJson;
	}

	// @RequiresPermissions("dc:dcTaskTime:pauseJob")
	@RequestMapping(value = "pauseJob")
	public String pauseJob(DcTaskTime dcTaskTime, RedirectAttributes redirectAttributes, Model model) throws Exception {
		String className = dcTaskTime.getScheduleName();
		// Class.forName(className)把String类型转化成类名
		// 通过类名找到方法名
		QuartzUtil.pauseJob(Class.forName(className), dcTaskTime.getScheduleExpr());// 类名。方法名，时间表达式
		addMessage(redirectAttributes, "标签删除成功");
		return "redirect:" + adminPath + "/dc/dataSearch/dcTaskTime/index";
	}
	
	
}
