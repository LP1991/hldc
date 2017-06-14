/********************** 版权声明 *************************
 * 文件名: Data2Neo4jService.java
 * 包名: com.hlframe.modules.dc.datasearch.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年12月28日 上午10:03:36
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.common.service.CrudService;
import com.hlframe.modules.dc.datasearch.dao.Data2Neo4jDao;
import com.hlframe.modules.dc.datasearch.entity.Data2Neo4j;


/** 
 * @类名: com.hlframe.modules.dc.datasearch.service.Data2Neo4jService.java 
 * @职责说明: TODO
 * @创建者: yuzh
 * @创建时间: 2016年12月28日 上午10:03:36
 */
@Service
@Transactional(readOnly = true)
public class Data2Neo4jService extends CrudService<Data2Neo4jDao, Data2Neo4j> {

}
