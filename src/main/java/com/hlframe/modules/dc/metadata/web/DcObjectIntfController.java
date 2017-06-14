/********************** 版权声明 *************************
 * 文件: DcObjectIntfController.java
 * 包名: com.hlframe.modules.dc.metadata.web
 * 版权: 杭州华量软件 hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年05月05日 14:39
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.web;

import com.google.gson.Gson;
import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.auth.entity.DcIntfVisitList;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.service.DcSearchLabelService;
import com.hlframe.modules.dc.metadata.entity.DcObjectInterface;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.entity.DcSysObjm;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.metadata.service.DcObjectIntfService;
import com.hlframe.modules.dc.utils.DESUtils;
import com.hlframe.modules.dc.utils.DcStringUtils;
import com.hlframe.modules.sys.entity.Office;
import com.hlframe.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;

/**
 * com.hlframe.modules.dc.metadata.web.DcObjectIntfController
 * 接口元数据Controller
 *
 * @author peijd
 * @create 2017-05-05 14:39
 **/
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcObjectIntf")
public class DcObjectIntfController extends BaseController{

    @Autowired
    private DcObjectIntfService objectIntfService;  //接口元数据 Service

    @Autowired
    private DcObjectAuService authService;      //数据权限Service

    @Autowired
    private DcSearchLabelService labelService;	//数据标签关系Service

    /**
     * @方法名称: list
     * @实现功能: 元数据接口列表
     * @params  [obj, model]
     * @return  java.lang.String
     * @create by peijd at 2017/5/5 14:48
     */
    @RequestMapping(value = "list")
    public String list(DcObjectInterface obj, Model model) {
        model.addAttribute("interface", obj);
        return "modules/dc/metaData/dcObjectMain/dcObjectInterfaceList";
    }

    /**
     * @方法名称: ajaxlist
     * @实现功能: 元数据接口列表
     * @params  [obj, request, response, model]
     * @return  com.hlframe.common.json.DataTable
     * @create by peijd at 2017/5/5 15:00
     */
    @ResponseBody
    @RequestMapping(value = "ajaxlist")
    public DataTable ajaxlist(DcObjectInterface obj, HttpServletRequest request, HttpServletResponse response, Model model) {
        obj.setObjType(DcObjectMain.OBJ_TYPE_INTER);//只显示接口
        Page<DcObjectInterface> page = objectIntfService.findPage(new Page<DcObjectInterface>(request), obj);

        List<DcObjectInterface> list = page.getList();
        String curUserId = UserUtils.getUser().getId();
        //查询权限列表
        List<DcSysObjm> accreList = authService.getAccreList(curUserId, null);
        List<String> hlist = new ArrayList<String>();
        for (DcSysObjm map : accreList) {
            if (StringUtils.isNotBlank(map.getObjMainId()))
                hlist.add(map.getObjMainId());
        }
        for (DcObjectInterface aaa : list) {
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
            //设置接口URL
            updateIntfUrl(request, aaa);
        }
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
     * @方法名称: intfForm
     * @实现功能: 接口元数据  编辑表单对象
     * @params
     * @return
     * @create by peijd at 2017/5/5 15:30
     */
    @RequestMapping(value = "intfForm")
    public String intfForm(DcObjectInterface intf, Model model) {
        try{
            //接口元数据  编辑表单对象
            DcObjectInterface dataObj = objectIntfService.get(intf);
            //获取该用户部门
            Office office  = UserUtils.getUser().getOffice();
            if(office!=null){
                dataObj.setOffice(office);
            }
            model.addAttribute("objectIntf", dataObj);

        }catch(Exception e){
            model.addAttribute("objectIntf", new DcObjectInterface());
            logger.error("-->intfForm: ",e);
        }
        return "modules/dc/metaData/dcObjectMain/dcObjectIntfForm";
    }

    /**
     * @方法名称: ajaxSaveIntf
     * @实现功能: 保存接口元数据
     * @params  [obj, request, model, redirectAttributes]
     * @return  com.hlframe.common.json.AjaxJson
     * @create by peijd at 2017/5/8 10:42
     */
    @ResponseBody
    @RequestMapping(value = "ajaxSaveIntf")
    public AjaxJson ajaxSaveIntf(DcObjectInterface obj, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        if (!beanValidator(model, obj)) {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg("验证失败！");
            return ajaxJson;
        }
        // TODO: 根据对象编码 判断是否存在同名对象 对象编码不可重复
        if (false) {
            ajaxJson.setMsg("保存数据对象'" + obj.getObjName() + "'失败, 对象编码[" + obj.getObjCode() + "]已存在!");
            return ajaxJson;
        }
        try {
            // 保存main和Intf对象
            objectIntfService.saveIntf(obj);
            ajaxJson.setMsg("保存数据对象'" + obj.getObjName() + "'成功!");
        } catch (Exception e) {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg(e.getMessage());
            logger.error(e.getMessage());
            e.printStackTrace();
        }
        return ajaxJson;
    }

    /**
     * @方法名称: intfView
     * @实现功能: 查看接口对象
     * @params  [intf, model, request]
     * @return  java.lang.String
     * @create by peijd at 2017/5/8 11:07
     */
    @RequestMapping(value = "intfView")
    public String intfView(DcObjectInterface intf, Model model, HttpServletRequest request) {
        try{
            int accreSrc = intf.getAccre(); //查看数据来源
            //接口元数据  编辑表单对象
            DcObjectInterface dataObj = objectIntfService.get(intf);
            //动态设置 服务端访问URL
            updateIntfUrl(request, dataObj);
            //调用示例
            if(StringUtils.isBlank(dataObj.getRemarks()) && DcObjectInterface.INTFC_TYPE_RESTFUL.equals(dataObj.getIntfcType())){
                dataObj.setRemarks(new StringBuilder(256)
                        .append("POST ").append(dataObj.getIntfcUrl()).append(" HTTP/1.1 </br>")
                        .append("Cache-Control: no-cache </br>")
                        .append("Content-Type: ").append(dataObj.getIntfcContype()).append(" </br>")
                        .append("objId=").append(dataObj.getObjId())
                        .append("&#38;clientId=").append(UserUtils.getUser().getId())
                        .append("&#38;pageNum={当前页码}")
                        .append("&#38;pageSize={每页数量}")
                        .append("&#38;orderField=").append(StringUtils.isBlank(dataObj.getOrderFields())?"{排序方式}":dataObj.getOrderFields())
                        .append("&#38;param=").append(StringUtils.isBlank(dataObj.getIntfcParams())?"{自定义条件}":dataObj.getIntfcParams()+" and {自定义条件}").append(" </br></br>")
                        .append("<p>接口备注:</p>")
                        .append("<li><strong>param/{自定义条件}</strong>为接口数据查询条件, 用户可根据业务设置, 若存在多个则以' and '分隔; <strong>e.g.</strong> fieldA>1 and fieldB='0'</li>")
                        .append("<li><strong>pageNum/{当前页码}</strong>为查询结果的请求分页; <strong>e.g.</strong> pageNum=1</li>")
                        .append("<li><strong>pageSize/{每页数量}</strong>为接口数据的每页数据量, 默认为100, 最大为200; <strong>e.g.</strong> pageSize=100</li>")
                        .append("<li><strong>orderField/{排序方式}</strong>为接口数据的默认排序方式, 多个排序字段以','分隔, 若不指定则自动排序; <strong>e.g.</strong> fieldA desc, fieldB</li>")
                        .toString());
            }
            //设置数据来源, 在页面上个性化控制...
            dataObj.setAccre(accreSrc);
            model.addAttribute("objectIntf", dataObj);

            //标签列表
            List<DcSearchLabel> objLabelList = labelService.findLabelListByObjId(dataObj.getObjId());
            model.addAttribute("objLabelList", objLabelList);

        }catch(Exception e){
            model.addAttribute("objectIntf", new DcObjectInterface());
            logger.error("-->intfForm: ",e);
        }
        return "modules/dc/metaData/dcObjectMain/dcObjectIntfView";
    }

     /**
     * @方法名称: updateIntfUrl
     * @实现功能: 设置接口访问URL
      * @param request
      * @param dataObj
     * @return  void
     * @create by peijd at 2017/5/8 15:21
     */
    private void updateIntfUrl(HttpServletRequest request, DcObjectInterface dataObj) {
        if(StringUtils.isBlank(dataObj.getIntfcUrl())){
            //设置地址
            dataObj.setIntfcUrl(DcStringUtils.getCurrentContextPath(request, true)+"/rest/metaDataIntf/buildMetaDataJson");
        }
    }

    /**
     * @方法名称: selectIntf
     * @实现功能: 弹框选择接口列表
     * @param dataObj   接口对象
     * @param url       页面URL
     * @param fieldLabels   字段名
     * @param fieldKeys     字段值
     * @param searchLabel   查询条件字段名
     * @param searchKey     查询条件字段值
     * @param request
     * @param response
     * @param model
     * @return
     * @throws UnsupportedEncodingException
     * @create by peijd at 2017/5/26 8:09
     */
    @RequestMapping({"selectIntf"})
    public String selectIntf(DcObjectInterface dataObj, String url, String fieldLabels, String fieldKeys, String searchLabel, String searchKey, HttpServletRequest request, HttpServletResponse response, Model model) throws UnsupportedEncodingException {
        Page page = objectIntfService.findPage(new Page(request, response), dataObj);

        try {
            fieldLabels = URLDecoder.decode(fieldLabels, "UTF-8");
            fieldKeys = URLDecoder.decode(fieldKeys, "UTF-8");
            searchLabel = URLDecoder.decode(searchLabel, "UTF-8");
            searchKey = URLDecoder.decode(searchKey, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            logger.error("-->selectIntf:", e);
        }

        model.addAttribute("labelNames", fieldLabels.split("\\|"));
        model.addAttribute("labelValues", fieldKeys.split("\\|"));
        model.addAttribute("fieldLabels", fieldLabels);
        model.addAttribute("fieldKeys", fieldKeys);
        model.addAttribute("url", url);
        model.addAttribute("searchLabel", searchLabel);
        model.addAttribute("searchKey", searchKey);
        model.addAttribute("obj", dataObj);
        model.addAttribute("page", page);
        return "modules/sys/gridselect";
    }

    /**
     * @方法名称: myList
     * @实现功能: 查看我的接口数据
     * @param obj
     * @param model
     * @return  java.lang.String
     * @create by peijd at 2017/5/31 15:22
     */
    @RequestMapping(value = "myList")
    public String myList(DcObjectInterface obj, Model model) {
        model.addAttribute("interface", obj);
        return "modules/dc/metaData/dcObjectMain/dcMyInterfaceList";
    }

    /**
     * @方法名称: myAjaxlist
     * @实现功能: 查询我的接口数据
     * @param obj
     * @param request
     * @param response
     * @param model
     * @return  com.hlframe.common.json.DataTable
     * @create by peijd at 2017/5/31 15:33
     */
    @ResponseBody
    @RequestMapping(value = "myAjaxlist")
    public DataTable myAjaxlist(DcObjectInterface obj, HttpServletRequest request, HttpServletResponse response, Model model) {

        Page<DcObjectInterface> page = objectIntfService.findMyDataPage(new Page<DcObjectInterface>(request), obj);

        for(DcObjectInterface aaa: page.getList()){
            //设置接口URL
            updateIntfUrl(request, aaa);
        }
        DataTable a = new DataTable();
        // 绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
        a.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
        // 必要，即没有过滤的记录数（数据库里总共记录数）
        a.setRecordsTotal((int) page.getCount());
        // 必要，过滤后的记录数 不使用自带查询框就没计算必要，与总记录数相同即可
        a.setRecordsFiltered((int) page.getCount());
        a.setLength(page.getPageSize());
        Gson gson = new Gson();
        a.put("gson", gson.toJson(page.getList()));
        return a;
    }


    /**vvcv
     * @方法名称: viewMyKey
     * @实现功能: 查看我的密钥
     * @params  [request, model]
     * @return  com.hlframe.common.json.AjaxJson
     * @create by peijd at 2017/5/31 16:47
     */
    @ResponseBody
    @RequestMapping(value = "viewMyKey")
    public AjaxJson viewMyKey(HttpServletRequest request, Model model) {
        AjaxJson ajaxJson = new AjaxJson();
        try {
            String userId = UserUtils.getUser().getId();
            ajaxJson.setMsg(DESUtils.getEncStr(userId));
        } catch (Exception e) {
            ajaxJson.setMsg("操作失败!</br>"+e.getMessage());
            ajaxJson.setSuccess(false);
            logger.error("-->viewMyKey", e);
        }
        return ajaxJson;

    }

    /**
     * @方法名称: downDesJar
     * @实现功能: 下载des解密jar包
     * @param request
     * @param response
     * @return  void
     * @create by peijd at 2017/5/31 19:13
     */
    @RequestMapping(value="downDesJar")
    public void downDesJar(HttpServletRequest request, HttpServletResponse response) throws Exception{
        //jar路径
        String jarPath = Global.getUserfilesBaseDir() + Global.USERFILES_BASE_URL+"/download/hlDesUtil.jar";
        File f = new File(jarPath);
        if (!f.exists()) {
            throw new FileNotFoundException(jarPath);
        }
        FileChannel channel = null;
        FileInputStream fs = null;
        try {
            fs = new FileInputStream(f);
            channel = fs.getChannel();
            ByteBuffer byteBuffer = ByteBuffer.allocate((int) channel.size());
            while ((channel.read(byteBuffer)) > 0) {
            }
            //加载文件内容
            byte[] data = byteBuffer.array();
            response.reset();
            response.setContentType("application/octet-stream;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=hlDesUtil.jar");
            response.addHeader("Content-Length", "" + data.length);
            OutputStream outputStream = response.getOutputStream();//获取OutputStream输出流
            outputStream.write(data);
            response.flushBuffer();

        } catch (IOException e) {
            logger.error("-->exportHdfsFile: ", e);
        } finally {
            try {
                channel.close();
                fs.close();
            } catch (IOException e) {
                logger.error("-->exportHdfsFile: ", e);
            }
        }
    }


}
