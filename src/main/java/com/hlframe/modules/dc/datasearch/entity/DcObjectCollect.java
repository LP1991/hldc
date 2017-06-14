/********************** 版权声明 *************************
 * 文件名: DcObjectCollect.java
 * 包名: com.hlframe.modules.dc.datasearch.entity
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年1月18日 下午5:16:06
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.entity;

import java.util.Date;

import com.hlframe.common.persistence.DataEntity;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.sys.entity.User;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.entity.DcObjectCollect.java 
 * @职责说明: 用户收藏对象
 * @创建者: peijd
 * @创建时间: 2017年1月18日 下午5:16:06
 */
public class DcObjectCollect extends DataEntity<DcObjectCollect> {

	private static final long serialVersionUID = 1L;
	
	private String userId;		//用户Id
	private String objId;		//对象Id
	private Date collectTime;	//收藏时间
	private DcObjectMain dcObjectMain; //收藏对象信息
	private User user;
	// @return the userId
	public String getUserId() {
		return userId;
	}
	// @param userId the userId to set
	public void setUserId(String userId) {
		this.userId = userId;
	}
	// @return the objId
	public String getObjId() {
		return objId;
	}
	// @param objId the objId to set
	public void setObjId(String objId) {
		this.objId = objId;
	}
	// @return the collectTime
	public Date getCollectTime() {
		return collectTime;
	}
	// @param collectTime the collectTime to set
	public void setCollectTime(Date collectTime) {
		this.collectTime = collectTime;
	}

	public DcObjectMain getDcObjectMain() {
		return dcObjectMain;
	}

	public void setDcObjectMain(DcObjectMain dcObjectMain) {
		this.dcObjectMain = dcObjectMain;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
}
