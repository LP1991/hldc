/********************** 版权声明 *************************
 * 文件名: job2mysqlService.java
 * 包名: com.hlframe.modules.dc.uploadtohdfs
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年12月5日 下午3:56:06
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.service;

import java.util.List;

import org.elasticsearch.client.Client;
import com.hlframe.modules.dc.metadata.dao.*;
import com.hlframe.modules.dc.metadata.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.common.service.CrudService;
import com.hlframe.modules.dc.common.service.DcCommonService;
import com.hlframe.modules.dc.dataprocess.dao.DcHiveDatabaseDao;
import com.hlframe.modules.dc.dataprocess.dao.DcHiveTableDao;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveDatabase;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveTable;
import com.hlframe.modules.dc.datasearch.entity.DcSearchContent;
import com.hlframe.modules.dc.datasearch.service.DcSearchContentService;
import com.hlframe.modules.dc.metadata.dao.DcObjectCataRefDao;
import com.hlframe.modules.dc.metadata.dao.DcObjectFieldDao;
import com.hlframe.modules.dc.metadata.dao.DcObjectFileDao;
import com.hlframe.modules.dc.metadata.dao.DcObjectFolderDao;
import com.hlframe.modules.dc.metadata.dao.DcObjectLableDao;
import com.hlframe.modules.dc.metadata.dao.DcObjectMainDao;
import com.hlframe.modules.dc.metadata.dao.DcObjectTableDao;
import com.hlframe.modules.dc.metadata.entity.DcObjectCataRef;
import com.hlframe.modules.dc.metadata.entity.DcObjectField;
import com.hlframe.modules.dc.metadata.entity.DcObjectFile;
import com.hlframe.modules.dc.metadata.entity.DcObjectFolder;
import com.hlframe.modules.dc.metadata.entity.DcObjectLable;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.entity.DcObjectTable;

/** 
 * @类名: com.hlframe.modules.dc.uploadtohdfs.job2mysqlService.java 
 * @职责说明: TODO 元数据存储方法整合, 需对元数据和ES数据统一封装, 根据元数据jobSrcFlag值判断是否要存储到到ES中...  
 * @创建者: yuzh
 * @创建时间: 2016年12月5日 下午3:56:06
 */
@Service
@Transactional(readOnly = false)
public class DcMetadataStroeService extends CrudService<DcObjectMainDao, DcObjectMain> {
	@Autowired
	private DcObjectTableDao dcObjectTableDao;
	@Autowired	//接口元数据
	private DcObjectInterfaceDao dcObjectIntfcDao;
	@Autowired
	private DcObjectFieldDao dcObjectFieldDao;
	@Autowired
	private DcObjectFileDao dcObjectFileDao;
	@Autowired
	private DcObjectFolderDao dcObjectFolderDao;
	@Autowired
	private DcObjectLableDao dcObjectLableDao;
	@Autowired
	private DcObjectCataRefDao dcObjectCataRefDao;
	@Autowired
	private DcSearchContentService dcSearchContentService;
	@Autowired
	private DcHiveDatabaseDao dcHiveDatabaseDao;
	@Autowired
	private DcHiveTableDao dcHiveTableDao;
	@Autowired
	private DcCommonService dcCommonService;

	/**
	 * @方法名称: obj2MySQL 
	 * @实现功能: 表和字段的新增修改
	 * @param dcObjectMain
	 * @param dcObjectTable
	 * @param dcObjectField
	 * @create by yuzh at 2016年12月6日 上午11:43:39
	 */
	public void obj2MySQL(DcObjectMain dcObjectMain, DcObjectTable dcObjectTable,List<DcObjectField> dcObjectField){
		String id = dcObjectMain.getId();//获取主表id作为从表id
		if (dao.getById(dcObjectMain.getId())==null){//判断主表新建或更新
			dcObjectMain.preInsert();
			dcObjectMain.setId(id);
			dcObjectMain.setObjName(dcObjectTable.getDbDataBase()+"."+dcObjectTable.getTableName());
			dao.insert(dcObjectMain);
			DcObjectCataRef dcObjectCataRef = new DcObjectCataRef();//将新建数据插入系统默认分类中
			dcObjectCataRef.setObjId(id);
			dcObjectCataRef.setCataId("af7cfe6232e44a6db031da602c197827");
			dcObjectCataRefDao.insert(dcObjectCataRef);
			for(DcSearchContent unMarked : dcSearchContentService.getUnmark()){
				dcObjectCataRef.setCataId(unMarked.getId());
				dcObjectCataRefDao.insert(dcObjectCataRef);
			}
			//创建table信息
			dcObjectTable.preInsert();
			dcObjectTable.setObjId(id);
			dcObjectTableDao.insert(dcObjectTable);
		}else{
			dcObjectMain.preUpdate();
			dcObjectMain.setObjName(dcObjectTable.getDbDataBase()+"."+dcObjectTable.getTableName());
			dao.update(dcObjectMain);
			//更新table信息
			dcObjectTable.preUpdate();
			dcObjectTableDao.update(dcObjectTable);
		}
		

		//dcObjectFieldDao.delete(new DcObjectField(id));//在对字段进行操作前 删除原有对应字段
		dcObjectFieldDao.deleteByBelong2Id(id);//在对字段进行操作前 删除原有对应字段

		//TODO: 更改为批量提交方式
		for(DcObjectField field:dcObjectField){
			field.preInsert();
			field.setBelong2Id(id);
			dcObjectFieldDao.insert(field);
		}		
		try {
			dcCommonService.loadTableToEs(id);
		} catch (Exception e) {
			logger.error("DcCommonService.loadTableToEs()",e);
		}
	}

	/**
	 * @方法名称: obj2MySQL 
	 * @实现功能: 文件的新增修改
	 * @param dcObjectMain
	 * @param dcObjectFile
	 * @create by yuzh at 2016年12月6日 上午11:44:16
	 */
	public void obj2MySQL(DcObjectMain dcObjectMain, DcObjectFile dcObjectFile){
		String id = dcObjectMain.getId();//获取主表id作为从表id
		DcObjectMain para = new DcObjectMain();
		para.setId(dcObjectMain.getId());
		if (dao.get(para)==null){//判断主表新建或更新
			dcObjectMain.preInsert();
			dcObjectMain.setId(id);
			dao.insert(dcObjectMain);
			DcObjectCataRef dcObjectCataRef = new DcObjectCataRef();
			dcObjectCataRef.setObjId(id);
			dcObjectCataRef.setCataId("d523ac0e2a5d4d80ab64c085ca3f9da3");
			dcObjectCataRefDao.insert(dcObjectCataRef);
			
			//插入table信息
			dcObjectFile.preInsert();
			dcObjectFile.setId(id);
			dcObjectFileDao.insert(dcObjectFile);
			try{
				dcCommonService.loadFileToEs(dcObjectFile.getId());
			}catch(Exception e){
				logger.error("DcCommonService.loadFileToEs()",e);
			}
		}else{
			dcObjectMain.preUpdate();
			dao.update(dcObjectMain);
			//更新table信息
			dcObjectFile.preUpdate();
			dcObjectFileDao.update(dcObjectFile);
		}
		try{
			dcCommonService.loadFileToEs(id);
		}catch(Exception e){
			logger.error("-->dcMetadataStoreService.obj2MySQL() fileId :"+id,e);
		}
	}
	
	
	/**
	 * @方法名称: obj2MySQL 
	 * @实现功能: 文件夹及文件的新增修改	TODO: 需实现文件对象批量保存, 批量load至ES peijd
	 * @param dcObjectMain
	 * @param dcObjectFolder
	 * @param dcObjectFile
	 * @param loadFile2ES	是否加载文件到ElasticSearch检索队列  add By peijd 2017-3-4
	 * @create by yuzh at 2016年12月6日 上午11:45:20
	 */
	public void obj2MySQL(DcObjectMain dcObjectMain, DcObjectFolder dcObjectFolder, List<DcObjectFile> dcObjectFile, boolean loadFile2ES){
		String id = dcObjectMain.getId();//获取主表id作为从表id
		DcObjectMain para = new DcObjectMain();
		para.setId(dcObjectMain.getId());
		if (dao.get(para)==null){//判断主表新建或更新
			dcObjectMain.preInsert();
			dcObjectMain.setId(id);
//			dcObjectMain.setFilename(dcObjectFolder.getFolderName());
//			dcObjectMain.setFileurl(dcObjectFolder.getFolderUrl());
			dao.insert(dcObjectMain);
			DcObjectCataRef dcObjectCataRef = new DcObjectCataRef();
			dcObjectCataRef.setObjId(id);
			dcObjectCataRef.setCataId("ef15e415e7684e0e9cba8450603493b8");
			dcObjectCataRefDao.insert(dcObjectCataRef);
			
			//插入folder信息
			dcObjectFolder.preInsert();
			dcObjectFolder.setId(id);
			dcObjectFolderDao.insert(dcObjectFolder);
		}else{
			dcObjectMain.preUpdate();
			dao.update(dcObjectMain);
			
			//更新folder信息
			dcObjectFolder.preUpdate();
			dcObjectFolderDao.update(dcObjectFolder);
		}
		
		DcObjectFile param = new DcObjectFile();
		param.setFileBelong(id);
		dcObjectFileDao.deleteByFileBelong(param);//删除原有对应所有文件夹内文件信息
		
		for(DcObjectFile field:dcObjectFile){//新建文件信息
			field.preInsert();
			field.setFileBelong(id);//设置文件归属id
			
			if(loadFile2ES){	//load 至ElasticSearch集群
				dcObjectMain.setId(field.getId());
				obj2MySQL(dcObjectMain, field);
			}else{	//直接保存
				dcObjectFileDao.insert(field);
			}
		}
		try{
			dcCommonService.loadFolderToEs(id);
		}catch(Exception e){
			logger.error("-->DcCommonService.loadFolderToEs()",e);
		}
	}
	
	
	/**
	 * @方法名称: obj2MySQL 
	 * @实现功能: 标签新增修改
	 * @param dcObjectMain
	 * @param dcObjectLable
	 * @create by yuzh at 2016年12月6日 上午11:45:57
	 */
	public void obj2MySQL(DcObjectMain dcObjectMain, DcObjectLable dcObjectLable){
		String id = dcObjectMain.getId();//获取主表id作为从表id
		if (dao.getById(dcObjectMain.getId())==null){//判断主表新建或更新
			dcObjectMain.preInsert();
			dcObjectMain.setId(id);
			dao.insert(dcObjectMain);
			DcObjectCataRef dcObjectCataRef = new DcObjectCataRef();
			dcObjectCataRef.setObjId(id);
			dcObjectCataRef.setCataId("37e715fc0aa944fda279b5ce3b6234b4");
			dcObjectCataRefDao.insert(dcObjectCataRef);
			
			//新建label信息
			dcObjectLable.preInsert();
			dcObjectLable.setId(id);
			dcObjectLableDao.insert(dcObjectLable);
		}else{
			dcObjectMain.preUpdate();
			dao.update(dcObjectMain);
			
			//更新label信息
			dcObjectLable.preUpdate();
			dcObjectLableDao.update(dcObjectLable);
		}
		try{
			dcCommonService.loadLabelToEs(dcObjectLable.getId());
		}catch(Exception e){
			logger.error("DcCommonService.loadLabelToEs()",e);
		}
	}

	/**
	 * @方法名称: obj2MySQL
	 * @实现功能: 数据库元数据新增修改
	 * @param dcObjectMain
	 * @param dcHiveDatabase
	 * @create by hgw at 2017年12月6日 上午11:45:57
	 */
	public void obj2MySQL(DcObjectMain dcObjectMain, DcHiveDatabase dcHiveDatabase){
		String id = dcObjectMain.getId();//获取主表id作为从表id
		if (dao.getById(dcObjectMain.getId())==null){//判断主表新建或更新
			dcObjectMain.preInsert();
			dcObjectMain.setId(id);
			dao.insert(dcObjectMain);
			
			//新建database信息
			dcHiveDatabase.preInsert();
			dcHiveDatabase.setId(id);
			dcHiveDatabaseDao.insert(dcHiveDatabase);
		}else{
			dcObjectMain.preUpdate();
			dao.update(dcObjectMain);
			//更新database信息
			dcHiveDatabase.preUpdate();
			dcHiveDatabaseDao.update(dcHiveDatabase);
		}
	}

	/**
	 * @方法名称: deObj2MySQL
	 * @实现功能: 数据库元数据删除
	 * @param dcObjectMain
	 * @param dcHiveDatabase
	 * @create by hgw at 2017年12月6日 上午11:45:57
	 */
	public void deObj2MySQL(DcObjectMain dcObjectMain, DcHiveDatabase dcHiveDatabase){
		dao.delete(dcObjectMain);
		dcHiveDatabaseDao.deleteByLogic(dcHiveDatabase);
	}

	/**
	 * @方法名称: delObj2MySQL
	 * @实现功能: 表和字段的删除
	 * @param dcObjectMain
	 * @param dcObjectTable
	 * @param dcObjectField
	 * @create by hgw at 2017年3月11日 上午11:43:39
	 */
	public void delObj2MySQL(DcObjectMain dcObjectMain, DcObjectTable dcObjectTable,DcObjectField dcObjectField,DcObjectCataRef dcObjectCataRef,DcHiveTable dcHiveTable){
		dao.delete(dcObjectMain);
		dcObjectCataRefDao.delete(dcObjectCataRef);
	}

	/**
	 * @方法名称: obj2MySQL
	 * @实现功能: 表和字段的新增修改
	 * @param dcObjectMain
	 * @param dcObjectTable
	 * @param dcObjectField
	 * @create by yuzh at 2016年12月6日 上午11:43:39
	 */
	public void obj2MySQL(DcObjectMain dcObjectMain, DcObjectTable dcObjectTable,List<DcObjectField> dcObjectField,DcHiveTable dcHiveTable){
		String id = dcObjectMain.getId();//获取主表id作为从表id
		if (dao.getById(dcObjectMain.getId())==null){//判断主表新建或更新
			dcObjectMain.preInsert();
			dcObjectMain.setId(id);
			dcObjectMain.setObjName(dcObjectTable.getDbDataBase()+"."+dcObjectTable.getTableName());
			dao.insert(dcObjectMain);
			DcObjectCataRef dcObjectCataRef = new DcObjectCataRef();//将新建数据插入系统默认分类中
			dcObjectCataRef.setObjId(id);
			dcObjectCataRef.setCataId("af7cfe6232e44a6db031da602c197827");
			dcObjectCataRefDao.insert(dcObjectCataRef);
			for(DcSearchContent unMarked : dcSearchContentService.getUnmark()){
				dcObjectCataRef.setCataId(unMarked.getId());
				dcObjectCataRefDao.insert(dcObjectCataRef);
			}
			
			//添加table信息
			dcObjectTable.preInsert();
			dcObjectTable.setObjId(id);
			dcObjectTableDao.insert(dcObjectTable);
			//添加hive table 信息
			dcHiveTable.preInsert();
			dcHiveTable.setId(id);
			dcHiveTableDao.insert(dcHiveTable);
		}else{
			dcObjectMain.preUpdate();
			dcObjectMain.setObjName(dcObjectTable.getDbDataBase()+"."+dcObjectTable.getTableName());
			dao.update(dcObjectMain);
			//更新table信息
			dcObjectTable.preUpdate();
			dcObjectTableDao.update(dcObjectTable);
			//更新hiveTable信息
			dcHiveTable.preUpdate();
			dcHiveTableDao.update(dcHiveTable);
		}

		dcObjectFieldDao.delete(new DcObjectField(id));//在对字段进行操作前 删除原有对应字段

		for(DcObjectField field:dcObjectField){
			field.preInsert();
			field.setBelong2Id(id);
			dcObjectFieldDao.insert(field);
		}
		try {
			dcCommonService.loadTableToEs(id);
		} catch (Exception e) {
			logger.error("DcCommonService.loadTableToEs()",e);
		}
	}
	
		/**
		 * @方法名称: findFieldList
		 * @实现功能: 根据表id查询字段信息
		 * @param  dcObjectField
		 * @create by hgw at 2017年3月24日 下午15:31:39
		 */
		 public List<DcObjectField> findFieldList(DcObjectField dcObjectField){
			 return dcObjectFieldDao.findList(dcObjectField);
		 }

	/**
	 * @方法名称: obj2MySQL
	 * @实现功能: 接口数据采集 保存元数据信息
	 * @params  [srcMain, intfc]
	 * @return  void
	 * @create by peijd at 2017/4/17 20:07
	 */
    public void obj2MySQL(DcObjectMain dcObjectMain, DcObjectInterface intfc) {
		String id = dcObjectMain.getId();//获取主表id作为从表id
		if (dao.getById(dcObjectMain.getId())==null){//判断主表新建或更新
			dcObjectMain.preInsert();
			dcObjectMain.setId(id);
			dao.insert(dcObjectMain);
			DcObjectCataRef dcObjectCataRef = new DcObjectCataRef();
			dcObjectCataRef.setObjId(id);
			dcObjectCataRef.setCataId("d523ac0e2a5d4d80ab64c085ca3f9da3");
			dcObjectCataRefDao.insert(dcObjectCataRef);

			//插入table信息
			intfc.preInsert();
			intfc.setId(id);
			dcObjectIntfcDao.insert(intfc);
		}else{
			dcObjectMain.preUpdate();
			dao.update(dcObjectMain);
			//更新table信息
			intfc.preUpdate();
			dcObjectIntfcDao.update(intfc);
		}

		try{
			//接口对象 推送至ES
			dcCommonService.loadInterfaceToEs(intfc.getId());
		}catch(Exception e){
			logger.error("DcCommonService.loadFileToEs()",e);
		}
    }
}
