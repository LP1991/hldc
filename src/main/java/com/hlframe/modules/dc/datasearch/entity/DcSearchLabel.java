/********************** 版权声明 *************************
 * 文件名: DcSearchLabel.java
 * 包名: com.hlframe.modules.dc.datasearch.entity
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月11日 上午9:49:29
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.entity;

import com.hlframe.common.persistence.DataEntity;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.entity.DcSearchLabel.java 
 * @职责说明: 标签管理实体类
 * @创建者: yuzh
 * @创建时间: 2016年11月11日 上午9:49:29
 */
public class DcSearchLabel extends DataEntity<DcSearchLabel>{
	private static final long serialVersionUID = 1L;
	private String labelName;
	private String labelDesc;
	private String status;
	
	public String getLabelName() {
		return labelName;
	}
	public void setLabelName(String labelName) {
		this.labelName = labelName;
	}
	public String getLabelDesc() {
		return labelDesc;
	}
	public void setLabelDesc(String labelDesc) {
		this.labelDesc = labelDesc;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
}
