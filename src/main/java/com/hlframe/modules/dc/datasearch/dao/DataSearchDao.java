package com.hlframe.modules.dc.datasearch.dao;

import com.hlframe.common.persistence.CrudDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.dc.datasearch.entity.DataSearch;

/**
 * 
 * @类名: DataSearchDao
 * @职责说明:数据搜索
 * @创建者: cdd
 * @创建时间: 2016年11月5日 下午3:09:30
 */
@MyBatisDao
public interface DataSearchDao extends CrudDao<DataSearch>{
	public DataSearch findDataByName(String name,String searchType);//根据名字找到数据
	public DataSearch findDataByObjName(String name);//根据名字找到数据
}