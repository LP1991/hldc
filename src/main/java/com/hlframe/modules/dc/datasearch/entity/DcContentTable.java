/********************** 版权声明 *************************
 * 文件名: DcContentTable.java
 * 包名: com.hlframe.modules.dc.datasearch.entity
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月9日 下午1:47:32
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.entity;

import com.hlframe.common.persistence.DataEntity;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.entity.DcContentTable.java 
 * @职责说明: 分类项目实体类
 * @创建者: yuzh
 * @创建时间: 2016年11月9日 下午1:47:32
 */
public class DcContentTable extends DataEntity<DcContentTable>{
	private static final long serialVersionUID = 1L;
	private String itemName;
	private String itemCode;
	private String status;
	private String sort;
	

	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}



}
