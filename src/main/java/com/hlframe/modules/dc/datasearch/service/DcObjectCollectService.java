/********************** 版权声明 *************************
 * 文件名: DcObjectCollectService.java
 * 包名: com.hlframe.modules.dc.datasearch.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年1月18日 下午5:23:10
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.service;

import java.util.List;

import com.hlframe.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.common.service.CrudService;
import com.hlframe.modules.dc.datasearch.dao.DcObjectCollectDao;
import com.hlframe.modules.dc.datasearch.entity.DcObjectCollect;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.service.DcObjectCollectService.java 
 * @职责说明: 用户收藏数据 Service
 * @创建者: peijd
 * @创建时间: 2017年1月18日 下午5:23:10
 */
 @Service
 @Transactional(readOnly = true)
public class DcObjectCollectService extends CrudService<DcObjectCollectDao, DcObjectCollect> {

	@Autowired
	private DcObjectCollectDao dcObjectCollectDao;
	 /**
	  * @方法名称: add2Favorite 
	  * @实现功能: 添加至个人收藏目录
	  * @param objId
	  * @create by peijd at 2017年1月18日 下午5:48:22
	  */
	 @Transactional(readOnly = false)
	 public void add2Favorite(String objId){
		 String userId = UserUtils.getUser().getId();
		 DcObjectCollect dcObjectCollect = new DcObjectCollect();
		 dcObjectCollect.preInsert();
		 dcObjectCollect.setCollectTime(dcObjectCollect.getCreateDate());
		 dcObjectCollect.setObjId(objId);
		 dcObjectCollect.setUserId(userId);
		 dcObjectCollectDao.insert(dcObjectCollect);
	 }
	 
	 /**
	  * @方法名称: removeFromFavorite 
	  * @实现功能: 从个人收藏目录移除
	  * @param objId
	  * @create by peijd at 2017年1月18日 下午5:49:22
	  */
	 @Transactional(readOnly = false)
	 public void removeFromFavorite(String objId){
		 dcObjectCollectDao.delete(objId);
	 }
	 
	 /**
	  * @方法名称: findListByUserId 
	  * @实现功能: 根据用户Id 查询收藏对象列表
	  * @param userId 默认为当前用户
	  * @return
	  */
	 public List<DcObjectCollect> findListByUserId(String userId){
		 DcObjectCollect dcObjectCollect = new DcObjectCollect();
		 dcObjectCollect.setUserId(userId);
		 return dcObjectCollectDao.findList(dcObjectCollect);
	 }
	 
	 /**
	  * @方法名称: findListByObjId 
	  * @实现功能: 根据对象Id 获取所有用户Id
	  * @param objId
	  * @return
	  */
	 public List<DcObjectCollect> findListByObjId(String objId){
		 DcObjectCollect dcObjectCollect = new DcObjectCollect();
		 dcObjectCollect.setUserId(objId);
		 return dcObjectCollectDao.findList(dcObjectCollect);
	 }
	 
	 /**
	  * @方法名称: isFavorite 
	  * @实现功能: 查询数据对象是否被指定用户收藏
	  * @param userId
	  * @param objId
	  * @return
	  */
	 public boolean isFavorite(String userId, String objId){
		 if (userId == null || objId == null){
			 return false;
		 }
		 List<DcObjectCollect> lists = findListByUserId(userId);
		 if (lists.size() == 0){
		 	return false;
		 }
		 for(DcObjectCollect dcObjectCollect : lists){
		 	if(objId.equals(dcObjectCollect.getObjId())){
				return true;
			}
		 }
		 return false;
	 }
	
}
