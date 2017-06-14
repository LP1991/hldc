/**
 * 
 */
package com.hlframe.modules.system.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.common.service.CrudService;
import com.hlframe.modules.system.dao.SysTemlectDao;
import com.hlframe.modules.system.entity.SysTem;




/**
 * @author Administrator
 *
 */
@Service
@Transactional(readOnly = true)
public class SysTemService extends CrudService<SysTemlectDao,SysTem> {
	
	@Autowired
	private SysTemlectDao systemlectdao;
	/*
	 * 添加
	 */
	@Transactional(readOnly = false)
	public void add2Favorite(){
		SysTem system=new SysTem();
		systemlectdao.insert(system);
		
	}
	/**
	 * 
	 * @方法名称: getLabelName 
	 * @实现功能: name查询判断重复
	 * @param labelName
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:53:30
	 */
		public SysTem getnumber(String number) {
			return systemlectdao.getnumber(number);
		}

}
