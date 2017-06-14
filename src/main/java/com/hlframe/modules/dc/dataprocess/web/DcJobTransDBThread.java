package com.hlframe.modules.dc.dataprocess.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransDataService;

/**
 * DB采集线程
 * @author Administrator
 *
 */
public class DcJobTransDBThread extends Thread {
	protected Logger logger = LoggerFactory.getLogger(getClass()); 
	DcJobTransDataService service = null;
	String jobId = null;
	
	public DcJobTransDBThread(DcJobTransDataService transService, String jobId){
		this.service = transService;
		this.jobId = jobId;
	}
	
	@Override
	public void run() {
		try {
			if(null!=service && StringUtils.isNotBlank(jobId)){
				logger.info("--------->begin job: transDBData:"+jobId);
//				String result = service.runTask(jobId);
//				logger.info("DB采集任务["+jobId+"]执行结果:", result);
				Thread.currentThread().sleep(10000);
				logger.info("--------->finish job: transDBData:"+jobId);
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
}
