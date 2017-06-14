/**
 * 
 */
package com.hlframe.modules.system.dao;

import java.util.List;

import com.hlframe.common.persistence.CrudDao;
import com.hlframe.common.persistence.annotation.MyBatisDao;
import com.hlframe.modules.system.entity.SysTem;




/**
 * @author Administrator
 *
 */
@MyBatisDao
public interface SysTemlectDao extends CrudDao<SysTem>{
	SysTem getnumber(String number);
	   /**
    *
    * @方法名称: findList
    * @实现功能: findAllByUseridOrObjId
    * @return
    */
   List<SysTem> findList(SysTem sys);

   /**
    *
    * @方法名称: insert
    * @实现功能: insert
    * @return
    */
   int insert(SysTem sys);

   /**
    *
    * @方法名称: update
    * @实现功能: update
    * @return
    */
   int update(SysTem sys);

   /**
    *
    * @方法名称: delete
    * @实现功能: delete
    * @return
    */
   int delete(String id);
}

	
	


