package com.hlframe.modules.dc.task;

import java.util.Date;


import com.hlframe.common.utils.IdGen;
import com.hlframe.common.utils.Reflections;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;
import com.hlframe.modules.dc.schedule.service.task.DcTaskService;
import com.hlframe.modules.dc.task.entity.DcTaskLogRun;
import com.hlframe.modules.dc.task.service.DcTaskLogRunService;
import com.hlframe.modules.dc.utils.DcStringUtils;

/**
 * @类名: com.hlframe.modules.dc.task.TaskClass.java 
 * @职责说明: 内部类调度任务入口, 提交后台线程执行
 * @修改者: peijd  统一返回结果, 增加同步/异步执行标记, 单一任务异步执行, 队列任务需同步执行(视业务而定)
 * @修改时间: 2017年3月16日 上午11:39:49
 */
public class TaskClass implements ITask {
	/**
	 * 单次执行任务
	 * @param taskInfo
	 * @return
	 */
	public DcDataResult doTask(final TaskInfo taskInfo) {
		DcDataResult result = new DcDataResult();
		try {
			Thread syncThread = new Thread(new Runnable() {
				public void run() {
					DcTaskLogRunService run = SpringContextHolder.getBean(DcTaskLogRunService.class);
					DcTaskLogRun runobj = new DcTaskLogRun();
					try {
						// 记录任务开始日志
						runobj.setIsNewRecord(true);
						runobj.setId(IdGen.uuid());
						runobj.setTaskid(taskInfo.getTaskid());
						runobj.setRunid(taskInfo.getRunid());
						runobj.setStartdate(new Date());
						runobj.setStatus(DcTaskTime.TASK_STATUS_RUNNING);
						run.save(runobj);
						
						/*Class<?> clz = Class.forName(taskInfo.getClassName());
						DcJobTransDataService clz = SpringContextHolder.getBean(DcJobTransDataService.class);
						 Method method = clz.getMethod(taskInfo.getMethodName(), new Class[]{double.class,double.class});
						 method.setAccessible(true); // 私有的方法通过发射可以修改其访问权限
						 //组装参数信息
						 */
						Object[] argspara = new Object[]{};
						 String programs = taskInfo.getPrograms();
						 if (StringUtils.isNotEmpty(programs)) {
							 argspara = programs.split(",");
						 }
						 
						 //动态调度service, 所有需调度的方法应实现DcTaskService接口, 返回结果为DcDataResult对象  add by peijd 2017-02-16
						 DcTaskService service = SpringContextHolder.getBean(DcStringUtils.firstChar2Lower(StringUtils.substringAfterLast(taskInfo.getClassName(), ".")));
//						DcJobTransDataService ins = SpringContextHolder.getBean(DcJobTransDataService.class);
//						Object result = Reflections.invokeMethodByName(clz.newInstance(), taskInfo.getMethodName(), argspara);
						 DcDataResult result = (DcDataResult) Reflections.invokeMethodByName(service, "runTask", argspara);
						 
						 // 记录任务结束日志
						 runobj.setIsNewRecord(false);
						 runobj.setEnddate(new Date());
						 runobj.setStatus(DcTaskTime.TASK_STATUS_SUCCESS);
						 
						 if (result.getRst_flag()) {
							 runobj.setRemarks("任务运行成功!"+result.getRst_std_msg());
						 }else{
							 runobj.setRemarks("任务运行失败!"+result.getRst_err_msg());
						 }
						 run.save(runobj);
						 
						 // 非自动清空下，需要将任务设置为完成状态
						 if (!DcTaskTime.TASK_TRIGGERTYPE_AUTO.equalsIgnoreCase(taskInfo.getExecuteType())) {
							 DcTaskTime dcTaskTime = new DcTaskTime();
							 dcTaskTime.setId(taskInfo.getTaskid());
							 dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_SUCCESS);
							 DcTaskTimeService obj = SpringContextHolder.getBean(DcTaskTimeService.class);
							 obj.updateStatus(dcTaskTime); 
						 }
					} catch (Exception e) {
						// 记录任务错误日志
						runobj.setIsNewRecord(false);
						runobj.setEnddate(new Date());
						runobj.setStatus(DcTaskTime.TASK_STATUS_ERROR);
						runobj.setRemarks("执行任务[" + taskInfo.getTaskName() + "]失败 : " + e.getMessage());
						run.save(runobj);
						
						// 非自动清空下，需要将任务设置为完成错误
						if (!DcTaskTime.TASK_TRIGGERTYPE_AUTO.equalsIgnoreCase(taskInfo.getExecuteType())) {
							DcTaskTime dcTaskTime = new DcTaskTime();
							dcTaskTime.setId(taskInfo.getTaskid());
							dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_ERROR);
							DcTaskTimeService obj = SpringContextHolder.getBean(DcTaskTimeService.class);
							obj.updateStatus(dcTaskTime); 
						}
					}
				}
			});
			
			syncThread.start();
			//同步执行标志, 任务执行完成再返回
			if(taskInfo.getSyncFlag()){
				syncThread.join();
			}
			result.setRst_flag(true);
			result.setRst_std_msg("任务["+taskInfo.getTaskName()+"]执行成功!");
		} catch (Exception e) {
			result.setRst_flag(false);
			result.setRst_err_msg("任务["+taskInfo.getTaskName()+"]执行失败! "+e.getMessage());
			logger.error("-->TaskClass["+taskInfo.getTaskName()+"].doTask: ", e);
		}
		return result;
	}
}
