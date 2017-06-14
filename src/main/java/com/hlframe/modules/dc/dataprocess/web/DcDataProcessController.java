/********************** 版权声明 *************************
 * 文件名: DcDataProcess.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月23日 下午1:15:19
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.web;

import java.util.List;

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
import com.hlframe.modules.dc.dataprocess.entity.DcDataProcessDesign;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.dataprocess.service.DcDataProcessDesignService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcDataProcessController.java 
 * @职责说明: 数据中心处理Controller
 * @创建者: peijd
 * @创建时间: 2016年11月23日 下午1:15:19
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/process")
public class DcDataProcessController extends BaseController {

	@Autowired	//处理过程设计 Service
	private DcDataProcessDesignService designService;
	
	/**
	 * @方法名称: openEtlTool 
	 * @实现功能: 打开Etl(taland)设计工具
	 * @param obj
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月23日 下午1:28:02
	 */
	@RequestMapping(value = "tool")
	public String openEtlTool(DcJobTransData obj, Model model) {
		//打开taland设计工具
		try {
			String tool = DcPropertyUtils.getProperty("tool.taland.location");
			logger.debug("--->"+tool);
			/*if(StringUtils.isNotEmpty(tool)){
				Runtime runtime = Runtime.getRuntime();
				runtime.exec(tool);
			}*/
		} catch (Exception e) {
			logger.error("openEtlTool error!", e);
			model.addAttribute("message", "请检查项目发布目录dc_config.properties中[tool.taland.location]配置信息!");
		}
		return "modules/dc/dataProcess/dcProcessDesign/dcProcessTool";
	}
	
	/**
	 * @方法名称: list 
	 * @实现功能: 首页列表
	 * @param design
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月21日 上午10:30:43
	 */
	@RequestMapping(value = "list")
	public String list(DcDataProcessDesign design, Model model) {
		model.addAttribute("design", new DcDataProcessDesign());
		return "modules/dc/dataProcess/dcProcessDesign/dcDataProcessDesignList";
	}
	
	/**
	 * @方法名称: ajaxlist 
	 * @实现功能: 分页查询
	 * @param design
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月21日 上午10:32:36
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcDataProcessDesign design, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcDataProcessDesign> page = designService.findPage(new Page<DcDataProcessDesign>(request), design);
		List<DcDataProcessDesign> list = page.getList();
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
	 * @param design
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月21日 上午10:33:51
	 */
	@RequestMapping(value = "form")
	public String form(DcDataProcessDesign design, Model model) {
		if(StringUtils.isNotEmpty(design.getId())){
			design = designService.get(design.getId());
		}else{
			design = new DcDataProcessDesign();
		}
		model.addAttribute("design", design);
		return "modules/dc/dataProcess/dcProcessDesign/dcDataProcessDesignForm";
	}
	
	/**
	 * @方法名称: ajaxSave 
	 * @实现功能: 保存数据转换设计图
	 * @param design
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年2月21日 上午10:40:40
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcDataProcessDesign design, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try{
			if (null!=designService.getDesignByName(design.getDesignName(), design.getId())){
				ajaxJson.setMsg("保存'" + design.getDesignName() + "'失败, 名称已存在!");
				ajaxJson.setSuccess(false);
				return ajaxJson;
			}
			designService.save(design);
			ajaxJson.setMsg("保存'" + design.getDesignName() + "'成功!");
			
		} catch (Exception e) {
			ajaxJson.setMsg("保存失败!");
			ajaxJson.setSuccess(false);
			logger.error("-->ajaxSave ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: view 
	 * @实现功能: 查看设计页面明细
	 * @param design
	 * @param model
	 * @return
	 * @create by peijd at 2017年2月21日 上午10:43:11
	 */
	@RequestMapping(value = "view")
	public String view(DcDataProcessDesign design , Model model) {
		model.addAttribute("design", designService.get(design.getId()));		
		return "modules/dc/dataProcess/dcProcessDesign/dcDataProcessDesignView";       //查看页面
	}
	
	/**
	 * @方法名称: ajaxDelete 
	 * @实现功能: ajax 删除数据
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年2月21日 上午10:49:17
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDelete")
	public AjaxJson ajaxDelete(DcDataProcessDesign obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			designService.delete(obj);
			ajaxJson.setMsg("删除成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("删除失败! "+e.getMessage());
			ajaxJson.setSuccess(false);
			logger.error("-->ajaxDelete: ", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: runTask 
	 * @实现功能: 运行任务
	 * @param jobId
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年3月7日 下午7:52:46
	 */
	@ResponseBody
	@RequestMapping(value = "runTask")
	public AjaxJson runTask(String jobId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			DcDataResult taskResult =  designService.runTask(jobId);
			if(taskResult.getRst_flag()){
				ajaxJson.setMsg(taskResult.getRst_std_msg());
			}else{
				ajaxJson.setMsg(taskResult.getRst_err_msg());
			}
		} catch (Exception e) {
			ajaxJson.setMsg("任务执行异常!</br>"+e.getMessage());
			ajaxJson.setSuccess(false);
			logger.error("dcDataProcessDesignService.runTask", e);
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
	 * @create by peijd at 2017年3月7日 下午7:54:42
	 */
	@ResponseBody
	@RequestMapping(value = "add2Schedule")
	public AjaxJson add2Schedule(String jobId, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			String msg = designService.add2Schedule(jobId);
			ajaxJson.setMsg(msg);
		} catch (Exception e) {
			ajaxJson.setMsg("调度任务创建失败!</br>"+e.getMessage());
			ajaxJson.setSuccess(false);
			logger.error("-->add2Schedule", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: checkDesignName 
	 * @实现功能: 检查 转换设计名称 是否重复
	 * @param oldDesignName
	 * @param designName
	 * @return
	 * @create by peijd at 2017年2月21日 下午1:41:41
	 */
	@ResponseBody
	@RequestMapping(value = "checkDesignName")
	public String checkDesignName(String oldDesignName, String designName) {
		if (designName !=null && designName.equals(oldDesignName)) {
			return "true";
		} else if (designName !=null && designService.getDesignByName(designName, null) == null) {
			return "true";
		}
		return "false";
	}
}
