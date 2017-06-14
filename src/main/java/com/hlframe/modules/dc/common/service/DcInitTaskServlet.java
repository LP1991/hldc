/********************** 版权声明 *************************
 * 文件名: DcInitTaskSchedule.java
 * 包名: com.hlframe.modules.dc.common.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年2月16日 下午7:48:03
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.common.service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;
import com.hlframe.modules.dc.task.TaskInfo;
import com.hlframe.modules.dc.utils.QuartzUtil;

/** 
 * @类名: com.hlframe.modules.dc.common.service.DcInitTaskServlet.java 
 * @职责说明: 初始化调度任务 状态
 * @创建者: peijd
 * @创建时间: 2017年2月16日 下午7:48:03
 */
public class DcInitTaskServlet extends HttpServlet{
	
	private static final long serialVersionUID = 1L;

	private static Logger log = LoggerFactory.getLogger(DcInitTaskServlet.class);
	
	/**
	 * Override
	 * @方法名称: init 
	 * @实现功能: 初始化调度任务
	 * @throws ServletException
	 * @create by peijd at 2017年2月16日 下午7:50:04
	 */
	@Override
	public void init() throws ServletException {
		
		super.init();

		DcTaskTimeService dcTaskTimeService = SpringContextHolder.getBean(DcTaskTimeService.class);
		DcTaskTime param = new DcTaskTime();
		param.setTriggerType(DcTaskTime.TASK_TRIGGERTYPE_AUTO);	//自动
		param.setStatus(DcTaskTime.TASK_STATUS_RUNNING);		//运行中
		
		//获取自动运行的调度任务
		List<DcTaskTime> taskTimeList = dcTaskTimeService.findList(param);
		
		//依次启动各调度任务
		TaskInfo taskInfo = null;
		for(DcTaskTime taskTime: taskTimeList ){
			try {
				taskInfo = dcTaskTimeService.buildTaskInfo(taskTime);
				//开始运行任务
				QuartzUtil.doTaskProcess(taskInfo);
			} catch (Exception e) {
				log.error("-->DcInitTaskSchedule init error: ", e);
			}
		}
	}
	
	/**
	 * Override
	 * @方法名称: doGet 
	 * @实现功能: TODO
	 * @param req
	 * @param resp
	 * @throws ServletException
	 * @throws IOException
	 * @create by peijd at 2017年2月16日 下午7:50:16
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("-->DcInitTaskSchedule: doget at "+DateUtils.getDateTime());
		super.doGet(req, resp);
	}
}
