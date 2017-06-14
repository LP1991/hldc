/********************** 版权声明 *************************
 * 文件名: DcImpalaHandle.java
 * 包名: com.hlframe.modules.dc.metadata.service.linkdb.impl
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年12月2日 下午1:51:41
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.service.linkdb.impl;

import java.sql.Connection;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.common.DcConstants;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSub;
import com.hlframe.modules.dc.metadata.entity.DcObjectLink;
import com.hlframe.modules.dc.metadata.entity.linkdb.DcQueryPage;
import com.hlframe.modules.dc.metadata.service.linkdb.DBConnectionManager;
import com.hlframe.modules.dc.metadata.service.linkdb.DcDataBaseLinkService;
import com.hlframe.modules.dc.metadata.service.linkdb.abs.DcAbsDataBaseHandle;

/** 
 * @类名: com.hlframe.modules.dc.metadata.service.linkdb.impl.DcImpalaHandle.java 
 * @职责说明: Impala
 * @创建者: peijd
 * @创建时间: 2016年12月2日 下午1:51:41
 */
@Service
@Transactional(readOnly = true)
public class DcImpalaHandle extends DcAbsDataBaseHandle implements DcDataBaseLinkService {

	/**
	 * Override
	 * @方法名称: runScript 
	 * @实现功能: 执行impala脚本 
	 * @param dbSrcId
	 * @param script
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月2日 下午2:22:44
	 */
	@Override
	public DcDataResult runScript(String dbSrcId, String script) throws Exception {
		Assert.hasText(dbSrcId);
		Assert.hasText(script);
		Connection con = null;
		Statement stmt = null;
		// 获取数据源连接
		DBConnectionManager connMng = DBConnectionManager.getInstance();
		DcDataResult result = new DcDataResult();
		try{
			con = connMng.getConnection(dbSrcId);
			Assert.notNull(con);
			stmt = con.createStatement();
			stmt.executeUpdate(script);
			
			//刷新元数据	当需要更新大量元数据时使用INVALIDATE METADATA（不加表名） 。否则优先使用REFRESH
//			stmt.execute("invalidate metadata");	//让元数据过期腐败不可用，当表重新引用的时候重新加载。缺点：该语句是重量级的，比较耗时
			stmt.execute("refresh tablename");		//刷新表的元数据，必须跟上表名这个参数（确定）。实时的，轻量级的（优点）
			
			//返回结果
			result.setRst_flag(true);
			result.setRst_std_msg("-->run sql:"+script+", success!");
		}catch(Exception e){
			result.setRst_flag(false);
			result.setRst_err_msg(e.getMessage());
			logger.error("-->DcImpalaHandle.DcDataResult", e);
		}finally {
			try {
				if (null != stmt) {
					stmt.close();
				}
				//释放数据源连接
				if (null!=con) {
					connMng.freeConnection(dbSrcId, con);
				}
			} catch (Exception e2) {
				logger.error("close connection",e2);
			}
		}
		return result;
	}
	
	/**
	 * Override
	 * @方法名称: buildTranslateSql 
	 * @实现功能: 构建数据转换脚本 基于Impala引擎   select a.id as tt_id,a.manage_id as ddd,CONCAT(a.task,'__',a.priority) as task,a.priority+12 as proId from yuzh_plan a where a.priority <4
	 * @param linkList
	 * @param transProcess
	 * @return
	 * @create by peijd at 2016年12月21日 下午7:19:59
	 */
	@Override
	public String buildTranslateSql(List<DcObjectLink> linkList, DcTransDataSub transProcess) {
		StringBuilder transSql = new StringBuilder(512), fieldSql = new StringBuilder(512);
		String srcTable = null, tarTable = null;
		//依次构建转换关系  不同引擎不同处理 
		for(DcObjectLink link: linkList){
			//如果是字段, 构建转换脚本
			if(DcObjectLink.LINK_TYPE_FIELD.equals(link.getLinkType())){
				fieldSql.append(",").append(transFieldService.translateField(transFieldService.TRANSLATE_ENGINE_IMPALA, link)).append(DcConstants.DC_TRANSLATE_SWAPLINE);
			}else{
				srcTable = link.getSrcObjId();
				tarTable = link.getTarObjId();
			}
		}
		transSql.append("DROP TABLE IF EXISTS ").append(tarTable).append(";").append(DcConstants.DC_TRANSLATE_SWAPLINE);
		transSql.append("CREATE TABLE ").append(tarTable).append(" AS ").append(DcConstants.DC_TRANSLATE_SWAPLINE);
		transSql.append("SELECT ").append(fieldSql.substring(1)).append(" FROM ").append(srcTable);
		if(StringUtils.isNotEmpty(transProcess.getTransFilter())){
			transSql.append(" WHERE ").append(transProcess.getTransFilter());
		}
		return transSql.toString();
	}
	
	/**
	 * Override
	 * @方法名称: querySchemaList 
	 * @实现功能: TODO
	 * @param dataSourceId
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月2日 下午1:51:41
	 */
	@Override
	public List<Map<String, Object>> querySchemaList(String dataSourceId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Override
	 * @方法名称: queryTableNames 
	 * @实现功能: TODO
	 * @param dataSourceId
	 * @param schema
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月2日 下午1:51:41
	 */
	@Override
	public List<Map<String, Object>> queryTableNames(String dataSourceId, String schema) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Override
	 * @方法名称: queryTableNames 
	 * @实现功能: TODO
	 * @param dataSourceId
	 * @param schema
	 * @param filter
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月2日 下午1:51:41
	 */
	@Override
	public List<Map<String, Object>> queryTableNames(String dataSourceId, String schema, String filter) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Override
	 * @方法名称: queryTableColumns 
	 * @实现功能: TODO
	 * @param dataSourceId
	 * @param schema
	 * @param tableName
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月2日 下午1:51:41
	 */
	@Override
	public List<Map<String, Object>> queryTableColumns(String dataSourceId, String schema, String tableName) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Override
	 * @方法名称: buildTableKeySql 
	 * @实现功能: TODO
	 * @param tableList
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月2日 下午1:51:41
	 */
	@Override
	public String buildTableKeySql(List<Map<String, String>> tableList) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Override
	 * @方法名称: buildTableKeyField 
	 * @实现功能: TODO
	 * @param tbNameList
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月2日 下午1:51:41
	 */
	@Override
	public String buildTableKeyField(List<String> tbNameList) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Override
	 * @方法名称: assembleQueryPageSql 
	 * @实现功能: TODO
	 * @param page
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年12月2日 下午1:51:41
	 */
	@Override
	protected String assembleQueryPageSql(DcQueryPage page) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
