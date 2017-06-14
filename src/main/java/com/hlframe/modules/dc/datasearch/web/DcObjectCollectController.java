package com.hlframe.modules.dc.datasearch.web;

import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.datasearch.entity.DcObjectCollect;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.service.DcObjectCollectService;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.util.Assert;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @类名: DcFavoriteController
 * @职责说明: 收藏功能控制类
 * @创建者: Primo
 * @创建时间: 2017/3/3
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/objCollect/dcObjCollect")
public class DcObjectCollectController extends BaseController {
    @Autowired
    private DcObjectCollectService dcObjectCollectService;

    /**
     * @方法名称: get
     * @实现功能: 设置userId获取
     * @param objName
     * @return
     */
    @ModelAttribute
    public DcObjectCollect get(@RequestParam(required=false) String objName) {
        DcObjectCollect entity = new DcObjectCollect();
        DcObjectMain obj = new DcObjectMain();
        if (StringUtils.isNotBlank(objName)){
            obj.setObjName(objName);
        }
        Assert.notNull(UserUtils.getUser().getId());
        entity.setUserId(UserUtils.getUser().getId());
        entity.setDcObjectMain(obj);
        return entity;
    }

    /**
     * @方法名称: ajaxSaveFavorite
     * @实现功能: 保存收藏信息
     * @param objId		对象Id
     */
    
    @ResponseBody
    @RequestMapping(value = "ajaxSaveObjCollect")
    public AjaxJson ajaxSaveFavorite(String objId) {
        AjaxJson ajaxJson = new AjaxJson();
        String userId = UserUtils.getUser().getId();
        try {
            if(dcObjectCollectService.isFavorite(userId,objId)){
                ajaxJson.setSuccess(false);
                ajaxJson.setMsg("已收藏!");
                return ajaxJson;
            }
            dcObjectCollectService.add2Favorite(objId);
            ajaxJson.setMsg("保存成功!");
        } catch (Exception e) {
            ajaxJson.setMsg("保存失败! </br>"+e.getMessage());
            ajaxJson.setSuccess(false);
            logger.error("-->ajaxSaveFavorite", e);
        }

        return ajaxJson;
    }

    /**
     * @方法名称: ajaxIsFavorite
     * @实现功能: 判断是否已经收藏
     * @param objId		对象Id
     */
    @ResponseBody
    @RequestMapping(value = "ajaxIsFavorite")
    public AjaxJson ajaxIsFavorite(String objId) {
        AjaxJson ajaxJson = new AjaxJson();
        String userId = UserUtils.getUser().getId();
        try {
            ajaxJson.setSuccess(dcObjectCollectService.isFavorite(userId,objId));
        } catch (Exception e) {
            ajaxJson.setSuccess(false);
            logger.error("-->ajaxIsFavorite", e);
        }

        return ajaxJson;
    }

    /**
     * @方法名称: list
     * @实现功能: 收藏列表 列表
     * @param dcObjectCollect
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequiresPermissions("dc:objCollect:dcObjCollect:list")
    @RequestMapping(value = "list")
    public String list(DcObjectCollect dcObjectCollect, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<DcObjectCollect> page = dcObjectCollectService.findPage(new Page<DcObjectCollect>(request, response), dcObjectCollect);
        model.addAttribute("page", page);
        return "modules/dc/metaData/dcDataSource/dcCollectList";
    }


    /**
     * @方法名称: delete
     * @实现功能: 收藏列表 列表
     * @param dcObjectCollect
     * @param redirectAttributes
     * @return
     */
    @RequiresPermissions("dc:objCollect:dcObjCollect:delete")
    @RequestMapping(value = "delete")
    public String delete(DcObjectCollect dcObjectCollect, RedirectAttributes redirectAttributes) {
        dcObjectCollectService.delete(dcObjectCollect);
        addMessage(redirectAttributes, "收藏删除成功!");
        return "redirect:"+adminPath+"/dc/objCollect/dcObjCollect/list/?repage";
    }
}
