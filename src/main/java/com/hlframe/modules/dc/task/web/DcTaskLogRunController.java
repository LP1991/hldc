/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.dc.task.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.hlframe.common.config.Global;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.utils.excel.ExportExcel;
import com.hlframe.common.utils.excel.ImportExcel;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.task.entity.DcTaskLogQquartz;
import com.hlframe.modules.dc.task.entity.DcTaskLogRun;
import com.hlframe.modules.dc.task.service.DcTaskLogRunService;

/**
 * 调度子任务执行情况Controller
 * @author hladmin
 * @version 2016-11-27
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/task/dcTaskLogRun")
public class DcTaskLogRunController extends BaseController {

	@Autowired
	private DcTaskLogRunService dcTaskLogRunService;
	
	@ModelAttribute
	public DcTaskLogRun get(@RequestParam(required=false) String id) {
		DcTaskLogRun entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcTaskLogRunService.get(id);
		}
		if (entity == null){
			entity = new DcTaskLogRun();
		}
		return entity;
	}
	
	/**
	 * 调度子任务执行情况列表页面
	 */
	@RequiresPermissions("dc:task:dcTaskLogRun:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcTaskLogRun dcTaskLogRun, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcTaskLogRun> page = dcTaskLogRunService.findPage(new Page<DcTaskLogRun>(request, response), dcTaskLogRun); 
		model.addAttribute("page", page);
		return "modules/dc/task/dcTaskLogRunList";
	}

	/**
	 * 查看，增加，编辑调度子任务执行情况表单页面
	 */
	@RequiresPermissions(value={"dc:task:dcTaskLogRun:view","dc:task:dcTaskLogRun:add","dc:task:dcTaskLogRun:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcTaskLogRun dcTaskLogRun, Model model) {
		model.addAttribute("dcTaskLogRun", dcTaskLogRun);
		return "modules/dc/task/dcTaskLogRunForm";
	}

	/**
	 * 保存调度子任务执行情况
	 */
	@RequiresPermissions(value={"dc:task:dcTaskLogRun:add","dc:task:dcTaskLogRun:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcTaskLogRun dcTaskLogRun, Model model, RedirectAttributes redirectAttributes) throws Exception{
		if (!beanValidator(model, dcTaskLogRun)){
			return form(dcTaskLogRun, model);
		}
		if(!dcTaskLogRun.getIsNewRecord()){//编辑表单保存
			DcTaskLogRun t = dcTaskLogRunService.get(dcTaskLogRun.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcTaskLogRun, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			dcTaskLogRunService.save(t);//保存
		}else{//新增表单保存
			dcTaskLogRunService.save(dcTaskLogRun);//保存
		}
		addMessage(redirectAttributes, "保存调度子任务执行情况成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogRun/?repage";
	}
	
	/**
	 * 删除调度子任务执行情况
	 */
	@RequiresPermissions("dc:task:dcTaskLogRun:del")
	@RequestMapping(value = "delete")
	public String delete(DcTaskLogRun dcTaskLogRun, RedirectAttributes redirectAttributes) {
		dcTaskLogRunService.delete(dcTaskLogRun);
		addMessage(redirectAttributes, "删除调度子任务执行情况成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogRun/?repage";
	}
	
	/**
	 * 批量删除调度子任务执行情况
	 */
	@RequiresPermissions("dc:task:dcTaskLogRun:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			dcTaskLogRunService.delete(dcTaskLogRunService.get(id));
		}
		addMessage(redirectAttributes, "删除调度子任务执行情况成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogRun/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("dc:task:dcTaskLogRun:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(DcTaskLogRun dcTaskLogRun, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调度子任务执行情况"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<DcTaskLogRun> page = dcTaskLogRunService.findPage(new Page<DcTaskLogRun>(request, response, -1), dcTaskLogRun);
    		new ExportExcel("调度子任务执行情况", DcTaskLogRun.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出调度子任务执行情况记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogRun/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("dc:task:dcTaskLogRun:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<DcTaskLogRun> list = ei.getDataList(DcTaskLogRun.class);
			for (DcTaskLogRun dcTaskLogRun : list){
				try{
					dcTaskLogRunService.save(dcTaskLogRun);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条调度子任务执行情况记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条调度子任务执行情况记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入调度子任务执行情况失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogRun/?repage";
    }
	
	/**
	 * 下载导入调度子任务执行情况数据模板
	 */
	@RequiresPermissions("dc:task:dcTaskLogRun:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调度子任务执行情况数据导入模板.xlsx";
    		List<DcTaskLogRun> list = Lists.newArrayList(); 
    		new ExportExcel("调度子任务执行情况数据", DcTaskLogRun.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogRun/?repage";
    }
	
	/**
	 * 异步加载数据
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxTasklist")
	public DataTable ajaxTasklist(String taskId, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		DcTaskLogRun dcTaskLogRun = new DcTaskLogRun();
		dcTaskLogRun.setTaskid(taskId);
		Page<DcTaskLogRun> page = dcTaskLogRunService.findPage(new Page<DcTaskLogRun>(request), dcTaskLogRun);
		List<DcTaskLogRun> list = page.getList();
		DataTable a = new DataTable();
		// 绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
		// 必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int) page.getCount());
		// 必要，过滤后的记录数 不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int) page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson", gson.toJson(list));
		return a;

	}
}