/********************** 版权声明 *************************
 * 文件名: DcTaskQueueController.java
 * 包名: com.hlframe.modules.dc.schedule.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年3月1日 下午2:27:05
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.schedule.web;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.metadata.entity.DcSysObjm;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.entity.DcTaskQueue;
import com.hlframe.modules.dc.schedule.entity.DcTaskQueueRef;
import com.hlframe.modules.dc.schedule.service.DcTaskMainService;
import com.hlframe.modules.dc.schedule.service.DcTaskQueueService;
import com.hlframe.modules.dc.utils.DcCommonUtils;
import com.hlframe.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/** 
 * @类名: com.hlframe.modules.dc.schedule.web.DcTaskQueueController.java 
 * @职责说明: 任务队列Controller
 * @创建者: peijd
 * @创建时间: 2017年3月1日 下午2:27:05
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/schedule/dcTaskQueue")
public class DcTaskQueueController extends BaseController {

	@Autowired
	private DcTaskQueueService taskQueueServise;
	@Autowired
	private DcObjectAuService dcObjectAuService;
	@Autowired
	private DcTaskMainService dcTaskMainService;
	
	/**
	 * @方法名称: list 
	 * @实现功能: 列表首页
	 * @param taskQueue
	 * @param model
	 * @return
	 * @create by peijd at 2017年3月1日 下午2:40:52
	 */
	@RequestMapping(value = "list")
	public String list(DcTaskQueue taskQueue , Model model) {
		model.addAttribute("dcTaskQueue", new DcTaskQueue());
		return "modules/dc/schedule/dcTaskQueueList";
	}
	
	/**
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax页面列表信息
	 * @param taskQueue
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2017年3月1日 下午2:43:59
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcTaskQueue taskQueue, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcTaskQueue> page = taskQueueServise.findPage(new Page<DcTaskQueue>(request), taskQueue);
		List<DcTaskQueue> list = page.getList();
		//设置权限
		String curUserId = UserUtils.getUser().getId();
		List<DcSysObjm> sysObjList = dcObjectAuService.getAccreList(curUserId, null);
		for(DcTaskQueue data: list){
			//创建者拥有所有权限
			if(curUserId.equals(data.getCreateBy().getId())){
				data.setAccre(1);
				
			}else{	//申请过权限的
				for(DcSysObjm acc: sysObjList){
					if(data.getId().equals(acc.getObjMainId())){
						data.setAccre(1);
					}
				}
			}
		}
		DataTable a = new DataTable();
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		a.setRecordsTotal((int)page.getCount());
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(list));
		return a;
	}
	
	/**
	 * @方法名称: form 
	 * @实现功能: 编辑表单 
	 * @param taskQueue
	 * @param model
	 * @return
	 * @create by peijd at 2017年3月1日 下午2:47:25
	 */
	@RequestMapping(value = "form")
	public String form(DcTaskQueue taskQueue, Model model) {
		if(StringUtils.isNotEmpty(taskQueue.getId())){
			taskQueue = taskQueueServise.get(taskQueue.getId());
			
			//编辑页面, 设置任务队列列表
			DcTaskQueueRef param = new DcTaskQueueRef();
			param.setQueueId(taskQueue.getId());
			model.addAttribute("taskList", taskQueueServise.getTaskRefList(param));
			
		}else{
			taskQueue = new DcTaskQueue();
			//新增时优先级取最大+30
			StringBuffer strbuf = new StringBuffer();
			strbuf.append("select max(a.priority) as max from dc_task_queue a ");
			List<Map<String, Object>> resultlist = DcCommonUtils.queryDataBySql(strbuf.toString());
			if(null!=resultlist.get(0)){
				String max = resultlist.get(0).get("max").toString();
				taskQueue.setPriority(Integer.parseInt(max)+30);
			}else{
				taskQueue.setPriority(1);
			}
		}
		model.addAttribute("dcTaskQueue", taskQueue);
		//数据源列表  下拉列表中显示数据源类别
		return "modules/dc/schedule/dcTaskQueueForm";
	}
	
	/**
	 * @方法名称: ajaxSave 
	 * @实现功能: 表单保存
	 * @param taskQueue
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年3月1日 下午2:47:43
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcTaskQueue taskQueue, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try{
			DcTaskQueue tarObj = taskQueueServise.getObjByName(taskQueue.getQueueName(), taskQueue.getId());
			if (null!=tarObj){
				ajaxJson.setMsg("保存'" + taskQueue.getQueueName() + "'失败, 名称已存在!");
				ajaxJson.setSuccess(false);
				return ajaxJson;
			}
			taskQueueServise.save(taskQueue);
			ajaxJson.setMsg("保存'" + taskQueue.getQueueName() + "'成功!");
			
		} catch (Exception e) {
			ajaxJson.setMsg("保存失败!");
			ajaxJson.setSuccess(false);
			logger.error("-->ajaxSave ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: view 
	 * @实现功能: 查看队列任务明细
	 * @param taskQueue
	 * @param model
	 * @return
	 * @create by peijd at 2017年3月1日 下午2:51:27
	 */
	@RequestMapping(value = "view")
	public String view(DcTaskQueue taskQueue , Model model) {
		model.addAttribute("taskQueue", taskQueueServise.get(taskQueue.getId()));		
		return "modules/dc/schedule/dcTaskQueueView";       //查看页面
	}
	
	/**
	 * @方法名称: ajaxDelete 
	 * @实现功能: 删除队列
	 * @param taskQueue
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年3月1日 下午2:51:57
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDelete")
	public AjaxJson ajaxDelete(DcTaskQueue taskQueue, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			taskQueueServise.deleteQueue(taskQueue);
			ajaxJson.setMsg("删除成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("删除失败!");
			ajaxJson.setSuccess(false);
			logger.error("-->ajaxDelete ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: editTask 
	 * @实现功能: 编辑任务项
	 * @param taskRef
	 * @param model
	 * @return
	 * @create by peijd at 2017年3月1日 下午6:13:51
	 */
	@RequestMapping(value = "editTask")
	public String editTask(DcTaskQueueRef taskRef, Model model) {
		Assert.hasText(taskRef.getQueueId());
		model.addAttribute("taskQueueId", taskRef.getQueueId());
		
		if(StringUtils.isNotEmpty(taskRef.getId())){
			taskRef = taskQueueServise.getTaskRef(taskRef.getId());
			taskRef.setTaskId(taskRef.getTask().getId());
			taskRef.setPreTaskId(taskRef.getPreTask().getId());
		}else{
			//新增时序号取最大+1
			StringBuffer strbuf = new StringBuffer();
			strbuf.append("select max(a.sort_num) as max from dc_task_queue_ref a where a.queue_id='"+taskRef.getQueueId()+"' and a.del_flag=0");
			List<Map<String, Object>> resultlist = DcCommonUtils.queryDataBySql(strbuf.toString());
			taskRef = new DcTaskQueueRef();
			if(null!=resultlist.get(0)){
				String max = resultlist.get(0).get("max").toString();
				taskRef.setSortNum(Integer.parseInt(max)+5);
			}else{
				taskRef.setSortNum(5);//默认序号
			}
		}
		model.addAttribute("dcTaskQueueRef", taskRef);
		//添加任务列表
		DcTaskMain taskMain = new DcTaskMain();
		//过滤权限 只看到自己的数据
		taskMain.getSqlMap().put("dsf", dcTaskMainService.dataScopeFilter(taskMain.getCurrentUser(),"o","u"));
		model.addAttribute("taskList", dcTaskMainService.findList(taskMain));
		
		//添加前置任务列表(排除当前任务)
		DcTaskQueueRef param = new DcTaskQueueRef();
		param.setId(taskRef.getId());
		param.setQueueId(taskRef.getQueueId());
		List<DcTaskQueueRef> taskRefList = taskQueueServise.getTaskRefList(param);
		/*for(DcTaskQueueRef subTask: taskRefList){
			subTask.setRemarks("("+subTask.getSortNum()+")"+subTask.getTask().getTaskName());
		}*/
		model.addAttribute("preTaskList", taskRefList);
		
		//数据源列表  下拉列表中显示数据源类别
		return "modules/dc/schedule/dcTaskQueueRefForm";
	}
	
	/**
	 * @方法名称: getTaskRefList 
	 * @实现功能: 获取任务列表
	 * @param taskQueueRef
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2017年3月2日 上午8:55:43
	 */
	@ResponseBody
	@RequestMapping(value = "getTaskRefList")
	public DataTable getTaskRefList(DcTaskQueueRef taskQueueRef, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcTaskQueueRef> page = taskQueueServise.findTaskRefPage(new Page<DcTaskQueueRef>(request), taskQueueRef);
		List<DcTaskQueueRef> list = page.getList();
		DataTable a = new DataTable();
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		a.setRecordsTotal((int)page.getCount());
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(list));
		return a;
	}
	
	/**
	 * @方法名称: viewTask 
	 * @实现功能: 查看任务明细
	 * @param taskRef
	 * @param model
	 * @return
	 * @create by peijd at 2017年3月1日 下午5:45:08
	 */
	@RequestMapping(value = "viewTask")
	public String viewTask(DcTaskQueueRef taskRef, Model model) {
		Assert.hasText(taskRef.getQueueId());
		
		if(StringUtils.isNotEmpty(taskRef.getId())){
			taskRef = taskQueueServise.getTaskRef(taskRef.getId());
			taskRef.setTaskId(taskRef.getTask().getId());
			taskRef.setPreTaskId(taskRef.getPreTask().getId());
		}else{
			taskRef = new DcTaskQueueRef();
			taskRef.setSortNum(5);	//默认序号
		}
		model.addAttribute("dcTaskQueueRef", taskRef);
		
		return "modules/dc/schedule/dcTaskQueueView2";       //查看任务明细页面
	}
	
	/**
	 * @方法名称: saveTask 
	 * @实现功能: 保存任务
	 * @param taskQueueRef
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年3月2日 下午1:43:59
	 */
	@ResponseBody
	@RequestMapping(value = "saveTask")
	public AjaxJson saveTask(DcTaskQueueRef taskQueueRef, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try{
			taskQueueServise.saveTask(taskQueueRef);
			ajaxJson.setMsg("保存任务成功!");
			
		} catch (Exception e) {
			ajaxJson.setMsg("保存任务失败!");
			ajaxJson.setSuccess(false);
			logger.error("-->saveTask ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: deleteTask 
	 * @实现功能: 删除任务项
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年3月1日 下午6:15:43
	 */
	@ResponseBody
	@RequestMapping(value = "deleteTask")
	public AjaxJson deleteTask(DcTaskQueueRef obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			taskQueueServise.deleteTask(obj);
			ajaxJson.setMsg("删除成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("删除失败!");
			ajaxJson.setSuccess(false);
			logger.error("-->deleteTask ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: checkTask 
	 * @实现功能: 检查队列任务是否存在
	 * @param obj
	 * @return
	 * @create by peijd at 2017年3月1日 下午7:00:15
	 */
	@ResponseBody
	@RequestMapping(value = "checkTask")
	public String checkTask(DcTaskQueueRef obj) {
		return taskQueueServise.checkTask(obj);
	}
	
	/**
	 * @方法名称: checkJobName 
	 * @实现功能: form表单 ajax 验证名字是否重复
	 * @param oldJobName
	 * @param jobName
	 * @return
	 * @create by peijd at 2017年3月1日 下午2:52:15
	 */
	@ResponseBody
	@RequestMapping(value = "checkJobName")
	public String checkJobName(String oldJobName, String jobName) {
		if (jobName !=null && jobName.equals(oldJobName)) {
			return "true";
		} else if (jobName !=null && taskQueueServise.getObjByName(jobName, null) == null) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * @方法名称: runTaskQueue 
	 * @实现功能: 运行任务队列
	 * @param queueId
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年3月1日 下午2:53:04
	 */
	@ResponseBody
	@RequestMapping(value = "runTask")
	public AjaxJson runTask(String queueId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			DcDataResult taskResult =  taskQueueServise.runTask(queueId);
			if(taskResult.getRst_flag()){
				ajaxJson.setMsg(taskResult.getRst_std_msg());
			}else{
				ajaxJson.setMsg(taskResult.getRst_err_msg());
			}
		} catch (Exception e) {
			ajaxJson.setMsg(e.getMessage());
			ajaxJson.setSuccess(false);
			logger.error("taskQueueServise.runTaskQueue", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: runQueueTask 
	 * @实现功能: 运行子任务项
	 * @param taskId
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年3月1日 下午5:33:03
	 */
	@ResponseBody
	@RequestMapping(value = "runQueueTask")
	public AjaxJson runQueueTask(String taskId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			DcDataResult taskResult =  taskQueueServise.runQueueTask(taskId, false);
			if(taskResult.getRst_flag()){
				ajaxJson.setMsg(taskResult.getRst_std_msg());
			}else{
				ajaxJson.setMsg(taskResult.getRst_err_msg());
			}
		} catch (Exception e) {
			ajaxJson.setMsg(e.getMessage());
			ajaxJson.setSuccess(false);
			logger.error("taskQueueServise.runTask", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: add2Schedule 
	 * @实现功能: 将任务队列 添加至调度管理页面
	 * @param queueId
	 * @param redirectAttributes
	 * @return 
	 * @create by peijd at 2017年3月1日 下午2:54:12
	 */
	@ResponseBody
	@RequestMapping(value = "add2Schedule")
	public AjaxJson add2Schedule(String queueId, RedirectAttributes redirectAttributes) {
		Assert.hasText(queueId);
		AjaxJson ajaxJson = new AjaxJson();	
		DcTaskQueue taskQueue = taskQueueServise.get(queueId);
		//队列已发布
		if(DcTaskQueue.QUEUE_STATUS_SCHEDULE.equals(taskQueue.getStatus())){
			ajaxJson.setMsg("该任务队列已经存在，不能重复添加！");
			ajaxJson.setSuccess(false);
			return ajaxJson;
		}
		try {
			taskQueueServise.add2Schedule(taskQueue);
			ajaxJson.setMsg("任务队列添加成功!");
			
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("任务队列添加失败!");
			logger.error("-->add2Schedule : " , e);
		}

		//设置页面提示信息
//		addMessage(redirectAttributes, ajaxJson.getMsg());
		return ajaxJson;
	}
	
}
