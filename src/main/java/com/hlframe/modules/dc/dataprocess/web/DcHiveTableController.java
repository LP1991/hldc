package com.hlframe.modules.dc.dataprocess.web;


import java.util.Date;
import java.util.List;
import java.util.Map;

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

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveDatabase;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveField;
import com.hlframe.modules.dc.dataprocess.entity.DcHiveTable;
import com.hlframe.modules.dc.dataprocess.service.DcHiveTableService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransHdfsService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.dc.utils.RegExpValidatorUtils;

@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/hiveTableData")
public class DcHiveTableController  extends BaseController{

	@Autowired
	private DcHiveTableService dcHiveTableService;
	
	@Autowired
	private DcJobTransHdfsService dcJobTransHdfsService;

	@ModelAttribute("dcHiveTable")
	public DcHiveTable get(@RequestParam(required = false) String id) {//自动获取数据中的数据，若没有则创建
		DcHiveTable entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcHiveTableService.get(id);
		}
		if (entity == null) {
			entity = new DcHiveTable();
		}
		return entity;
	}
	
	/**
	 * @方法名称: list
	 * @实现功能: 首页跳转页面
	 * @param obj
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月10日 下午7:40:57
	 */
	@RequiresPermissions("dc:dataProcess:hiveTableData:list")
	@RequestMapping(value = { "list", "" })
	public String list(DcHiveTable obj, Model model) {
		List<DcHiveDatabase> dbList = dcHiveTableService.getHiveDatabase();// 获得hive表空间
		model.addAttribute("dbList", dbList);
		return "modules/dc/dataProcess/hiveTableData/hiveTableDataList";
	}
	
	/**
	 * @方法名称: ajaxlist
	 * @实现功能: 异步加载数据
	 * @param obj,request,response, model
	 * @return
	 * @create by cdd at 2017年1月10日 下午7:41:10
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcHiveTable obj, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcHiveTable> page = dcHiveTableService.findPage(new Page<DcHiveTable>(request), obj);
		List<DcHiveTable> list = page.getList();

		DataTable a = new DataTable();
		// 绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
		a.setRecordsTotal((int) page.getCount()); // 必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsFiltered((int) page.getCount());// 必要，过滤后的记录数
													// 不使用自带查询框就没计算必要，与总记录数相同即可
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson", gson.toJson(list));
		return a;
	}
	
	/**
	 * 增加，编辑采集传输文件表单页面
	 */
	@RequiresPermissions(value = { "dc:dataProcess:hiveTableData:add","dc:dataProcess:hiveTableData:edit" }, logical = Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcHiveTable obj, Model model) {
		List<DcHiveDatabase> dbList = dcHiveTableService.getHiveDatabase();// 获取hive表空间
		model.addAttribute("dbList", dbList);

		model.addAttribute("dcHiveTable", obj);
		return "modules/dc/dataProcess/hiveTableData/hiveTableDataForm";
	}
	
	/**
	 * @方法名称: checkTableName
	 * @实现功能: 检查表名是否重复
	 * @param oldTableName
	 * @param tableName
	 * @return
	 * @create by cdd at 2017年1月10日 下午7:39:28
	 */
	@ResponseBody
	@RequestMapping(value = "checkTableName")
	public String checkTableName(String oldTableName, String tableName) {
		if (tableName != null && tableName.equals(oldTableName)) {
			return "true";
		} else if (tableName != null && dcHiveTableService.getTableName(tableName) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * @方法名称: ajaxTableSave
	 * @实现功能: 异步实现数据表创建
	 * @param obj, request, model
	 * @param redirectAttributes
	 * @return
	 * @create by cdd at 2017年1月10日 下午7:40:10
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxTableSave")
	public AjaxJson ajaxTableSave(DcHiveTable obj, HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		obj.setCreateTime(new Date());
		if(dcHiveTableService.getTableName(obj.getTableName())!=null){
			ajaxJson.setMsg("数据库表名已存在");
			ajaxJson.setSuccess(false);
			return  ajaxJson;
		}
		try {
			dcHiveTableService.saveTableData(obj);// 将数据存到表中
			ajaxJson.setSuccess(true);
			ajaxJson.setMsg("保存数据对象成功!");
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("保存失败!:" );
			logger.error("-->ajaxTableSave", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: ajaxFieldSave 
	 * @实现功能: 异步实现字段保存
	 * @param dcHiveTable
	 * @param belong2Id
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @create by cdd at 2017年1月14日 下午1:36:41
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxFieldSave")
	public AjaxJson ajaxFieldSave(DcHiveField dcHiveTable,String belong2Id,HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();	
		try {
			dcHiveTableService.saveFieldData(dcHiveTable);
			ajaxJson.setSuccess(true);
			ajaxJson.setMsg("保存数据对象成功!");
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("保存失败:");
			logger.error("-->ajaxSave", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: view 
	 * @实现功能: 打开查看界面
	 * @param obj
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月10日 下午3:47:03
	 */
	@RequiresPermissions("dc:dataProcess:hiveTableData:view")
	@RequestMapping(value = "dataView")
	public String view(DcHiveTable obj, Model model) {	
		try {
			List<Map<String,Object>> fieldList = dcHiveTableService.loadFieldData(obj);//显示字段信息descTable(obj.getTableName())
			model.addAttribute("fieldList",fieldList);
			
			List<Map<String,Object>> dataList = dcHiveTableService.selectData(obj);//显示数据信息
			model.addAttribute("dataList", dataList);
		} catch (Exception e) {
			logger.error("-->dataView:", e);
		}
		
		return "modules/dc/dataProcess/hiveTableData/hiveTableDataView";
	}
	
	/**
	 * @方法名称: ajaxDelete 
	 * @实现功能: 删除数据表
	 * @param obj
	 * @param redirectAttributes
	 * @return
	 * @create by cdd at 2017年1月9日 上午10:53:18
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDelete")
	public AjaxJson ajaxDelete(DcHiveTable obj, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try{
			String result =  dcHiveTableService.deleteData(obj);//将其他数据表中的数据删除
			ajaxJson.setMsg(result);
		}catch(Exception e){
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("删除失败!");
			logger.error("-->ajaxDelete", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: setFieldData 
	 * @实现功能: 设置字段数据
	 * @param ob
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月11日 下午4:22:54
	 */
	@RequestMapping(value = "setFieldData")
	public String setFieldData(DcHiveTable obj,Model model) {
		List<Map<String,Object>> fieldList = dcHiveTableService.loadFieldData(obj);//导入字段信息
		model.addAttribute("fieldList",fieldList);
		
		model.addAttribute("dcHiveTable",obj);
		return "modules/dc/dataProcess/hiveTableData/hiveTableFieldSet";
	}
	
	/**
	 * @方法名称: loadData 
	 * @实现功能: 预览数据
	 * @param ob
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月11日 下午4:22:54
	 */
	@RequestMapping(value = "loadData")
	public String loadData(String location,String separatorSign,Model model) {
		List<Map<String,Object>> dataList = dcHiveTableService.loadData(location,separatorSign);//字段信息
		model.addAttribute("dataList",dataList);
		
		model.addAttribute("separatorSign",separatorSign);
		return "modules/dc/dataProcess/hiveTableData/hiveTableLoadData";
	}
	
	/**
	 * @方法名称: loadDataByCatalog 
	 * @实现功能: 按目录导入数据
	 * @param obj
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月20日 上午11:07:05
	 */
	@RequestMapping(value = "loadDataByCatalog")
	public String loadDataByCatalog(DcHiveTable obj, Model model) {
		model.addAttribute("dcHiveTable", obj);
		return "modules/dc/dataProcess/hiveTableData/hiveTableDataSet";
	}
	
	/**
	 * @方法名称: createHiveTable 
	 * @实现功能: 创建hive数据表
	 * @param obj
	 * @param request
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月16日 上午9:06:44
	 */
	@ResponseBody
	@RequestMapping(value = "createHiveTable")
	public AjaxJson createHiveTable(DcHiveTable obj,HttpServletRequest request,Model model) {
		AjaxJson ajaxJson = new AjaxJson();	
		try {
			String msg =dcHiveTableService.createHiveTable(obj);//在hive中创建表
			ajaxJson.setMsg(msg);
		} catch (Exception e) {
			ajaxJson.setMsg("创建hive表失败");
			ajaxJson.setSuccess(false);
			logger.error("DcHiveTableController.createHiveTable", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: loadHiveData 
	 * @实现功能: 数据导入hive表
	 * @param obj
	 * @param request
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月16日 上午9:06:54
	 */
	@ResponseBody
	@RequestMapping(value = "loadHiveData")
	public AjaxJson loadHiveData(DcHiveTable obj, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();		
		try {
			String msg = dcHiveTableService.loadHiveData(obj);//将数据导入到Hive表中
			ajaxJson.setMsg(msg);
		} catch (Exception e) {
			ajaxJson.setMsg("数据导入hive表失败");
			logger.error("DcHiveTableController.loadHiveData", e);
		}
		return ajaxJson;
	}
	
	/**
	 * @方法名称: getDataFromCatalog 
	 * @实现功能: 根据目录导入数据
	 * @param obj
	 * @param request
	 * @param model
	 * @return
	 * @create by cdd at 2017年1月23日 下午2:22:21
	 */
	@ResponseBody
	@RequestMapping(value = "getDataFromCatalog")
	public AjaxJson getDataFromCatalog(DcHiveTable obj, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();	
		try {
			String result =  dcHiveTableService.getDataFromCatalog(obj, "true".equals(obj.getIsLoadData()));//根据目录导入数据
			ajaxJson.setMsg(result);
		} catch (Exception e) {
			ajaxJson.setMsg("数据导入hive表失败");
			logger.error("DcHiveTableController.loadHiveData", e);
		}
		return ajaxJson;
	}
	
	/**
	 * 
	 * @方法名称:  根据ip获取hdfs地址 
	 * @实现功能: TODO
	 * @param params
	 * @return
	 * @create by hgw at 2017年4月15日 下午4:20:52
	 */
	@ResponseBody
	@RequestMapping(value = "HdfsPathTreeData")
	public List<Map<String,Object>> HdfsPathTreeData(){
		String hdfsIp = DcPropertyUtils.getProperty("hdfs.datanode.address");
		return dcJobTransHdfsService.treeData(hdfsIp);
	}
	
	/**
	 * 
	 * @方法名称: checkDatabase 
	 * @实现功能: 校验表名命名规则
	 * @param database
	 * @return
	 * @create by hgw at 2017年4月12日 下午2:58:43
	 */
	@ResponseBody
	@RequestMapping(value = "checkTable")
	public String checkTable(String tableName) {	
		if (RegExpValidatorUtils.isDTable(tableName)) {
			return "true";
		}
		return "false";
	}
}
