/********************** 版权声明 *************************
 * 文件名: DcTransDataMainService.java
 * 包名: com.hlframe.modules.dc.dataprocess.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月30日 下午3:42:19
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.service.CrudService;
import com.hlframe.common.service.ServiceException;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.common.DcConstants;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.dao.DcTransDataMainDao;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataMain;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataMainLog;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSub;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSubLog;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.service.DcTaskMainService;
import com.hlframe.modules.dc.schedule.service.task.DcTaskService;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.service.DcTransDataMainService.java 
 * @职责说明: 数据转换任务Main
 * @创建者: peijd
 * @创建时间: 2016年11月30日 下午3:42:19
 */
@Service
@Transactional(readOnly = true)
public class DcTransDataMainService extends CrudService<DcTransDataMainDao, DcTransDataMain> implements DcTaskService {
	
	@Autowired
	private DcTransDataSubService transSubService;
	@Autowired
	private DcTransDataMainLogService transLogService;
	@Autowired
	private DcTaskMainService taskMainService;

	/**
	 * @实现功能: 数据权限过滤
	 * @create by yuzh at 2016年12月15日 16:30:29
	 */
	public Page<DcTransDataMain> findPage(Page<DcTransDataMain> page, DcTransDataMain dcTransDataMain) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		dcTransDataMain.getSqlMap().put("dsf", dataScopeFilter(dcTransDataMain.getCurrentUser(),"o","u"));
		// 设置分页参数
		dcTransDataMain.setPage(page);
		// 执行分页查询
		page.setList(dao.findList(dcTransDataMain));
		return super.findPage(page, dcTransDataMain);
	}
	
	/**
	 * @方法名称: runTask 
	 * @实现功能: 执行转换任务
	 * @param jobId
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:16:32
	 */
	@Transactional(readOnly = false)
	public DcDataResult runTask(String jobId)  throws Exception {
		Assert.hasText(jobId);
		
		DcDataResult taskResult = new DcDataResult();
		DcTransDataMainLog mainLog = new DcTransDataMainLog();
		DcTransDataSub param = new DcTransDataSub();
		mainLog.setBeginTime(new Date());
		mainLog.setJobId(jobId);
		param.setJobId(jobId);
		
		//任务信息
		DcTransDataMain mainTask = get(jobId);
		//获取任务中每个过程
		List<DcTransDataSub> proList = transSubService.findList(param);
		if(CollectionUtils.isEmpty(proList)){
			mainLog.setRemarks("该转换任务未设置转换过程!");
			mainLog.setStatus(DcConstants.DC_RESULT_FLAG_FALSE);
			mainLog.setEndTime(new Date());
			transLogService.save(mainLog);
			taskResult.setRst_flag(false);
			taskResult.setRst_err_msg(mainLog.getRemarks());
			return taskResult;
		}
		
		//任务日志
		StringBuilder logDetail = new StringBuilder(64);
		DcTransDataSubLog proLog = null;
		boolean rstFlag = true;
		//JOB执行策略  
		String transType = mainTask.getTransType();
		try {
			//分别运行任务中每个过程
			for(DcTransDataSub process: proList){
				proLog = transSubService.runProcess(process.getId());
				//执行成功
				if(DcConstants.DC_RESULT_FLAG_TRUE.equals(proLog.getStatus())){
					logDetail.append("\r\n  -->转换过程[").append(process.getTransName()).append("]执行成功!");
					
				}else{	//执行失败则停止任务
					logDetail.append("\r\n  -->转换过程[").append(process.getTransName()).append("]执行失败!");
					logDetail.append("\r\n     明细: ").append(proLog.getRemarks());
					mainTask.setResultStatus(DcConstants.DC_RESULT_FLAG_FALSE);
					//记录明细
					mainLog.setRemarks("任务["+mainTask.getJobName()+"]执行失败!\r\n"+logDetail.toString());
					rstFlag = false;
					
					//遇到异常继续执行
					if(DcTransDataMain.TRANSJOB_STRATEGY_EXP_GOON.equals(transType)){
						continue;
						
					//遇到异常立即终止	
					}else if(DcTransDataMain.TRANSJOB_STRATEGY_EXP_BREAK.equals(transType)){
						break;
					}
				}
			}
			//转换过程全部执行成功
			if(rstFlag){
				mainTask.setResultStatus(DcConstants.DC_RESULT_FLAG_TRUE);
				mainLog.setRemarks("任务["+mainTask.getJobName()+"]执行成功! \r\n"+logDetail.toString());
			}else{
				mainTask.setResultStatus(DcConstants.DC_RESULT_FLAG_FALSE);
				mainLog.setRemarks("任务["+mainTask.getJobName()+"]执行失败! \r\n"+logDetail.toString());
			}
		} catch (Exception e) {
			mainTask.setResultStatus(DcConstants.DC_RESULT_FLAG_FALSE);
			mainLog.setRemarks("任务["+mainTask.getJobName()+"]执行失败!\r\n"+e.getMessage());
			logger.error("-->DcTransDataMainService.runTask", e);
		}
		
		//更新任务状态
		if(mainTask.TASK_STATUS_EDIT.equals(mainTask.getStatus())){
			mainTask.setStatus(mainTask.TASK_STATUS_TEST);
		}
		save(mainTask);
		//保存日志
		mainLog.setEndTime(new Date());
		mainLog.setStatus(mainTask.getResultStatus());
		transLogService.save(mainLog);
		
		taskResult.setRst_flag(DcConstants.DC_RESULT_FLAG_TRUE.equals(mainTask.getResultStatus()));
		if(taskResult.getRst_flag()){
			taskResult.setRst_std_msg(mainLog.getRemarks());
			
		}else{
			taskResult.setRst_err_msg(mainLog.getRemarks());
		}
		return taskResult;
	}

	/**
	 * @方法名称: getJobName 
	 * @实现功能: 检测job名称是否重复 
	 * @param jobName
	 * @return
	 * @create by peijd at 2016年11月30日 下午4:19:01
	 */
	public DcTransDataMain getJobName(String jobName) {
		return dao.getJobName(jobName);
	}
	
	/**
	 * Override
	 * @方法名称: save 
	 * @实现功能: 更新编辑状态
	 * @param entity
	 * @create by peijd at 2016年11月30日 下午8:58:28
	 */
	@Transactional(readOnly = false)
	public void save(DcTransDataMain entity) {
		if(StringUtils.isBlank(entity.getStatus()) ){
			entity.setStatus(entity.TASK_STATUS_EDIT);
		}
		super.save(entity);
	}

	/**
	 * @方法名称: add2Schedule 
	 * @实现功能: 添加至调度任务
	 * @param jobId
	 * @return
	 * @create by peijd at 2016年12月5日 上午9:58:20
	 */
	@Transactional(readOnly = false)
	public String add2Schedule(String jobId) {
		Assert.hasText(jobId);
		//检查调度任务是否存在 
		DcTaskMain taskMain = taskMainService.get(jobId);
		Assert.isTrue(null==taskMain || StringUtils.isBlank(taskMain.getId()), "该调度任务已存在!");
		
		DcTransDataMain transJob = dao.get(jobId);
		String taskName = "数据转换_"+transJob.getJobName();
		//调度任务
		taskMain = new DcTaskMain();
		//ID
		taskMain.setId(jobId);
		//任务名称
		taskMain.setTaskName(taskName);
		//调用方法
		taskMain.setMethodName("runTask");
		//任务描述
		taskMain.setTaskDesc(transJob.getJobDesc());
		//任务来源
		taskMain.setTaskPath(DcTaskMain.TASK_FROMTYPE_PROCESS_SCRIPT);
		//优先级
		taskMain.setPriority("1");
		//任务状态
		taskMain.setStatus(taskMain.TASK_STATUS_EDIT);
		//参数
		taskMain.setParameter(jobId);
		//调用方法
		taskMain.setClassName(this.getClass().getName());
		//内部类
		taskMain.setTaskType(DcTaskMain.TASK_TYPE_INNERCLASS);
		taskMainService.insert(taskMain);
		
		//更新记录状态
		DcTransDataMain updateObj = new DcTransDataMain();
		updateObj.setId(jobId);
		updateObj.setStatus(updateObj.TASK_STATUS_TASK);	//更新为调度状态
		updateObj.preUpdate();
		dao.update(updateObj);
		
		return "添加调度任务["+taskName+"]成功!";
	}
	
	/**
	 * Override
	 * @方法名称: delete 
	 * @实现功能: 任务删除验证
	 * @param entity
	 * @create by peijd at 2017年3月10日 上午10:48:39
	 */
	@Override
	@Transactional(readOnly = false)
	public void delete(DcTransDataMain entity) {

		Assert.hasText(entity.getId());
		entity = dao.get(entity.getId());
		Assert.notNull(entity);
		// 判断任务状态 如果是调度任务  则不可删除
		if(DcTransDataMain.TASK_STATUS_TASK.equals(entity.getStatus())){
			throw new ServiceException("该任务已添加调度任务, 不可删除!");
		}
		super.delete(entity);
	}

	/**
	 * @方法名称: updateStatus 
	 * @实现功能: 更新业务状态
	 * @param objId
	 * @param status
	 * @create by peijd at 2017年3月10日 下午2:50:57
	 */
	@Transactional(readOnly = false)		
	public void updateStatus(String objId, String status){
		Assert.hasText(objId);
		status = StringUtils.isEmpty(status)?DcTransDataMain.TASK_STATUS_EDIT:status;
		DcTransDataMain obj = new DcTransDataMain();
		obj.setId(objId);
		obj.setStatus(status);
		obj.preUpdate();
		dao.update(obj);
	}

}
