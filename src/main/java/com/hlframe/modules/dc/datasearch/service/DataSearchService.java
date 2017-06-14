package com.hlframe.modules.dc.datasearch.service;


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.metadata.service.DcObjectTableService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.elasticsearch.client.Client;
import org.elasticsearch.index.query.*;
import org.elasticsearch.search.aggregations.AggregationBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.service.CrudService;
import com.hlframe.common.utils.DateUtils;
import com.hlframe.modules.dc.dataprocess.entity.DcHdfsFile;
import com.hlframe.modules.dc.dataprocess.entity.DcJobDb2Hdfs;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransFile;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransHdfs;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataMain;
import com.hlframe.modules.dc.dataprocess.service.DcHdfsFileLookService;
import com.hlframe.modules.dc.dataprocess.service.DcHdfsFileService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransDataService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransFileService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransHdfsService;
import com.hlframe.modules.dc.dataprocess.service.DcTransDataMainService;
import com.hlframe.modules.dc.datasearch.dao.DataSearchDao;
import com.hlframe.modules.dc.datasearch.entity.DataSearch;
import com.hlframe.modules.dc.datasearch.entity.DcSearchParam;
import com.hlframe.modules.dc.metadata.entity.DcObjectAu;
import com.hlframe.modules.dc.metadata.entity.DcObjectFile;
import com.hlframe.modules.dc.metadata.entity.DcObjectFolder;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.entity.DcObjectTable;

import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.dc.metadata.service.linkdb.DbHandleService;
import com.hlframe.modules.dc.utils.DcCommonUtils;
import com.hlframe.modules.dc.utils.DcEsUtil;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.dc.utils.DcStringUtils;
import com.hlframe.modules.sys.utils.UserUtils;


/**
 * @类名: DataSearchService
 * @职责说明: 数据搜索
 * @创建者: cdd
 * @创建时间: 2016年11月5日 下午3:08:43
 */
@Service
@Transactional(readOnly = true)
public class DataSearchService extends CrudService<DataSearchDao, DataSearch> {

	@Autowired
	private DcObjectMainService objMainService;	//数据对象Service
	@Autowired
	private DcObjectTableService objTableService;	//数据对象Service
	@Autowired
	private DcJobTransDataService dcJobTransDataService;
	@Autowired	//数据源引擎 Service 用于执行异构数据库的脚本
	private DbHandleService dbHandleService;
	@Autowired
	private DcJobTransDataService extractDBJobService;	//DB采集Service
	
	@Autowired
	private DcJobTransFileService extractFileJobService;//文件采集Service
	
	@Autowired
	private DcJobTransHdfsService extractHdfsJobService;//HDFS采集Service
	
	@Autowired
	private DcTransDataMainService translateJobService;	//数据转换Service
	
	@Autowired
	private DcSearchLabelService labelService;	//数据标签关系Service
	
	@Autowired
	private DcHdfsFileLookService dcHdfsFileLookService;  //hdfs文件处理
	
	@Autowired
	private DcHdfsFileService dcHdfsFileService;
	@Autowired	//权限表service
	private DcObjectAuService dcObjectAuService;

	/**
	 * @方法名称: findDataByName
	 * @实现功能: 根据名称 模糊检索数据对象
	 * @param param
	 * @return
	 * @throws Exception
	 * @create by cdd at 2016年11月6日 下午1:35:25
	 */
	public Map<String, Object> findDataByName(DcSearchParam param) {
		Date date = new Date();
	

				
		/*if(param.getSearchName().equals(param.getSearchName())){
			param.setSearchName("*"+param.getSearchName()+"*");
		}else{

//	        param.setSearchName("*"+getSearchName()+"*");
		}*/
		if(StringUtils.isBlank(param.getSearchName())){
			param.setSearchName("*");
		}else{
			param.setSearchName("*"+param.getSearchName()+"*");
		}
	
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

		String oneYearBefore = df.format(DateUtils.addYears(date, -1));
		String sixMonthsBefore = df.format(DateUtils.addMonths(date, -6));
		String threeMonthsBefore = df.format(DateUtils.addMonths(date, -3));
		String oneMonthsBefore = df.format(DateUtils.addMonths(date, -1));
		String oneWeekBefore = df.format(DateUtils.addWeeks(date, -1));
		String now = df.format(date);
		String tomorrow = df.format(DateUtils.addDays(date, 1));
		try {
			Client client = DcEsUtil.getClient();//连接es
			QueryBuilder qb;
			if ("*".equals(param.getSearchName())){
				qb = QueryBuilders.queryStringQuery(param.getSearchName());// 全文检索0
			}else {
				// a wildcard term should not start with one of the wildcards * or ?
				qb = QueryBuilders.boolQuery().should(QueryBuilders.wildcardQuery("objName",  param.getSearchName())).should(
						QueryBuilders.wildcardQuery("objDesc",  param.getSearchName())
				);
//				qb = QueryBuilders.wildcardQuery("objName",  param.getSearchName());
			}
			Map<String, Object> searchMap = new LinkedHashMap<String, Object>();
			//1. search the data by params //TODO 大类区分table file interface等 查询添加大类
			//根据用户页面的选择构建过滤器
			BoolQueryBuilder builder = QueryBuilders.boolQuery();
			if (StringUtils.isNotEmpty(param.getSearchTime())) {//判断是否选择了时间周期里的时间
				//按照时间过滤
				builder.must(QueryBuilders.rangeQuery("createDate").gte(convertToDate(param.getSearchTime())).lte(tomorrow));
			}
			if (StringUtils.isNotEmpty(param.getSearchType())) {//判断是否选择了业务分类中的分类
				//按照类型过滤
				String[] types = param.getSearchType().split(",");
				for (String type : types){
					if (StringUtils.isNoneEmpty(type) && StringUtils.isNotBlank(type)){
						builder.must(QueryBuilders.nestedQuery(param.getSearchCat(),QueryBuilders.matchQuery(param.getSearchCat()+".cata_id", type)));
					}
				}
			}

//2. aggregate the data //TODO
// 关于时间范围聚合部分初始化
				AggregationBuilder dateAndCategory = AggregationBuilders.dateRange("dateAgg")
						.field("createDate").format("YYYY-MM-dd")
						.addRange(oneYearBefore,tomorrow)
						.addRange(sixMonthsBefore,tomorrow)
						.addRange(threeMonthsBefore, tomorrow)
						.addRange(oneMonthsBefore, tomorrow)
						.addRange(oneWeekBefore, tomorrow)
						.addRange(now,tomorrow);

// 关于类型聚合部分初始化,按照二级类型聚合
				AggregationBuilder aggregation =
						AggregationBuilders
								.nested("cataAgg").path("s_cata")
								.subAggregation(
										AggregationBuilders
												.terms("name").field("s_cata.cata_id").size(100)
								);

				searchMap = DcEsUtil.queryPageFromSize(client,
						DcPropertyUtils.getProperty("elasticSearch.dataObj.index", "dc_metadata"), param.getObjType(),
						param.getPageSize(), param.getPageNo(),qb, builder, dateAndCategory, aggregation);


			return searchMap;
			// client.close();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("数据检索异常!", e);
		}
		return null;
	}
	/**
	 * @return
	 */
	private String getSearchName() {
		// TODO Auto-generated method stub
		return null;
	}
	/**
	 * @方法名称: convertToDate 
	 * @实现功能: 根据周期时间上所选择的时间进行转换
	 * @param searchTime
	 * @return
	 * @create by cdd at 2016年12月19日 下午6:20:37
	 */
	public String convertToDate(String searchTime){
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String fromDate = "";
		if (searchTime.equals("oneYear")) {//时间周期选择为最近一年
			fromDate=df.format(DateUtils.addMonths(date, -12));
		} else if (searchTime.equals("halfYear")) {//时间周期选择为最近半年
			fromDate=df.format(DateUtils.addMonths(date, -6));
		} else if (searchTime.equals("threeMonths")) {//时间周期选择为最近三个月
			fromDate=df.format(DateUtils.addMonths(date, -3));
		} else if (searchTime.equals("oneMonth")) {//时间周期选择为最近一个月
			fromDate=df.format(DateUtils.addMonths(date, -1));
		} else if (searchTime.equals("oneWeek")) {//时间周期选择为最近一周
			fromDate = df.format(DateUtils.addDays(date, -7));
		} else if (searchTime.equals("today")) {//时间周期选择为今天
			fromDate = df.format(date);
		}
		return fromDate;
	}

	/**
	 * @方法名称: findDataByObjName
	 * @实现功能: 通过objName获取DcObjectMain对象信息
	 * @param objName(对象名称)
	 * @return
	 * @create by cdd at 2016年11月7日 上午11:12:45
	 */
	public DcObjectMain findDataByObjName(String objName) {
		DcObjectMain obj = new DcObjectMain();// 新建一个DcObjectMain对象obj
		obj.setObjName(objName);// 将objName给obj

		// 调用findListByCata(){此方法返回的是List<Map<String,Object>>类型}方法，获取dcObjectMain
		DcObjectMain objList = objMainService.findUniqueByProperty("OBJ_NAME",objName);
		if(objList!=null){
			return objList;
		}
		return null;// 返回此对象
	}

	/**
	 * @方法名称: getFieldDataById 
	 * @实现功能:在通过表id获取到字段信息
	 * @param id(对象ID)
	 * @return
	 * @create by cdd at 2016年12月16日 下午4:21:44
	 */
	public List<Map<String, Object>> getFieldDataById(String id) {
		List<Map<String,Object>> dataList  =  new ArrayList<Map<String,Object>>();
//		DcObjectMain dcObjectMain = findDataByObjName(objName);// 通过objName获取DcObjectMain对象信息
		//Assert.notNull(dcObjectMain, "原数据对象无效或已删除!");
		 List<Map<String,Object>> dcObjectFieldList = objTableService.getFieldsListByBelong2Id(id);//关于表的相关字段信息

		if (CollectionUtils.isEmpty(dcObjectFieldList)) {// 判断dcObjectFieldList是否为空
			logger.error("DataSearchService.getFieldDataById() 里面没有数据");// 若是数据为空，在系统日志里写上日志
			dataList = null;
		}else{
				for(int i=0;i<dcObjectFieldList.size();i++){
					Map<String,Object> dataMap  =  new LinkedHashMap<String,Object>();
					Map<String,Object> dcObjectFieldMap = dcObjectFieldList.get(i);
				
				if(StringUtils.isNotEmpty(dcObjectFieldMap.get("fieldName").toString())){	//判断fieldName是否为空
					dataMap.put("字段名称", dcObjectFieldMap.get("fieldName").toString());
				}else{
					dataMap.put("字段名称", "");
				}
				
//				if(StringUtils.isBlank(dcObjectFieldMap.get("fieldDesc").toString())){	
//					dataMap.put("字段描述", "");
//				}else{
//					dataMap.put("字段描述", dcObjectFieldMap.get("fieldDesc").toString());
//				}
				
				if(StringUtils.isNotEmpty(dcObjectFieldMap.get("fieldType").toString())){//判断fieldType是否为空
					dataMap.put("字段类型", dcObjectFieldMap.get("fieldType").toString());
				}else{
					dataMap.put("字段类型", "");
				}
				
				if(StringUtils.isNotEmpty(dcObjectFieldMap.get("fieldLeng").toString())){//判断fieldLeng是否为空	
					dataMap.put("字段长度", dcObjectFieldMap.get("fieldLeng").toString());
				}else{
					dataMap.put("字段长度", "");
				}
				
				if(StringUtils.isNotEmpty(dcObjectFieldMap.get("decimalNum").toString())){//判断decimalNum是否为空	
					dataMap.put("小数位数", dcObjectFieldMap.get("decimalNum").toString());
				}else{
					dataMap.put("小数位数", "");
				}
				
				if(StringUtils.isNotEmpty(dcObjectFieldMap.get("isKey").toString())){//判断isKey是否为空		
					dataMap.put("是否主键", dcObjectFieldMap.get("isKey").toString());
				}else{
					dataMap.put("是否主键", "");
				}
				
//				if(StringUtils.isNotEmpty(dcObjectFieldMap.get("validateRule").toString())){	
//					dataMap.put("字段验证规则", dcObjectFieldMap.get("validateRule").toString());
//				}else{
//					dataMap.put("字段验证规则", "");
//				}
			
//				if(StringUtils.isNotEmpty(dcObjectFieldMap.get("remarks").toString())){	
//					dataMap.put("备注", dcObjectFieldMap.get("remarks").toString());
//				}else{
//					dataMap.put("备注", "");
//				}
				
				dataList.add(dataMap);
			}
		}
//		System.out.println(dataList);
		return dataList;
	}

	/**
	 * @方法名称: getCataList 
	 * @实现功能: 获取业务分类的第二三层数据
	 * @param id
	 * @return
	 * @create by cdd at 2016年12月16日 下午4:31:12
	 */
	public List<Map<String, Object>> getCataList(String id) {
		String sql = "SELECT id,cata_name" + " FROM  dc_cata_detail " + " where PARENT_ID='" + id + "'";// 构建sql语句
		List<Map<String, Object>> contentTableList = DcCommonUtils.queryDataBySql(sql);// 查询业务分类的信息

		if (CollectionUtils.isEmpty(contentTableList)) {// 判断contentTableList是否为空
			logger.error(" dcContentTableService.getCataList()里面没有数据");// 若是为空，在系统日志里写日志
			contentTableList = null;// 赋空值
		}
		return contentTableList;
	}

	/**
	 * @方法名称: getCategoryTree 
	 * @实现功能: 获得分类树
	 * @return
	 * @create by cdd at 2016年12月16日 下午4:09:56
	 */
	public List<Map<String, Object>> getCategoryTree() {
		String sql = "select id, item_name from dc_cata_item where status = '1'";//构建sql语句，获取dc_cata_item里面的item_name以及id
		List<Map<String, Object>> categoryList = DcCommonUtils.queryDataBySql(sql);//获取dc_cata_item里面的item_name以及id，作为分类树的第一层
		if (CollectionUtils.isEmpty(categoryList)) {//判断categoryList是否为空
			logger.error(" dcContentTableService.getCategoryTree()里面没有数据");//若是categoryList为空，则在系统日志上添加这个日志
			categoryList = null;//若为空，则赋值为空
		} else {
			for (int i = 0; i < categoryList.size(); i++) {//若是categoryList不为空，则循环categoryList
				Map<String, Object> dataMap = categoryList.get(i);

				if (StringUtils.isNotEmpty(dataMap.get("id").toString())) {//判断id是否为空
					List<Map<String, Object>> subDataList = getCataList(dataMap.get("id").toString());//此getDataList（）方法可获得第二层业务数据信息

					for (int j = 0; j < subDataList.size(); j++) {
						Map<String, Object> subdataMap = subDataList.get(j);
						if (StringUtils.isNotEmpty(subdataMap.get("id").toString())) {//构建第三层业务分类
							subdataMap.put("children", getCataList(subdataMap.get("id").toString()));
						}
					}
					dataMap.put("children", subDataList);//构建第二层业务分类
				}

			}
		}
		return categoryList;//返回数据
	}
	
	/**
	 * @方法名称: buildObjViewData 
	 * @实现功能: 构建数据对象查看明细
	 * @param name
	 * @return
	 * @create by peijd at 2017年1月17日 下午3:18:17
	 */
	public Map<String, Object> buildObjViewData(String name) {
		Assert.hasText(name);
		DcObjectMain dataObj  = findDataByObjName(name);//通过objName获取DcObjectMain对象信息
		Assert.notNull(dataObj, "该对象无效或已删除!");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//数据对象
		Map<String, String> dataMap = new HashMap<String, String>();
		dataMap.put("createDate", DateUtils.formatDateTime(dataObj.getCreateDate()));	//创建时间
		dataMap.put("updateDate", DateUtils.formatDateTime(dataObj.getUpdateDate()));	//更新时间
		dataMap.put("objName",name);					//对象名称
		dataMap.put("objectId", dataObj.getId());		//对象Id	
		dataMap.put("jobType", dataObj.getJobType());	//产出job类别
		dataMap.put("jobId", dataObj.getJobId());		//产出jobId
		dataMap.put("managerPer", dataObj.getManagerPer());	//负责人
		dataMap.put("managerOrg", dataObj.getManagerOrg());	//责任部门
		dataMap.put("objDesc",dataObj.getObjDesc());	//描述
		dataMap.put("remarks",dataObj.getRemarks());	//备注		
		
		//设置job名称
		if(StringUtils.isNotBlank(dataObj.getJobId())){
			if(DcObjectMain.JOB_TYPE_EXTRACT_DB.equals(dataObj.getJobType())){			//DB采集Job
				DcJobTransData dbJob = extractDBJobService.get(dataObj.getJobId());
				Assert.notNull(dbJob);
				dataMap.put("jobName", dbJob.getJobName());
				
			}else if(DcObjectMain.JOB_TYPE_EXTRACT_FILE.equals(dataObj.getJobType())){	//文件采集Job
				DcJobTransFile fileJob = extractFileJobService.get(dataObj.getJobId());
				Assert.notNull(fileJob);
				dataMap.put("jobName", fileJob.getJobname());
				
			}else if(DcObjectMain.JOB_TYPE_EXTRACT_HDFS.equals(dataObj.getJobType())){	//hdfs采集Job
				DcJobTransHdfs hdfsJob = extractHdfsJobService.get(dataObj.getJobId());
				Assert.notNull(hdfsJob);
				dataMap.put("jobName", hdfsJob.getJobName());
				
			}else if(DcObjectMain.JOB_TYPE_TRANSLATE.equals(dataObj.getJobType())){		//数据转换Job
				DcTransDataMain transJob = translateJobService.get(dataObj.getJobId());
				Assert.notNull(transJob);
				dataMap.put("jobName", transJob.getJobName());
			}
		}
		
		dataMap.put("systemId",dataObj.getSystemId());	//所属应用 TODO: 应用系统名称
		//设置应用系统
//		if(StringUtils.isNotBlank(dataObj.getSystemId())){}
		
		//数据表 对象
		if(DcObjectMain.OBJ_TYPE_TABLE.equals(DcStringUtils.getObjValue(dataObj.getObjType()))){
			DcObjectTable table = objTableService.getTableByObjId(dataObj.getId());
			Assert.notNull(table);
			dataMap.put("dbType", table.getDbType());	//数据库类别
			dataMap.put("database", table.getDbDataBase());	//表空间
			dataMap.put("dataNum", DcStringUtils.getObjValue(table.getDataNum()));	//数据量
			
			//数据表字段列表
			List<Map<String,Object>> feildList = getFieldDataById(dataObj.getId());
			resultMap.put("fieldList", feildList);
			
		//文件对象	
		}else if(DcObjectMain.OBJ_TYPE_FILE.equals(dataObj.getObjType())){
//			DcObjectFile file = objMainService.getFileByObjId(dataObj.getId());
//			Assert.notNull(file);
		}
		
		//对象标签列表
		resultMap.put("labelList", labelService.findLabelListByObjId(dataObj.getId()));
		
		resultMap.put("dataInfo", dataMap);
		return resultMap;
	}

	/**
	 * @方法名称: buildObjViewData 
	 * @实现功能: 文件下载和压缩
	 * @param response
	 * @return
	 * @create by hgw
	 */
	public boolean exportFile(String id,String line,HttpServletResponse response) throws Exception{
		DcObjectFile dcObjectFile = dcHdfsFileLookService.getFile(id);
		String address = DcPropertyUtils.getProperty("hadoop.main.address");
		String filePath = dcObjectFile.getFileUrl().replace("hdfs://"+address, "");
		DcHdfsFile file = new DcHdfsFile();
		file.setFilePath(filePath);
		dcHdfsFileService.loadFileContent(file , line);
		byte[] data = file.getContent().getBytes("UTF-8");
		//创建hdfs连接
		FileSystem fs = null;
		//初始化
		fs = FileSystem.get(new URI("hdfs://"+address),new Configuration(), "hdfs");//hdfs配置信息在dc_config中配置
		FileStatus f = fs.getFileStatus(new Path(filePath));
		if(f.getLen()>1024*1024*50){
			return false;
		}
		response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(dcObjectFile.getFileName().getBytes("utf-8"),"ISO-8859-1") + "\"");
		response.addHeader("Content-Length", "" + data.length);
		dcHdfsFileLookService.downloadT(filePath,response);
		response.flushBuffer();
		return true;
	}
	
	/**
	 * @方法名称: exportZiP
	 * @实现功能: 文件夹压缩下载
	 * @return
	 * @create by hgw
	 */
/*	public void exportZip(String id,HttpServletResponse response) throws Exception{
		try {
			DcObjectFolder  dcObjectFolder  = dcHdfsFileLookService.getFolder(id);
			String filePath =dcObjectFolder.getFolderUrl();///tempp
			String folderName =dcObjectFolder.getFolderName();//tempp
			//创建hdfs连接
			FileSystem fs = null;
			//初始化
			String address = DcPropertyUtils.getProperty("hadoop.main.address");//10.1.20.137
			fs = FileSystem.get(new URI("hdfs://"+address),new Configuration(), "hdfs");//hdfs配置信息在dc_config中配置
			Class<?> codeClass;
			codeClass = Class.forName("org.apache.hadoop.io.compress.DefaultCodec");
			CompressionCodec codec = (CompressionCodec)ReflectionUtils.newInstance(codeClass, fs.getConf());
			指定压缩文件路径
			//压缩文件路径
			String gzName = filePath+"/"+folderName+".zip";
			FileStatus[] filelist = fs.listStatus(new Path(filePath));
			FSDataOutputStream outputStream = fs.create(new Path(gzName));
			FSDataInputStream in = null;
			CompressionOutputStream out = null;
			for(int i=0;i<filelist.length;i++){
				FileStatus fileStatus = filelist[i];
				//得到完整路径
				String pa = fileStatus.getPath().toString();
				String pathName = pa.replaceFirst("hdfs://"+DcPropertyUtils.getProperty("hdfs.datanode.address"), "");
				//指定要被压缩的文件路径
				in = fs.open(new Path(pathName));
				//创建压缩输出流
				out = codec.createOutputStream(outputStream);
				IOUtils.copyBytes(in, out, fs.getConf(),false);
			}
			IOUtils.closeStream(in);
	        IOUtils.closeStream(out);
			
			//压缩完成后
			DcHdfsFile file = new DcHdfsFile();
			file.setFilePath(gzName);
			dcHdfsFileService.loadFileContent(file , null);
			byte[] data = file.getContent().getBytes("UTF-8");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + new String((folderName+".gz").getBytes("utf-8"),"ISO-8859-1") + "\"");
			response.addHeader("Content-Length", "" + data.length);
			dcHdfsFileLookService.downloadT(gzName,response);
			response.flushBuffer();
			fs.delete(new Path(gzName),true);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}*/
	public boolean exportZip(String id,HttpServletResponse response) {
        FSDataInputStream fis = null;  
        BufferedInputStream bis = null;  
        FileOutputStream fos = null;  
        ZipOutputStream zos = null; 
        
		try {
			DcObjectFolder dcObjectFolder = dcHdfsFileLookService.getFolder(id);
			String filePath =dcObjectFolder.getFolderUrl();///tempp
			String folderName =dcObjectFolder.getFolderName();//tempp
			//创建hdfs连接
			FileSystem fs = null;
			//初始化
			String address = DcPropertyUtils.getProperty("hadoop.main.address");//10.1.20.137
			fs = FileSystem.get(new URI("hdfs://"+address),new Configuration(), "hdfs");//hdfs配置信息在dc_config中配置
			FileStatus[] filelist = fs.listStatus(new Path(filePath));
			int size=0;
			for(int i = 0;i<filelist.length;i++){
				FileStatus fileStatus= filelist[i];
				if(fileStatus.isDirectory()){
					String pa = fileStatus.getPath().toString();
					String pathName = pa.replaceFirst("hdfs://"+DcPropertyUtils.getProperty("hdfs.datanode.address"), "");
					size+=size(fs,pathName);
				}else{
					size+=fileStatus.getLen();
				}
			}
			if(size>1024*1024*50){
				return false;
			}
			response.setHeader("Content-disposition", "attachment; filename=\"" + new String((folderName+".zip").getBytes("utf-8"),"ISO-8859-1") + "\"");
//			response.addHeader("Content-Length", "" + 1024*10);
			response.setContentType("application/x-msdownload");
			
			zos = new ZipOutputStream(new BufferedOutputStream(response.getOutputStream())); 
			for(int i=0;i<filelist.length;i++){
				FileStatus fileStatus= filelist[i];
				//得到完整路径
				String pa = fileStatus.getPath().toString();
				String pathName = pa.replaceFirst("hdfs://"+DcPropertyUtils.getProperty("hdfs.datanode.address"), "");
				if(fileStatus.isDirectory()){
					try {
						ZipEntry zipEntry = new ZipEntry(fileStatus.getPath().getName()+"/");  
		                zos.putNextEntry(zipEntry);
						doZip(fs,pa,zos,fileStatus.getPath().getName()+"/");
					} catch (Exception e) {
						// TODO Auto-generated catch block
						logger.error("-->exportZip: ", e);
					}
				}else{
					ZipEntry zipEntry = new ZipEntry(fileStatus.getPath().getName());  
	                zos.putNextEntry(zipEntry);
					fis = fs.open(new Path(pathName));
					 bis = new BufferedInputStream(fis, 1024*10);
					int read = 0 ;
					byte[] bufs = new byte[1024*10];  
					while((read=bis.read(bufs, 0, 1024*10))!=-1){
						zos.write(bufs,0,read); 
					}
					bis.close();
					zos.flush();				
					fis.close();
				}
			}
//			IOUtils.copyBytes(zos, out, 4096, true); 
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			logger.error("-->exportZip: ", e);
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			logger.error("-->exportZip: ", e);
		} catch (UnsupportedEncodingException e) {
			logger.error("-->exportZip: ", e);
		} catch (IOException e) {
			logger.error("-->exportZip: ", e);
		} catch (InterruptedException e) {
			logger.error("-->exportZip: ", e);
		} catch (URISyntaxException e) {
			logger.error("-->exportZip: ", e);
		}finally{  
            //关闭流  
            try {  
                if(null != zos) zos.close();  
            } catch (IOException e) {  
    			logger.error("-->exportZip: ", e);
                throw new RuntimeException(e);  
            }  
        }  
		return true;
	}
	
	public void doZip(FileSystem fs,String pathName,ZipOutputStream zos,String mlm) throws Exception{//"" 666/
		//得到完整路径
		pathName = pathName.replaceFirst("hdfs://"+DcPropertyUtils.getProperty("hdfs.datanode.address"), "");
		FileStatus[] filelist = fs.listStatus(new Path(pathName));
		for(int i=0;i<filelist.length;i++){
			FileStatus fileStatus= filelist[i];
			//得到完整路径
			String pa = fileStatus.getPath().toString();
			String f = pa.replaceFirst("hdfs://"+DcPropertyUtils.getProperty("hdfs.datanode.address"), "");
			if(fileStatus.isDirectory()){
				String name = mlm +fileStatus.getPath().getName()+"/";
				ZipEntry zipEntry = new ZipEntry(name);  
                zos.putNextEntry(zipEntry);
				doZip(fs,fileStatus.getPath().toString(),zos,name);
			}else{
				ZipEntry zipEntry = new ZipEntry(mlm+fileStatus.getPath().getName());  
	            zos.putNextEntry(zipEntry);
	            FSDataInputStream fis = fs.open(new Path(f));
	            BufferedInputStream bis = new BufferedInputStream(fis, 1024*10);
				int read = 0 ;
				byte[] bufs = new byte[1024*10];  
				while((read=bis.read(bufs, 0, 1024*10))!=-1){
					zos.write(bufs,0,read); 
				}
				bis.close();
				zos.flush();				
				fis.close();
			}
		}
	}
	
	public int size(FileSystem fs,String filePath){
		try {
			int dx = 0;
			FileStatus[] filelist = fs.listStatus(new Path(filePath));
			for(int i=0;i<filelist.length;i++){
				FileStatus fileStatus= filelist[i];
				if(fileStatus.isDirectory()){
					String pa = fileStatus.getPath().toString();
					String pathName = pa.replaceFirst("hdfs://"+DcPropertyUtils.getProperty("hdfs.datanode.address"), "");
					dx+=size(fs,pathName);
				}else{
					dx +=fileStatus.getLen();
				}
			}
			return dx;
		} catch (Exception e) {
			logger.error("-->exportZip: ", e);
		} 
		return 0;
	}

	/**
	 * @方法名称: getAu 
	 * @实现功能: 发起权限申请请求
	 * @param obj
	 * @create by yuzh at 2016年11月19日 下午2:28:49
	 */
	@Transactional(readOnly = false)
	public void getAu(DcJobTransData obj) {
		DcObjectAu dcObjectAu = new DcObjectAu();
		dcObjectAu.setUserId(UserUtils.getUser().getId());
		dcObjectAu.setFileId(obj.getId());
		dcObjectAu.setStatus("未处理");
		dcObjectAu.setFrom("1");
 		if(DcStringUtils.isNotNull(dcObjectAuService.get(dcObjectAu))){
		dcObjectAuService.save(dcObjectAu);
		}
	}
	 /**
	  * @方法名称: findListByUserId 
	  * @实现功能: 根据用户Id 查询权限对象列表
	  * @param userId 默认为当前用户
	  * @return
	  */
	 public List< DcObjectAu> findListByUserId(String userId){
		 DcObjectAu dcObjectAu  = new DcObjectAu();
		 dcObjectAu.setUserId(userId);
		 return dcObjectAuService.findList(dcObjectAu);
	 }
	 /**
	  * @方法名称: isFavorite 
	  * @实现功能: 查询数据对象已经被申请
	  * @param userId
	  * @param fileId
	  * @return
	  */
	 public boolean isFavorite(String userId, String fileId){
		
		 List<DcObjectAu> lists = findListByUserId(fileId);
		 if (lists.size() == 0){
		 	return false;
		 }
		 for(DcObjectAu dcObjectAu  : lists){
		 	if(fileId.equals(dcObjectAu.getFileId())){
				return true;
			}
		 }
		 return false;
	 }
	 /**
		 * @方法名称: buildJobData 
		 * @实现功能: 根据jobId  构建job对象
		 * @param jobid
		 * @return
		 * @create by peijd at 2016年11月17日 下午2:18:00
		 */
		public DcJobDb2Hdfs buildJobData(String jobid) {
			Assert.hasText(jobid);
			return dcJobTransDataService.buildJobData(jobid);
		}
		/*
		 * 表字段数据预览
		 */
		
	 public List<Map<String, Object>> previewDbData(String jobId) {
		
			//Assert.hasText(jobId);
			//构建数据对象
			DcJobDb2Hdfs jobData = buildJobData(jobId);
			//Assert.notNull(jobData);
			if(jobData!=null){
			//构建查询SQL
			StringBuilder tableSql = new StringBuilder(128);
			if(StringUtils.isNotEmpty(jobData.getTableColumn())){
				tableSql.append("select ").append(jobData.getTableColumn());
			
			}
			if(StringUtils.isNotEmpty(jobData.getTableName())){
				tableSql.append(" from ");
		
				tableSql.append(dbHandleService.buildTableName(jobData.getFromLink(), jobData.getSchemaName(), jobData.getTableName())).append(" ");
			}	
			//获取返回结果 默认显示
			return dbHandleService.queryLimitMetaSql(jobData.getFromLink(),tableSql.toString(), Integer.parseInt(DcPropertyUtils.getProperty("extractdb.preview.datanum", "50")));
			}
			return null;
		}

}

