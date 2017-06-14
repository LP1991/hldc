/********************** 版权声明 *************************
 * 文件名: DcTaskLogController.java
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.schedule.entity.DcTaskLog;
import com.hlframe.modules.dc.schedule.service.DcTaskLogService;

/**
 * @类名: com.hlframe.modules.dc.schedule.web.DcTaskLogController.java
 * @职责说明: TODO
 * @创建者: cdd
 * @创建时间: 2016年11月14日 下午2:31:46
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/schedule/dcTaskLog")
public class DcTaskLogController extends BaseController {
	@Autowired
	private DcTaskLogService dcTaskLogService;

	@ModelAttribute("dcTaskLog")
	public DcTaskLog get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return dcTaskLogService.get(id);
		} else {
			return new DcTaskLog();
		}
	}

	// @RequiresPermissions("dc:dcTaskLog:index")
	@RequestMapping(value = { "index" })
	public String index(DcTaskLog dcTaskLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcTaskLog> page = dcTaskLogService.findPage(new Page<DcTaskLog>(request, response), dcTaskLog);
		model.addAttribute("page", page);
		return "modules/dc/schedule/dcTaskLogList";
	}

	@RequiresPermissions(value = { "dc:dcTaskLog:add", "dc:dcTaskLog:edit" }, logical = Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcTaskLog dcTaskLog, Model model) {
		model.addAttribute("dcTaskLog", dcTaskLog);
		return "modules/dc/schedule/dcTaskLogForm";
	}

	/**
	 * 
	 * @方法名称: save
	 * @实现功能: TODO
	 * @param dcTaskLog
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * @create by cdd at 2016年11月15日 下午4:53:18
	 */
	@RequiresPermissions(value = { "dc:dcTaskLog:add", "dc:dcTaskLog:edit" }, logical = Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcTaskLog dcTaskLog, Model model, RedirectAttributes redirectAttributes) throws Exception {
		if (!beanValidator(model, dcTaskLog)) {
			return form(dcTaskLog, model);
		}
		if (!dcTaskLog.getIsNewRecord()) {// 编辑表单保存
			DcTaskLog t = dcTaskLogService.get(dcTaskLog.getId());// 从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcTaskLog, t);// 将编辑表单中的非NULL值覆盖数据库记录中的值
			dcTaskLogService.save(t);// 保存
		} else {// 新增表单保存
			//Class.forName(dcTaskLog.getTaskName()).getClass();//获取类所在的包名
			dcTaskLogService.save(dcTaskLog);// 保存
		}
		
		addMessage(redirectAttributes, "调度任务保存成功");
		return "redirect:" + adminPath + "/dc/schedule/dcTaskLog/index";
	}


	
	
}
