/********************** 版权声明 *************************
 * 文件名: DcDataSourceController.java
 * 包名: com.hlframe.modules.dc.metadata.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2016年11月7日 下午1:55:49
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.web;

import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.utils.Des;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.metadata.entity.DcDataSource;
import com.hlframe.modules.dc.metadata.service.DcDataSourceService;


/** 
 * @类名: com.hlframe.modules.dc.metadata.web.DcDataSourceController.java 
 * @职责说明: 数据源管理 controller
 * @创建者: peijd
 * @创建时间: 2016年11月7日 下午1:55:49
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcDataSource")
public class DcDataSourceController extends BaseController {

	@Autowired
	private DcDataSourceService dcDataSourceService;
	
	/**
	 * @方法名称: get 
	 * @实现功能: 根据Id获取数据源连接 明细
	 * @param id
	 * @return
	 * @create by peijd at 2016年11月7日 下午1:59:38
	 */
	@ModelAttribute
	public DcDataSource get(@RequestParam(required=false) String id) {
		DcDataSource entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcDataSourceService.get(id);
		}
		if (entity == null){
			entity = new DcDataSource();
		}
		return entity;
	}
	
	/**
	 * @方法名称: list 
	 * @实现功能: 数据源连接 列表
	 * @param dcDataSource
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月7日 下午2:00:08
	 */
	@RequiresPermissions("dc:metadata:dcDataSource:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcDataSource dcDataSource, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcDataSource> page = dcDataSourceService.findPage(new Page<DcDataSource>(request, response), dcDataSource);
		model.addAttribute("page", page);
		return "modules/dc/metaData/dcDataSource/dcDataSourceList";
	}

	/**
	 * @方法名称: form 
	 * @实现功能: 数据源连接 表单编辑
	 * @param dcDataSource
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月7日 下午2:02:38
	 */
	@RequiresPermissions(value={"dc:metadata:dcDataSource:add","dc:metadata:dcDataSource:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcDataSource dcDataSource, Model model) {
		model.addAttribute("dcDataSource", dcDataSource);
		return "modules/dc/metaData/dcDataSource/dcDataSourceForm";
	}
	
	/**
	 * @方法名称: ajaxSave 
	 * @实现功能: 通过ajax方式保存对象
	 * @param obj
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2016年11月18日 下午4:27:58
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcDataSource obj, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if (!beanValidator(model, obj)){
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("验证失败！");
			return ajaxJson;
		}
		//初始化数据源连接参数
		dcDataSourceService.initDBConnInfo(obj);
		dcDataSourceService.save(obj);
		ajaxJson.setMsg("保存成功!");
		//返回Id, 下拉列表加载用
		ajaxJson.getBody().put("dataSourceId", obj.getId());
		return ajaxJson;
	}
	
	
	
	/**
	 * @方法名称: checkConnName 
	 * @实现功能: 判断数据源连接名是否已存在
	 * @param oldConnName	
	 * @param connName
	 * @return
	 * @create by peijd at 2016年11月19日 上午11:01:52
	 */
	@ResponseBody
	@RequestMapping(value = "checkConnName")
	public String checkConnName(String oldConnName, String connName) {
		if (connName !=null && connName.equals(oldConnName)) {
			return "true";
		} else if (connName !=null && dcDataSourceService.findUniqueByProperty("conn_name", connName) == null) {
			return "true";
		}
		return "false";
	}
	
	
	/**
	 * @方法名称: ajaxNewSource 
	 * @实现功能: 通过ajax方式创建表单
	 * @param dcDataSource
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月18日 下午4:16:28
	 */
	@RequiresPermissions(value={"dc:metadata:dcDataSource:add"})
	@RequestMapping(value = "ajaxNewSource")
	public String ajaxNewSource(DcDataSource dcDataSource, Model model) {
		model.addAttribute("dcDataSource", dcDataSource);
		return "modules/dc/metaData/dcDataSource/dcDataSourceAjaxForm";
	}
	
	/**
	 * @方法名称: view 
	 * @实现功能: 数据源连接 表单查看
	 * @param dcDataSource
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月7日 下午4:37:32
	 */
	@RequiresPermissions("dc:metadata:dcDataSource:view")
	@RequestMapping(value = "view")
	public String view(DcDataSource dcDataSource, Model model) {
		model.addAttribute("dcDataSource", dcDataSource);
		return "modules/dc/metaData/dcDataSource/dcDataSourceView";
	}
	
	/**
	 * @方法名称: previewData 
	 * @实现功能: 预览源数据
	 * @param dcDataSource	数据源连接
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月19日 上午11:36:57
	 */
	@RequestMapping(value = "previewData")
	public String previewData(DcDataSource dcDataSource, Model model) {
		model.addAttribute("dcDataSource", dcDataSource);
		return "modules/dc/metaData/dcDataSource/dcDataSourceView";
	}

	/**
	 * @方法名称: save 
	 * @实现功能: 保存 数据源连接
	 * @param dcDataSource
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 * @create by peijd at 2016年11月7日 下午2:04:25
	 */
	@RequiresPermissions(value={"dc:metadata:dcDataSource:add","dc:metadata:dcDataSource:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcDataSource dcDataSource, Model model, RedirectAttributes redirectAttributes) throws Exception{
		if (!beanValidator(model, dcDataSource)){
			return form(dcDataSource, model);
		}
		//初始化连接信息
		dcDataSourceService.initDBConnInfo(dcDataSource);
		if(!dcDataSource.getIsNewRecord()){//编辑表单保存
			DcDataSource t = dcDataSourceService.get(dcDataSource.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcDataSource, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			dcDataSourceService.save(t);//保存
		}else{//新增表单保存
			dcDataSourceService.save(dcDataSource);//保存
		}
		addMessage(redirectAttributes, "保存数据源连接成功");
		return "redirect:"+Global.getAdminPath()+"/dc/metadata/dcDataSource/?repage";
	}
	
	/**
	 * @方法名称: delete 
	 * @实现功能: 删除数据源连接
	 * @param dcDataSource
	 * @param redirectAttributes
	 * @return
	 * @create by peijd at 2016年11月7日 下午2:04:17
	 */
	@RequiresPermissions("dc:metadata:dcDataSource:del")
	@RequestMapping(value = "delete")

	public String delete(DcDataSource dcDataSource, RedirectAttributes redirectAttributes) {
		try {
			if (dcDataSourceService.getlist(dcDataSource.getId()) == null) {
				dcDataSourceService.delete(dcDataSource);
				addMessage(redirectAttributes, "删除数据源连接成功");

			} else {
				addMessage(redirectAttributes, "数据源连接已被引用,删除失败");
			}
		} catch (Exception e) {
			logger.error("数据源连接已被引用删除失败", e);
			addMessage(redirectAttributes, "数据源连接已被引用,删除失败");
		}
		return "redirect:" + Global.getAdminPath() + "/dc/metadata/dcDataSource/?repage";

	}

	/**
	 * @方法名称: testDataSource 
	 * @实现功能: 验证数据源连接是否正常
	 * @param dcDataSource
	 * @return
	 * @create by peijd at 2016年11月8日 上午11:17:06
	 */
	@ResponseBody
	@RequestMapping(value = "testDataSource")
	public AjaxJson testDataSource(DcDataSource dcDataSource) {
		AjaxJson ajaxJson = new AjaxJson();
		//初始化数据源连接
		dcDataSourceService.initDBConnInfo(dcDataSource);
		String driverClazz = dcDataSource.getDriverClass();
		if (StringUtils.isBlank(driverClazz)) {
			driverClazz = DcDataSource.dbDriverMap.get(dcDataSource.getServerType());
		}
		Assert.hasText(driverClazz,"未配置数据库连接驱动!");
		
		DcDataSource tar = new DcDataSource();
		try {
			Class.forName(driverClazz);	
			//建立数据库连接
			Connection conn = DriverManager.getConnection(dcDataSource.getServerUrl(), dcDataSource.getServerUser(), Des.strDec(dcDataSource.getServerPswd()));
			if (null!=conn) {
				conn.close();
			}
			ajaxJson.setMsg("连接成功!");
			tar.setRemarks("1");	//连接成功
		} catch (Exception e) {
			logger.error("数据源["+dcDataSource.getConnName()+"]连接异常!", e);
			ajaxJson.setMsg("数据源["+dcDataSource.getConnName()+"]连接失败!");
			tar.setRemarks("0");	//连接失败
		}
		//有记录 则更新
		if(StringUtils.isNotEmpty(dcDataSource.getId())){
			//待更新的对象
			tar.setId(dcDataSource.getId());
			dcDataSourceService.save(tar);
		}
		return ajaxJson;
	}
	
	
}
