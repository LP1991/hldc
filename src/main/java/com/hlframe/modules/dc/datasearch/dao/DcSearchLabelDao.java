/********************** 版权声明 *************************
 * 文件名: DcSearchLabelDao.java
 * 包名: com.hlframe.modules.dc.datasearch.dao
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月11日 上午9:54:37
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.dao;

import java.util.List;

import com.hlframe.common.persistence.CrudDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabelRef;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.dao.DcSearchLabelDao.java 
 * @职责说明: 标签管理用户dao
 * @创建者: yuzh
 * @创建时间: 2016年11月11日 上午9:54:37
 */
@MyBatisDao
public interface DcSearchLabelDao extends CrudDao<DcSearchLabel>{

	DcSearchLabel getLabelName(String labelName);

	/**
	 * @方法名称: findLabelRefList 
	 * @实现功能: 查询数据对象标签列表
	 * @param param
	 * @return
	 * @create by peijd at 2017年1月18日 上午10:44:37
	 */
	List<DcSearchLabelRef> findLabelRefList(DcSearchLabelRef param);
	
	/**
	 * @方法名称: insertLabelRef 
	 * @实现功能: 新增对象标签
	 * @param param
	 * @return
	 * @create by peijd at 2017年1月18日 上午10:46:44
	 */
	int insertLabelRef(DcSearchLabelRef param);
	

	/**
	 * @方法名称: deleteLabelRef 
	 * @实现功能: 删除对象标签
	 * @param param
	 * @return
	 * @create by peijd at 2017年1月18日 上午10:48:26
	 */
	int deleteLabelRef(DcSearchLabelRef param);

	/**
	 * @方法名称: findLabelListByObjId 
	 * @实现功能: 根据对象Id 获取标签列表
	 * @param objId
	 * @return
	 * @create by peijd at 2017年1月18日 下午4:00:16
	 */
	List<DcSearchLabel> findLabelListByObjId(String objId);
	/**
	 * @方法名称: Labeldelete 
	 * @实现功能: 根据对象Id 删除标签
	 * @param objId
	 * @return
	 * @create by peijd at 2017年1月18日 下午4:00:16
	 */
	void Labeldelete(String objId);
}
