/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.sys.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.service.TreeService;
import com.hlframe.common.utils.CacheUtils;
import com.hlframe.modules.sys.dao.DictDao;
import com.hlframe.modules.sys.entity.Dict;
import com.hlframe.modules.sys.entity.Role;
import com.hlframe.modules.sys.entity.Dict;
import com.hlframe.modules.sys.entity.Dict;
import com.hlframe.modules.sys.utils.DictUtils;
import com.hlframe.modules.sys.utils.UserUtils;

/**
 * 字典Service
 * @author hlframe
 * @version 2014-05-16
 */
@Service
@Transactional(readOnly = true)
public class DictService extends TreeService<DictDao, Dict> {
	@Autowired
	private DictDao dictDao;

	/**
	 * 查询字段类型列表
	 *
	 * @return
	 */
	public List<String> findTypeList() {
		return dao.findTypeList(new Dict());
	}

	public List<Dict> findAllTypeList() {
		return dao.findAllTypeList(new Dict());
	}

	@Transactional(readOnly = false)
	public void save(Dict dict) {
		super.save(dict);
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
	}

	@Transactional(readOnly = false)
	public void delete(Dict dict) {
		super.delete(dict);
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
	}

	public Page<Dict> findDict(Page<Dict> page, Dict dict) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		dict.getSqlMap().put("dsf", dataScopeFilter(dict.getCurrentUser(), "o", "a"));
		// 设置分页参数
		dict.setPage(page);
		// 执行分页查询
		page.setList(dictDao.findList(dict));
		return page;
	}

	public Dict getDict(String id) {
		return dictDao.get(id);
	}

	public List<Dict> findAllList(Dict dict) {
		return dictDao.findAllTypeList(dict);
	}

	public static void sortList(List<Dict> list, List<Dict> sourcelist, String parentId, boolean cascade) {
		for (int i = 0; i < sourcelist.size(); i++) {
			Dict e = sourcelist.get(i);
			if (e.getParentId().equals(parentId)) {
				list.add(e);
				if (cascade) {
					// 判断是否还有子节点, 有则继续获取子节点
					for (int j = 0; j < sourcelist.size(); j++) {
						Dict child = sourcelist.get(j);
						if (child.getParent() != null && child.getParent().getId() != null
								&& child.getParent().getId().equals(e.getId())) {
							sortList(list, sourcelist, e.getId(), true);
							break;
						}
					}
				}
			}
		}
	}

	/*
     * 远程验证value键值的方法
     * bao gang 2017,4,25 星期2 18：50
     */
	public Dict getRoleByValue(String value, String parentId) {
		Dict r = new Dict();
		r.setValue(value);
		Dict parent = new Dict();
		parent.setId(parentId);
		r.setParent(parent);

		return dictDao.getRoleByValue(r);
	}

	/*
	 * 远程验证label标签的方法
	 * bao gang 2017,4,25 星期2 18：50
	 */
	public Dict getRoleByLable(String label, String parentId) {
		Dict r = new Dict();
		r.setLabel(label);
		Dict parent = new Dict();
		parent.setId(parentId);
		return dictDao.getRoleByLabel(r);
	}

	/*
    验证树标签
     */
	public Dict getlabel(String label) {
    Dict labe =new Dict();
    labe.setLabel(label);
    return  dictDao.getlabel(labe);
	}

}
