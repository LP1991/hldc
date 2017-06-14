/********************** 版权声明 *************************
 * 文件名: CatalogDao.java
 * 包名: com.hlframe.modules.dc.datasearch.dao
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月3日 下午8:07:34
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.dao;

import com.hlframe.common.persistence.CrudDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.dc.datasearch.entity.DcCatalog;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.dao.CatalogDao.java 
 * @职责说明: 用户DAO接口
 * @创建者: yuzh
 * @创建时间: 2016年11月3日 下午8:07:34
 */
@MyBatisDao
public interface DcCatalogDao extends CrudDao<DcCatalog> {

}
