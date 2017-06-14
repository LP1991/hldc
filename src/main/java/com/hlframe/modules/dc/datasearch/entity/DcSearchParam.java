/********************** 版权声明 *************************
 * 文件名: DcSearchParam.java
 * 包名: com.hlframe.modules.dc.datasearch.entity
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月14日 下午1:46:51
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.entity;

import java.io.Serializable;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.entity.DcSearchParam.java 
 * @职责说明: 数据检索 实体参数
 * @创建者: peijd
 * @创建时间: 2016年11月14日 下午1:46:51
 */
public class DcSearchParam  implements Serializable {
	private static final long serialVersionUID = 1L;
	
	//检索名称
	private String searchName;
	//对象类型 (数据表/接口/文件/字段/指标)
	private String objType;
	
	
	//检索分类, 多个分类按逗号分隔
	private String searchType;
	//检索标签, 多个标签按逗号分隔
	private String searchLabel;
	//检索时间, 多个时间按逗号分隔
	private String searchTime;
	//检索业务分类层次, 多个分类按逗号分隔
	private String searchCat;
	
	
	private String oldFieldName;
	private String fieldValue;
	private String tableName;
	private String newFieldName;
	
	//当前页数
	private int pageNo;
	//每页数目
	private int pageSize;
	
	/**
	 * @return the searchName
	 */
	public String getSearchName() {
		return searchName;
	}
	/**
	 * @param searchName the searchName to set
	 */
	public void setSearchName(String searchName) {
		this.searchName = searchName;
	}
	/**
	 * @return the objType
	 */
	public String getObjType() {
		return objType;
	}
	/**
	 * @param objType the objType to set
	 */
	public void setObjType(String objType) {
		this.objType = objType;
	}
	/**
	 * @return the searchType
	 */
	public String getSearchType() {
		return searchType;
	}
	/**
	 * @param searchType the searchType to set
	 */
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	/**
	 * @return the searchLabel
	 */
	public String getSearchLabel() {
		return searchLabel;
	}
	/**
	 * @param searchLabel the searchLabel to set
	 */
	public void setSearchLabel(String searchLabel) {
		this.searchLabel = searchLabel;
	}
	/**
	 * @return the searchTime
	 */
	public String getSearchTime() {
		return searchTime;
	}
	/**
	 * @param searchTime the searchTime to set
	 */
	public void setSearchTime(String searchTime) {
		this.searchTime = searchTime;
	}
	
	public String getSearchCat() {
		return searchCat;
	}
	public void setSearchCat(String searchCat) {
		this.searchCat = searchCat;
	}
	/**
	 * @return the pageNo
	 */
	public int getPageNo() {
		return pageNo;
	}
	/**
	 * @param pageNo the pageNo to set
	 */
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	/**
	 * @return the pageSize
	 */
	public int getPageSize() {
		return pageSize;
	}
	/**
	 * @param pageSize the pageSize to set
	 */
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public String getOldFieldName() {
		return oldFieldName;
	}
	public void setOldFieldName(String oldFieldName) {
		this.oldFieldName = oldFieldName;
	}
	public String getFieldValue() {
		return fieldValue;
	}
	public void setFieldValue(String fieldValue) {
		this.fieldValue = fieldValue;
	}
	public String getTableName() {
		return tableName;
	}
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	public String getNewFieldName() {
		return newFieldName;
	}
	public void setNewFieldName(String newFieldName) {
		this.newFieldName = newFieldName;
	} 
	
}
