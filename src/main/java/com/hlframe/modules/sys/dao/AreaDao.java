/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.sys.dao;

import com.hlframe.common.persistence.TreeDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.sys.entity.Area;

/**
 * 区域DAO接口
 * @author hlframe
 * @version 2014-05-16
 */
@MyBatisDao
public interface AreaDao extends TreeDao<Area> {
	
}
