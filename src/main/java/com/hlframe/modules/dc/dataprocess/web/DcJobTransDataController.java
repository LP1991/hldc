/********************** 版权声明 *************************
 * 文件名: DcJobTransDataController.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月16日 下午9:03:08
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.web;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.metadata.entity.DcSysObjm;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.utils.DcCommonUtils;
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
import com.hlframe.modules.dc.common.DcConstants;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.entity.DcJobDb2Hdfs;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransDataService;
import com.hlframe.modules.dc.metadata.entity.DcDataSource;
import com.hlframe.modules.dc.metadata.service.DcDataSourceService;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.sys.utils.UserUtils;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcJobTransDataController.java 
 * @职责说明: 数据转换任务Controller 
 * @创建者: peijd
 * @创建时间: 2016年11月16日 下午9:03:08
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/transJob")
public class DcJobTransDataController extends BaseController {  

	@Autowired
	private DcJobTransDataService dcJobTransDataService;
	@Autowired
	private DcDataSourceService dcDataSourceService;
	@Autowired
	private DcTaskTimeService dcTaskTimeService;
	@Autowired
	private DcObjectAuService authService;      //数据权限Service

	/**
	 * @方法名称: list 
	 * @实现功能: 列表数据查询
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月16日 下午9:28:07
	 */
	@RequiresPermissions("dc:dataProcess:dcJobTransData:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcJobTransData obj, Model model) {
		if(StringUtils.isNotEmpty(obj.getId())){
			obj = dcJobTransDataService.get(obj.getId());
		}else{
			obj = new DcJobTransData();
		}
		model.addAttribute("dcJobTransData", obj);
		return "modules/dc/dataProcess/dcJobTransData/dcJobTransDataList";
	}
	

	/**
	 * @方法名称: form 
	 * @实现功能: 编辑表单
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月16日 下午9:28:21
	 */
	@RequiresPermissions(value={"dc:dataProcess:dcJobTransData:add","dc:dataProcess:dcJobTransData:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcJobTransData obj, Model model) {	
		DcJobDb2Hdfs jobData = null;
		if(null!=obj && StringUtils.isNotEmpty(obj.getId())){
			jobData = dcJobTransDataService.buildJobData(obj.getId());
			//hive/hbase 数据表设置
			if(DcJobTransData.TOLINK_HIVE.equals(jobData.getToLink())){
				jobData.setCreateTbHive(DcConstants.DC_RESULT_FLAG_TRUE.equals(jobData.getIsCreateTable()));
				jobData.setTbNameHive(jobData.getOutputTable());
			}else if(DcJobTransData.TOLINK_HBASE.equals(jobData.getToLink())){
				jobData.setCreateTbHbase(DcConstants.DC_RESULT_FLAG_TRUE.equals(jobData.getIsCreateTable()));
				jobData.setTbNameHbase(jobData.getOutputTable());
			}
			
		}else{
			jobData = new DcJobDb2Hdfs();
			//默认线程数1个
			jobData.setSortNum(1);
			jobData.setCreateTbHive(false);
			jobData.setCreateTbHbase(false);
		}
		//添加连接信息 dbConnName
//		jobData.setDbConnName();
		model.addAttribute("jobInfo", jobData);
		//数据源列表  下拉列表中显示数据源类别
		model.addAttribute("dataSourceList", dcDataSourceService.buildSelectList(new DcDataSource()));
		return "modules/dc/dataProcess/dcJobTransData/dcJobTransDataForm";
	}

	/**
	 * @方法名称: checkJobName
	 * @实现功能: 验证任务名称是否存在
	 * @params  [oldJobName, jobName]
	 * @return  java.lang.String
	 * @create by peijd at 2017/4/18 14:25
	 */
	@ResponseBody
	@RequestMapping(value = "checkJobName")
	public String checkJobName(String oldJobName, String jobName) {
		if (jobName !=null && jobName.equals(oldJobName)) {
			return "true";
		} else if (jobName !=null && dcJobTransDataService.getJobName(jobName) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * @方法名称: checkTableName
	 * @实现功能: 验证数据表是否存在, 接口采集数据表需要新建并初始化
	 * @params  [tableName]
	 * @return  java.lang.String
	 * @create by peijd at 2017/4/18 14:26
	 */
	@ResponseBody
	@RequestMapping(value = "checkTableName")
	public Boolean checkTableName(String tableName){
		return DcCommonUtils.existTableName(tableName);
	}
	
	/**
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax方式查询列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月16日 下午9:28:30
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcJobDb2Hdfs obj, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcJobDb2Hdfs> page = dcJobTransDataService.buildPage(new Page<DcJobDb2Hdfs>(request), obj);
		List<DcJobDb2Hdfs> list = page.getList();
		
		String curUserId = UserUtils.getUser().getId();
		//查询权限列表
		List<DcSysObjm> accreList = authService.getAccreList(curUserId, null);
		List<String> hlist=new ArrayList<String>();
		for (DcSysObjm map : accreList) {
			if (StringUtils.isNotBlank(map.getObjMainId()))
				hlist.add(map.getObjMainId());
		}
		for(DcJobDb2Hdfs aaa:list){
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
	 * @create by peijd at 2016年11月16日 下午9:28:48
	 */
	@RequiresPermissions(value={"dc:dataProcess:dcJobTransData:view"})
	@RequestMapping(value = "dataView")
	public String view(DcJobTransData obj , Model model) {
	//	model.addAttribute("dcJobTransData", dcJobTransDataService.get(obj.getId()));		
		DcJobDb2Hdfs jobData = null;
		jobData = dcJobTransDataService.buildJobData(obj.getId());
		model.addAttribute("jobInfo", jobData);
		return "modules/dc/dataProcess/dcJobTransData/dcJobTransDataView";       //查看页面
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
	public AjaxJson ajaxDelete(DcJobTransData obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try{
			dcJobTransDataService.delete(obj);
			ajaxJson.setMsg("删除数据对象成功!");
		}catch(Exception e){
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("删除失败!"+e.getMessage());
			logger.error("-->ajaxDelete", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: ajaxSave 
	 * @实现功能: ajax方式保存数据对象
	 * @param obj
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2016年11月16日 下午9:31:48
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcJobDb2Hdfs obj, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcJobTransDataService.save(obj);
			ajaxJson.setSuccess(true);
			ajaxJson.setMsg("保存数据对象'" + obj.getJobName() + "'成功!");
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("保存失败!<br>明细:"+e.getMessage());
			logger.error("-->ajaxSave", e);
		}
		return ajaxJson;
	}
	
	/**
	 * 
	 * @方法名称: getAu 
	 * @实现功能: 发起权限申请
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2017年1月19日 下午2:26:29
	 */
	@ResponseBody
	@RequestMapping(value = "getAu")
	public AjaxJson getAu(DcJobTransData obj, RedirectAttributes redirectAttributes){
		dcJobTransDataService.getAu(obj);
		AjaxJson ajaxJson = new AjaxJson();
		ajaxJson.setMsg("已向管理员申请该任务操作权限，请等待管理员审核!");
		return ajaxJson;
	}
	
	
	/**
	 * @方法名称: runTask 
	 * @实现功能: 测试任务
	 * @param jobId
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2016年11月17日 下午4:56:04
	 */
	@ResponseBody
	@RequestMapping(value = "runTask")
	public AjaxJson runTask(String jobId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			DcDataResult taskResult =  dcJobTransDataService.runTask(jobId);
			if(taskResult.getRst_flag()){
				ajaxJson.setMsg(taskResult.getRst_std_msg());
			}else{
				ajaxJson.setMsg(taskResult.getRst_err_msg());
			}
		} catch (Exception e) {
			ajaxJson.setMsg(e.getMessage());
			logger.error("dcJobTransDataService.runTask", e);
		}
		return ajaxJson;
	}
	
	/**
	 * 批量调用DB采集任务（多线程并发调用）
	 * @param jobIdArr
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
//	@ResponseBody
	@RequestMapping(value = "batchRunTask")
	public String batchRunTask(String jobIdArr, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes){
		if(StringUtils.isBlank(jobIdArr)){
			return "没有调度任务ID";
		}
		
		for(String jobId: jobIdArr.split(",")){
			//每个调度任务单独起一个线程执行
			new DcJobTransDBThread(dcJobTransDataService, jobId).start();
			try{
				//每个线程等待5秒
				Thread.currentThread().sleep(2000);
			}catch(Exception e){
				logger.error("-->batchRunTask", e);
			}
		}
		return "批量采集任务结束!";
	}

	/**
	 * 批量调用DB采集任务（单线程依次执行）
	 * @param jobIdArr
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "batchRunTask2")
	public String batchRunTask2(String jobIdArr, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes){
		if(StringUtils.isBlank(jobIdArr)){
			return "没有调度任务ID";
		}
		
		StringBuilder resultMsg = new StringBuilder(512);
		DcDataResult taskResult = null;
		for(String jobId: jobIdArr.split(",")){
			//逐个添加调度任务
			try{
				taskResult =  dcJobTransDataService.runTask(jobId);
				String msg = taskResult.getRst_flag()?taskResult.getRst_std_msg():taskResult.getRst_err_msg();
				logger.debug(msg);
				if(msg.startsWith("--")){
					resultMsg.append("job[").append(jobId).append("]执行成功!");
				}else{
					resultMsg.append("job[").append(jobId).append("]执行失败!");;
				}
				resultMsg.append("</br>");
				//每个线程等待5秒
//				Thread.currentThread().sleep(5000);
			}catch(Exception e){
				logger.error("-->batchRunTask", e);
			}
		}
		return resultMsg.toString();
	}
	
	
	/**
	 * @方法名称: scheduleForm 
	 * @实现功能: 调度设置表单
	 * @param jobId
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月25日 下午5:11:43
	 */
	@RequestMapping(value = "scheduleForm")
	public String scheduleForm(DcJobTransData obj, HttpServletRequest request, Model model) {
		//任务表单明细
		DcJobDb2Hdfs formData = dcJobTransDataService.buildJobData(obj.getId());
		
		DcTaskTime param  = new DcTaskTime();
		//根据分类和ID查找  调度设置
		param.setTaskfromid(obj.getId());
		param.setTaskfromtype(DcTaskMain.TASK_FROMTYPE_EXTRACT_RMDB);
		List<DcTaskTime> taskList = dcTaskTimeService.findList(param);
		
		//没有对象则新建, 否则编辑
		if(CollectionUtils.isEmpty(taskList)){
			param.setScheduleName("DB数据采集任务_"+formData.getJobName());	//任务名
			param.setScheduleDesc("DB数据采集任务_"+formData.getJobDesc());	//描述
			param.setTaskfromname(formData.getJobDesc());					//任务描述
		}else{
			param = taskList.get(0);
		}
		param.setStatus("0");
		//采集任务表单
		model.addAttribute("formData", param);
		
		return "modules/dc/dataProcess/dcJobTransData/dcJobSchedule";
	}
	
	/**
	 * @方法名称: add2Schedule 
	 * @实现功能: 添加至调度任务列表
	 * @param jobId
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月5日 下午2:20:02
	 */
	@ResponseBody
	@RequestMapping(value = "add2Schedule")
	public AjaxJson add2Schedule(String jobId, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			String msg = dcJobTransDataService.add2Schedule(jobId);
			ajaxJson.setMsg(msg);
		} catch (Exception e) {
			ajaxJson.setMsg("调度任务创建失败!</br>"+e.getMessage());
			ajaxJson.setSuccess(false);
			logger.error("-->add2Schedule", e);
		}
		return ajaxJson;
	}


	/**
	 * @方法名称: previewData 
	 * @实现功能: 预览采集源数据
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月21日 上午11:17:53
	 */
	@RequestMapping(value = "previewData")
	public String previewData(DcJobTransData obj, Model model,HttpServletRequest request) {
		List<Map<String, Object>> jobList = dcJobTransDataService.previewDbData(obj.getId());
		//数据对象字段列表
		model.addAttribute("columnList",jobList);			
		return "modules/dc/dataProcess/dcJobTransData/dcJobPreviewData";       //数据预览页面
	}
	
	/**
	 * @方法名称: editExpress 
	 * @实现功能: 编辑表达式
	 * @param obj
	 * @param model
	 * @param request
	 * @return
	 * @create by peijd at 2016年11月25日 下午7:46:54
	 */
	@RequestMapping(value = "editExpress")
	public String editExpress(Model model, HttpServletRequest request) {
		//调度表达式 传值
		String cronExpr = StringUtils.isNotEmpty(request.getParameter("cronExpr"))?request.getParameter("cronExpr"):"* * * * * ?";
		model.addAttribute("cronExpr", cronExpr);			
		return "modules/dc/schedule/cronExpDesign";       //数据预览页面
	}
	
	/**
	 * @方法名称: jobMonitor 
	 * @实现功能: 查看hadoop-job日志
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月23日 上午11:00:33
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
	 * @方法名称: jobMonitor 
	 * @实现功能: 查看数据存储目录
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月23日 上午11:00:33
	 */
	@ResponseBody
	@RequestMapping(value = "previewStoreDir")
	public AjaxJson previewStoreDir(String jobId, HttpServletRequest request, Model model) {
		
		String hdfsAddress = DcPropertyUtils.getProperty("hue.server.address", "");
		AjaxJson ajaxJson = new AjaxJson();
		DcJobDb2Hdfs jobData = dcJobTransDataService.buildJobData(jobId);
//		String dataDir = StringUtils.isNotBlank(jobData.getOutputDir())?jobData.getOutputDir():"/";
		StringBuilder storeUrl = new StringBuilder(64);
//		monirotUrl.append("http://10.1.20.137:8888/filebrowser/view=/tmp/oracle/dcCollectLog");
		storeUrl.append("http://").append(hdfsAddress).append("/filebrowser/view=").append(jobData.getOutputDir()).append("/");
		ajaxJson.setMsg(storeUrl.toString());
		return ajaxJson;       //数据预览页面
	}
	
}
