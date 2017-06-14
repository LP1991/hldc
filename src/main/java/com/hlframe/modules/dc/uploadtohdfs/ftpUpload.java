package com.hlframe.modules.dc.uploadtohdfs;
 
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.hlframe.modules.dc.metadata.entity.DcObjectField;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.entity.DcObjectTable;
import com.hlframe.modules.dc.metadata.service.DcMetadataStroeService;

import junit.framework.TestCase;
 
public class ftpUpload extends TestCase {
  
/* public void testFavFTPUtil(){
 String hostname = "10.1.20.85";
 int port = 7000;
 String username = "anonymous";
 String password = "111";
 String pathname = "hzhl_rd/ccc/"; 
 String filename = "big.rar"; 
 String originfilename = "C:\\Users\\Downloads\\Downloads.rar";
 //ftpUploadUtil.uploadFileFromProduction(hostname, port, username, password, pathname, filename, originfilename);
// String localpath = "D:/";
 ftpUploadUtil.uploadFileToHDFS(hostname, port, username, password, pathname);
// FavFTPUtil.downloadFile(hostname, port, username, password, pathname, filename, localpath);
 //System.out.println(pathname.substring(0, pathname.length()-1));
 }*/
 
	@Autowired
	private DcMetadataStroeService job2mysqlService; 
 public void test2mysql(){
	 DcObjectMain dcObjectMain = new DcObjectMain();
	 DcObjectTable dcObjectTable = new DcObjectTable();
	 List<DcObjectField> dcObjectField = new ArrayList<DcObjectField>();
	 DcObjectField Field = new DcObjectField("1");
	 dcObjectMain.setObjCode("123456");
	 dcObjectMain.setObjName("1234567");
	 dcObjectTable.setTableName("1234567");
	 Field.setId(null);
	 Field.setFieldName("0");
	 dcObjectField.add(0, Field);
	 Field.setFieldName("1");
	 dcObjectField.add(1, Field);
	 Field.setFieldName("2");
	 dcObjectField.add(2, Field);
	 Field.setFieldName("3");
	 dcObjectField.add(3, Field);
	 job2mysqlService.obj2MySQL(dcObjectMain, dcObjectTable, dcObjectField);
 }
 
 
}