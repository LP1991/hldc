/********************** 版权声明 *************************
 * 文件名: CatalogService.java
 * 包名: com.hlframe.modules.dc.datasearch.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月3日 下午8:11:06
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.service;

import java.util.List;

import org.elasticsearch.action.admin.indices.mapping.put.PutMappingRequest;
import org.elasticsearch.action.bulk.BulkRequestBuilder;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.Requests;
import org.elasticsearch.common.xcontent.XContentBuilder;
import org.elasticsearch.common.xcontent.XContentFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hlframe.common.service.CrudService;
import com.hlframe.modules.dc.datasearch.dao.DcCatalogDao;
import com.hlframe.modules.dc.datasearch.entity.DcCatalog;
import com.hlframe.modules.dc.utils.DcEsUtil;
import com.hlframe.modules.dc.utils.DcPropertyUtils;


/** 
 * @类名: com.hlframe.modules.dc.datasearch.service.CatalogService.java 
 * @职责说明: 系统配置Service
 * @创建者: yuzh
 * @创建时间: 2016年11月3日 下午8:11:06
 */
@Service
@Transactional(readOnly = true)
public class DcCatalogService extends CrudService<DcCatalogDao, DcCatalog>{
	
	protected Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * @方法名称: putDataToEs 
	 * @实现功能: 提交数据
	 * @param dcCatalog
	 * @create by yzh at 2016年11月4日 下午4:17:49
	 * 	modeify by peijd at 2016-11-4 配置文件获取es的index/type, 提交之前先删除数据
	 */
	public void putDataToEs(DcCatalog dcCatalog) {
		//es元数据索引
		String es_index = DcPropertyUtils.getProperty("elasticSearch.dataObj.index", "dc_metadata");
		//es元数据类型
		String es_type = DcPropertyUtils.getProperty("elasticSearch.dataObj.type", "dc_datainfo");
		//es批量提交数
		Integer es_batchNum = Integer.parseInt(DcPropertyUtils.getProperty("elasticSearch.bat.num", "1000"));
		
		Client client = null;
		try {
			// 获取ES client连接
			client = DcEsUtil.getClient();
			//首先清除ES上索引
			cleanESData(client, es_index, es_type);
			
			// 从数据库获取数据
			List<DcCatalog> tmpDataList = dao.findList(dcCatalog);// dcCatalogDao.get(dcCatalog);
			// 包装成bulk所需形式
			int count = 0;
			if (tmpDataList.size() == 0) {
				logger.info("没有待缓存的元数据!");
				return;
			} else {
				BulkRequestBuilder bulkRequest = client.prepareBulk();
				for (DcCatalog wk : tmpDataList) {
					count++;
					// 构建数据对象
					XContentBuilder xContentBuilder = XContentFactory.jsonBuilder().startObject()
							.field("id", wk.getId()).field("objCode", wk.getObjCode()).field("objName", wk.getObjName())
							.field("objType", wk.getObjType()).field("systemId", wk.getSystemId())
							.field("objDesc", wk.getObjDesc()).field("managerPer", wk.getManagerPer())
							.field("managerOrg", wk.getManagerOrg()).field("fieldName", wk.getFieldName())
							.field("fieldDesc", wk.getFieldDesc()).field("fieldType", wk.getFieldType())
							.field("fieldLeng", wk.getFieldLeng()).field("decimalNum", wk.getDecimalNum())
							.field("validateRule", wk.getValidateRule()).field("tableName", wk.getTableName())
							.field("tableLink", wk.getTableLink()).field("dataNum", wk.getDataNum())
							.field("storeType", wk.getStoreType()).field("fileName", wk.getFileName())
							.field("fileUrl", wk.getFileUrl()).field("splitter", wk.getSplitter())
							.field("intfcType", wk.getIntfcType()).field("intfcProtocal", wk.getIntfcProtocal())
							.field("intfcUrl", wk.getIntfcUrl()).field("intfcNamespace", wk.getIntfcNamespace())
							.field("intfcUser", wk.getIntfcUser());
					bulkRequest.add(client.prepareIndex(es_index, es_type).setSource(xContentBuilder));
					// bulk批量提交
					if (count % es_batchNum == 0) {
						if (logger.isDebugEnabled()) {
							logger.debug("elasticSearch index["+es_index + "], type[" + es_type + "] batch commit " + es_batchNum + " files! ");
						}
						// api上传
						bulkRequest.execute().actionGet();
					}

				}
				bulkRequest.execute().actionGet();
				logger.info("elasticSearch update finish, index["+es_index + "], type[" + es_type + "] batch commit " + count + " files! ");
			}
		} catch (Exception e) {
			logger.error("putDataToEs error", e);
		}finally{
			//关闭连接
			if(null!=client){
				client.close();
			}
		}
	}

	/**
	 * @方法名称: cleanESData 
	 * @实现功能: 删除索引 并重建
	 * @param client
	 * @param es_type 
	 * @param es_index 
	 * @throws Exception 
	 * @create by peijd at 2016年11月4日 下午5:12:32
	 */
	private void cleanESData(Client client, String es_index, String es_type) throws Exception {
		try{
			//删除索引
			DcEsUtil.deleteIndex(client, es_index);
			//重建索引
			DcEsUtil.creataIndex(client, es_index);
			//重建类型数据
			XContentBuilder mapping = XContentFactory.jsonBuilder()  
					.startObject()  
						.startObject(es_type)  
							.startObject("properties")  // 字段名/类型(string/Numeric[integer,float]/date/IP/boolean)/检索方式(analyzed/not_analyzed/no)  ik中文分词
								.startObject("id").field("type","string").field("index", "no").endObject()  
								.startObject("objCode").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("objName").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("objType").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("systemId").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("objDesc").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("managerPer").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("managerOrg").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("fieldName").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("fieldDesc").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("fieldType").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("fieldLeng").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("validateRule").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("tableName").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("tableLink").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("dataNum").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("storeType").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("fileName").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("fileUrl").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("splitter").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("intfcType").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("intfcProtocal").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("intfcUrl").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("intfcNamespace").field("type","string").field("index", "not_analyzed").endObject()  
								.startObject("intfcUser").field("type","string").field("index", "not_analyzed").endObject()
							.endObject()  
						.endObject()  
					.endObject();
			
			PutMappingRequest mappingRequest = Requests.putMappingRequest(es_index).type(es_type).source(mapping);  
			client.admin().indices().putMapping(mappingRequest).actionGet();
			
		}catch(Exception e){
			logger.error("rebuilt ES type["+es_type+"] error!",e);
			throw e;
		}
	}
	
}