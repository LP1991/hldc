/********************** 版权声明 *************************
 * 文件: DcMetaDataServer.java
 * 包名: com.hlframe.modules.dc.jersey
 * 版权: 杭州华量软件 hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年05月03日 19:37
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.jersey;

import com.hlframe.common.service.ServiceException;
import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.auth.entity.DcIntfVisitList;
import com.hlframe.modules.dc.auth.service.DcIntfVisitListService;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataexport.entity.DcDataInterface;
import com.hlframe.modules.dc.dataexport.entity.DcDataInterfaceLog;
import com.hlframe.modules.dc.dataexport.service.DcDataInterfaceLogService;
import com.hlframe.modules.dc.dataexport.service.DcMetaDataJsonService;
import com.hlframe.modules.dc.metadata.entity.DcObjectInterface;
import com.hlframe.modules.dc.metadata.service.DcObjectIntfService;
import com.hlframe.modules.dc.utils.DESUtils;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.sys.entity.User;
import com.hlframe.modules.sys.utils.UserUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import java.util.Date;

/**
 * com.hlframe.modules.dc.jersey.DcMetaDataIntface
 * 元数据访问接口
 *
 * @author peijd
 * @create 2017-05-03 19:37
 **/
@Path("/metaDataIntf")
public class DcMetaDataIntface {

    private Logger logger = LoggerFactory.getLogger(getClass());

    //json对象转换Service
    private DcMetaDataJsonService metaDataJsonService = SpringContextHolder.getBean(DcMetaDataJsonService.class);
    //接口对象Service
    private DcObjectIntfService intfService = SpringContextHolder.getBean(DcObjectIntfService.class);
    //接口日志对象Service
    private DcDataInterfaceLogService interfaceLogService = SpringContextHolder.getBean(DcDataInterfaceLogService.class);
    //接口访问权限Service
    private DcIntfVisitListService visitService = SpringContextHolder.getBean(DcIntfVisitListService.class);

    /**
     * 服务健康情况测试
     * @return
     */
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String testServer() {
        return "healthy";
    }

    /**
     * @方法名称: buildMetaDataJson
     * @实现功能: 构建元数据接口内容 json列表
     * @param objId         接口ID        不可为空
     * @param clientId      调用用户ID     不可为空
     * @param param         参数条件
     * @param pageSize      分页-每页数量  不可为空 默认每页50条记录
     * @param pageNum       分页-当前页码  不可为空 默认-1表示不分页
     * @param orderField    排序字段
     * @return  java.lang.String
     * @create by peijd at 2017/5/3 19:59
     */
    @POST
    @Path("/buildMetaDataJson")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String buildMetaDataJson(@FormParam("objId") String objId,
                                    @FormParam("clientId") String clientId,
                                    @FormParam("param") String param,
                                    @FormParam("pageSize") Integer pageSize,
                                    @FormParam("pageNum") Integer pageNum,
                                    @FormParam("orderField") String orderField,
                                    @Context HttpServletRequest request){
        DcDataResult result = new DcDataResult();
        try{
            Assert.hasText(objId);
            DcObjectInterface intf = intfService.get(objId);
            Assert.notNull(intf, "接口不存在或已删除!");

            //验证调用者信息
            validateClientId(clientId, objId);

            //设置参数条件
            if(StringUtils.isBlank(param)){
                param = intf.getIntfcParams();
            }else{
                param += " and "+intf.getIntfcParams();
            }

            //接口查询参数
            DcDataInterface dcDataInterface = new DcDataInterface();
            dcDataInterface.setObjId(intf.getIntfcSrcId()); //数据表ID
            dcDataInterface.setIntfFields(intf.getIntfcFields());   //字段列表
            dcDataInterface.setIntfParams(StringEscapeUtils.unescapeXml(param));   //参数
            //每页数据量 默认100, 最大200条
            int maxPageSize = Integer.parseInt(DcPropertyUtils.getProperty("intf.max.pageSize","200"));
            dcDataInterface.setPageSize(null==pageSize? Integer.parseInt(DcPropertyUtils.getProperty("intf.default.pageSize","100")):pageSize>maxPageSize?maxPageSize:pageSize);
            //当前页码  默认为第1页
            dcDataInterface.setPageNum(null==pageNum?1:pageNum);
            dcDataInterface.setOrderField(orderField);
            //密钥key
            dcDataInterface.setEncryptKey(DESUtils.getEncStr(clientId));

            //开始记录调用日志
            DcDataInterfaceLog log = new DcDataInterfaceLog();
            log.setIntfId(objId);
            log.setStartTime(DateUtils.getDateTime());  //开始时间
            long startTimeStamp = new Date().getTime();
            result = metaDataJsonService.convertData2Json(dcDataInterface);

            log.setCallBy(clientId);      //调用者ID
            log.setCallParam(param);       //参数
            log.setRtnFields(intf.getIntfcFields());   //字段
            if (null!=request){           //获取IP
                log.setClintIp(request.getRemoteAddr());
            }
            log.setEndTime(DateUtils.getDateTime());    //结束时间
            log.setResponseTime((int) ((new Date().getTime()-startTimeStamp)/1000));  //响应时长 单位: 秒
            if(result.getRst_flag()){   //成功
                log.setRstFlag("1");//调用结果标记(1-成功; 0-失败)
                log.setRstMsg(result.getRemarks());
            }else{  //失败
                log.setRstMsg(result.getRst_err_msg().length()>1500?result.getRst_err_msg().substring(0,1500)+"...":result.getRst_err_msg());
                log.setRstFlag("0");//调用结果标记(1-成功; 0-失败)
            }
            //保存到数据库
            interfaceLogService.insertInterfaceLog(log);

        }catch(Exception e){
            result.setRst_flag(false);
            result.setTotleNum(0);
            result.setRst_err_msg(e.getMessage());
        }

        return result.toString();
    }

    /**
     * @方法名称: validateClientId
     * @实现功能: 验证调用者信息
     * @param  clientId 调用者ID
     * @param objId
     * @return  void
     * @create by peijd at 2017/5/9 15:01
     */
    private void validateClientId(String clientId, String objId) {
        Assert.hasText(clientId, "调用者信息为空!");
        User user = UserUtils.get(clientId);
        Assert.notNull(user, "clientId无效, 请检查!");

        //增加访问权限认证 接口黑名单/白名单, 不在白名单的禁止访问
        DcIntfVisitList visitObj = visitService.getByUserIdAndObjId(clientId, objId);
        if(null==visitObj || DcIntfVisitList.CONN_TYPE_BLACK.equals(visitObj.getConnType())){
            throw new ServiceException("您没有该接口的访问权限, 请申请!");
        }
    }

}
