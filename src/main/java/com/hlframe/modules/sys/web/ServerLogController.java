package com.hlframe.modules.sys.web;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hlframe.common.web.BaseController;
import com.hlframe.modules.sys.entity.Role;
import com.hlframe.modules.sys.utils.FileUtil;

/**
 * 
 * @类名: com.hlframe.modules.sys.web.ServerLogController.java 
 * @职责说明: tomcat日志处理类
 * @创建者: cdd
 * @创建时间: 2016年12月1日 下午3:54:08
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/serverLog")
public class ServerLogController extends BaseController {
    /**
     * 
     * @方法名称: index 
     * @实现功能: 跳转到服务器日志首页
     * @param role
     * @param model
     * @return
     * @throws Exception
     * @create by cdd at 2016年11月30日 下午3:53:25
     */
	@RequiresPermissions("sys:serverLog:index")
	@RequestMapping(value = { "index", "" })
	public String index(Role role, Model model) throws Exception {
		model.addAttribute("tomcatInformation", FileUtil.ShowTomcatInformation());
		return "modules/sys/serverLogIndex";
	}
}