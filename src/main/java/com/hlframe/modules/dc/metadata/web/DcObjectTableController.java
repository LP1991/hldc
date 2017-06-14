/********************** 版权声明 *************************
 * 文件: DcObjectTableController.java
 * 包名: com.hlframe.modules.dc.metadata.web
 * 版权: 杭州华量软件 hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年05月06日 15:08
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.web;

import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.service.DcSearchLabelService;
import com.hlframe.modules.dc.metadata.entity.*;
import com.hlframe.modules.dc.metadata.service.*;
import com.hlframe.modules.sys.entity.Office;
import com.hlframe.modules.sys.utils.UserUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * com.hlframe.modules.dc.metadata.web.DcObjectTableController
 * 元数据-数据表Controller
 *
 * @author peijd
 * @create 2017-05-06 15:08
 **/
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcObjectTable")
public class DcObjectTableController extends BaseController {

    @Autowired
    private DcObjectTableService objTableService;
    @Autowired
    private DcSearchLabelService labelService; // 数据标签关系Service
    @Autowired
    private DcObjectIntfService objIntfService; // 元数据-接口Service
    @Autowired
    private DcMetadataStroeService dcMetadataStroeService;  //元数据分类service
    @Autowired
    private DcDataSourceService dcDataSourceService;
    @Autowired
    private DcObjectAuService authService;      //数据权限Service

    /**
     * @方法名称: form
     * @实现功能: 元数据-table对象编辑
     * @param obj
     * @param model
     * @return
     * @create by peijd at 2016年11月8日 下午4:12:05
     */
    @RequiresPermissions(value = { "dc:metadata:dcObjectMain:add", "dc:metadata:dcObjectMain:edit" }, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(DcObjectMain obj, Model model) {
        DcDataObject dataObj = new DcDataObject(obj);
        model.addAttribute("objectMain", dataObj);
        // 数据源列表
        model.addAttribute("dataSourceList", dcDataSourceService.findList(new DcDataSource()));
        return "modules/dc/metaData/dcObjectMain/dcObjectMainForm";
    }
    /**
     * @方法名称: ajaxSaveTable
     * @实现功能: ajaxSaveTable方式保存数据表对象
     * @param obj
     * @param request
     * @param model
     * @param redirectAttributes
     * @return
     * @create by peijd at 2016年11月8日 下午4:52:33
     */
    @ResponseBody
    @RequestMapping(value = "ajaxSaveTable")
    public AjaxJson ajaxSaveTable(DcObjectTable obj, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        if (!beanValidator(model, obj)) {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg("验证失败！");
            return ajaxJson;
        }
        try {
            // 保存main和table对象
            objTableService.saveTable(obj);

            // TODO: 保存字段列表
            // model.addAttribute("fieldList", fieldList);
            ajaxJson.setMsg("保存数据对象'" + obj.getObjName() + "'成功!");
            ajaxJson.setSuccess(true);
        } catch (Exception e) {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg(e.getMessage());
            logger.error(e.getMessage());
        }
        return ajaxJson;
    }



    /**
     * @方法名称: ajaxPub2Interface
     * @实现功能: 发布数据访问接口
     * @params  [intf, request, model, redirectAttributes]
     * @return  com.hlframe.common.json.AjaxJson
     * @create by peijd at 2017/5/5 7:27
     */
    @ResponseBody
    @RequestMapping(value = "ajaxPub2Interface")
    public AjaxJson ajaxPub2Interface(DcObjectInterface intf, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        try{
            objTableService.public2Interface(intf);
            ajaxJson.setMsg("数据对象发布接口成功!");
        }catch(Exception e){
            e.printStackTrace();
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg(e.getMessage());
            logger.error("-->ajaxPub2Interface: ",e.getMessage());
        }
        return ajaxJson;
    }


    /**
     * @方法名称: queryTableList
     * @实现功能: 构建元数据对象列表
     * @param obj
     * @param redirectAttributes
     * @return
     * @create by peijd at 2016年12月27日 下午4:26:02
     */
    @ResponseBody
    @RequestMapping(value = "queryTableList")
    public AjaxJson queryTableList(DcObjectMain obj, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        List<DcObjectTable> tableList = objTableService.queryTableList(obj);
        if (CollectionUtils.isNotEmpty(tableList)) {
            ajaxJson.setSuccess(true);
            ajaxJson.put("tableList", tableList);
        } else {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg("没有可用的数据对象!");
        }
        return ajaxJson;
    }


    @ResponseBody
    @RequestMapping(value = "ajaxlist")
    public DataTable ajaxlist(DcObjectTable obj, HttpServletRequest request, HttpServletResponse response, Model model) {
        obj.setObjType(DcObjectMain.OBJ_TYPE_TABLE);//只显示数据表

        Page<DcObjectTable> page = objTableService.findTablePage(new Page<DcObjectTable>(request), obj);

        List<DcObjectTable> list = page.getList();
        String curUserId = UserUtils.getUser().getId();
        //查询权限列表
        List<DcSysObjm> accreList = authService.getAccreList(curUserId, null);
        List<String> hlist = new ArrayList<String>();
        for (DcSysObjm map : accreList) {
            if (StringUtils.isNotBlank(map.getObjMainId()))
                hlist.add(map.getObjMainId());

        }
        for(DcObjectTable aaa:list){
            //如果是当前用户创建, 则拥有所有权限  baog gang
            if(curUserId.equals(aaa.getCreateBy().getId())){
                aaa.setAccre(1);

            }else{	//申请过权限的
                for(String str :hlist){
                    if(StringUtils.isNotBlank(aaa.getId()) && aaa.getId().equals(str)){
                        aaa.setAccre(1);
                    }
                }
            }
        }

        // 转换类型
        // for (DcObjectMain item : list) {
        // item.setDataScope(DictUtils.getDictLabel(role2.getDataScope(),
        // "sys_data_scope", ""));
        // }
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

    /**
     * @方法名称: updateTable
     * @实现功能: 数据表元数据对象修改界面
     * @param obj
     * @param model
     * @return
     * @create by peijd at 2016年11月8日 下午4:36:43
     */
	/* @RequiresPermissions(value={"dc:metadata:dcObjectMain:updateView"}) */
    @RequestMapping(value = "updateTable")
    public String updateTable(DcObjectMain obj, Model model) {
        DcObjectTable objectTable = null;
        List<DcSearchLabel> labelList = null;
        try {
            // 构建Map 存储object_main和object_table对象
            objectTable = objTableService.buildUpdateTableForm(obj);

            // TODO: 构建字段列表
            // model.addAttribute("fieldList", fieldList);
            // 添加标签信息 modify by peijd 0327
            labelList = labelService.findLabelListByObjId(objectTable.getId());
        } catch (Exception e) {
            logger.error(e.getMessage());
            objectTable = new DcObjectTable();
            labelList = new ArrayList<DcSearchLabel>();
        }
        //获取该用户部门
        Office office  = UserUtils.getUser().getOffice();
        if(office!=null){
            objectTable.setOffice(office);
        }
        model.addAttribute("objLabelList", labelList);
        model.addAttribute("objectTable", objectTable);
        return "modules/dc/metaData/dcObjectMain/dcObjectMainUpdate"; // 查看页面
    }

    /**
     * @方法名称: view
     * @实现功能: 查看数据对象或数据表对象
     * @param obj
     * @param model
     * @return
     * @create by peijd at 2016年11月8日 下午4:36:43
     */
    /*@RequiresPermissions(value = { "dc:metadata:dcObjectMain:view" })*/
    @RequestMapping(value = "dataView")
    public String view(DcObjectMain obj, Model model, HttpServletRequest request) {
        DcObjectTable objectTable = null;
        DcObjectTable list = null;
        try{
            list = objTableService.tnadmin(obj.getId());
            // 构建Map 存储object_main和object_table对象
            objectTable = objTableService.buildUpdateTableForm(obj);
           // list = objTableService.get(obj.getId());

        }catch(Exception e){
            logger.error(e.getMessage());
            objectTable = new DcObjectTable();
        }
       // model.addAttribute("objectMais", list);
        List<DcSearchLabel> objLabelList = labelService.findLabelListByObjId(obj.getId());
        model.addAttribute("objLabelList", objLabelList);
        model.addAttribute("objectMais", list);
        model.addAttribute("objectTable", objectTable);
        return "modules/dc/metaData/dcObjectMain/dcObjectMainView"; // 查看页面
    }


    /**
     * @方法名称: queryTableFieldList
     * @实现功能: 查询数据表  字段列表
     * @param extId
     * @param type
     * @param grade
     * @param isAll
     * @param request
     * @return
     * @create by peijd at 2017/5/5 11:39
     */
    @ResponseBody
    @RequestMapping(value = "queryTableFieldList")
    public List<Map<String, Object>> queryTableFieldList(@RequestParam(required=false) String extId, @RequestParam(required=false) String type, @RequestParam(required=false) Long grade, @RequestParam(required=false) Boolean isAll, HttpServletRequest request) {

        //获取数据表ID
        String tableId = (String) request.getParameter("otherParam1");
        String tableName = (String) request.getParameter("otherParam2");
        Assert.hasText(tableId,"数据表不存在或者已删除!");

        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        //添加根节点
        Map<String, Object> map = null;
        map = Maps.newHashMap();
        map.put("id", "table");
        map.put("pId", "0");
        map.put("name", tableName);
        map.put("isParent", true);
        mapList.add(map);
        try{
            List<DcObjectField> fieldList = objTableService.getByTableId(tableId);
            Assert.notNull(fieldList);
            //添加字段对象
            for(DcObjectField item: fieldList){
                map = Maps.newHashMap();
                map.put("pId", "table");
                map.put("id", item.getFieldName());		//字段名
                map.put("type", item.getFieldType());	//字段类型
                map.put("name", StringUtils.isNotBlank(item.getFieldDesc())?item.getFieldName()+"#"+item.getFieldDesc(): item.getFieldName());	//字段描述
                map.put("isParent", false);
                mapList.add(map);
            }
        }catch(Exception e){
            logger.error("-->queryTableFieldList: ", e);
        }
        return mapList;
    }



    /**
     * @方法名称: public2Intf
     * @实现功能: 添加接口发布页面
     * @params  [obj, model]
     * @return  java.lang.String
     * @create by peijd at 2017/5/4 17:45
     */
    @RequestMapping(value = "public2Intf")
    public String public2Intf(DcObjectMain obj, Model model) {
        try{
            DcObjectInterface objectIntf = objIntfService.buildUpdateIntfForm(obj);
            if(null==objectIntf){
                objectIntf = new DcObjectInterface();
            }
            DcObjectTable objectTable = objTableService.buildUpdateTableForm(obj);
            model.addAttribute("objectTable", objectTable);
            model.addAttribute("objectIntf", objectIntf);
        }catch(Exception e){
            model.addAttribute("objectTable", new DcObjectTable());
            model.addAttribute("objectIntf", new DcObjectInterface());
        }
        return "modules/dc/metaData/dcObjectMain/dcTablePublic2Intf";
    }

    /**
     *
     * @方法名称: ajaxfieldlist
     * @实现功能: ajax字段分页列表
     * @param obj
     * @param request
     * @param response
     * @param model
     * @return
     * @create by hgw at 2017年3月25日 上午10:33:16
     */
    @ResponseBody
    @RequestMapping(value = "ajaxfieldlist")
    public DataTable ajaxTablelist(DcObjectField obj, HttpServletRequest request, HttpServletResponse response, Model model) {

        List<DcObjectField> list = dcMetadataStroeService.findFieldList(obj);

        DataTable a = new DataTable();
        // 绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
        a.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
        a.setRecordsTotal(list.size());
        Gson gson = new Gson();
        a.put("gson", gson.toJson(list));
        return a;
    }


}
