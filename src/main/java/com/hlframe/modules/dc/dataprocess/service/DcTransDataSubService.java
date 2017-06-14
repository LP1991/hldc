/********************** 版权声明 *************************
 * 文件名: DcTransDataSubService.java
 * 包名: com.hlframe.modules.dc.dataprocess.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月30日 下午3:57:18
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.service;

import java.util.*;

import com.hlframe.modules.dc.dataprocess.entity.DcParamRegex;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.service.CrudService;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.common.DcConstants;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.dao.DcTransDataSubDao;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSub;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSubLog;
import com.hlframe.modules.dc.dataprocess.service.translate.DcTransSqlService;
import com.hlframe.modules.dc.metadata.entity.DcObjectField;
import com.hlframe.modules.dc.metadata.entity.DcObjectLink;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.entity.DcObjectTable;
import com.hlframe.modules.dc.metadata.service.DcMetadataStroeService;
import com.hlframe.modules.dc.metadata.service.DcObjectLinkService;
import com.hlframe.modules.dc.metadata.service.linkdb.DbHandleService;
import com.hlframe.modules.dc.metadata.service.linkdb.impl.DcImpalaHandle;
import com.hlframe.modules.dc.utils.DcParseSqlUtils;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.service.DcTransDataSubService.java 
 * @职责说明: 数据转换过程
 * @创建者: peijd
 * @创建时间: 2016年11月30日 下午3:57:18
 */
@Service
@Transactional(readOnly = true)
public class DcTransDataSubService extends CrudService<DcTransDataSubDao, DcTransDataSub> {

	@Autowired
	private DcTransDataMainLogService transLogService;	
	
	@Autowired
	private DcMetadataStroeService metaDataService;	
	
	@Autowired
	private DcObjectLinkService linkService;	
	
	@Autowired
	private DbHandleService dbHandleService;
	
	@Autowired
	private DcTransEngineService transEngineService;
	
	/**
	 * @方法名称: save 
	 * @实现功能: 保存转换过程和节点关系
	 * @param entity
	 * @create by peijd at 2016年12月10日 下午1:20:10
	 */
	@Transactional(readOnly = false)
	public void saveProcess(DcTransDataSub entity) throws Exception {
		//保存转换过程
		save(entity);
		
		//解析转换对象关系 TODO: 提供可视化页面设计数据表/字段关系, 这里不实现解析,
//		configDataLinkByProcess(entity);
	}
	
	/**
	 * @方法名称: runProcess 
	 * @实现功能: 运行转换过程
	 * @param processId	过程Id
	 * @return
	 * @create by peijd at 2016年12月1日 上午10:48:46
	 */
	@Transactional(readOnly = false)
	public DcTransDataSubLog runProcess(String processId) throws Exception {
		Assert.hasText(processId);
		DcTransDataSub process = dao.get(processId);
		//记录日志 
		DcTransDataSubLog log = new DcTransDataSubLog();
		log.setBeginTime(new Date());
		try {
			String transSql = process.getTransSql().replaceAll(DcConstants.DC_TRANSLATE_SWAPLINE, " ");
			
			//未设置处理数据源  使用默认的转换连接id='defaultTransConnection'
//			String transConnId = StringUtils.isNotEmpty(process.getTransConn())?process.getTransConn():DcConstants.DC_TRANSLATE_DEFAULT_CONN;
			//运行转换脚本	替换换行符
			DcDataResult result = transEngineService.runScript(process.getTransEngine(), transSql);
			log.setRemarks(result.getRst_flag()?result.getRst_std_msg():result.getRst_err_msg());
			
			//执行状态
			process.setStatus(result.getRst_flag()?DcConstants.DC_RESULT_FLAG_TRUE:DcConstants.DC_RESULT_FLAG_FALSE);
			/** 预处理sql
			transSql = DcParseSqlUtils.preProcessSql(process.getTransEngine(), transSql);
			//解析sql
			DcTransParseSqlResult parseRst = DcParseSqlUtils.parseTransSql(transSql);
			//解析sql 获取转换结果对象  以建表语句开头
			if(StringUtils.startsWithIgnoreCase(transSql, "create") && transSql.indexOf("(")>0){
				transSql = transSql.split("[(]")[0].toUpperCase();
				process.setTransRst(transSql.split("TABLE")[1].trim());
			}
			process.setTransRst(parseRst.getTarTable());
			**/
			
			//更新元数据信息(TODO: 解析sql)
//			updateMetaData(process, transSql);
			
		} catch (Exception e) {
			log.setRemarks(e.getMessage());
			process.setStatus(DcConstants.DC_RESULT_FLAG_FALSE);
			logger.error("-->DcTransDataSubService.runProcess", e);
		}
		process.preUpdate();
		dao.update(process);
		
		//保存日志
		log.setStatus(process.getStatus());
		log.setSubId(processId);
		log.setJobId(process.getJobId());
		log.setEndTime(new Date());
		transLogService.saveTransSubLog(log);
		
		return log;
	}

	/**
	 * @param process 
	 * @方法名称: updateMetaData 
	 * @实现功能: 更新元数据信息(解析sql, 通过org.apache.hadoop.hive.ql.tools.LineageInfo, 依赖jar: hive-exec-1.1.0-cdh5.8.0.jar)
	 * @param process	转换过程
	 * @param transSql	解析脚本
	 * @throws Exception 
	 * @create by peijd at 2016年12月6日 下午3:37:08
	 */
	@Transactional(readOnly = false)
	private void updateMetaData(DcTransDataSub process, String transSql) throws Exception {
		Assert.hasText(transSql);
		Map<String, String> rstMap =  DcParseSqlUtils.parseHiveSqlToMap(transSql);
		Assert.notEmpty(rstMap);
		//失败则抛异常  终止处理
		Assert.isTrue(DcConstants.DC_RESULT_FLAG_TRUE.equals(rstMap.get("resultFlag")));
		
		//将目标表 添加到元数据表 DcObjectMain/DcObjectTable/DcObjectField(暂不解析)
		String tarTable = rstMap.get("outputTable");
		Assert.hasText(tarTable);
		//对象主表
		DcObjectMain mainObj = new DcObjectMain();
		mainObj.setId(process.getId());
		mainObj.setObjCode(tarTable);
		mainObj.setJobId(process.getJobId());
		mainObj.setJobType(DcObjectMain.JOB_TYPE_TRANSLATE);		//转换任务
		mainObj.setJobSrcFlag(DcObjectMain.JOB_SRC_FLAG_YES);		
		mainObj.setObjName(process.getTransName());
		mainObj.setObjType(mainObj.OBJ_TYPE_TABLE);				//数据表
		mainObj.setObjDesc(process.getTransDesc());
		mainObj.setRemarks("create by transProcess, "+(StringUtils.isNotBlank(process.getRemarks())?process.getRemarks():""));
		
		//数据表对象
		DcObjectTable table = new DcObjectTable();
		table.setObjId(process.getId());
		table.setTableName(tarTable);
		table.setTableLink(process.getTransConn());
		table.setStoreType(DcObjectTable.TD_STORE_TYPE_WHOLE);	//全量更新
		table.setRemarks("process jobId:"+process.getJobId());
		
		//字段列表(暂不解析) 
		List<DcObjectField> fieldList = new ArrayList<DcObjectField>();
		metaDataService.obj2MySQL(mainObj, table, fieldList);
			
		
		/** 静态数据测试   字段1 订单日期
		DcObjectField field1 = new DcObjectField(IdGen.uuid());
		field1.setFieldName("orderDate");
		field1.setFieldType("timestamp");
		field1.setBelong2Id(process.getId());
		field1.setRemarks("来自转换任务-peijd");
		fieldList.add(field1);
		//字段2 coffee类型
		DcObjectField field2 = new DcObjectField(IdGen.uuid());
		field2.setFieldName("coffee_type");
		field2.setFieldType("integer");
		field2.setBelong2Id(process.getId());
		field2.setRemarks("来自转换任务-peijd");
		fieldList.add(field2);
		//字段3 coffee名称
		DcObjectField field3 = new DcObjectField(IdGen.uuid());
		field3.setFieldName("coffee_name");
		field3.setFieldType("timestamp");
		field3.setBelong2Id(process.getId());
		field3.setRemarks("来自转换任务-peijd");
		fieldList.add(field3);
		
		//更新
		metaDataService.obj2MySQL(mainObj, table, fieldList);
		**/
	}
	
	/**
	 * @方法名称: configDataLinkByProcess 
	 * @实现功能: 配置数据对象连接关系
	 * @param process
	 * @throws Exception
	 * @create by peijd at 2016年12月10日 下午1:06:38
	 */
	@Transactional(readOnly = false)
	public void configDataLinkByProcess(DcTransDataSub process) throws Exception {
		//将转换脚本换行处理
		String transSql = process.getTransSql().replaceAll(DcConstants.DC_TRANSLATE_SWAPLINE, " ");
		Map<String, String> rstMap =  DcParseSqlUtils.parseHiveSqlToMap(transSql);
		Assert.notEmpty(rstMap);
		//失败则抛异常  终止处理
		Assert.isTrue(DcConstants.DC_RESULT_FLAG_TRUE.equals(rstMap.get("resultFlag")), "转换脚本解析异常!");
		
		//将目标表 添加到元数据表 DcObjectMain/DcObjectTable/DcObjectField(暂不解析)
		String tarTable = rstMap.get("outputTable"), srcTable = rstMap.get("inputTable");
		if(StringUtils.isNotEmpty(srcTable) && StringUtils.isNotEmpty(tarTable)){
			//批量保存对象连接关系
			linkService.configObjLinkByProcess(process.getId(), srcTable, tarTable);
		}
	}

	/**
	 * @方法名称: getProName 
	 * @实现功能: 获取过程名称  根据任务Id和
	 * @param transName
	 * @param jobId
	 * @return
	 * @create by peijd at 2016年12月1日 下午2:59:20
	 */
	public DcTransDataSub getProName(String transName, String jobId) {
		Assert.hasText(jobId);
		Assert.hasText(transName);
		DcTransDataSub param = new DcTransDataSub();
		param.setJobId(jobId);
		param.setTransName(transName);
		return dao.getProName(param);
	}

	/**
	 * @方法名称: queryTransNum 
	 * @实现功能: 获取转换任务数量
	 * @param jobId	任务Id
	 * @return
	 * @create by peijd at 2016年12月1日 下午5:05:54
	 */
	public int queryTransNum(String jobId) {
		Assert.hasText(jobId);
		return dao.queryTransNum(jobId);
	}

	/**
	 * @方法名称: deleteByLogic 
	 * @实现功能: 逻辑删除转换过程
	 * @param obj
	 * @create by peijd at 2016年12月3日 下午4:25:34
	 */
	@Transactional(readOnly = false)
	public void deleteByLogic(DcTransDataSub obj) {
		Assert.isTrue(dao.deleteByLogic(obj)>0);
	}

	/**
	 * @方法名称: buildTransSql 
	 * @实现功能: 构建转换脚本, 根据字段映射关系
	 * @param obj	数据转换任务 
	 * INSERT OVERWRITE TABLE tab3 SELECT id, col_1, col_2, MONTH(col_3), DAYOFMONTH(col_3) FROM tab1 WHERE YEAR(col_3) = 2012;
	 * @create by peijd at 2016年12月21日 下午4:45:17
	 */
	public String buildTransSql(DcTransDataSub obj) {
		Assert.hasText(obj.getId());
		DcObjectLink param = new DcObjectLink();
		param.setProcessId(obj.getId());
		List<DcObjectLink> linkList = linkService.findList(param);
		if(CollectionUtils.isEmpty(linkList)){
			return null;
		}
		
		//获取执行引擎类别 默认为Impala
		String engineType = StringUtils.isNotEmpty(obj.getTransEngine())?obj.getTransEngine():DcTransDataSub.TRANSLATE_ENGINE_IMPALA;
		
		//数据转换Service  动态加载
		return dbHandleService.buildTranslateSql(engineType, linkList, obj); 
		
	}

	/**
	 * @方法名称: getParamRegexMap
	 * @实现功能: 获取参数正则表达式Map
	 * @params  []
	 * @return  java.util.List<java.util.Map<java.lang.String,java.lang.String>>
	 * @create by peijd at 2017/5/18 11:14
	 */
	public List<DcParamRegex> getParamRegexMap(){
		List<DcParamRegex> paramList = new LinkedList<DcParamRegex>();
		Map<String, Map<String, String>> regexMap = transEngineService.getRegexMap();
		DcParamRegex param = null;
		for(String key: regexMap.keySet()){
			param = new DcParamRegex();
			param.setParamName(key);			//变量名称
			param.setParamUsage("${"+key+"}");	//使用
			param.setParamDesc(regexMap.get(key).get("desc"));	//变量描述
			param.setParamValue(regexMap.get(key).get("val"));	//变量值
			paramList.add(param);
		}
		return paramList;
	}

}
