/********************** 版权声明 *************************
 * 文件名: SysController.java
 * 包名: com.hlframe.modules.sys.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：cdd   创建时间：2016年11月9日 上午11:12:40
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.sys.web;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.common.collect.Maps;
import com.hlframe.common.config.Global;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.security.shiro.session.SessionDAO;
import com.hlframe.common.utils.CacheUtils;
import com.hlframe.common.utils.CookieUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.iim.entity.MailBox;
import com.hlframe.modules.iim.entity.MailPage;
import com.hlframe.modules.iim.service.MailBoxService;
import com.hlframe.modules.oa.entity.OaNotify;
import com.hlframe.modules.oa.service.OaNotifyService;
import com.hlframe.modules.sys.security.SystemAuthorizingRealm.Principal;
import com.hlframe.modules.sys.utils.UserUtils;

/** 
 * @类名: com.hlframe.modules.sys.web.SysController.java 
 * @职责说明: TODO
 * @创建者: cdd
 * @创建时间: 2016年11月9日 上午11:12:40
 */
//@Controller
//@RequestMapping(value = "${adminPath}/sys")
public class SysController  extends BaseController{

//	@Autowired
//	private SessionDAO sessionDAO;
//	
//	@Autowired
//	private OaNotifyService oaNotifyService;
//	
//	@Autowired
//	private MailBoxService mailBoxService;
//	
//	@RequiresPermissions("user")
//	@RequestMapping(value = "index")
//	public String index(HttpServletRequest request, HttpServletResponse response) {
//		Principal principal = UserUtils.getPrincipal();
//		// 登录成功后，验证码计算器清零
//		isValidateCodeLogin(principal.getLoginName(), false, true);
//		
//		if (logger.isDebugEnabled()){
//			logger.debug("show index, active session size: {}", sessionDAO.getActiveSessions(false).size());
//		}
//		
//	
//		if(Global.getBooleanValue("oa.start")) {
//			OaNotify oaNotify = new OaNotify();
//			oaNotify.setSelf(true);
//			oaNotify.setReadFlag("0");
//			Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify); 
//			request.setAttribute("page", page);
//			request.setAttribute("count", page.getList().size());//未读通知条数
//		}
//		
//		if(Global.getBooleanValue("mail.start")) {
//			//
//			MailBox mailBox = new MailBox();
//			mailBox.setReceiver(UserUtils.getUser());
//			mailBox.setReadstatus("0");//筛选未读
//			Page<MailBox> mailPage = mailBoxService.findPage(new MailPage<MailBox>(request, response), mailBox); 
//			request.setAttribute("noReadCount", mailBoxService.getCount(mailBox));
//			request.setAttribute("mailPage", mailPage);
//		}
//		
//		if(Global.getBooleanValue("system.setSkin")) {
//			// 默认风格
//			String indexStyle = "default";
//			Cookie[] cookies = request.getCookies();
//			for (Cookie cookie : cookies) {
//				if (cookie == null || StringUtils.isEmpty(cookie.getName())) {
//					continue;
//				}
//				if (cookie.getName().equalsIgnoreCase("theme")) {
//					indexStyle = cookie.getValue();
//				}
//			}
//			// 要添加自己的风格，复制下面三行即可
//			if (StringUtils.isNotEmpty(indexStyle)
//					&& indexStyle.equalsIgnoreCase("ace")) {
//				return "modules/sys/sysIndex-ace";
//			}
//			if (StringUtils.isNotEmpty(indexStyle)
//					&& indexStyle.equalsIgnoreCase("shortcut")) {
//				return "modules/sys/sysIndex-shortcut";
//			}
//			if (StringUtils.isNotEmpty(indexStyle)
//					&& indexStyle.equalsIgnoreCase("sliding")) {
//				return "modules/sys/sysIndex-sliding";
//			}
//		}
//		
//		return "modules/sys/sysIndex";
//	}
//	
//	/**
//	 * 是否是验证码登录
//	 * @param useruame 用户名
//	 * @param isFail 计数加1
//	 * @param clean 计数清零
//	 * @return
//	 */
//	@SuppressWarnings("unchecked")
//	public static boolean isValidateCodeLogin(String useruame, boolean isFail, boolean clean){
//		Map<String, Integer> loginFailMap = (Map<String, Integer>)CacheUtils.get("loginFailMap");
//		if (loginFailMap==null){
//			loginFailMap = Maps.newHashMap();
//			CacheUtils.put("loginFailMap", loginFailMap);
//		}
//		Integer loginFailNum = loginFailMap.get(useruame);
//		if (loginFailNum==null){
//			loginFailNum = 0;
//		}
//		if (isFail){
//			loginFailNum++;
//			loginFailMap.put(useruame, loginFailNum);
//		}
//		if (clean){
//			loginFailMap.remove(useruame);
//		}
//		return loginFailNum >= 3;
//	}
}
