/********************** 版权声明 *************************
 * 文件名: DcTaskMainService.java
 * 包名: com.hlframe.modules.dc.schedule.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：cdd  创建时间：2016年11月14日 下午2:30:10
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.schedule.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.service.CrudService;
import com.hlframe.common.service.ServiceException;
import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.modules.dc.dataexport.entity.DcJobExportData;
import com.hlframe.modules.dc.dataexport.service.DcJobExportDataService;
import com.hlframe.modules.dc.dataprocess.entity.DcDataProcessDesign;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransFile;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransHdfs;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataMain;
import com.hlframe.modules.dc.dataprocess.service.DcDataProcessDesignService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransDataService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransFileService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransHdfsService;
import com.hlframe.modules.dc.dataprocess.service.DcTransDataMainService;
import com.hlframe.modules.dc.schedule.dao.DcTaskMainDao;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.utils.DcCommonUtils;
import com.hlframe.modules.dc.utils.DcStringUtils;

/** 
 * @类名: com.hlframe.modules.dc.schedule.service.DcTaskMainService.java 
 * @职责说明: 调度任务 Service
 * @创建者: cdd
 * @创建时间: 2016年11月14日 下午2:30:10
 */
@Service
@Transactional(readOnly = true)
public class DcTaskMainService extends CrudService<DcTaskMainDao, DcTaskMain> {
	
	/** 各来源任务Service peijd  **/
	private DcJobTransDataService extractDBService = null;
	private DcJobTransFileService extractFileService = null;
	private DcJobTransHdfsService extractHdfsService = null;
	private DcDataProcessDesignService processDesignService = null;
	private DcTransDataMainService processScriptService = null;
	private DcJobExportDataService exportDBService = null;

	/**
	 * @实现功能: 数据权限过滤
	 * @create by yuzh at 2016年12月15日 15:30:29
	 */
	public Page<DcTaskMain> findPage(Page<DcTaskMain> page, DcTaskMain dcTaskMain) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		dcTaskMain.getSqlMap().put("dsf", dataScopeFilter(dcTaskMain.getCurrentUser(),"o","u"));
		// 设置分页参数
		dcTaskMain.setPage(page);
		// 执行分页查询
		page.setList(dao.findList(dcTaskMain));
		return super.findPage(page, dcTaskMain);
	}

	/**
	 * @方法名称: getTaskName 
	 * @实现功能: TODO
	 * @param taskName
	 * @return
	 * @create by cdd at 2016年11月15日 下午4:56:27
	 */
	public DcTaskMain getTaskName(String taskName) {
		return dao.getTaskName(taskName);
	}


	/**
	 * @方法名称: insert 
	 * @实现功能: 新增调度任务   这里需要指定Id, 不能用平台默认的save方法
	 * @param taskMain
	 * @create by peijd at 2016年12月5日 下午3:19:43
	 */
	@Transactional(readOnly = true)
	public void insert(DcTaskMain taskMain) {
		Assert.notNull(taskMain);
		//设置为新纪录
		taskMain.setIsNewRecord(true);
		taskMain.preInsert();
		Assert.isTrue(dao.insert(taskMain)>0);
	}

	/**
	 * Override
	 * @方法名称: delete 
	 * @实现功能: 删除自定义任务 
	 * @param entity
	 * @create by peijd at 2017年3月9日 下午8:06:54
	 */
	@Override
	@Transactional(readOnly = false)
	public void delete(DcTaskMain task) {
		Assert.notNull(task);
		if(DcTaskMain.TASK_STATUS_QUEUE.equals(task.getStatus())){
			throw new ServiceException("该任务已添加至任务队列!");
		}
		if(DcTaskMain.TASK_STATUS_JOB.equals(task.getStatus())){
			throw new ServiceException("该任务已添加至调度任务!");
		}
		super.delete(task);
		
		//删除子任务时  需根据任务类型, 还原各来源任务的状态(编辑) 
		if(DcTaskMain.TASK_FROMTYPE_EXTRACT_RMDB.equals(task.getTaskPath())){			//DB采集任务
			getExtractDBService().updateStatus(task.getId(), DcJobTransData.TASK_STATUS_EDIT);
			
		}else if(DcTaskMain.TASK_FROMTYPE_EXTRACT_FILE.equals(task.getTaskPath())){	//文件采集任务
			getExtractFileService().updateStatus(task.getId(), DcJobTransFile.TASK_STATUS_EDIT);
			
		}else if(DcTaskMain.TASK_FROMTYPE_EXTRACT_INTF.equals(task.getTaskPath())){	//接口采集任务 TODO 待实现
			logger.error("TODO: 接口采集 Service! ");
//			getExtractHdfsService().updateStatus(task.getId(), DcJobTransHdfs.TASK_STATUS_EDIT);
			
		}else if(DcTaskMain.TASK_FROMTYPE_EXTRACT_HDFS.equals(task.getTaskPath())){	//HDFS采集任务
			getExtractHdfsService().updateStatus(task.getId(), DcJobTransHdfs.TASK_STATUS_EDIT);
			
		}else if(DcTaskMain.TASK_FROMTYPE_PROCESS_DESIGN.equals(task.getTaskPath())){	//转换设计任务
			getProcessDesignService().updateStatus(task.getId(), DcDataProcessDesign.JOB_STATUS_EDIT);
			
		}else if(DcTaskMain.TASK_FROMTYPE_PROCESS_SCRIPT.equals(task.getTaskPath())){	//转换脚本任务
			getProcessScriptService().updateStatus(task.getId(), DcTransDataMain.TASK_STATUS_EDIT);
			
		}else if(DcTaskMain.TASK_FROMTYPE_EXPORT_RMDB.equals(task.getTaskPath())){	//导出任务脚本
			getExportDBService().updateStatus(task.getId(), DcJobExportData.TASK_STATUS_EDIT);
		}
	}

	/**
	 * @方法名称: getExportDBService 
	 * @实现功能: 获取数据导出至RMDB任务 Service
	 * @return
	 * @create by peijd at 2017年3月10日 下午2:45:16
	 */
	private DcJobExportDataService getExportDBService() {
		if(null==exportDBService){
			synchronized (DcTaskMainService.class) {
				if(null==exportDBService){
					exportDBService = SpringContextHolder.getBean(DcJobExportDataService.class);
				}
			}
		}
		return exportDBService;
	}

	/**
	 * @方法名称: getProcessScriptService 
	 * @实现功能: 获取数据脚本转换任务 Service
	 * @return
	 * @create by peijd at 2017年3月10日 下午2:41:50
	 */
	private DcTransDataMainService getProcessScriptService() {
		if(null==processScriptService){
			synchronized (DcTaskMainService.class) {
				if(null==processScriptService){
					processScriptService = SpringContextHolder.getBean(DcTransDataMainService.class);
				}
			}
		}
		return processScriptService;
	}

	/**
	 * @方法名称: getExtractDBService 
	 * @实现功能: 获取DB数据采集Service
	 * @return
	 * @create by peijd at 2017年3月10日 下午2:21:44
	 */
	private DcJobTransDataService getExtractDBService() {
		if(null==extractDBService){
			synchronized (DcTaskMainService.class) {
				if(null==extractDBService){
					extractDBService = SpringContextHolder.getBean(DcJobTransDataService.class);
				}
			}
		}
		return extractDBService;
	}
	
	/**
	 * @方法名称: getExtractFileService 
	 * @实现功能: 获取文件采集Service
	 * @return
	 * @create by peijd at 2017年3月10日 下午2:30:16
	 */
	private DcJobTransFileService getExtractFileService() {
		if(null==extractFileService){
			synchronized (DcTaskMainService.class) {
				if(null==extractFileService){
					extractFileService = SpringContextHolder.getBean(DcJobTransFileService.class);
				}
			}
		}
		return extractFileService;
	}
	
	/**
	 * @方法名称: getExtractHdfsService 
	 * @实现功能: 获取Hdfs采集Service
	 * @return
	 * @create by peijd at 2017年3月10日 下午2:32:33
	 */
	private DcJobTransHdfsService getExtractHdfsService() {
		if(null==extractHdfsService){
			synchronized (DcTaskMainService.class) {
				if(null==extractHdfsService){
					extractHdfsService = SpringContextHolder.getBean(DcJobTransHdfsService.class);
				}
			}
		}
		return extractHdfsService;
	}
	
	/**
	 * @方法名称: getProcessDesignService 
	 * @实现功能: 获取转换任务设计 Service
	 * @return
	 * @create by peijd at 2017年3月10日 下午2:38:46
	 */
	private DcDataProcessDesignService getProcessDesignService() {
		if(null==processDesignService){
			synchronized (DcTaskMainService.class) {
				if(null==processDesignService){
					processDesignService = SpringContextHolder.getBean(DcDataProcessDesignService.class);
				}
			}
		}
		return processDesignService;
	}
	
	/**
	 * buildHomePageStatMap
	 * 方法说明: 构建首页任务信息 统计数据
	 * create by peijd at 2017年3月19日 下午5:09:14
	 * @return
	 */
	public Map<String, String> buildHomePageStatMap() {
		Map<String, String> statMap = new HashMap<String, String>();
		//统计查询查询sql
		List<Map<String, Object>> dataList = DcCommonUtils.queryDataBySql("select TASKPATH,count(1) as taskNum from dc_task_main where del_flag = '0' GROUP BY TASKPATH");
		int totleNum=0, collectNum=0, transNum=0, exportNum=0;	//任务数
		for(Map<String, Object> map: dataList){
			totleNum += Integer.parseInt(String.valueOf(map.get("taskNum")));	
			if(DcTaskMain.TASK_FROMTYPE_EXTRACT_RMDB.equals(String.valueOf(map.get("TASKPATH")))	//采集任务
				|| DcTaskMain.TASK_FROMTYPE_EXTRACT_FILE.equals(String.valueOf(map.get("TASKPATH")))
				|| DcTaskMain.TASK_FROMTYPE_EXTRACT_INTF.equals(String.valueOf(map.get("TASKPATH")))
				|| DcTaskMain.TASK_FROMTYPE_EXTRACT_HDFS.equals(String.valueOf(map.get("TASKPATH")))){	
				collectNum += Integer.parseInt(String.valueOf(map.get("taskNum")));
				
			}else if(DcTaskMain.TASK_FROMTYPE_PROCESS_DESIGN.equals(String.valueOf(map.get("TASKPATH"))) 	//转换任务
				|| DcTaskMain.TASK_FROMTYPE_PROCESS_SCRIPT.equals(String.valueOf(map.get("TASKPATH")))){
				transNum += Integer.parseInt(String.valueOf(map.get("taskNum")));
				
			}else if(DcTaskMain.TASK_FROMTYPE_EXPORT_RMDB.equals(String.valueOf(map.get("TASKPATH")))){	//导出任务
				exportNum += Integer.parseInt(String.valueOf(map.get("taskNum")));
			}
		}
		//加入总数
		statMap.put("task_totle", totleNum+"");
		statMap.put("task_extract", collectNum+"");
		statMap.put("task_translate", transNum+"");
		statMap.put("task_load", exportNum+"");
		
		StringBuilder dateArr = new StringBuilder(128), 
					  extractArr = new StringBuilder(128),
					  translatetArr = new StringBuilder(128),
					  loadArr = new StringBuilder(128);
		int curHour = Integer.parseInt(DateUtils.formatDate(new Date(), "HH"));	//当前小时
		for(int h=0; h<=curHour; h++){
			dateArr.append(h).append(",");
		}
		statMap.put("task_hour", dateArr.deleteCharAt(dateArr.length()-1).toString());
		//构建当日的统计数据 按小时统计 group by startdate
		dataList = DcCommonUtils.queryDataBySql(""
				+ "SELECT date_format(a.startdate,'%H') as tdate, b.taskfromtype as ttype, count(1) as taskNum"
				+ "  FROM dc_task_log_run a LEFT JOIN dc_task_time b on a.taskid=b.ID "
				+ " WHERE date_format(a.startdate,'%Y-%m-%d') = date_format(now(),'%Y-%m-%d') and date_format(a.startdate,'%H')<="+curHour+" and b.DEL_FLAG='0' "
				+ " GROUP BY tdate, ttype");
		if(CollectionUtils.isNotEmpty(dataList)){
			int hour = 0;
			Map<String, Integer> typeMap = null;
			//过程统计Map<hour, map<type, num>>
			Map<Integer, Map<String, Integer>> hourMap = new HashMap<Integer, Map<String, Integer>>();
			for(Map<String, Object> map: dataList){
				hour = Integer.parseInt(DcStringUtils.getObjValue(map.get("tdate")));
				if(hourMap.containsKey(hour)){
					hourMap.get(hour).put(DcStringUtils.getObjValue(map.get("ttype")), Integer.parseInt(String.valueOf(map.get("taskNum"))));
				}else{
					typeMap = new HashMap<String, Integer>();
					typeMap.put(DcStringUtils.getObjValue(map.get("ttype")), Integer.parseInt(String.valueOf(map.get("taskNum"))));
					hourMap.put(hour, typeMap);
				}
			}
			//解析过程统计Map 按分类统计任务
			for(int h=0; h<=curHour; h++){
				collectNum = 0; transNum=0; exportNum=0;
				if(hourMap.containsKey(h)){
					for(String type: hourMap.get(h).keySet()){
						//根据任务类型统计
						if(DcTaskMain.TASK_FROMTYPE_EXTRACT_RMDB.equals(type)	//采集任务
								|| DcTaskMain.TASK_FROMTYPE_EXTRACT_FILE.equals(type)
								|| DcTaskMain.TASK_FROMTYPE_EXTRACT_INTF.equals(type)
								|| DcTaskMain.TASK_FROMTYPE_EXTRACT_HDFS.equals(type)){	
							collectNum += hourMap.get(h).get(type);
							
						}else if(DcTaskMain.TASK_FROMTYPE_PROCESS_DESIGN.equals(type) 	//转换任务
								|| DcTaskMain.TASK_FROMTYPE_PROCESS_SCRIPT.equals(type)){
							transNum += hourMap.get(h).get(type);
							
						}else if(DcTaskMain.TASK_FROMTYPE_EXPORT_RMDB.equals(type)){	//导出任务
							exportNum += hourMap.get(h).get(type);
						}
					}
				}
				extractArr.append(collectNum).append(",");
				translatetArr.append(transNum).append(",");
				loadArr.append(exportNum).append(",");
			}
		}else{
			for(int h=0; h<=curHour; h++){
				extractArr.append("0,");
				translatetArr.append("0,");
				loadArr.append("0,");
			}
		}
		statMap.put("task_hour_extract", extractArr.deleteCharAt(extractArr.length()-1).toString());
		statMap.put("task_hour_translate", translatetArr.deleteCharAt(translatetArr.length()-1).toString());
		statMap.put("task_hour_load", loadArr.deleteCharAt(loadArr.length()-1).toString());
		return statMap;
	}

}
