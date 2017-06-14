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
import com.hlframe.modules.dc.task.service.DcTaskLogQquartzService;

/**
 * 调度日志Controller
 * @author hladmin
 * @version 2016-11-27
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/task/dcTaskLogQquartz")
public class DcTaskLogQquartzController extends BaseController {

	@Autowired
	private DcTaskLogQquartzService dcTaskLogQquartzService;
	
	@ModelAttribute
	public DcTaskLogQquartz get(@RequestParam(required=false) String id) {
		DcTaskLogQquartz entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcTaskLogQquartzService.get(id);
		}
		if (entity == null){
			entity = new DcTaskLogQquartz();
		}
		return entity;
	}
	
	/**
	 * 调度日志列表页面
	 */
	@RequiresPermissions("dc:task:dcTaskLogQquartz:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcTaskLogQquartz dcTaskLogQquartz, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcTaskLogQquartz> page = dcTaskLogQquartzService.findPage(new Page<DcTaskLogQquartz>(request, response), dcTaskLogQquartz); 
		model.addAttribute("page", page);
		return "modules/dc/task/dcTaskLogQquartzList";
	}

	/**
	 * 查看，增加，编辑调度日志表单页面
	 */
	@RequiresPermissions(value={"dc:task:dcTaskLogQquartz:view","dc:task:dcTaskLogQquartz:add","dc:task:dcTaskLogQquartz:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcTaskLogQquartz dcTaskLogQquartz, Model model) {
		model.addAttribute("dcTaskLogQquartz", dcTaskLogQquartz);
		return "modules/dc/task/dcTaskLogQquartzForm";
	}

	/**
	 * 保存调度日志
	 */
	@RequiresPermissions(value={"dc:task:dcTaskLogQquartz:add","dc:task:dcTaskLogQquartz:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcTaskLogQquartz dcTaskLogQquartz, Model model, RedirectAttributes redirectAttributes) throws Exception{
		if (!beanValidator(model, dcTaskLogQquartz)){
			return form(dcTaskLogQquartz, model);
		}
		if(!dcTaskLogQquartz.getIsNewRecord()){//编辑表单保存
			DcTaskLogQquartz t = dcTaskLogQquartzService.get(dcTaskLogQquartz.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcTaskLogQquartz, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			dcTaskLogQquartzService.save(t);//保存
		}else{//新增表单保存
			dcTaskLogQquartzService.save(dcTaskLogQquartz);//保存
		}
		addMessage(redirectAttributes, "保存调度日志成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogQquartz/?repage";
	}
	
	/**
	 * 删除调度日志
	 */
	@RequiresPermissions("dc:task:dcTaskLogQquartz:del")
	@RequestMapping(value = "delete")
	public String delete(DcTaskLogQquartz dcTaskLogQquartz, RedirectAttributes redirectAttributes) {
		dcTaskLogQquartzService.delete(dcTaskLogQquartz);
		addMessage(redirectAttributes, "删除调度日志成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogQquartz/?repage";
	}
	
	/**
	 * 批量删除调度日志
	 */
	@RequiresPermissions("dc:task:dcTaskLogQquartz:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			dcTaskLogQquartzService.delete(dcTaskLogQquartzService.get(id));
		}
		addMessage(redirectAttributes, "删除调度日志成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogQquartz/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("dc:task:dcTaskLogQquartz:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(DcTaskLogQquartz dcTaskLogQquartz, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调度日志"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<DcTaskLogQquartz> page = dcTaskLogQquartzService.findPage(new Page<DcTaskLogQquartz>(request, response, -1), dcTaskLogQquartz);
    		new ExportExcel("调度日志", DcTaskLogQquartz.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出调度日志记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogQquartz/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("dc:task:dcTaskLogQquartz:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<DcTaskLogQquartz> list = ei.getDataList(DcTaskLogQquartz.class);
			for (DcTaskLogQquartz dcTaskLogQquartz : list){
				try{
					dcTaskLogQquartzService.save(dcTaskLogQquartz);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条调度日志记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条调度日志记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入调度日志失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogQquartz/?repage";
    }
	
	/**
	 * 下载导入调度日志数据模板
	 */
	@RequiresPermissions("dc:task:dcTaskLogQquartz:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调度日志数据导入模板.xlsx";
    		List<DcTaskLogQquartz> list = Lists.newArrayList(); 
    		new ExportExcel("调度日志数据", DcTaskLogQquartz.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogQquartz/?repage";
    }
	
	/**
	 * 异步加载数据
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxTasklist")
	public DataTable ajaxTasklist(String taskId, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		DcTaskLogQquartz dcTaskLogQquartz = new DcTaskLogQquartz();
		dcTaskLogQquartz.setTaskid(taskId);
		// dcTaskLogQquartzService.findList(dcTaskLogQquartz);
		Page<DcTaskLogQquartz> page = dcTaskLogQquartzService.findPage(new Page<DcTaskLogQquartz>(request),
				dcTaskLogQquartz);
		List<DcTaskLogQquartz> list = page.getList();
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