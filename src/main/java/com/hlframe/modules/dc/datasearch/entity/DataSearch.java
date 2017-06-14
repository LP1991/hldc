package com.hlframe.modules.dc.datasearch.entity;

import com.hlframe.common.persistence.DataEntity;

/**
 * 
 * @类名:DataSearch 
 * @职责说明: 数据搜索实体类
 * @创建者: cdd
 * @创建时间: 2016年11月5日 下午3:05:20
 */
public class DataSearch extends DataEntity<DataSearch>{
	private static final long serialVersionUID = 1L;
	
	private String objCode;
	private String objName;
	private String objType;
	private String systemId;
	private String objDesc;
	private String managerPer;
	private String managerOrg;
	private String status;
	private String fObjId;
	private String belong2Id;
	private String fieldName;
	private String fieldDesc;
	private String fieldType;
	private int fieldLeng;
	private int decimalNum;
	private int isKey;
	private String validateRule;
	private String fRemarks;
	private String tObjId;
	private String tableName;
	private String tableLink;
	private int dataNum;
	private String storeType;
	private String tRemarks;
	
	

	public String getObjCode() {
		return objCode;
	}
	public void setObjCode(String objCode) {
		this.objCode = objCode;
	}
	public String getObjName() {
		return objName;
	}
	public void setObjName(String objName) {
		this.objName = objName;
	}
	public String getObjType() {
		return objType;
	}
	public void setObjType(String objType) {
		this.objType = objType;
	}
	public String getSystemId() {
		return systemId;
	}
	public void setSystemId(String systemId) {
		this.systemId = systemId;
	}
	public String getObjDesc() {
		return objDesc;
	}
	public void setObjDesc(String objDesc) {
		this.objDesc = objDesc;
	}
	public String getManagerPer() {
		return managerPer;
	}
	public void setManagerPer(String managerPer) {
		this.managerPer = managerPer;
	}
	public String getManagerOrg() {
		return managerOrg;
	}
	public void setManagerOrg(String managerOrg) {
		this.managerOrg = managerOrg;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getfObjId() {
		return fObjId;
	}
	public void setfObjId(String fObjId) {
		this.fObjId = fObjId;
	}
	public String getBelong2Id() {
		return belong2Id;
	}
	public void setBelong2Id(String belong2Id) {
		this.belong2Id = belong2Id;
	}
	public String getFieldName() {
		return fieldName;
	}
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}
	public String getFieldDesc() {
		return fieldDesc;
	}
	public void setFieldDesc(String fieldDesc) {
		this.fieldDesc = fieldDesc;
	}
	public String getFieldType() {
		return fieldType;
	}
	public void setFieldType(String fieldType) {
		this.fieldType = fieldType;
	}
	public int getFieldLeng() {
		return fieldLeng;
	}
	public void setFieldLeng(int fieldLeng) {
		this.fieldLeng = fieldLeng;
	}
	public int getDecimalNum() {
		return decimalNum;
	}
	public void setDecimalNum(int decimalNum) {
		this.decimalNum = decimalNum;
	}
	public int getIsKey() {
		return isKey;
	}
	public void setIsKey(int isKey) {
		this.isKey = isKey;
	}
	public String getValidateRule() {
		return validateRule;
	}
	public void setValidateRule(String validateRule) {
		this.validateRule = validateRule;
	}
	public String getfRemarks() {
		return fRemarks;
	}
	public void setfRemarks(String fRemarks) {
		this.fRemarks = fRemarks;
	}
	public String gettObjId() {
		return tObjId;
	}
	public void settObjId(String tObjId) {
		this.tObjId = tObjId;
	}
	public String getTableName() {
		return tableName;
	}
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	public String getTableLink() {
		return tableLink;
	}
	public void setTableLink(String tableLink) {
		this.tableLink = tableLink;
	}
	public int getDataNum() {
		return dataNum;
	}
	public void setDataNum(int dataNum) {
		this.dataNum = dataNum;
	}
	public String getStoreType() {
		return storeType;
	}
	public void setStoreType(String storeType) {
		this.storeType = storeType;
	}
	public String gettRemarks() {
		return tRemarks;
	}
	public void settRemarks(String tRemarks) {
		this.tRemarks = tRemarks;
	}



}
