/********************** 版权声明 *************************
 * 文件名: JsonTest.java
 * 包名: com.hzhl.query
 * 版权:	杭州华量软件  jerseyHive
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年12月21日 下午3:26:47
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.jersey;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

/** 
 * @类名:com.hlframe.modules.dc.jersey.JsonTest.java 
 * @职责说明: 访问  http://10.1.21.16:9020/hldc/rest/test
 * @创建者: peijd
 * {"nodes":[{"id":"1","label":"Person","title":"Peter"},{"id":"2","label":"Person","title":"Michael"}],"links":[{"start":0,"end":1,"type":"KNOWS"}]}
 * @创建时间: 2016年12月21日 下午3:26:47
 */
@Path("/test") 
public class DcJerseyServerTest {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public String testServer() {
		JSONObject json = new JSONObject();
//		List<JSONObject> nodeList = new ArrayList<JSONObject>(), linkList = new ArrayList<JSONObject>();
		try {			
			json.put("server", "HuaLiang Soft");
			json.put("version", "1.0");
			json.put("status", "healthy");
			
			/*JSONObject nodeJson = new JSONObject(), linkJson = new JSONObject();
			nodeJson.put("id", "1");
			nodeJson.put("label", "Person");
			nodeJson.put("title", "Peter");
			nodeList.add(nodeJson);
			
			nodeJson = new JSONObject();
			nodeJson.put("id", "2");
			nodeJson.put("label", "Person");
			nodeJson.put("title", "Michael");
			nodeList.add(nodeJson);			
			json.put("nodes", nodeList);
			
			linkJson.put("start","0");
			linkJson.put("end","1");
			linkJson.put("type","KNOWS");
			linkList.add(linkJson);
			
			json.put("links", linkList);*/
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return json.toString();
	}
}
