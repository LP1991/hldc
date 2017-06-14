/********************** 版权声明 *************************
 * 文件: DcObjectIntfService.java
 * 包名: com.hlframe.modules.dc.metadata.service
 * 版权: 杭州华量软件 hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年05月05日 14:43
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.metadata.service;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.service.CrudService;
import com.hlframe.common.utils.MyBeanUtils;
import com.hlframe.modules.dc.metadata.dao.DcObjectInterfaceDao;
import com.hlframe.modules.dc.metadata.entity.DcObjectInterface;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import java.util.List;
import java.util.Map;

/**
 * com.hlframe.modules.dc.metadata.service.DcObjectIntfService
 * 元数据-接口对象 Service
 *
 * @author peijd
 * @create 2017-05-05 14:43
 **/
@Service
@Transactional(readOnly = true)
public class DcObjectIntfService extends CrudService<DcObjectInterfaceDao, DcObjectInterface> {

    @Autowired
    private DcObjectMainService mainService;

    /**
     * @方法名称: findPage
     * @实现功能: 构建分页对象
     * @param page
     * @param intf
     * @return  com.hlframe.common.persistence.Page<com.hlframe.modules.dc.metadata.entity.DcObjectInterface>
     * @create by peijd at 2017/5/5 15:26
     */
    public Page<DcObjectInterface> findPage(Page<DcObjectInterface> page, DcObjectInterface intf) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        intf.getSqlMap().put("dsf", dataScopeFilter(intf.getCurrentUser(), "o", "u"));
        // 设置分页参数
        intf.setPage(page);
        // 执行分页查询
        page.setList(dao.findList(intf));
        return page;
    }

    /**
     * @方法名称: saveIntf
     * @实现功能: 保存接口对象
     * @params  [obj]
     * @return  void
     * @create by peijd at 2017/5/5 15:40
     */
    @Transactional(readOnly = false)
    public void saveIntf(DcObjectInterface obj) throws Exception {
        DcObjectMain main = new DcObjectMain();
        //将obj的属性复制到main中
        MyBeanUtils.copyBean2Bean(main, obj);
        //保存Main对象
        main.setId(obj.getObjId());
        main.setIsNewRecord(false); //不是新纪录
        mainService.save(main);
        //保存table对象
//        dao.update(obj);

        //TODO 更新到ES集群中 DcMetadataStroeService
    }


    /**
     * @方法名称: getInterface4es
     * @实现功能: get the all interface with the catalog detail, using for
     *        initialize ES data
     * @return
     * @create by lp at 2017年3月8日
     */
    public List<Map<String, Object>> getInterfaces4es(DcObjectMain obj) {
        if (null == obj) {
            obj = new DcObjectMain();
        }
        return dao.getInterfaces4es(obj);
    }


    /**
     * @方法名称: buildUpdateIntfForm
     * @实现功能: 构建接口对象表单
     * @params  [obj]
     * @return  com.hlframe.modules.dc.metadata.entity.DcObjectInterfaceInfo
     * @create by peijd at 2017/5/4 17:51
     */
    public DcObjectInterface buildUpdateIntfForm(DcObjectMain obj) throws Exception {
        String objId = obj.getId();
        Assert.hasText(objId);
        return dao.buildIntfInfo(objId);
    }

    /**
     * 删除接口
     * @param dcObjectMain
     */
    @Transactional(readOnly = false)
    public void delete(DcObjectMain dcObjectMain) {

        DcObjectInterface intf = new DcObjectInterface();
        intf.setObjId(dcObjectMain.getId());
        dao.delete(intf);

        mainService.delete(dcObjectMain);
    }

    /**
     * @方法名称: findMyDataPage
     * @实现功能: 获取我的接口数据
     * @param page
     * @param obj
     * @return  com.hlframe.common.persistence.Page<com.hlframe.modules.dc.metadata.entity.DcObjectInterface>
     * @create by peijd at 2017/5/31 15:32
     */
    public Page<DcObjectInterface> findMyDataPage(Page<DcObjectInterface> page, DcObjectInterface obj) {
        obj.setObjType(DcObjectMain.OBJ_TYPE_INTER);//只显示接口
        obj.setApplyUserId(UserUtils.getUser().getId());
        // 设置分页参数
        obj.setPage(page);
        // 执行分页查询
        page.setList(dao.findMyDataList(obj));
        return page;
    }
}
