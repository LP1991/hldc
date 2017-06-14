/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.service.TreeService;
import com.hlframe.modules.sys.dao.AreaDao;
import com.hlframe.modules.sys.entity.Area;
import com.hlframe.modules.sys.utils.UserUtils;

/**
 * 区域Service
 * @author hlframe
 * @version 2014-05-16
 */
@Service
@Transactional(readOnly = true)
public class AreaService extends TreeService<AreaDao, Area> {

	public List<Area> findAll(){
		return UserUtils.getAreaList();
	}

	@Transactional(readOnly = true)
	public List<Area> findListBy(Area area){
		area.setParentIds(area.getParentIds()+"%");
		
		return dao.findByParentIdsLike(area);
	}
	
	@Transactional(readOnly = false)
	public void save(Area area) {
		super.save(area);
		UserUtils.removeCache(UserUtils.CACHE_AREA_LIST);
	}
	
	@Transactional(readOnly = false)
	public void delete(Area area) {
		super.delete(area);
		UserUtils.removeCache(UserUtils.CACHE_AREA_LIST);
	}
	
//	public Page<Area> findArea(Page<Area> page, Area area) {
//		// 设置分页参数
//		area.setPage(page);
//	    // 执行分页查询
//		page.setList(areaDao.findList(area));
//		return page;
//	}
	public Page<Area> findArea(Page<Area> page, Area area) {
		// 设置分页参数
		area.setPage(page);
	    // 执行分页查询
		page.setList(dao.findList(area));
		return page;
	}
	
}
