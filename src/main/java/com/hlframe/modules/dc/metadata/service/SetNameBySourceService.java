/********************** 版权声明 *************************
 * 文件名: SetNameBySourceService.java
 * 包名: com.hlframe.modules.dc.metadata.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2017年1月19日 下午5:28:28
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.service;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.modules.dc.dataprocess.service.DcJobTransDataService;
import com.hlframe.modules.dc.metadata.entity.DcObjectAu;

/** 
 * @类名: com.hlframe.modules.dc.metadata.service.SetNameBySourceService.java 
 * @职责说明: TODO
 * @创建者: yuzh
 * @创建时间: 2017年1月19日 下午5:28:28
 */
@Service
@Transactional(readOnly = true)
public class SetNameBySourceService {
	@Autowired
	private DcObjectMainService dcObjectMainService;
	@Autowired
	private DcJobTransDataService dcJobTransDataService;
	
	public void setNameBySource(DcObjectAu obj){
		if(obj.getFrom().equals("1")){
			if(null!=dcJobTransDataService.get(obj.getFileId())){
				obj.setFileName(dcObjectMainService.get(obj.getFileId()).getObjName());
			}
		}else if(obj.getFrom().equals("2")){
			if(null!=dcJobTransDataService.get(obj.getFileId())){
				obj.setFileName(dcJobTransDataService.get(obj.getFileId()).getJobName());
			}
		}
	}
}
