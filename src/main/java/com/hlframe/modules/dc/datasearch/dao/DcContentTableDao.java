/********************** 版权声明 *************************
 * 文件名: DcContentTableDao.java
 * 包名: com.hlframe.modules.dc.datasearch.dao
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月9日 下午1:46:41
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.dao;

import com.hlframe.common.persistence.CrudDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.dc.datasearch.entity.DcContentTable;
import org.apache.ibatis.annotations.Param;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.dao.DcContentTableDao.java 
 * @职责说明: 分类管理用户dao
 * @创建者: yuzh
 * @创建时间: 2016年11月9日 下午1:46:41
 */

@MyBatisDao
public interface DcContentTableDao extends CrudDao<DcContentTable>{

    void deleteRefByItemId(@Param("id") String id);
}
