/********************** 版权声明 *************************
 * 文件: HldcWebApplicationContext.java
 * 包名: com.hlframe.modules.dc.sys
 * 版权: 杭州华量软件 hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年05月04日 20:08
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.sys;

import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.web.context.support.XmlWebApplicationContext;

/**
 * com.hlframe.modules.dc.sys.HldcWebApplicationContext
 * 临时解决service循环依赖导致项目无法启动问题
 * 多个service之间相互引用,应从设计上解决根本问题
 *
 * @author peijd
 * @create 2017-05-04 20:08
 **/
public class HldcWebApplicationContext extends XmlWebApplicationContext {
    /**
     * @方法名称: createBeanFactory
     * @实现功能: 复写springBeanFactory, 解决循环依赖导致项目无法启动问题
     * @params  []
     * @return  org.springframework.beans.factory.support.DefaultListableBeanFactory
     * @create by peijd at 2017/5/4 20:10
     */
    @Override
    protected DefaultListableBeanFactory createBeanFactory() {
        DefaultListableBeanFactory beanFactory =  super.createBeanFactory();
        beanFactory.setAllowRawInjectionDespiteWrapping(true);
        return beanFactory;
    }
}
