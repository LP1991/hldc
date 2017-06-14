/********************** 版权声明 *************************
 * 文件名: Catalog.java
 * 包名: com.hlframe.modules.dc.datasearch.entity
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月3日 下午7:02:38
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.entity;

import com.hlframe.common.persistence.DataEntity;

/**
 * @类名: com.hlframe.modules.dc.datasearch.entity.Catalog.java
 * @职责说明: Catalog实体类
 * @创建者: yuzh
 * @创建时间: 2016年11月3日 下午7:02:38
 */
public class DcCatalog extends DataEntity<DcCatalog> {

	private static final long serialVersionUID = 1L;
	private String id;
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
	private String feObjId;
	private String fileName;
	private String fileUrl;
	private int isStruct;
	private String splitter;
	private String feRemarks;
	private String iObjId;
	private String intfcType;
	private String intfcProtocal;
	private String intfcUrl;
	private String intfcNamespace;
	private String intfcUser;
	private String intfcPswd;
	private String iRemarks;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

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

	public String getFeObjId() {
		return feObjId;
	}

	public void setFeObjId(String feObjId) {
		this.feObjId = feObjId;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileUrl() {
		return fileUrl;
	}

	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}

	public int getIsStruct() {
		return isStruct;
	}

	public void setIsStruct(int isStruct) {
		this.isStruct = isStruct;
	}

	public String getSplitter() {
		return splitter;
	}

	public void setSplitter(String splitter) {
		this.splitter = splitter;
	}

	public String getFeRemarks() {
		return feRemarks;
	}

	public void setFeRemarks(String feRemarks) {
		this.feRemarks = feRemarks;
	}

	public String getiObjId() {
		return iObjId;
	}

	public void setiObjId(String iObjId) {
		this.iObjId = iObjId;
	}

	public String getIntfcType() {
		return intfcType;
	}

	public void setIntfcType(String intfcType) {
		this.intfcType = intfcType;
	}

	public String getIntfcProtocal() {
		return intfcProtocal;
	}

	public void setIntfcProtocal(String intfcProtocal) {
		this.intfcProtocal = intfcProtocal;
	}

	public String getIntfcUrl() {
		return intfcUrl;
	}

	public void setIntfcUrl(String intfcUrl) {
		this.intfcUrl = intfcUrl;
	}

	public String getIntfcNamespace() {
		return intfcNamespace;
	}

	public void setIntfcNamespace(String intfcNamespace) {
		this.intfcNamespace = intfcNamespace;
	}

	public String getIntfcUser() {
		return intfcUser;
	}

	public void setIntfcUser(String intfcUser) {
		this.intfcUser = intfcUser;
	}

	public String getIntfcPswd() {
		return intfcPswd;
	}

	public void setIntfcPswd(String intfcPswd) {
		this.intfcPswd = intfcPswd;
	}

	public String getiRemarks() {
		return iRemarks;
	}

	public void setiRemarks(String iRemarks) {
		this.iRemarks = iRemarks;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
