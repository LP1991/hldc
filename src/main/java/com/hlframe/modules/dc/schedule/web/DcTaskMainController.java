/********************** 版权声明 *************************
 * 文件名: DcTaskMainController.java
 * 包名: com.hlframe.modules.dc.schedule.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：cdd  创建时间：2016年11月14日 下午2:31:46
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.schedule.web;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.FileUtils;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.metadata.entity.DcObjectAu;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.schedule.entity.DcTaskLog;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskMainService;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;
import com.hlframe.modules.dc.utils.QuartzUtil;
import com.hlframe.modules.sys.entity.User;
import com.hlframe.modules.sys.utils.UserUtils;

/**
 * @类名: com.hlframe.modules.dc.schedule.web.DcTaskMainController.java
 * @职责说明: TODO
 * @创建者: cdd
 * @创建时间: 2016年11月14日 下午2:31:46
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/schedule/dcTaskMain")
public class DcTaskMainController extends BaseController {
	@Autowired
	private DcTaskMainService dcTaskMainService;
	@Autowired
	private DcTaskTimeService dcTaskTimeService;

	@ModelAttribute("dcTaskMain")
	public DcTaskMain get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return dcTaskMainService.get(id);
		} else {
			return new DcTaskMain();
		}
	}

	// @RequiresPermissions("dc:dcTaskMain:index")
	@RequestMapping(value = { "index" })
	public String index(DcTaskMain dcTaskMain, HttpServletRequest request, HttpServletResponse response, Model model) {
//		List<DcTaskMain> list = dcTaskMainService.findList(dcTaskMain);
//		model.addAttribute("list", list);//列表
		if(null!=dcTaskMain && StringUtils.isNotEmpty(dcTaskMain.getId())){
			dcTaskMain =  dcTaskMainService.get(dcTaskMain.getId());
		}else{
			dcTaskMain = new DcTaskMain();
		}
		model.addAttribute("dcTaskMain", dcTaskMain);//查询
		return "modules/dc/schedule/dcTaskMainList";
	}

	
	/**
	 * 
	 * @方法名称: ajaxlist 
	 * @实现功能: ajax分页列表
	 * @param obj
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月19日 下午3:19:04
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcTaskMain dcTaskMain, HttpServletRequest request, HttpServletResponse response, Model model) {
 		Page<DcTaskMain> page = dcTaskMainService.findPage(new Page<DcTaskMain>(request), dcTaskMain);
		List<DcTaskMain> list = page.getList();
		//转换类型
//		for (DcObjectAu item : list) {
//			item.setDataScope(DictUtils.getDictLabel(role2.getDataScope(), "sys_data_scope", ""));
//		}
		DataTable a = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(list));
		return a;
	}
	
	@RequiresPermissions(value = { "dc:dcTaskMain:add", "dc:dcTaskMain:edit" }, logical = Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcTaskMain dcTaskMain, Model model) {
		if(dcTaskMain!=null&&StringUtils.isNotEmpty(dcTaskMain.getId())){
			model.addAttribute("dcTaskMain", dcTaskMain);
		}else{
			dcTaskMain.setMethodName("runTask");
			model.addAttribute("dcTaskMain", dcTaskMain);
		}
		return "modules/dc/schedule/dcTaskMainForm";
	}

	/**
	 * 
	 * @方法名称: save
	 * @实现功能: TODO
	 * @param dcTaskMain
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * @create by cdd at 2016年11月15日 下午4:53:18
	 */
	@RequiresPermissions(value = { "dc:dcTaskMain:add", "dc:dcTaskMain:edit" }, logical = Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcTaskMain dcTaskMain, Model model, RedirectAttributes redirectAttributes) throws Exception {
		if (!beanValidator(model, dcTaskMain)) {
			return form(dcTaskMain, model);
		}
		if (!dcTaskMain.getIsNewRecord()) {// 编辑表单保存
			DcTaskMain t = dcTaskMainService.get(dcTaskMain.getId());// 从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcTaskMain, t);// 将编辑表单中的非NULL值覆盖数据库记录中的值
			dcTaskMainService.save(t);// 保存
			
		} else {// 新增表单保存
			//Class.forName(dcTaskMain.getTaskName()).getClass();//获取类所在的包名
			dcTaskMain.setStatus(DcTaskMain.TASK_STATUS_EDIT);	//默认设置编辑状态
			dcTaskMain.setTaskPath(DcTaskMain.TASK_FROMTYPE_TASK_CUSTOM);	//任务类型-peijd
			dcTaskMainService.save(dcTaskMain);// 保存	
		}

		addMessage(redirectAttributes, "任务保存成功");
		return "redirect:" + adminPath + "/dc/schedule/dcTaskMain/index";
	}
	/**
	 * 
	 * @方法名称: saveA 
	 * @实现功能: ajax保存
	 * @param dcTaskMain
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:01:08
	 */
	@ResponseBody
	@RequestMapping(value = "saveA")
	public AjaxJson saveA(DcTaskMain dcTaskMain, HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			if(dcTaskMain.getIsNewRecord()){
				dcTaskMain.setStatus(DcTaskMain.TASK_STATUS_EDIT);	//默认设置编辑状态
			}
			dcTaskMain.setTaskPath(DcTaskMain.TASK_FROMTYPE_TASK_CUSTOM);	//任务类型-peijd
			dcTaskMainService.save(dcTaskMain);// 保存
			ajaxJson.setMsg("保存" + dcTaskMain.getTaskName()+ "成功");

		} catch (Exception e) {
			ajaxJson.setMsg("保存失败");
			logger.error("DctaskMain.saveA()", e);
		}
		return ajaxJson;
	}

	@ResponseBody
	@RequestMapping(value = "checkTaskName")
	public String checkTaskName(String oldTaskName, String taskName) {
		if (taskName != null && taskName.equals(oldTaskName)) {
			return "true";
		} else if (taskName != null && dcTaskMainService.getTaskName(taskName) == null) {
			return "true";
		}

		return "false";
	}


	/**
	 * 
	 * @方法名称: view
	 * @实现功能: 查看表单页面
	 * @param dcTaskMain
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:51:00
	 */
	@RequiresPermissions(value = { "dc:dcTaskMain:view" })
	@RequestMapping(value = "view")
	public String view(DcTaskMain dcTaskMain, Model model) {
		model.addAttribute("dcTaskMain",  dcTaskMainService.get(dcTaskMain.getId()));
		return "modules/dc/schedule/dcTaskMainView";
	}
	/**
	 * 
	 * @方法名称: deleteA 
	 * @实现功能: ajax删除
	 * @param dcTaskMain
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月12日 下午12:00:57
	 */
	/**
	 * @方法名称: deleteA 
	 * @实现功能: TODO
	 * @param dcTaskMain
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2017年3月11日 下午4:23:09
	 */
	@ResponseBody
	@RequestMapping(value = "deleteA")
	public AjaxJson deleteA(DcTaskMain dcTaskMain, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcTaskMainService.delete(dcTaskMain);
			ajaxJson.setMsg("删除任务成功!");
			
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("删除任务失败! "+e.getMessage());
			logger.error("-->deleteA: ", e);
		}
		return ajaxJson;
	}

	/**
	 * @方法名称: delete
	 * @实现功能: 删除
	 * @param dcTaskMain
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月11日 下午4:20:20
	 */
	@RequiresPermissions("dc:dcTaskMain:del")
	@RequestMapping(value = "delete")
	public String delete(DcTaskMain dcTaskMain, RedirectAttributes redirectAttributes) {
		dcTaskMainService.delete(dcTaskMain);
		DcTaskTime dcTaskTime = new DcTaskTime();
		dcTaskTime.setScheduleName(dcTaskMain.getTaskName());
		dcTaskTimeService.delete(dcTaskTime);
		
		addMessage(redirectAttributes, "任务删除成功");
		return "redirect:" + adminPath + "/dc/dataSearch/dcTaskMain/?repage";
	}

	
	/**
	 * 
	 * @方法名称: addJob
	 * @实现功能: ajax删除
	 * @param dcTaskMain
	 * @param redirectAttributes
	 * @return
	 * @throws ParseException 
	 * @create by yuzh at 2016年11月12日 下午12:00:57
	 */
	@ResponseBody
	@RequestMapping(value = "addJobA")
	public AjaxJson addJobA(DcTaskMain dcTaskMain, RedirectAttributes redirectAttributes) throws ParseException {
		AjaxJson ajaxJson = new AjaxJson();
		String result = "任务添加成功";
		try {
			// TODO 需要验证是否已经添加过，并且已经添加过的在页面中按钮不出现
			// TODO 未来允许多次添加，未来参数会移植到调度的子任务中
			// TODO 这种重复性验证需要加到DcTaskTime中，添加例如addTaskTime方法中，而不是每个业务中自己判断
			//      暂不修改这种做法，因为未来这种添加方式需要重构
			if (dcTaskTimeService.getByTaskfromid(dcTaskMain.getId()) == null) {
				DcTaskTime dcTaskTime = new DcTaskTime();
				dcTaskTime.setScheduleName(dcTaskMain.getTaskName());
				dcTaskTime.setScheduleDesc(dcTaskMain.getTaskDesc());
				dcTaskTime.setTriggerType(DcTaskTime.TASK_TRIGGERTYPE_HAND);
				dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_INIT);
				dcTaskTime.setTaskfromid(dcTaskMain.getId());
				dcTaskTime.setTaskfromtype(dcTaskMain.getTaskPath());	//任务来源
				dcTaskTime.setTaskfromname(dcTaskMain.getTaskName());
				dcTaskTimeService.save(dcTaskTime);
				
				//添加调度 更新任务状态-添加调度
				dcTaskMain.setStatus(DcTaskMain.TASK_STATUS_JOB);
				dcTaskMainService.save(dcTaskMain);
				
			} else {
				result = "任务已经存在，不能重复添加！";
			}
		} catch (Exception e) {
			result = "任务添加失败";
			ajaxJson.setSuccess(false);
			logger.error("任务添加失败 : " + e.getMessage());
		}//类名。方法名，时间表达式

		addMessage(redirectAttributes, result);
		ajaxJson.setMsg(result);
		return ajaxJson;
	}
	
	/**
	 * 上传jars
	 * @param model
	 * @return
	 * @throws IOException 
	 * @throws IllegalStateException 
	 */
	@ResponseBody
	@RequestMapping(value = "uploadJars")
	public AjaxJson uploadJars( HttpServletRequest request, HttpServletResponse response,MultipartFile file) throws IllegalStateException, IOException {
		AjaxJson ajaxJson = new AjaxJson();
		ajaxJson.put("message", "success");
		// 判断文件是否为空
		if (!file.isEmpty()) {
			// 文件保存路径
			String directory = String.valueOf(System.currentTimeMillis());
			String realPath = "/uploadFiles/jars/";
			// 转存文件
			FileUtils.createDirectory(Global.getUserfilesBaseDir() + realPath + directory);
			String fileName = file.getOriginalFilename();
			String prefix = fileName.substring(fileName.lastIndexOf(".")+1);
			fileName = directory + "." + prefix;
			String filepath = Global.getUserfilesBaseDir() + realPath + directory + "/" + fileName; // 压缩文件路径
			String directoryPath = Global.getUserfilesBaseDir() + realPath + directory + "/un"; // 解压路径
			file.transferTo(new File(filepath));
			if ("rar".equalsIgnoreCase(prefix)) {
				com.hlframe.modules.dc.utils.FileUtils.unRarFile(filepath, directoryPath);
				// 为了适应window和linux环境，需要转义文件地址为左斜杠
				directoryPath = StringUtils.replace(directoryPath, "\\", "/");
			} else if("zip".equalsIgnoreCase(prefix))
			{
				FileUtils.unZipFiles(filepath, directoryPath);
				// 为了适应window和linux环境，需要转义文件地址为左斜杠
				directoryPath = StringUtils.replace(directoryPath, "\\", "/");
			}else if("jar".equalsIgnoreCase(prefix)||"sh".equalsIgnoreCase(prefix)||"bat".equalsIgnoreCase(prefix)){
				// 为了适应window和linux环境，需要转义文件地址为左斜杠
				directoryPath = StringUtils.replace(Global.getUserfilesBaseDir() + realPath + directory, "\\", "/");
			}
			
			ajaxJson.put("directoryPath", directoryPath);
		}

		return ajaxJson;
	}
	
	/*
	@RequiresPermissions("dc:dcTaskMain:addJob")
	@RequestMapping(value = "addJob")
	public String addJob(String ids, RedirectAttributes redirectAttributes,Model model) throws Exception { 	
		DcTaskMain dcTaskMain = dcTaskMainService.get(ids);
		try {
			QuartzUtil.addJob(Class.forName(dcTaskMain.getTaskName()),"2 * * * * ?",dcTaskMain.getTaskName(),dcTaskMain.getTaskName(),dcTaskMain.getTaskName(),dcTaskMain.getTaskName());
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}//类名。方法名，时间表达式
		addMessage(redirectAttributes, "任务执行成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcTaskMain/index";
	}*/
}
