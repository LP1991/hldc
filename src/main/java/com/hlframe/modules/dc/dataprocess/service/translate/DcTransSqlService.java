/********************** 版权声明 *************************
 * 文件名: DcTransSqlService.java
 * 包名: com.hlframe.modules.dc.dataprocess.service.translate.impl
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年12月1日 下午9:05:41
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.service.translate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hlframe.modules.dc.common.dao.DcDataResult;


/** 
 * @类名: com.hlframe.modules.dc.dataprocess.service.translate.impl.DcTransSqlService.java 
 * @职责说明: 转换Sql服务类
 * @创建者: peijd
 * @创建时间: 2016年12月1日 下午9:05:41
 */
public interface DcTransSqlService {
	
	Logger logger = LoggerFactory.getLogger(DcTransSqlService.class);
	
	/**
	 * @方法名称: runScript 
	 * @实现功能: 运行脚本
	 * @param script
	 * @return
	 * @create by peijd at 2016年12月1日 下午9:13:39
	 */
	DcDataResult runScript(String script) throws Exception;

}
