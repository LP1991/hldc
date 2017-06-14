/********************** 版权声明 *************************
 * 文件名: Data2Neo4jDao.java
 * 包名: com.hlframe.modules.dc.datasearch.dao
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年12月28日 上午10:26:38
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.dao;

import com.hlframe.common.persistence.CrudDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.dc.datasearch.entity.Data2Neo4j;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.dao.Data2Neo4jDao.java 
 * @职责说明: TODO
 * @创建者: yuzh
 * @创建时间: 2016年12月28日 上午10:26:38
 */
@MyBatisDao
public interface Data2Neo4jDao extends CrudDao<Data2Neo4j> {

}
