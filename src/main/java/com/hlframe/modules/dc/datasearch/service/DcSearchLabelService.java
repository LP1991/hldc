/********************** 版权声明 *************************
 * 文件名: DcSearchLabelService.java
 * 包名: com.hlframe.modules.dc.datasearch.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月11日 上午9:48:20
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.service;

import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.service.CrudService;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.modules.dc.datasearch.dao.DcSearchLabelDao;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabelRef;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.service.DcSearchLabelService.java 
 * @职责说明: 标签管理service
 * @创建者: yuzh
 * @创建时间: 2016年11月11日 上午9:48:20
 */
@Service
@Transactional(readOnly = true)
public class DcSearchLabelService extends CrudService<DcSearchLabelDao, DcSearchLabel> {
	private static DcSearchLabelDao dcSearchLabelDao = SpringContextHolder.getBean(DcSearchLabelDao.class);
/**
 * 
 * @方法名称: getLabelName 
 * @实现功能: name查询判断重复
 * @param labelName
 * @return
 * @create by yuzh at 2016年11月12日 上午11:53:30
 */
	public DcSearchLabel getLabelName(String labelName) {
		return dcSearchLabelDao.getLabelName(labelName);
	}
	
	/**
	 * @方法名称: findLabelRefList 
	 * @实现功能: 获取对象/标签关联列表
	 * @param param
	 * @return
	 * @create by peijd at 2017年1月18日 上午10:44:04
	 */
	public List<DcSearchLabelRef> findLabelRefList(DcSearchLabelRef param){
		Assert.notNull(param);
		return dcSearchLabelDao.findLabelRefList(param);
	}
	
	/**
	 * @方法名称: findLabelListByObjId 
	 * @实现功能: 根据对象Id 获取标签列表
	 * @param objId
	 * @return
	 * @create by peijd at 2017年1月18日 下午3:59:33
	 */
	public List<DcSearchLabel> findLabelListByObjId(String objId){
		Assert.hasText(objId);
		return dcSearchLabelDao.findLabelListByObjId(objId);
	}
	
	/**
	 * @方法名称: insertLabelRef 
	 * @实现功能: 新增数据对象标签
	 * @param param
	 * @create by peijd at 2017年1月18日 上午11:03:50
	 */
	@Transactional(readOnly = false)
	public void insertLabelRef(DcSearchLabelRef param){
		Assert.notNull(param);
		Assert.isTrue(dcSearchLabelDao.insertLabelRef(param)>0);
	}
	

	/**
	 * @方法名称: deleteLabelRef 
	 * @实现功能: 删除数据对象标签
	 * @param param
	 * @create by peijd at 2017年1月18日 上午11:03:43
	 */
	@Transactional(readOnly = false)
	public void deleteLabelRef(DcSearchLabelRef param){
		Assert.notNull(param);
		Assert.isTrue(dcSearchLabelDao.deleteLabelRef(param)>0);
	}

	/**
	 * @方法名称: saveLabelRef 
	 * @实现功能: 保存标签及对象关联关系
	 * @param objId			对象Id
	 * @param labelName		标签名称
	 * @create by peijd at 2017年1月18日 下午2:06:57
	 */
	@Transactional(readOnly = false)
	public void saveLabelRef(String objId, String labelName) {
		Assert.hasText(objId);
		Assert.hasText(labelName);
		labelName = labelName.trim();
		
		//检查标签名称是否存在, 不存在则新建
		DcSearchLabel label = getLabelName(labelName);
		if(null==label){
			label = new DcSearchLabel();
			label.setLabelName(labelName);
			label.setLabelDesc(labelName);
			save(label);
			
		}else{	//判断该对象是否存在该标签
			DcSearchLabelRef param = new DcSearchLabelRef(objId, label.getId());
			Assert.isTrue(CollectionUtils.isEmpty(findLabelRefList(param)), "该标签已关联对象!");
		}
		
		//保存关联关系
		insertLabelRef(new DcSearchLabelRef(objId, label.getId()));
	}

}

