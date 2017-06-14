/********************** 版权声明 *************************
 * 文件: DcJobTransIntfController.java
 * 包名: com.hlframe.modules.dc.dataprocess.web
 * 版权: 杭州华量软件 hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年04月18日 10:55
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.web;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.entity.DcHdfsFile;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransIntf;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransIntfForm;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransIntfService;
import com.hlframe.modules.dc.metadata.entity.*;
import com.hlframe.modules.dc.metadata.service.DcDataSourceService;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.dc.metadata.service.DcObjectTableService;
import com.hlframe.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * com.hlframe.modules.dc.dataprocess.web.DcJobTransIntfController
 * 接口数据采集 控制类
 *
 * @author peijd
 * @create 2017-04-18 10:55
 **/
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/transIntf")
public class DcJobTransIntfController extends BaseController {

    @Autowired  //采集任务Service
    private DcJobTransIntfService transIntfService;
    @Autowired  //权限管理Service
    private DcObjectAuService authService;
    @Autowired  //数据源链接
    private DcDataSourceService dcDataSourceService;
    @Autowired  //元数据对象
    private DcObjectMainService objMainService;
    @Autowired  //元数据-table对象
    private DcObjectTableService objTableService;

    /**
     * @return java.lang.String
     * @方法名称: restList
     * @实现功能: 查看rest接口采集数据对象/列表
     * @params [obj, model]
     * @create by peijd at 2017/4/18 13:15
     */
    @RequestMapping(value = "restList")
    public String restList(DcJobTransIntf obj, Model model) {
        if (StringUtils.isNotEmpty(obj.getId())) {
            obj = transIntfService.get(obj.getId());
        } else {
            obj = new DcJobTransIntf();
        }
        model.addAttribute("dcJobTransIntf", obj);
        return "modules/dc/dataProcess/dcJobTransIntf/dcExtractRestWSList";
    }

    /**
     * @方法名称: soapList
     * @实现功能: 查看soap接口采集数据对象/列表
     * @params  [obj, model]
     * @return  java.lang.String
     * @create by peijd at 2017/4/19 11:51
     */
    @RequestMapping(value ="soapList")
    public String soapList(DcJobTransIntf obj, Model model) {
        if (StringUtils.isNotEmpty(obj.getId())) {
            obj = transIntfService.get(obj.getId());
        } else {
            obj = new DcJobTransIntf();
        }
        model.addAttribute("dcJobTransIntf", obj);
        return "modules/dc/dataProcess/dcJobTransIntf/dcExtractSoapWSList";
    }
    /**
     * @return java.lang.String
     * @方法名称: dataForm
     * @实现功能: rest webservice 采集配置
     * @params [obj, model]
     * @create by peijd at 2017/4/18 13:18
     */
    @RequestMapping(value = "dataForm")
    public String dataForm(DcJobTransIntf obj, Model model) {
        DcJobTransIntfForm jobData = new DcJobTransIntfForm();
        if (null != obj && StringUtils.isNotEmpty(obj.getId())) {
            jobData = transIntfService.buildFormData(obj.getId());
        }else{
            jobData.setJobType(obj.getJobType());
        }
        model.addAttribute("formData", jobData);
        //数据源列表  下拉列表中显示数据源类别
        DcDataSource param  = new DcDataSource();
        param.setServerType(DcDataSource.DB_SERVER_TYPE_MYSQL);
        model.addAttribute("dataSourceList", dcDataSourceService.buildSelectList(param));

        if(DcJobTransIntf.JOB_TYPE_RESTFUL.equals(jobData.getJobType())){
            return "modules/dc/dataProcess/dcJobTransIntf/dcExtractRestWSForm";
        }
        return "modules/dc/dataProcess/dcJobTransIntf/dcExtractSoapWSForm";
    }

     /**
     * @方法名称: initTarTable
     * @实现功能: 初始化目标表对象
     * @create by peijd at 2017/4/20 14:32
     * @param intf
     * @param model
     * @return
     */
     @RequestMapping(value = "initTarTable")
    public String initTarTable(DcJobTransIntf intf, Model model, RedirectAttributes redirectAttributes){
        DcJobTransIntfForm jobData = transIntfService.buildFormData(intf.getId());
         DcObjectTable tableForm = new DcObjectTable();
        if(DcJobTransIntf.TASK_STATUS_EDIT.equals(jobData.getStatus())){    //编辑状态 初始化表单
            tableForm.setTableName(jobData.getTarName());
            tableForm.setDbDataBase(jobData.getSchemaName());
            tableForm.setObjDesc(jobData.getJobDesc());
            tableForm.setRemarks(jobData.getCreateFlag().toString());   //是否创建数据表

        }else{  //直接获取表单对象
            tableForm = objTableService.getTableByObjId(intf.getId()) ;
        }
         tableForm.setId(intf.getId());
         model.addAttribute("formData", tableForm);

        //初始化接口字段
         List<DcObjectField> fields = new ArrayList<DcObjectField>();
         List<String> intfFields = new ArrayList<String>();
         try {
             Map<String, Object> rstMap  = transIntfService.initTableField(jobData);
             //数据表字段
             fields = (List<DcObjectField>) rstMap.get("fieldList");
             //接口字段
             intfFields = (List<String>) rstMap.get("intfFields");
         } catch (Exception e) {
             logger.error("-->initTarTable: ", e);
//             addMessage(redirectAttributes, "接口配置信息异常!"); //无法传递message信息...
             model.addAttribute("message", e.getMessage());
         }
         model.addAttribute("fieldList", fields);
         model.addAttribute("f_remarks", intfFields);
         return "modules/dc/dataProcess/dcJobTransIntf/dcTarTableFieldSet";
    }

    /**
     * @方法名称: refreshTarTable
     * @实现功能: 刷新数据表对象
     * @param form
     * @param request
     * @param response
     * @param model
     * @return
     * @return  com.hlframe.common.json.DataTable
     * @create by peijd at 2017/5/13 11:19
     */
    @ResponseBody
    @RequestMapping(value = "refreshTarTable")
    public DataTable refreshTarTable(DcJobTransIntf form, HttpServletRequest request, HttpServletResponse response, Model model) {
        DcJobTransIntfForm jobData = transIntfService.buildFormData(form.getId());
        //初始化接口字段
        List<DcObjectField> fields = new ArrayList<DcObjectField>();
        List<String> intfFields = new ArrayList<String>();
        try {
            Map<String, Object> rstMap  = transIntfService.initTableField(jobData);
            //数据表字段
            fields = (List<DcObjectField>) rstMap.get("fieldList");
            //接口字段
            intfFields = (List<String>) rstMap.get("intfFields");
        } catch (Exception e) {
            logger.error("-->refreshTarTable: ", e);

        }

        model.addAttribute("fieldList", fields);
        model.addAttribute("f_remarks", intfFields);
        DataTable a = new DataTable();
        //绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
        a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
        Gson gson = new Gson();
        a.put("gson",gson.toJson(fields));
        return a;
    }

    /**
     * @方法名称: view
     * @实现功能: 查看接口对象配置
     * @params  [obj, model]
     * @return  java.lang.String
     * @create by peijd at 2017/4/18 13:47
     */
    @RequestMapping(value = "dataView")
    public String view(DcJobTransIntf obj , Model model) {
        DcJobTransIntfForm formData = transIntfService.buildFormData(obj.getId());
        model.addAttribute("formData", formData);
        if(DcJobTransIntf.JOB_TYPE_RESTFUL.equals(formData.getJobType())){
            return "modules/dc/dataProcess/dcJobTransIntf/dcExtractRestWSView";
        }
        return "modules/dc/dataProcess/dcJobTransIntf/dcExtractSoapWSView";
    }

    /**
     * @方法名称: checkJobName
     * @实现功能: 验证任务名称是否重复
     * @params  [oldJobName, jobName]
     * @return  java.lang.String
     * @create by peijd at 2017/4/18 13:31
     */
    @ResponseBody
    @RequestMapping(value = "checkJobName")
    public String checkJobName(String jobType, String oldJobName, String jobName) {
        if (jobName !=null && jobName.equals(oldJobName)) {
            return "true";
        } else if (jobName !=null && transIntfService.getJobName(jobType, jobName) == null) {
            return "true";
        }
        return "false";
    }

    /**
     * @方法名称: checkTarName
     * @实现功能: 检查目标表名
     * @param tarName       目标表名
     * @param connId        数据源连接ID
     * @param schemaName    表空间
     * @param tarType       存储目标:0-mysql
     * @param oldTarName    原目标表名
     * @return  java.lang.String
     * @create by peijd at 2017/4/19 21:31
     */
    @ResponseBody
    @RequestMapping(value = "checkTarName")
    public String checkTarName(String tarName, String connId, String schemaName, String tarType, String oldTarName) {
//        System.out.println("-->"+tarType+"-->"+tarName+"-->"+connId+"-->"+schemaName);
        if (tarName !=null && tarName.equals(oldTarName)) {
            return "true";
        } else if (tarName !=null && transIntfService.checkTarName(tarName, connId, schemaName, tarType)) {
            return "true";
        }
        return "false";
    }

    /**
     * @方法名称: ajaxlist
     * @实现功能: ajax分页代码
     * @params  [obj, request, response, model]
     * @return  com.hlframe.common.json.DataTable
     * @create by peijd at 2017/4/18 13:44
     */
    @ResponseBody
    @RequestMapping(value = "ajaxlist")
    public DataTable ajaxlist(DcJobTransIntfForm obj, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<DcJobTransIntfForm> page = transIntfService.buildPage(new Page<DcJobTransIntfForm>(request), obj);
        List<DcJobTransIntfForm> list = page.getList();

        String curUserId = UserUtils.getUser().getId();
        List<DcSysObjm> accreList = authService.getAccreList(curUserId, null);
        List<String> hlist = new ArrayList<String>();
        for (DcSysObjm map : accreList) {
            if (StringUtils.isNotBlank(map.getObjMainId()))
                hlist.add(map.getObjMainId());
        }
        for (DcJobTransIntfForm aaa : list) {
            //如果是当前用户创建, 则拥有所有权限
            if (curUserId.equals(aaa.getCreateBy().getId())) {
                aaa.setAccre(1);

            } else {    //申请过权限的
                for (String str : hlist) {
                    if (StringUtils.isNotBlank(aaa.getId()) && aaa.getId().equals(str)) {
                        aaa.setAccre(1);
                    }
                }
            }
        }
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

    /**
     * @方法名称: ajaxDelete
     * @实现功能: 删除接口采集配置
     * @params  [obj, redirectAttributes]
     * @return  com.hlframe.common.json.AjaxJson
     * @create by peijd at 2017/4/18 13:49
     */
    @ResponseBody
    @RequestMapping(value = "ajaxDelete")
    public AjaxJson ajaxDelete(DcJobTransIntf obj, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        try{
            transIntfService.delete(obj);
            ajaxJson.setMsg("删除数据对象成功!");
        }catch(Exception e){
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg("删除失败!"+e.getMessage());
            logger.error("-->ajaxDelete", e);
        }
        return ajaxJson;
    }

    /**
     * @方法名称: ajaxSave
     * @实现功能: 保存接口采集配置
     * @params  [obj, request, model, redirectAttributes]
     * @return  com.hlframe.common.json.AjaxJson
     * @create by peijd at 2017/4/18 13:50
     */
    @ResponseBody
    @RequestMapping(value = "ajaxSave")
    public AjaxJson ajaxSave(DcJobTransIntfForm obj, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        try {
            transIntfService.save(obj);
            ajaxJson.setSuccess(true);
            ajaxJson.setMsg("保存数据对象'" + obj.getJobName() + "'成功!");
        } catch (Exception e) {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg("保存失败!<br>明细:"+e.getMessage());
            logger.error("-->ajaxSave", e);
        }
        return ajaxJson;
    }


    /**
     * @方法名称: ajaxSaveTarTable
     * @实现功能: 保存目标表对象/字段
     * @create by peijd at 2017/4/20 16:51
     * @param obj
     * @param request
     * @param model
     * @param redirectAttributes
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "ajaxSaveTarTable")
    public AjaxJson ajaxSaveTarTable(DcJobTransIntfForm obj, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        try {
            transIntfService.saveTarTable(obj);
            ajaxJson.setSuccess(true);
            ajaxJson.setMsg("初始化目标表成功!");
        } catch (Exception e) {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg("初始化目标表失败!<br>明细:"+e.getMessage());
            logger.error("-->ajaxSaveTarTable", e);
        }
        return ajaxJson;
    }

    /**
     * @方法名称: getAu
     * @实现功能: 发起权限申请
     * @params  [obj, redirectAttributes]
     * @return  com.hlframe.common.json.AjaxJson
     * @create by peijd at 2017/4/18 13:51
     */
    @ResponseBody
    @RequestMapping(value = "getAu")
    public AjaxJson getAu(DcJobTransIntf obj, RedirectAttributes redirectAttributes){
        transIntfService.getAu(obj);
        AjaxJson ajaxJson = new AjaxJson();
        ajaxJson.setMsg("已向管理员申请该任务操作权限，请等待管理员审核!");
        return ajaxJson;
    }

    /**
     * @方法名称: runTask
     * @实现功能: 运行采集任务
     * @params  [jobId, request, model, redirectAttributes]
     * @return  com.hlframe.common.json.AjaxJson
     * @create by peijd at 2017/4/18 13:52
     */
    @ResponseBody
    @RequestMapping(value = "runTask")
    public AjaxJson runTask(String jobId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        try {
            DcDataResult taskResult =  transIntfService.runTask(jobId);
            if(taskResult.getRst_flag()){
                ajaxJson.setMsg(taskResult.getRst_std_msg());
            }else{
                ajaxJson.setMsg(taskResult.getRst_err_msg());
                ajaxJson.setSuccess(false);
            }
        } catch (Exception e) {
            ajaxJson.setMsg(e.getMessage());
            logger.error("dcJobTransDataService.runTask", e);

        }
        return ajaxJson;
    }

    /**
     * @方法名称: add2Schedule
     * @实现功能: 添加至自定义任务
     * @params  [jobId, request, model]
     * @return  com.hlframe.common.json.AjaxJson
     * @create by peijd at 2017/4/18 13:53
     */
    @ResponseBody
    @RequestMapping(value = "add2Schedule")
    public AjaxJson add2Schedule(String jobId, HttpServletRequest request, Model model) {
        AjaxJson ajaxJson = new AjaxJson();
        try {
            String msg = transIntfService.add2Schedule(jobId);
            ajaxJson.setMsg(msg);
        } catch (Exception e) {
            ajaxJson.setMsg("调度任务创建失败!</br>"+e.getMessage());
            ajaxJson.setSuccess(false);
            logger.error("-->add2Schedule", e);

        }
        return ajaxJson;
    }

    /**
     * @方法名称: previewData
     * @实现功能: 预览数据内容
     * @params  [obj, model, request]
     * @return  java.lang.String
     * @create by peijd at 2017/4/18 13:55
     */
    @RequestMapping(value = "previewData")
    public String previewData(DcJobTransIntf obj, Model model,HttpServletRequest request) {
        List<Map<String, Object>> jobList = transIntfService.previewDbData(obj.getId());
        //数据对象字段列表
        model.addAttribute("columnList",jobList);
        return "modules/dc/dataProcess/dcJobTransData/dcJobPreviewData";       //数据预览页面(借用DB数据采集 源数据预览)
    }

    /**
     * @方法名称: logInfo
     * @实现功能: 加载日志信息
     * @create by peijd at 2017/4/25 20:49
     * @param obj
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "logInfo")
    public String logInfo(DcJobTransIntf obj, Model model,HttpServletRequest request){
        Assert.hasText(obj.getId());
        DcJobTransIntf intf = transIntfService.get(obj.getId());
        DcHdfsFile file = new DcHdfsFile();
        file.setContent(intf.getRemarks());
        model.addAttribute("hdfsFile", file);
        return "modules/dc/dataProcess/dcJobTransData/dcHdfsFileContent";
    }


}
