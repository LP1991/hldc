/********************** 版权声明 *************************
 * 文件名: DcTransHiveTable.java
 * 包名: com.hlframe.modules.dc.jersey
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年2月17日 下午1:45:13
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.jersey;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.collections.CollectionUtils;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;

import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveField;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveTable;
import com.hlframe.modules.dc.dataprocess.service.DcHiveFieldService;
import com.hlframe.modules.dc.dataprocess.service.DcHiveTableService;
import com.hlframe.modules.dc.dataprocess.service.DcQueryHiveService;
import com.hlframe.modules.sys.entity.Dict;
import com.hlframe.modules.sys.service.DictService;
import com.hlframe.modules.sys.utils.DictUtils;

/** 
 * @类名: com.hlframe.modules.dc.jersey.DcTransHiveTable.java 
 * @职责说明: hive table 转换 rest实现类
 * @创建者: peijd
 * @创建时间: 2017年2月17日 下午1:45:13
 */
@Path("/translate")
public class DcTransHiveTable {

	private Logger logger = LoggerFactory.getLogger(getClass());
	
	//hive table service
	private DcHiveTableService hiveTableService = SpringContextHolder.getBean(DcHiveTableService.class);
	
	//hive field service
	private DcHiveFieldService hiveFieldService = SpringContextHolder.getBean(DcHiveFieldService.class);
	
	//hive field service
	private DcQueryHiveService queryHiveService = SpringContextHolder.getBean(DcQueryHiveService.class);

	
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public String testServer() {
		return "healthy";
	}
	
	/**
	 * @方法名称: buildHiveTableList 
	 * @实现功能: 根据参数 构建hive table 列表
	 * @param tableSpace	表空间
	 * @param tableName		表名
	 * @return
	 * @create by peijd at 2017年2月17日 下午2:21:52
	 */
	@POST  
    @Path("/buildHiveTableList")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String buildHiveTableList(@FormParam("tableSpace") String tableSpace, @FormParam("tableName") String tableName){
		DcDataResult result = new DcDataResult();
		//测试数据
		if("test".equalsIgnoreCase(tableSpace)){
			return buildTestTableList();
		}else if("test".equalsIgnoreCase(tableName)){
			return buildTestTable();
		}
		
		DcHiveTable param = new DcHiveTable();
		if(StringUtils.isNotEmpty(tableSpace)){
			param.setTableSpace(tableSpace);
		}
		if(StringUtils.isNotEmpty(tableName)){
			param.setTableName(tableName);
		}
		List<DcHiveTable> tableList = hiveTableService.findList(param);
		if(CollectionUtils.isEmpty(tableList)){
			result.setRst_flag(false);
			result.setRst_err_msg("hive table 列表为空, 请联系管理员!");
		}else{
			JSONObject tbJson = null, stageJson = null, insJson = null, uiJson = null, fieldJson = null;
			DcHiveField fieldParam = new DcHiveField();
			List<DcHiveField>  fieldList = null;
			List<JSONObject> hiveTbList = new ArrayList<JSONObject>(), insList = null, hiveFdList = null;
			try {
				if(StringUtils.isEmpty(tableName)){
					fieldList = hiveFieldService.findList(fieldParam);
				}
				for(DcHiveTable tb: tableList){
					insList = new ArrayList<JSONObject>() ;
					//stages 对象
					tbJson = new JSONObject();
					tbJson.put("name", tb.getTableName());
					tbJson.put("tableSpace",tb.getTableSpace());
					tbJson.put("stageinstance", insList);
					
					//uiInfo 对象
					uiJson = new JSONObject();
					uiJson.put("description", "");
					uiJson.put("xPos", new Integer(300));
					uiJson.put("yPos", new Integer(10));
					uiJson.put("name", tb.getTableName());
					uiJson.put("stageType", "source");
					uiJson.put("label", tb.getTableDesc());
					
					//stageinstance 对象
					insJson = new JSONObject();
					insJson.put("uiInfo", uiJson);
					insJson.put("instanceName", "2");
					insJson.put("eventLanes", "");
					insJson.put("outputLanes", "2dev");
					
					//字段列表
					hiveFdList = new ArrayList<JSONObject>();
					if(null==fieldList){
						fieldParam.setBelong2Id(tb.getId());
						fieldList = hiveFieldService.findList(fieldParam);
					}
					for(DcHiveField field: fieldList){
						if(field.getBelong2Id().equals(tb.getId())){
							fieldJson = new JSONObject();
							fieldJson.put("fieldName",field.getFieldName());
							fieldJson.put("fielDesc",field.getFieldDesc());
							fieldJson.put("fieldType",field.getFieldType());
							hiveFdList.add(fieldJson);
						}
					}

					insJson.put("one", hiveFdList);
					insList.add(insJson);
					//实例列表
					tbJson.put("stageinstance", insList);
					hiveTbList.add(tbJson);
				}
				stageJson = new JSONObject();
				stageJson.put("stages", hiveTbList);
				stageJson.put("rst_flag", true);
				return stageJson.toString();
				
			} catch (Exception e) {
				logger.error("-->buildHiveTableList: ", e);
				result.setRst_err_msg("获取hive table 列表异常!"+e.getMessage());
				result.setRst_flag(false);
			}
		}
		return result.toString();
	}
	
	/**
	 * @方法名称: buildTestData 
	 * @实现功能: 构建测试表列表
	 * @return
	 * @create by peijd at 2017年2月24日 下午2:42:15
	 */
	private String buildTestTableList() {
		StringBuilder tableList = new StringBuilder(512);
		tableList.append("{");
		tableList.append("	\"rst_flag\" : true,");
		tableList.append("	\"stages\" : [{");
		tableList.append("}");
		
		return tableList.toString().replaceAll("	", "");
	}
	
	/**
	 * @方法名称: buildTestTable 
	 * @实现功能: 构建测试表数据
	 * @return
	 * @create by peijd at 2017年2月24日 下午2:43:22
	 */
	private String buildTestTable() {
		StringBuilder tableList = new StringBuilder(512);
		tableList.append("{");
		tableList.append("	\"rst_flag\" : true,");
		tableList.append("	\"stages\" : [{");
		tableList.append("			\"name\" : \"产品信息表\",");
		tableList.append("			\"tableSpace\" : \"test\",");
		tableList.append("			\"stageinstance\" : [{");
		tableList.append("					\"uiInfo\" : {");
		tableList.append("						\"description\" : \"产品信息表\",");
		tableList.append("						\"xPos\" : 300,");
		tableList.append("						\"yPos\" : 10,");
		tableList.append("						\"name\" : \"test_product_info\",");
		tableList.append("						\"stageType\" : \"source\",");
		tableList.append("						\"label\" : \"产品信息表\"");
		tableList.append("					},");
		tableList.append("					\"instanceName\" : \"2\",");
		tableList.append("					\"eventLanes\" : \"\",");
		tableList.append("					\"outputLanes\" : \"2dev\",");
		tableList.append("					\"one\" : [{");
		tableList.append("							\"fieldName\" : \"productName\",");
		tableList.append("							\"fielDesc\" : \"产品名称\",");
		tableList.append("							\"fieldType\" : \"string\"");
		tableList.append("						}, {");
		tableList.append("							\"fieldName\" : \"productId\",");
		tableList.append("							\"fielDesc\" : \"产品Id\",");
		tableList.append("							\"fieldType\" : \"string\"");
		tableList.append("						}, {");
		tableList.append("							\"fieldName\" : \"productType\",");
		tableList.append("							\"fielDesc\" : \"产品分类\",");
		tableList.append("							\"fieldType\" : \"string\"");
		tableList.append("						}, {");
		tableList.append("							\"fieldName\" : \"productCost\",");
		tableList.append("							\"fielDesc\" : \"生产成本\",");
		tableList.append("							\"fieldType\" : \"double\"");
		tableList.append("						}, {");
		tableList.append("							\"fieldName\" : \"productLSH\",");
		tableList.append("							\"fielDesc\" : \"零售价\",");
		tableList.append("							\"fieldType\" : \"double\"");
		tableList.append("						}, {");
		tableList.append("							\"fieldName\" : \"status\",");
		tableList.append("							\"fielDesc\" : \"状态\",");
		tableList.append("							\"fieldType\" : \"string\"");
		tableList.append("						}");
		tableList.append("					]");
		tableList.append("				}");
		tableList.append("			]");
		tableList.append("		}");
		tableList.append("	]");
		tableList.append("}");
		
		return tableList.toString().replaceAll("	", "");
	}

	/**
	 * @方法名称: buildHiveFuncList 
	 * @实现功能: 构建hive 转换功能列表
	 * @return
	 * @create by peijd at 2017年2月17日 下午5:17:19
	 */
	@GET  
    @Path("/getHiveFuncList")
	@Produces(MediaType.TEXT_PLAIN)
	public String buildHiveFuncList(){
		DcDataResult result = new DcDataResult();
		try {
			//hive 转换函数 数据字典
			List<Dict> dictList = DictUtils.getDictList("dc_transfield_function");
			List<JSONObject> funcList = new LinkedList<JSONObject>(); 
			JSONObject funcObj = null, funcListObj = null;
			for(Dict item: dictList){
				//排除根节点
				if(Dict.DICT_ROOT_ID.equals(item.getParentId())){
					continue;
				}
				funcObj = new JSONObject();
				funcObj.put("value", item.getValue());
				funcObj.put("label", item.getLabel());
				funcObj.put("remarks", item.getRemarks());
				funcObj.put("sortnum", item.getSort());				
				funcList.add(funcObj);
			}
			if(CollectionUtils.isNotEmpty(funcList)){
				funcListObj = new JSONObject();
				funcListObj.put("rst_flag", true);
				funcListObj.put("funcList", funcList);
				return funcListObj.toString();
			}else{
				result.setRst_flag(false);
				result.setRst_err_msg("未能加载字段转换函数!");
			}
		} catch (Exception e) {
			logger.error("-->buildHiveFuncList: ", e);
			result.setRst_flag(false);
			result.setRst_err_msg(e.getMessage());
		}
		return result.toString();
	}
	
	/**
	 * @方法名称: buildFilterExpList 
	 * @实现功能: 构建过滤条件表达式 
	 * @return
	 * @create by peijd at 2017年3月9日 下午1:50:28
	 */
	@GET  
    @Path("/getFilterExpList")
	@Produces(MediaType.TEXT_PLAIN)
	public String buildFilterExpList(){
		DcDataResult result = new DcDataResult();
		try {
			//hive 过滤表达式 数据字典
			List<Dict> dictList = DictUtils.getDictList("dc_filter_express");
			List<JSONObject> funcList = new LinkedList<JSONObject>(); 
			JSONObject funcObj = null;
			for(Dict item: dictList){
				//排除根节点
				if(Dict.DICT_ROOT_ID.equals(item.getParentId())){
					continue;
				}
				funcObj = new JSONObject();
				funcObj.put("value", item.getValue());
				funcObj.put("label", item.getLabel());
				funcObj.put("remarks", item.getRemarks());
				funcObj.put("sortnum", item.getSort());				
				funcList.add(funcObj);
			}
			if(CollectionUtils.isNotEmpty(funcList)){
				JSONObject funcListObj = new JSONObject();
				funcListObj.put("rst_flag", true);
				funcListObj.put("expList", funcList);
				return funcListObj.toString();
			}else{
				result.setRst_flag(false);
				result.setRst_err_msg("未能加载过滤条件表达式!");
			}
		} catch (Exception e) {
			logger.error("-->buildFilterExpList: ", e);
			result.setRst_flag(false);
			result.setRst_err_msg(e.getMessage());
		}
		return result.toString();
	}
	
	/**
	 * @方法名称: queryHiveTableList 
	 * @实现功能: 查询hive table列表
	 * @param tableSpace
	 * @return
	 * @create by peijd at 2017年2月27日 下午4:38:54
	 */
	@POST  
    @Path("/queryHiveTableList")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String queryHiveTableList(@FormParam("tableSpace") String tableSpace) {
		DcDataResult result = new DcDataResult();
		// 测试数据
		if ("test".equalsIgnoreCase(tableSpace)) {
			return buildTestTableList();
		}

		DcHiveTable param = new DcHiveTable();
		if (StringUtils.isNotEmpty(tableSpace)) {
			param.setTableSpace(tableSpace);
		}
		List<DcHiveTable> tableList = hiveTableService.findList(param);
		if (CollectionUtils.isEmpty(tableList)) {
			result.setRst_flag(false);
			result.setRst_err_msg("hive table 列表为空, 请联系管理员!");
		} else {
			JSONObject tbJson = null, stageJson = null;
			List<JSONObject> hiveTbList = new ArrayList<JSONObject>();
			try {
				for (DcHiveTable tb : tableList) {
					// table 对象
					tbJson = new JSONObject();
					tbJson.put("tableName", tb.getTableName());
					tbJson.put("tableSpace", tb.getTableSpace());
					tbJson.put("tableDesc", tb.getTableDesc());
					hiveTbList.add(tbJson);
				}
				stageJson = new JSONObject();
				stageJson.put("rst_std_msg", hiveTbList);
				stageJson.put("rst_flag", true);
				return stageJson.toString();

			} catch (Exception e) {
				logger.error("-->queryHiveTableList: ", e);
				result.setRst_err_msg("获取hive table 列表异常!" + e.getMessage());
				result.setRst_flag(false);
			}
		}
		return result.toString();
	}
	
	/**
	 * @方法名称: queryHiveFieldByTable 
	 * @实现功能: 根据表名查询hive 字段列表
	 * @param tableName
	 * @return
	 * @create by peijd at 2017年2月27日 下午4:40:20
	 */
	@POST  
    @Path("/queryHiveFieldByTable")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String queryHiveFieldByTable(@FormParam("tableName") String tableName) {
		Assert.hasText(tableName);
		DcDataResult result = new DcDataResult();
		DcHiveTable param = new DcHiveTable();
		param.setTableName(tableName);
		try{
			DcHiveTable tb = hiveTableService.get(param);
			Assert.notNull(tb, "未获取到hive表:"+tableName);
			
			JSONObject fieldJson = null, tbJson = new JSONObject();
			//构建hive table 信息
			tbJson.put("tableName", tb.getTableName());
			tbJson.put("tableSpace", tb.getTableSpace());
			tbJson.put("tableDesc", tb.getTableDesc());
			
			//查询hive 字段信息
			DcHiveField fieldParam = new DcHiveField();
			fieldParam.setBelong2Id(tb.getId());
			List<DcHiveField> fieldList = hiveFieldService.findList(fieldParam);
			List<JSONObject> hiveTbList = new ArrayList<JSONObject>();
			for(DcHiveField field: fieldList){
				fieldJson = new JSONObject();
				fieldJson.put("fieldName",field.getFieldName());
				fieldJson.put("fielDesc",field.getFieldDesc());
				fieldJson.put("fieldType",field.getFieldType());
				hiveTbList.add(fieldJson);
			}
			tbJson.put("fieldArr", hiveTbList);
			tbJson.put("rst_flag", true);
			return tbJson.toString();
			
		}catch(Exception e){
			logger.error("-->queryHiveFieldByTable: ", e);
			result.setRst_err_msg("获取hive table 对象["+tableName+"]异常!" + e.getMessage());
			result.setRst_flag(false);
		}
		
		return result.toString();
	}
	
	/**
	 * @方法名称: checkHiveTableName 
	 * @实现功能: 检查hive表是否已经存在  表空间+表名 验证
	 * @param tableName
	 * @return 返回json: {"rst_flag":true,"rst_msg":"false"}, rst_msg:true-不存在, false-已存在
	 * @create by peijd at 2017年3月14日 上午10:05:40
	 */
	@POST  
    @Path("/checkHiveTableName")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String checkHiveTableName(@FormParam("tableName") String tableName) {
		Assert.hasText(tableName, "表名不可为空!");
		DcDataResult result = new DcDataResult();
		try{
			//查询hive 元数据表中记录
			result.setRst_std_msg(String.valueOf(queryHiveService.checkHiveTableName(tableName))); 
			result.setRst_flag(true);
		}catch(Exception e){
			result.setRst_flag(false);
			result.setRst_err_msg(e.getMessage());
			logger.error("-->checkHiveTableName:", e);
		}
		
		return result.toString();
	}
}
