/********************** 版权声明 *************************
 * 文件名: DcPostgresqlHandle.java
 * 包名: com.hlframe.modules.dc.metadata.service.linkdb.impl
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月21日 下午10:41:09
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.service.linkdb.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.metadata.entity.linkdb.DcQueryPage;
import com.hlframe.modules.dc.metadata.service.linkdb.DcDataBaseLinkService;
import com.hlframe.modules.dc.metadata.service.linkdb.abs.DcAbsDataBaseHandle;

/** 
 * @类名: com.hlframe.modules.dc.metadata.service.linkdb.impl.DcPostgresqlHandle.java 
 * @职责说明: Postgresql 数据库处理类
 * @创建者: peijd
 * @创建时间: 2016年11月21日 下午10:41:09
 */
@Service
@Transactional(readOnly = true)
public class DcPostgresqlHandle extends DcAbsDataBaseHandle implements DcDataBaseLinkService {

	/**
	 * Override
	 * @方法名称: queryTableNames 
	 * @实现功能: TODO
	 * @param dataSourceId
	 * @param schema
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年11月21日 下午10:41:10
	 */
	@Override
	public List<Map<String, Object>> queryTableNames(String dataSourceId, String schema) throws Exception {
		return queryTableNames(dataSourceId, schema, null);
	}

	/**
	 * Override
	 * @方法名称: queryTableNames 
	 * @实现功能: 获取数据表名称
	 * @param dataSourceId
	 * @param schema
	 * @param filter
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年11月21日 下午10:41:10
	 */
	@Override
	public List<Map<String, Object>> queryTableNames(String dataSourceId, String schema, String filter)
			throws Exception {
		StringBuilder metaSql = new StringBuilder(128);
		metaSql.append("SELECT a.table_name as TABNAME, ");
		metaSql.append("  case when a.TABLE_type='BASE TABLE' then 'TABLE' else TABLE_type end AS TABTYPE, ");
		metaSql.append("  case when obj_description(b.relfilenode,'pg_class') is null THEN table_name else table_name||'('||obj_description(relfilenode,'pg_class')||')' end as TABCOMMENT ");
		metaSql.append("  FROM information_schema.tables a, pg_class b WHERE a.table_name = b.relname and table_schema = '").append(schema).append("'");	
		
		//增加过滤条件  变量替换
		if (StringUtils.isNotBlank(filter)) {
			metaSql.append(" AND ").append(filter);
		}
		metaSql.append(" ORDER BY a.table_name");
		
		//返回查询结果
		return queryMetaSql(dataSourceId, metaSql.toString(), true);
	}

	/**
	 * Override
	 * @方法名称: queryTableColumns 
	 * @实现功能: 获取table字段列表
	 * @param dataSourceId
	 * @param schema
	 * @param tableName
	 * @return
	 * @throws Exception
	 * @create by peijd at 2017年2月8日 下午6:38:19
	 */
	@Override
	public List<Map<String, Object>> queryTableColumns(String dataSourceId, String schema, String tableName) throws Exception {
		Assert.hasText(tableName);
		StringBuilder metaSql = new StringBuilder(64);
		metaSql.append("select a.attname as COLNAME, ");//列名
		metaSql.append("   (case when col_description(a.attrelid,a.attnum) is null then a.attname else a.attname||'('||col_description(a.attrelid,a.attnum)||')' end) as COLCOMMECT, ");	//注释
		metaSql.append("   (case when atttypmod-4>0 then atttypmod-4 else 0 end) as COLLENG, ");	//长度
		metaSql.append("   format_type(a.atttypid,a.atttypmod) as COLTYPE, ");		//类型
		metaSql.append("   (case when (select count(*) from pg_constraint where conrelid = a.attrelid and conkey[1]=attnum and contype='p')>0 then 'Y' else 'N' end) as COLKEY,");			//是否主键
		metaSql.append("   (case when a.attnotnull=true then 'Y' else 'N' end) as COLISNULL ");		//是否为空
		metaSql.append(" from pg_attribute a where attstattarget=-1 and attrelid = (select oid from pg_class where relname ='").append(tableName).append("')");
		
		return queryMetaSql(dataSourceId, metaSql.toString(), true);
	}

	/**
	 * Override
	 * @方法名称: buildTableKeySql 
	 * @实现功能: TODO
	 * @param tableList
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年11月21日 下午10:41:10
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
	 * @create by peijd at 2016年11月21日 下午10:41:10
	 */
	@Override
	public String buildTableKeyField(List<String> tbNameList) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Override
	 * @方法名称: assembleQueryPageSql 
	 * @实现功能: 分页查询
	 * @param page
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年11月21日 下午10:41:10
	 */
	@Override
	protected String assembleQueryPageSql(DcQueryPage page) throws Exception {
		String tableName = page.getTableName();
		Assert.hasText(tableName);
		//分页查询Sql
		StringBuilder pageSql = new StringBuilder(64);
		pageSql.append("SELECT ").append(page.getFieldStr()).append(" FROM \"").append(tableName).append("\" ");
		//过滤条件
		if (StringUtils.isNotBlank(page.getFilter())) {
			pageSql.append(" WHERE ").append(page.getFilter());
		}
		//排序
		if (StringUtils.isNotBlank(page.getOrderBy())) {
			pageSql.append(" ORDER BY ").append(page.getOrderBy());
		}
		//分页记录
		if (page.getStart()>0) {
			pageSql.append(" LIMIT ").append(page.getLimit()).append(" OFFSET ").append(page.getFirstrownum());
		}
		return pageSql.toString();
	}

	/**
	 * Override
	 * @方法名称: querySchemaList 
	 * @实现功能: 获取schema 列表
	 * @param dataSourceId
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年11月22日 下午2:46:08
	 */
	@Override
	public List<Map<String, Object>> querySchemaList(String dataSourceId) throws Exception {
		Assert.hasText(dataSourceId);
		StringBuilder metaSql = new StringBuilder(64).append("select schema_name as SCHEMANAME from information_schema.schemata");
		return queryMetaSql(dataSourceId, metaSql.toString(), true);
	}

	/**
	 * Override
	 * @方法名称: queryLimitMetaSql 
	 * @实现功能: 查询指定记录数, postgresql表名加双引号("),否则大写的表名无法查询
	 * @param dbSrcId
	 * @param sql
	 * @param dataNum
	 * @return
	 * @throws Exception
	 * @create by peijd at 2017年2月8日 下午7:13:08
	 */
	@Override
	public List<Map<String, Object>> queryLimitMetaSql(String dbSrcId, String sql, int dataNum)  throws Exception {
		Assert.hasText(dbSrcId);
		Assert.hasText(sql);
		Assert.isTrue(dataNum>0);
		StringBuilder querySql = new StringBuilder(64);
		boolean quoteFlag = false;
	    for(String chr: sql.split(" ")){
	    	if(StringUtils.isBlank(chr)){
	    		continue;
	    	}
	    	if(quoteFlag){
	    		querySql.append(chr.replace(".","\".\"")).append("\"");
	    		quoteFlag = false;
	    	}else{
	    		querySql.append(chr);
	    	}
	    	if("from".equalsIgnoreCase(chr)){
	    		querySql.append(" \"");
	    		quoteFlag = true;
	    	}else{
	    		querySql.append(" ");
	    	}
	    }
//		System.out.println(querySql.toString());
		return queryMetaSql(dbSrcId, querySql.append(" limit ").append(dataNum).toString());
	}
}
