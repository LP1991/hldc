/********************** 版权声明 *************************
 * 文件名: DcObjectCollectDao.java
 * 包名: com.hlframe.modules.dc.datasearch.dao
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年1月18日 下午5:20:29
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.dao;

import com.hlframe.common.persistence.CrudDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.dc.datasearch.entity.DcObjectCollect;

import java.util.List;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.dao.DcObjectCollectDao.java 
 * @职责说明: TODO
 * @创建者: peijd
 * @创建时间: 2017年1月18日 下午5:20:29
 */
@MyBatisDao
public interface DcObjectCollectDao extends CrudDao<DcObjectCollect>{
    /**
     *
     * @方法名称: findList
     * @实现功能: findAllByUseridOrObjId
     * @return
     */
    List<DcObjectCollect> findList(DcObjectCollect param);

    /**
     *
     * @方法名称: insert
     * @实现功能: insert
     * @return
     */
    int insert(DcObjectCollect param);

    /**
     *
     * @方法名称: update
     * @实现功能: update
     * @return
     */
    int update(DcObjectCollect param);

    /**
     *
     * @方法名称: delete
     * @实现功能: delete
     * @return
     */
    int delete(String id);
}
