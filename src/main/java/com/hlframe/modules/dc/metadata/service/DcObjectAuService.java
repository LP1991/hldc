
package com.hlframe.modules.dc.metadata.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.service.CrudService;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.modules.dc.datasearch.entity.DcObjectCollect;
import com.hlframe.modules.dc.metadata.dao.DcObjectAuDao;
import com.hlframe.modules.dc.metadata.entity.DcObjectAu;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.entity.DcSysObjm;

/**
 * 
 * @类名: com.hlframe.modules.dc.metadata.service.DcObjectAuService.java 
 * @职责说明: dc权限管理
 * @创建者: yuzh
 * @创建时间: 2016年11月19日 下午2:56:37
 */
@Service
@Transactional(readOnly = true)
public class DcObjectAuService extends CrudService<DcObjectAuDao, DcObjectAu> {
	
	/**
	 * @方法名称: pass 
	 * @实现功能: 申请通过
	 * @param obj
	 * @create by yuzh at 2016年11月19日 下午4:11:31
	 */
	@Transactional(readOnly = false)
	public void pass(DcObjectAu obj) {
		obj.setStatus("已通过");
		dao.update(obj);
		dao.pass(obj);
	}
	
	/**
	 * @方法名称: pass 
	 * @实现功能: 撤回申请
	 * @param obj
	 * @create by yuzh at 2016年11月19日 下午4:11:31
	 */
	@Transactional(readOnly = false)
	public void nopass(DcObjectAu obj) {
		obj.setStatus("已撤回");
		dao.update(obj);
		dao.delete(obj);
	}

	/**
	 * @方法名称: getById 
	 * @实现功能: TODO
	 * @param id
	 * @create by yuzh at 2017年1月18日 下午2:08:59
	 */
	public DcObjectAu getById(String id) {
		return dao.getById(id);
	}	
	
	/**
	 * @方法名称: getAccreList 
	 * @实现功能: 获取用户-元数据对象权限
	 * @param userId
	 * @param objId
	 * @return
	 * @create by peijd at 2017年2月25日 下午1:40:56
	 */
	public List<DcSysObjm> getAccreList(String userId, String objId){
		Assert.hasText(userId+objId);
		return dao.getAccreList(userId, objId);
	}
	
	public List<DcObjectMain> queryMyDataList(DcObjectMain main){
		return dao.queryMyDataList(main);
	}
	
 public List<DcObjectMain> colleCtDataList(DcObjectMain ser){
	return  dao.colleCtDataList(ser);
	 
 }
}
