/********************** 版权声明 *************************
 * 文件名: DcJobExportDataController.java
 * 包名: com.hlframe.modules.dc.dataexport.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年2月23日 下午5:06:04
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataexport.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataexport.entity.DcJobExportData;
import com.hlframe.modules.dc.dataexport.service.DcJobExportDataService;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.metadata.entity.DcDataSource;
import com.hlframe.modules.dc.metadata.entity.DcSysObjm;
import com.hlframe.modules.dc.metadata.service.DcDataSourceService;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.sys.utils.UserUtils;


/** 
 * @类名: com.hlframe.modules.dc.dataexport.web.DcJobExportDataController.java 
 * @职责说明: hadoop集群数据导出 controller
 * @创建者: peijd
 * @创建时间: 2017年2月23日 下午5:06:04
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataExport/job")
public class DcJobExportDataController extends BaseController {

	@Autowired	//处理过程设计 Service
	private DcJobExportDataService exportDataService;
	@Autowired
	private DcDataSourceService dcDataSourceService;
	@Autowired
	private DcObjectAuService dcObjectAuService;
	
	/**
	 * @方法名称: list 
	 * @实现功能: 配置列表
	 * @param exportData
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月23日 下午5:13:33
	 */
	@RequestMapping(value = "list")
	public String list(DcJobExportData exportData , Model model) {
		model.addAttribute("exportDataJob", new DcJobExportData());
		return "modules/dc/dataexport/dcJobExportDataList";
	}
	
	/**
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax 翻页查询
	 * @param exportData
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月23日 下午5:14:46
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcJobExportData exportData, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcJobExportData> page = exportDataService.findPage(new Page<DcJobExportData>(request), exportData);
		List<DcJobExportData> list = page.getList();
		//设置权限
		String curUserId = UserUtils.getUser().getId();
		List<DcSysObjm> sysObjList = dcObjectAuService.getAccreList(curUserId, null);
		for(DcJobExportData data: list){
			//创建者拥有所有权限
			if(curUserId.equals(data.getCreateBy().getId())){
				data.setAccre(1);
				
			
			}
			
			else{	//申请过权限的
				for(DcSysObjm acc: sysObjList){
					if(data.getId().equals(acc.getObjMainId())){
						data.setAccre(1);
					}
				}
			}
		}
		DataTable a = new DataTable();
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		a.setRecordsTotal((int)page.getCount());
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(list));
		return a;
	}
	
	/**
	 * @方法名称: form 
	 * @实现功能: 编辑表单
	 * @param exportData
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月23日 下午5:15:55
	 */
	@RequestMapping(value = "form")
	public String form(DcJobExportData exportData, Model model) {
		if(StringUtils.isNotEmpty(exportData.getId())){
			exportData = exportDataService.get(exportData.getId());
		}else{
			exportData = new DcJobExportData();
		}
		model.addAttribute("exportDataJob", exportData);
		//数据源列表  下拉列表中显示数据源类别
		model.addAttribute("dataSourceList", dcDataSourceService.buildSelectList(new DcDataSource()));
		return "modules/dc/dataexport/dcJobExportDataForm";
	}
	
	/**
	 * @方法名称: ajaxSave 
	 * @实现功能: 保存保单数据
	 * @param exportData
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年2月23日 下午5:18:56
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcJobExportData exportData, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try{
			DcJobExportData tarObj = exportDataService.getObjByName(exportData.getJobName(), exportData.getId());
			if (null!=tarObj){
				ajaxJson.setMsg("保存'" + exportData.getJobName() + "'失败, 名称已存在!");
				ajaxJson.setSuccess(false);
				return ajaxJson;
			}
			exportDataService.save(exportData);
			ajaxJson.setMsg("保存'" + exportData.getJobName() + "'成功!");
			
		} catch (Exception e) {
			ajaxJson.setMsg("保存失败!");
			ajaxJson.setSuccess(false);
			logger.error("-->ajaxSave ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: view 
	 * @实现功能: 查看数据导出配置
	 * @param exportData
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月23日 下午5:19:40
	 */
	@RequestMapping(value = "view")
	public String view(DcJobExportData exportData, Model model) {
//		DcJobDb2Hdfs jobData = null;
//		jobData = exportDataService.buildJobData(obj.getId());
		model.addAttribute("exportData", exportDataService.get(exportData.getId()));	
//		model.addAttribute("jobInfo", jobData);
		return "modules/dc/dataexport/dcJobExportDataView";       //查看页面
	}
	
	/**
	 * @方法名称: ajaxDelete 
	 * @实现功能: 删除数据导出对象
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年2月23日 下午5:20:23
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDelete")
	public AjaxJson ajaxDelete(DcJobExportData obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			exportDataService.delete(obj);
			ajaxJson.setMsg("删除成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("删除失败!");
			ajaxJson.setSuccess(false);
			logger.error("-->ajaxDelete ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: checkJobName 
	 * @实现功能: 检查 任务名称是否重复
	 * @param oldJobName
	 * @param jobName
	 * @return
	 * @create by peijd at 2017年2月23日 下午5:25:45
	 */
	@ResponseBody
	@RequestMapping(value = "checkJobName")
	public String checkJobName(String oldJobName, String jobName) {
		if (jobName !=null && jobName.equals(oldJobName)) {
			return "true";
		} else if (jobName !=null && exportDataService.getObjByName(jobName, null) == null) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * @方法名称: runTask 
	 * @实现功能: 测试运行任务
	 * @param jobId
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年2月27日 上午10:13:24
	 */
	@ResponseBody
	@RequestMapping(value = "runTask")
	public AjaxJson runTask(String jobId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			DcDataResult taskResult =  exportDataService.runTask(jobId);
			if(taskResult.getRst_flag()){
				ajaxJson.setMsg(taskResult.getRst_std_msg());
			}else{
				ajaxJson.setMsg(taskResult.getRst_err_msg());
			}
		} catch (Exception e) {
			ajaxJson.setMsg(e.getMessage());
			logger.error("exportDataService.runTask", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: add2Schedule 
	 * @实现功能: 添加至调度任务
	 * @param jobId
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月27日 上午10:46:36
	 */
	@ResponseBody
	@RequestMapping(value = "add2Schedule")
	public AjaxJson add2Schedule(String jobId, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			String msg = exportDataService.add2Schedule(jobId);
			ajaxJson.setMsg(msg);
		} catch (Exception e) {
			ajaxJson.setMsg("调度任务创建失败!</br>"+e.getMessage());
			logger.error("-->add2Schedule", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: previewData 
	 * @实现功能: 预览导出结果数据
	 * @param obj
	 * @param model
	 * @param request
	 * @return
	 * @create by peijd at 2017年2月27日 上午10:46:20
	 */
	@RequestMapping(value = "previewData")
	public String previewData(DcJobExportData obj, Model model,HttpServletRequest request) {
		List<Map<String, Object>> jobList = exportDataService.previewDbData(obj.getId());
		//数据对象字段列表
		model.addAttribute("columnList",jobList);			
		return "modules/dc/dataProcess/dcJobTransData/dcJobPreviewData";       //数据预览页面
	}
	@ResponseBody
	@RequestMapping(value = "getAu")
	public AjaxJson getAu(DcJobTransData obj, RedirectAttributes redirectAttributes){
		exportDataService.getAu(obj);
		AjaxJson ajaxJson = new AjaxJson();
		ajaxJson.setMsg("已向管理员申请该任务操作权限，请等待管理员审核!");
		return ajaxJson;
	}
	
}
