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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.hlframe.common.config.Global;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.utils.excel.ExportExcel;
import com.hlframe.common.utils.excel.ImportExcel;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.task.entity.DcTaskLogNext;
import com.hlframe.modules.dc.task.service.DcTaskLogNextService1;

/**
 * 调度任务下次执行时间Controller
 * @author hladmin
 * @version 2016-11-27
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/task/dcTaskLogNext")
public class DcTaskLogNextController extends BaseController {

	@Autowired
	private DcTaskLogNextService1 dcTaskLogNextService;
	
	@ModelAttribute
	public DcTaskLogNext get(@RequestParam(required=false) String id) {
		DcTaskLogNext entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcTaskLogNextService.get(id);
		}
		if (entity == null){
			entity = new DcTaskLogNext();
		}
		return entity;
	}
	
	/**
	 * 调度任务下次执行时间列表页面
	 */
	@RequiresPermissions("dc:task:dcTaskLogNext:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcTaskLogNext dcTaskLogNext, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcTaskLogNext> page = dcTaskLogNextService.findPage(new Page<DcTaskLogNext>(request, response), dcTaskLogNext); 
		model.addAttribute("page", page);
		return "modules/dc/task/dcTaskLogNextList";
	}

	/**
	 * 查看，增加，编辑调度任务下次执行时间表单页面
	 */
	@RequiresPermissions(value={"dc:task:dcTaskLogNext:view","dc:task:dcTaskLogNext:add","dc:task:dcTaskLogNext:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcTaskLogNext dcTaskLogNext, Model model) {
		model.addAttribute("dcTaskLogNext", dcTaskLogNext);
		return "modules/dc/task/dcTaskLogNextForm";
	}

	/**
	 * 保存调度任务下次执行时间
	 */
	@RequiresPermissions(value={"dc:task:dcTaskLogNext:add","dc:task:dcTaskLogNext:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcTaskLogNext dcTaskLogNext, Model model, RedirectAttributes redirectAttributes) throws Exception{
		if (!beanValidator(model, dcTaskLogNext)){
			return form(dcTaskLogNext, model);
		}
		if(!dcTaskLogNext.getIsNewRecord()){//编辑表单保存
			DcTaskLogNext t = dcTaskLogNextService.get(dcTaskLogNext.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcTaskLogNext, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			dcTaskLogNextService.save(t);//保存
		}else{//新增表单保存
			dcTaskLogNextService.save(dcTaskLogNext);//保存
		}
		addMessage(redirectAttributes, "保存调度任务下次执行时间成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogNext/?repage";
	}
	
	/**
	 * 删除调度任务下次执行时间
	 */
	@RequiresPermissions("dc:task:dcTaskLogNext:del")
	@RequestMapping(value = "delete")
	public String delete(DcTaskLogNext dcTaskLogNext, RedirectAttributes redirectAttributes) {
		dcTaskLogNextService.delete(dcTaskLogNext);
		addMessage(redirectAttributes, "删除调度任务下次执行时间成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogNext/?repage";
	}
	
	/**
	 * 批量删除调度任务下次执行时间
	 */
	@RequiresPermissions("dc:task:dcTaskLogNext:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			dcTaskLogNextService.delete(dcTaskLogNextService.get(id));
		}
		addMessage(redirectAttributes, "删除调度任务下次执行时间成功");
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogNext/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("dc:task:dcTaskLogNext:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(DcTaskLogNext dcTaskLogNext, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调度任务下次执行时间"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<DcTaskLogNext> page = dcTaskLogNextService.findPage(new Page<DcTaskLogNext>(request, response, -1), dcTaskLogNext);
    		new ExportExcel("调度任务下次执行时间", DcTaskLogNext.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出调度任务下次执行时间记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogNext/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("dc:task:dcTaskLogNext:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<DcTaskLogNext> list = ei.getDataList(DcTaskLogNext.class);
			for (DcTaskLogNext dcTaskLogNext : list){
				try{
					dcTaskLogNextService.save(dcTaskLogNext);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条调度任务下次执行时间记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条调度任务下次执行时间记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入调度任务下次执行时间失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogNext/?repage";
    }
	
	/**
	 * 下载导入调度任务下次执行时间数据模板
	 */
	@RequiresPermissions("dc:task:dcTaskLogNext:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调度任务下次执行时间数据导入模板.xlsx";
    		List<DcTaskLogNext> list = Lists.newArrayList(); 
    		new ExportExcel("调度任务下次执行时间数据", DcTaskLogNext.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dc/task/dcTaskLogNext/?repage";
    }
	

}