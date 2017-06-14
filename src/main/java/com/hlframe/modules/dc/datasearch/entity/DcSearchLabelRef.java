/********************** 版权声明 *************************
 * 文件名: DcSearchLabelRef.java
 * 包名: com.hlframe.modules.dc.datasearch.entity
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年1月18日 上午10:40:34
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.entity;

import com.hlframe.common.persistence.DataEntity;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.entity.DcSearchLabelRef.java 
 * @职责说明: 标签与数据对象 关联
 * @创建者: peijd
 * @创建时间: 2017年1月18日 上午10:40:34
 */
public class DcSearchLabelRef extends DataEntity<DcSearchLabelRef> {
	
	private String objId;
	private String labelId;
	
	public DcSearchLabelRef(){
		
	}
	
	public DcSearchLabelRef(String objId, String labelId){
		this.objId = objId;
		this.labelId = labelId;
	}
	
	// @return the objId
	public String getObjId() {
		return objId;
	}
	// @param objId the objId to set
	public void setObjId(String objId) {
		this.objId = objId;
	}
	// @return the labelId
	public String getLabelId() {
		return labelId;
	}
	// @param labelId the labelId to set
	public void setLabelId(String labelId) {
		this.labelId = labelId;
	}
	
	
}
