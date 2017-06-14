/********************** 版权声明 *************************
 * 文件名: DcDataSourceController.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：Primo   创建时间：2017年05月23日 下午1:55:49
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.web;

import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.FileUtils;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataprocess.entity.DcHdfsFileLook;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveFunction;
import com.hlframe.modules.dc.dataprocess.service.DcHdfsFileLookService;
import com.hlframe.modules.dc.dataprocess.service.DcHiveFuncService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;


/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcHiveFuncController.java
 * @职责说明: hive udf controller
 * @创建者: Primo
 * @创建时间: 2017年05月23日 下午1:55:49
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/dcHiveFunc")
public class DcHiveFuncController extends BaseController {

	@Autowired
	private DcHiveFuncService dcHiveFuncService;

	@Autowired
	private DcHdfsFileLookService dcHdfsFileLookService;
	/**
	 * @方法名称: get 
	 * @实现功能: 根据Id获取数据源连接 明细
	 * @param id
	 * @return
	 * @create by Primo at 2017年05月23日 下午1:55:49
	 */
	@ModelAttribute
	public DcHiveFunction get(@RequestParam(required=false) String id) {
        DcHiveFunction entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcHiveFuncService.get(id);
		}
		if (entity == null){
			entity = new DcHiveFunction();
		}
		return entity;
	}
	
	/**
	 * @方法名称: list 
	 * @实现功能: 列表
	 * @param dcHiveFunction
	 * @param request
	 * @param response
	 * @param model
	 * @return
     * @Create by lp at 2017/5/24 13:58
	 */
	@RequiresPermissions("dc:dataProcess:dcHiveFunc:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcHiveFunction dcHiveFunction, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcHiveFunction> page = dcHiveFuncService.findPage(new Page<DcHiveFunction>(request, response), dcHiveFunction);
		model.addAttribute("page", page);
		return "modules/dc/dataProcess/dcHiveFunc/dcHiveFuncList";
	}

	/**
	 * @方法名称: form
	 * @实现功能: 表单编辑
	 * @param dcHiveFunction
	 * @param model
	 * @return
     * @Create by lp at 2017/5/24 13:59
	 */
	@RequiresPermissions(value={"dc:dataProcess:dcHiveFunc:add","dc:dataProcess:dcHiveFunc:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcHiveFunction dcHiveFunction, Model model) {
		model.addAttribute("dcHiveFunction", dcHiveFunction);
		return "modules/dc/dataProcess/dcHiveFunc/dcHiveFuncForm";
	}

	/**
	 * @方法名称: checkName
	 * @实现功能: 检查重名
	 * @param oldFuncName
	 * @param funcName
	 * @return
     * @Create by lp at 2017/5/24 14:03
	 */
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkName(String oldFuncName, String funcName) {
		if (funcName !=null && funcName.equals(oldFuncName)) {
			return "true";
		} else if (funcName !=null && dcHiveFuncService.findUniqueByProperty("FUNC_NAME", funcName) == null) {
			return "true";
		}
		return "false";
	}


	/**
	 * @方法名称: ajaxForm
	 * @实现功能: 通过ajax方式创建表单
	 * @param dcHiveFunction
	 * @param model
	 * @return
     * @Create by lp at 2017/5/24 14:04
	 */
	@RequiresPermissions(value={"dc:dataProcess:dcHiveFunc:add"})
	@RequestMapping(value = "ajaxForm")
	public String ajaxForm(DcHiveFunction dcHiveFunction, Model model) {
		model.addAttribute("dcHiveFunction", dcHiveFunction);
		return "modules/dc/dataProcess/dcHiveFunc/dcHiveFuncForm";
	}

	/**
	 * @方法名称: view
	 * @实现功能: 表单查看
	 * @param dcHiveFunction
	 * @param model
	 * @return
     * @Create by lp at 2017/5/24 14:07
	 */
	@RequiresPermissions("dc:dataProcess:dcHiveFunc:view")
	@RequestMapping(value = "view")
	public String view(DcHiveFunction dcHiveFunction, Model model) {
		model.addAttribute("dcHiveFunction", dcHiveFunction);
		return "modules/dc/dataProcess/dcHiveFunc/dcHiveFuncView";
	}

	/**
	 * @方法名称: save
	 * @实现功能: 保存
	 * @param dcHiveFunction
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
     * @Create by lp at 2017/5/24 14:07
	 */
	@RequiresPermissions(value={"dc:dataProcess:dcHiveFunc:add","dc:dataProcess:dcHiveFunc:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(DcHiveFunction dcHiveFunction, Model model, RedirectAttributes redirectAttributes) throws Exception{
		if (!beanValidator(model, dcHiveFunction)){
			return form(dcHiveFunction, model);
		}
		//初始化连接信息
//		dcHiveFuncService.initDBConnInfo(dcHiveFunction);
		if(!dcHiveFunction.getIsNewRecord()){//编辑表单保存
            DcHiveFunction temp = dcHiveFuncService.get(dcHiveFunction.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(dcHiveFunction, temp);//将编辑表单中的非NULL值覆盖数据库记录中的值
            dcHiveFuncService.save(temp);//保存
		}else{//新增表单保存
			dcHiveFunction.setStatus(DcHiveFunction.HIVE_FUNC_STATUS_UPLOAD);
            dcHiveFuncService.save(dcHiveFunction);//保存
		}
		addMessage(redirectAttributes, "保存成功");
		return "redirect:"+Global.getAdminPath()+"/dc/dataProcess/dcHiveFunc/?repage";
	}

	/**
	 * @name: delete
	 * @funciton: 删除
	 * @param id
     * @param redirectAttributes
	 * @return
	 * @Create by lp at 2017/5/24 14:22
	 * @throws
	 */
	@RequiresPermissions("dc:dataProcess:dcHiveFunc:del")
	@RequestMapping(value = "delete")
    public String delete(String id, RedirectAttributes redirectAttributes) {
	    if (id != null) {
			DcHiveFunction dcHiveFunction = dcHiveFuncService.get(id);
	        dcHiveFuncService.delete(dcHiveFunction);
            addMessage(redirectAttributes, "删除成功");
        } else {
            addMessage(redirectAttributes, "删除失败");
        }
        return "redirect:"+Global.getAdminPath()+"/dc/dataProcess/dcHiveFunc/?repage";
	}

	/**
	 * 上传jars
	 * @param request
	 * @param response
	 * @param file
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
			DcHdfsFileLook dcHdfsFileLook =  new DcHdfsFileLook();
			dcHdfsFileLook.setTempPath("hdfs://"+DcPropertyUtils.getProperty("hive.udf.path","/home/jar"));
			dcHdfsFileLookService.uploads(dcHdfsFileLook,new MultipartFile[]{file});
		}
		return ajaxJson;
	}

	/**
	 * register function to hive
	 * @param id
	 * @return

	 */
	@RequestMapping(value = "register")
	public String register(String id, RedirectAttributes redirectAttributes){
		boolean flag = false;
		if (id != null) {
			flag = dcHiveFuncService.register(id);
		}
		if (flag){
			addMessage(redirectAttributes, "注册成功");
		}else {
			addMessage(redirectAttributes, "注册成功");
		}
		return "redirect:"+Global.getAdminPath()+"/dc/dataProcess/dcHiveFunc/?repage";
	}

	/**
	 * unregister function from hive
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "unregister")
	public String unregister(String id, RedirectAttributes redirectAttributes) {
		boolean flag = false;
		if (id != null) {
			flag = dcHiveFuncService.unregister(id);
		}
		if (flag){
			addMessage(redirectAttributes, "注销成功");
		}else {
			addMessage(redirectAttributes, "注销成功");
		}
		return "redirect:"+Global.getAdminPath()+"/dc/dataProcess/dcHiveFunc/?repage";
	}

}
