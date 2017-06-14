/********************** 版权声明 *************************
 * 文件名: Data2Neo4j.java
 * 包名: com.hlframe.modules.dc.datasearch.entity
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年12月28日 上午10:00:51
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.entity;

import com.hlframe.common.persistence.DataEntity;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.entity.Data2Neo4j.java 
 * @职责说明: TODO
 * @创建者: yuzh
 * @创建时间: 2016年12月28日 上午10:00:51
 */
public class Data2Neo4j extends DataEntity<Data2Neo4j>{
	
	private static final long serialVersionUID = 1L;
	
	private String tableName;
	private String tarName;
	private String processId;
	private String processName;
	private String processDes;
	
	
	/**
	 * @return the tableName
	 */
	public String getTableName() {
		return tableName;
	}
	/**
	 * @param tableName the tableName to set
	 */
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	/**
	 * @return the tarName
	 */
	public String getTarName() {
		return tarName;
	}
	/**
	 * @param tarName the tarName to set
	 */
	public void setTarName(String tarName) {
		this.tarName = tarName;
	}
	/**
	 * @return the processId
	 */
	public String getProcessId() {
		return processId;
	}
	/**
	 * @param processId the processId to set
	 */
	public void setProcessId(String processId) {
		this.processId = processId;
	}
	/**
	 * @return the processName
	 */
	public String getProcessName() {
		return processName;
	}
	/**
	 * @param processName the processName to set
	 */
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	/**
	 * @return the processDes
	 */
	public String getProcessDes() {
		return processDes;
	}
	/**
	 * @param processDes the processDes to set
	 */
	public void setProcessDes(String processDes) {
		this.processDes = processDes;
	}
	

}
