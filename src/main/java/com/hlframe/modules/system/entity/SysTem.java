
package com.hlframe.modules.system.entity;

import java.util.Date;

import com.hlframe.common.persistence.DataEntity;



public class SysTem extends DataEntity<SysTem>{
	
	private static final long serialVersionUID = 1L;
	
	
	private String number;
	private String name;
	private String homes;
	private String bewrite;
	private String per;
	private String pers;
	private String contact;
	private String manuf;
	private String manufs;
	private String contacts;
	private Date sysdate;
	
	/**
	 * @return the number
	 */
	public String getNumber() {
		return number;
	}
	/**
	 * @param number the number to set
	 */
	public void setNumber(String number) {
		this.number = number;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the homes
	 */
	public String getHomes() {
		return homes;
	}
	/**
	 * @param homes the homes to set
	 */
	public void setHomes(String homes) {
		this.homes = homes;
	}
	/**
	 * @return the bewrite
	 */
	public String getBewrite() {
		return bewrite;
	}
	/**
	 * @param bewrite the bewrite to set
	 */
	public void setBewrite(String bewrite) {
		this.bewrite = bewrite;
	}
	/**
	 * @return the per
	 */
	public String getPer() {
		return per;
	}
	/**
	 * @param per the per to set
	 */
	public void setPer(String per) {
		this.per = per;
	}
	/**
	 * @return the pers
	 */
	public String getPers() {
		return pers;
	}
	/**
	 * @param pers the pers to set
	 */
	public void setPers(String pers) {
		this.pers = pers;
	}
	/**
	 * @return the contact
	 */
	public String getContact() {
		return contact;
	}
	/**
	 * @param contact the contact to set
	 */
	public void setContact(String contact) {
		this.contact = contact;
	}
	/**
	 * @return the manuf
	 */
	public String getManuf() {
		return manuf;
	}
	/**
	 * @param manuf the manuf to set
	 */
	public void setManuf(String manuf) {
		this.manuf = manuf;
	}
	/**
	 * @return the manufs
	 */
	public String getManufs() {
		return manufs;
	}
	/**
	 * @param manufs the manufs to set
	 */
	public void setManufs(String manufs) {
		this.manufs = manufs;
	}
	/**
	 * @return the contacts
	 */
	public String getContacts() {
		return contacts;
	}
	/**
	 * @param contacts the contacts to set
	 */
	public void setContacts(String contacts) {
		this.contacts = contacts;
	}
	/**
	 * @return the sysdate
	 */
	public Date getSysdate() {
		return sysdate;
	}
	/**
	 * @param sysdate the sysdate to set
	 */
	public void setSysdate(Date sysdate) {
		this.sysdate = sysdate;
	}


	
}
