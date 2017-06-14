/********************** 版权声明 *************************
 * 文件名: DcTransMysqlService.java
 * 包名: com.hlframe.modules.dc.dataprocess.service.translate.impl
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年12月1日 下午9:16:30
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.service.translate.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.service.translate.DcTransSqlService;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.service.translate.impl.DcTransMysqlService.java 
 * @职责说明: mysql转换SQL service
 * @创建者: peijd
 * @创建时间: 2016年12月1日 下午9:16:30
 */
@Service
@Transactional(readOnly = true)
public class DcTransMysqlService implements DcTransSqlService {

	/**
	 * Override
	 * @方法名称: runScript 
	 * @实现功能: TODO
	 * @param script
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月1日 下午9:16:30
	 */
	@Override
	public DcDataResult runScript(String script) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
