/********************** 版权声明 *************************
 * 文件名: DcContentTableService.java
 * 包名: com.hlframe.modules.dc.datasearch.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月9日 下午1:43:52
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.service.CrudService;
import com.hlframe.modules.dc.datasearch.dao.DcContentTableDao;
import com.hlframe.modules.dc.datasearch.entity.DcContentTable;
import com.hlframe.modules.dc.utils.DcCommonUtils;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.service.DcContentTableService.java 
 * @职责说明: 分类管理service
 * @创建者: yuzh
 * @创建时间: 2016年11月9日 下午1:43:52
 */
@Service
@Transactional(readOnly = true)
public class DcContentTableService extends CrudService<DcContentTableDao, DcContentTable> {

	public List<DcContentTable> findList(DcContentTable dcContentTable){
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		dcContentTable.getSqlMap().put("dsf", dataScopeFilter(dcContentTable.getCurrentUser(),"o","u"));
		return super.findList(dcContentTable);
	}
	/**
	 * @实现功能: 数据权限过滤
	 * @create by yuzh at 2016年12月15日 14:30:29
	 */
	public Page<DcContentTable> findPage(Page<DcContentTable> page, DcContentTable dcContentTable) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		dcContentTable.getSqlMap().put("dsf", dataScopeFilter(dcContentTable.getCurrentUser(),"o","u"));
		// 设置分页参数
		dcContentTable.setPage(page);
		// 执行分页查询
		page.setList(dao.findList(dcContentTable));
		return super.findPage(page, dcContentTable);
		}
	
	/**
	 * 
	 * @方法名称: saveAndGetId 
	 * @实现功能: 新增时返回ID
	 * @param dcContentTable
	 * @return
	 * @create by yuzh at 2016年12月7日 下午7:43:18
	 */
	@Transactional(readOnly = false)
	public String saveAndGetId(DcContentTable dcContentTable){
		dcContentTable.setStatus("0");
		dcContentTable.preInsert();
		dao.insert(dcContentTable);
		return dcContentTable.getId();
	}
	/**
	 * @方法名称: addDataToDataSearch 
	 * @实现功能: 把这条业务分类显示到搜索页面上
	 * @param ids
	 * @create by cdd at 2017年1月23日 下午1:58:37
	 */
	@Transactional(readOnly = false)
	public void addDataToDataSearch(DcContentTable dcContentTable) {
		DcCommonUtils.updateFieldByField("ID",dcContentTable.getId(),"STATUS","1","dc_cata_item");//根据某个字段更新某个表里字段值
	}
	
	/**
	 * @方法名称: delDataToDataSearch 
	 * @实现功能: TODO
	 * @param dcContentTable
	 * @create by cdd at 2017年1月23日 下午3:39:17
	 */
	@Transactional(readOnly = false)
	public void delDataToDataSearch(DcContentTable dcContentTable) {
		DcCommonUtils.updateFieldByField("ID",dcContentTable.getId(),"STATUS","0","dc_cata_item");//根据某个字段更新某个表里字段值
	}
	/**
	 * @name: delete
	 * @funciton: refactor delete
	 * @param
	 * @return
	 * @Create by lp at 2017/3/16 11:25
	 * @throws
	 */
	@Transactional(readOnly = false)
	public void delete(DcContentTable entity) {
		dao.deleteRefByItemId(entity.getId());
		super.delete(entity);
	}
}
