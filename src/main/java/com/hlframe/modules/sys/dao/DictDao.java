/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.sys.dao;

import java.util.List;

import com.hlframe.common.persistence.TreeDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.sys.entity.Dict;
import com.hlframe.modules.sys.entity.Role;

/**
 * 字典DAO接口
 * @author hlframe
 * @version 2014-05-16
 */
@MyBatisDao
public interface DictDao extends TreeDao<Dict> {
	
	
	public Dict getRoleByValue(Dict role);//远程验证 baognag 2017,4,25 星期二 18：48 value键值
	public Dict getRoleByLabel(Dict role);//远程验证 baognag 2017,4,25 星期二 18：48 label 标签
	public Dict getlabel(Dict role);//远程验证 树标签
	public List<String> findTypeList(Dict dict);

	public List<Dict> findAllTypeList(Dict dict);
	
	/**
	 * @方法名称: queryListByTypeId 
	 * @实现功能: 获取数据字典对象 包含列表
	 * @param dict
	 * @return
	 * @create by peijd at 2017年3月11日 上午10:36:03
	 */
	public List<Dict> queryListByTypeId(Dict dict);
	
}
