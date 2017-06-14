/********************** 版权声明 *************************
 * 文件名: DcTransDataMainLogService.java
 * 包名: com.hlframe.modules.dc.dataprocess.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月30日 下午3:59:27
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.service.CrudService;
import com.hlframe.modules.dc.dataprocess.dao.DcTransDataMainLogDao;
import com.hlframe.modules.dc.dataprocess.dao.DcTransDataSubLogDao;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataMainLog;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSubLog;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.service.DcTransDataMainLogService.java 
 * @职责说明: 数据转换任务/过程日志
 * @创建者: peijd
 * @创建时间: 2016年11月30日 下午3:59:27
 */
@Service
@Transactional(readOnly = true)
public class DcTransDataMainLogService extends CrudService<DcTransDataMainLogDao, DcTransDataMainLog> {

	@Autowired
	DcTransDataSubLogDao subLogDao;
	
	/**
	 * @方法名称: saveTransSubLog 
	 * @实现功能: 记录过程日志
	 * @param log
	 * @create by peijd at 2016年12月3日 上午10:39:19
	 */
	@Transactional(readOnly = false)
	public void saveTransSubLog(DcTransDataSubLog log){
		log.preInsert();
		subLogDao.insert(log);
	}

	/**
	 * @方法名称: getProcessLog 
	 * @实现功能: 获取过程日志
	 * @param id	日志Id
	 * @return
	 * @create by peijd at 2016年12月3日 下午3:33:22
	 */
	public DcTransDataSubLog getProcessLog(String id) {
		Assert.hasText(id);
		return subLogDao.get(id);
	}

	/**
	 * @方法名称: getLatestProLog 
	 * @实现功能: 获取最近的处理过程日志
	 * @param subId	处理过程Id
	 * @return
	 * @create by peijd at 2016年12月3日 下午3:41:29
	 */
	public DcTransDataSubLog getLatestProLog(String subId) {
		Assert.hasText(subId);
		return subLogDao.getLatestProLog(subId);
	}

	/**
	 * @方法名称: getLatestTaskLog 
	 * @实现功能: 获取最近的处理任务日志
	 * @param jobId
	 * @return
	 * @create by peijd at 2016年12月3日 下午6:09:30
	 */
	public DcTransDataMainLog getLatestTaskLog(String jobId) {
		Assert.hasText(jobId);
		return dao.getLatestTaskLog(jobId);
	}
}
