/********************** 版权声明 *************************
 * 文件: DcObjectFileController.java
 * 包名: com.hlframe.modules.dc.metadata.web
 * 版权: 杭州华量软件 hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年05月06日 15:10
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.web;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.service.DcSearchLabelService;
import com.hlframe.modules.dc.metadata.entity.DcObjectFile;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.entity.DcSysObjm;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.metadata.service.DcObjectFileService;
import com.hlframe.modules.sys.entity.Office;
import com.hlframe.modules.sys.utils.UserUtils;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * com.hlframe.modules.dc.metadata.web.DcObjectFileController
 * 元数据-文件/目录 controller
 *
 * @author peijd
 * @create 2017-05-06 15:10
 **/
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcObjectFile")
public class DcObjectFileController extends BaseController{


	@Autowired
	private DcObjectFileService objFileService;
    @Autowired
    private DcObjectAuService authService;      //数据权限Service
	@Autowired
    private DcSearchLabelService labelService; // 数据标签关系Service
    /**
     * @方法名称: queryFileList
     * @实现功能: 构建元文件对象列表R
     * @param obj
     * @param redirectAttributes
     * @return
     * @create by peijd at 2016年12月27日 下午4:30:33
     */
    @ResponseBody
    @RequestMapping(value = "queryFileList")
    public AjaxJson queryFileList(DcObjectMain obj, RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        List<DcObjectFile> fileList = objFileService.queryFileList(obj);
        if (CollectionUtils.isNotEmpty(fileList)) {
            ajaxJson.put("fileList", fileList);
            ajaxJson.setSuccess(true);
        } else {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg("没有可用的文件对象!");
        }
        return ajaxJson;
    }
    /**
     * @方法名称: ajaxlist
     * @实现功能: ajax分页列表
     * @param qdd
     * @param request
     * @param response
     * @param model
     * @return
     * @create by bao gang  2017年4月20日 下午2 :15
     */
    @ResponseBody
    @RequestMapping(value = "ajaxlist")
    public DataTable ajaxlist(DcObjectFile qdd, HttpServletRequest request, HttpServletResponse response, Model model) {
        qdd.setObjType(DcObjectMain.OBJ_TYPE_FILE+","+DcObjectMain.OBJ_TYPE_FOLDER);// 文件和文件夹
        Page<DcObjectFile> page = objFileService.findLabelList(new Page<DcObjectFile>(request), qdd);
        List<DcObjectFile> list = page.getList();
        String curUserId = UserUtils.getUser().getId();
        List<DcSysObjm> accreList = authService.getAccreList(curUserId, null);
       List<String> hlist=new ArrayList<String>();
      for(DcSysObjm map : accreList){
          if (StringUtils.isNotBlank(map.getObjMainId()))
              hlist.add(map.getObjMainId());
        }
        for(DcObjectFile aaa:list){
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
        //必要，即没有过滤的记录数（数据库里总共记录数）
       a.setRecordsTotal((int) page.getCount());
        // 必要，过滤后的记录数 不使用自带查询框就没计算必要，与总记录数相同即可
        a.setRecordsFiltered((int) page.getCount());
        a.setLength(page.getPageSize());
        Gson gson = new Gson();
        a.put("gson", gson.toJson(list));
        return a;
    }
    /**
     * @方法名称: view
     * @实现功能: 查看数据对象或数据表对象
     * @param obj
     * @param model
     * @return
     * @create bao gang at 2017年4月20日 下午1:36:43

    @RequiresPermissions(value = { "dc:metadata:dcObjectMain:view" })
    @RequestMapping(value = "dataView")
    public String view(DcObjectMain obj, Model model, HttpServletRequest request) {

        model.addAttribute("objectMain", dcObjectMainService.tnadmin(obj.getId()));
        return "modules/dc/metaData/dcObjectMain/dcObjectMainView"; // 查看页面
    }
    */
    /**
     * @方法名称: view
     * @实现功能: 查看文件和文件夹对象
     * @param obj
     * @param model
     * @return
     * @create by  bao gang at 2017年4月20日 下午3:36:43
     */

    @RequestMapping(value = "dataVie")
    public String vie(DcObjectFile obj, Model model, HttpServletRequest request) {

       DcObjectFile list = objFileService.getdc(obj.getId());
      model.addAttribute("objectMais", list);
        model.addAttribute("objectMain", obj);
        return "modules/dc/metaData/dcObjectMain/dcObjectMainDcoView"; // 查看页面
    }
    /**
     * @方法名称: updateDco
     * @实现功能:文件 文件夹对象修改界面
     * @param obj
     * @param model
     * @return
     * @create by bao gang at 2017年4月20日 下午3:36:43
     */
	/* @RequiresPermissions(value={"dc:metadata:dcObjectMain:updateView"}) */
    @RequestMapping(value = "updateDco")
    public String updateDco(DcObjectFile obj, Model model) {
        DcObjectFile list = objFileService.getdc(obj.getId());
        // 添加标签信息 modify by bao gnag d 0327
        List<DcSearchLabel> labelList = labelService.findLabelListByObjId(obj.getId());
        //获取该用户部门
        Office office  = UserUtils.getUser().getOffice();
        if(office!=null){
            list.setOffice(office);
        }
        model.addAttribute("objLabelList", labelList);
        model.addAttribute("objectTable", list);
        return "modules/dc/metaData/dcObjectMain/dcObjectMainDcoUpdate"; // 查看页面
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
    @RequestMapping(value = "ajaxSaveFile")
    public AjaxJson ajaxSaveFile(DcObjectFile obj, HttpServletRequest request, Model model,
                                  RedirectAttributes redirectAttributes) {
        AjaxJson ajaxJson = new AjaxJson();
        if (!beanValidator(model, obj)) {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg("验证失败！");
            return ajaxJson;
        }

        try {

            objFileService.savefile(obj);
            ajaxJson.setMsg("保存文件对象'" + obj.getObjName() + "'成功!");
        } catch (Exception e) {
            ajaxJson.setSuccess(false);
            ajaxJson.setMsg(e.getMessage());
            logger.error(e.getMessage());
        }
        return ajaxJson;
    }
    /**
     *
     * @方法名称: checkItemName
     * @实现功能: 判断项目名否已存在
     * @param
     * @param
     * @return
     * @create by hgw at 2017年3月30日 下午1:48:40
     */
    @ResponseBody
    @RequestMapping(value = "checkItemName")
    public String checkItemName(String oldItemName, String itemName) {
        if (itemName !=null && itemName.equals(oldItemName)) {
            return "true";
        } else if (itemName !=null && objFileService.findUniqueByProperty("OBJ_NAME", itemName) == null) {
            return "true";
        }
        return "false";
    }

    /**
     *
     * @方法名称: checkCodeName
     * @实现功能: 判断编号名是否已存在
     * @param
     * @param
     * @return
     * @create by hgw at 2017年3月30日 下午1:48:56
     */
    @ResponseBody
    @RequestMapping(value = "checkCodeName")
    public String checkCodeName(String oldItemCode, String itemCode) {
        if (itemCode !=null && itemCode.equals(oldItemCode)) {
            return "true";
        } else if (itemCode !=null && objFileService.findUniqueByProperty("OBJ_CODE", itemCode) == null) {
            return "true";
        }
        return "false";
    }

}

