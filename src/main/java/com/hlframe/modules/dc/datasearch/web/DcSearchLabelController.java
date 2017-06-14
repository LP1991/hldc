/********************** 版权声明 *************************
 * 文件名: DcSearchLabelController.java
 * 包名: com.hlframe.modules.dc.datasearch.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：yuzh   创建时间：2016年11月11日 上午9:46:41
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.datasearch.web;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.service.DcSearchLabelService;

/** 
 * @类名: com.hlframe.modules.dc.datasearch.web.DcSearchLabelController.java 
 * @职责说明: 标签管理controller
 * @创建者: yuzh
 * @创建时间: 2016年11月11日 上午9:46:41
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataSearch/dcSearchLabel")
public class DcSearchLabelController extends BaseController{
	@Autowired
	private DcSearchLabelService dcSearchLabelService;
	
	@ModelAttribute
	public DcSearchLabel get(@RequestParam(required=false) String id) {
		DcSearchLabel entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcSearchLabelService.get(id);
		}
		if (entity == null){
			entity = new DcSearchLabel();
		}
		return entity;
	}
	
	/**
	 * 
	 * @方法名称: list 
	 * @实现功能: 列表页面
	 * @param dcSearchLabel
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:50:37
	 */
	@RequiresPermissions("dc:searchLabel:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcSearchLabel dcSearchLabel, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcSearchLabel> page = dcSearchLabelService.findPage(new Page<DcSearchLabel>(request, response), dcSearchLabel); 
		model.addAttribute("page", page);
		
		return "modules/dc/dataSearch/dcSearchLabelList";
		
	}

	/**
	 * 
	 * @方法名称: form 
	 * @实现功能: 增加，编辑表单页面
	 * @param dcSearchLabel
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:50:46
	 */
	@RequiresPermissions(value={"dc:searchLabel:add","dc:searchLabel:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcSearchLabel dcSearchLabel, Model model) {
		model.addAttribute("dcSearchLabel", dcSearchLabel);
		
		return "modules/dc/dataSearch/dcSearchLabelForm";
	}

	/**
	 * 
	 * @方法名称: view 
	 * @实现功能: 查看表单页面
	 * @param dcSearchLabel
	 * @param model
	 * @return
	 * @create by yuzh at 2016年11月12日 上午11:51:00
	 */
	@RequiresPermissions(value={"dc:searchLabel:view"})
	@RequestMapping(value = "view")
	public String view(DcSearchLabel dcSearchLabel, Model model) {
		model.addAttribute("dcSearchLabel", dcSearchLabel);
		return "modules/dc/dataSearch/dcSearchLabelView";
	}

	/**
	 * 
	 * @方法名称: save 
	 * @实现功能: 保存
	 * @param dcSearchLabel
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * @create by yuzh at 2016年11月12日 上午11:51:11
	 */
	@RequiresPermissions(value={"dc:searchLabel:add","dc:searchLabel:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcSearchLabel dcSearchLabel, Model model, RedirectAttributes redirectAttributes) throws Exception{
		if (!beanValidator(model, dcSearchLabel)){
			return form(dcSearchLabel, model);
		}
		if(!dcSearchLabel.getIsNewRecord()){//编辑表单保存
			DcSearchLabel t = dcSearchLabelService.get(dcSearchLabel.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcSearchLabel, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			dcSearchLabelService.save(t);//保存
		}else{//新增表单保存
			dcSearchLabelService.save(dcSearchLabel);//保存
		}
		addMessage(redirectAttributes, "标签保存成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcSearchLabel/?repage";
	}
	
	/**
	 * 验证信息是否有效
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkLabelName")
	public String checkLabelName(String oldLabelName, String labelName) {
		if (labelName !=null && labelName.equals(oldLabelName)) {
			return "true";
		} else if (labelName !=null && dcSearchLabelService.getLabelName(labelName) == null) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * @方法名称: delete 
	 * @实现功能: 删除
	 * @param dcSearchLabel
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月11日 下午4:20:20
	 */
	@RequiresPermissions("dc:searchLabel:del")
	@RequestMapping(value = "delete")
	public String delete(DcSearchLabel dcSearchLabel, RedirectAttributes redirectAttributes) {
		dcSearchLabelService.delete(dcSearchLabel);
		addMessage(redirectAttributes, "标签删除成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcSearchLabel/?repage";
	}
	
	/**
	 * @方法名称: deleteAll 
	 * @实现功能: 批量删除
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 * @create by yuzh at 2016年11月11日 下午4:20:41
	 */
	@RequiresPermissions("dc:searchLabel:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			dcSearchLabelService.delete(dcSearchLabelService.get(id));
		}
		addMessage(redirectAttributes, "标签删除成功");
		return "redirect:"+adminPath+"/dc/dataSearch/dcSearchLabel/?repage";
	}
	
	/**
	 * @方法名称: ajaxSaveLabelRef 
	 * @实现功能: 保存对象标签关联信息
	 * @param objId		对象Id
	 * @param labelName	标签名称
	 * @return
	 * @create by peijd at 2017年1月18日 下午2:00:50
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSaveLabelRef")
	public AjaxJson ajaxSaveLabelRef(String objId, String labelName) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			dcSearchLabelService.saveLabelRef(objId,labelName);
			ajaxJson.setMsg("保存成功!");
		} catch (Exception e) {
			ajaxJson.setMsg("保存失败! </br>"+e.getMessage());
			ajaxJson.setSuccess(false);
			logger.error("-->ajaxSaveLabelRef", e);
		}
		
		return ajaxJson;
	}
	
}
