package com.hlframe.modules.dc.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hlframe.modules.dc.common.dao.DcDataResult;

public interface ITask {
	
	Logger logger = LoggerFactory.getLogger(ITask.class);
	
	/**
	 * 单次执行任务
	 * @param taskInfo
	 * @return DcDataResult 结果对象
	 */
	DcDataResult doTask(TaskInfo taskInfo);
}
