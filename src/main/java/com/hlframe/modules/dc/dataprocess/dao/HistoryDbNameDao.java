package com.hlframe.modules.dc.dataprocess.dao;

import java.util.List;
import java.util.Map;

import com.hlframe.common.persistence.CrudDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.dc.dataprocess.entity.HistoryDbName;

/**
 * Hive历史记录
 * @author hgw
 *
 */
@MyBatisDao
public interface HistoryDbNameDao extends CrudDao<HistoryDbName>{

	List getHistoryMsg(HistoryDbName historyDbName);
}
