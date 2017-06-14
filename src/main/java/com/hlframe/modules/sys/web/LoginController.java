/********************** 版权声明 *************************
 * 文件名: DcLoginController.java
 * 包名: com.hlframe.modules.dc.sys.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：cdd   创建时间：2016年11月9日 上午10:24:14
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.sys.web;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.web.util.SavedRequest;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.google.common.collect.Maps;
import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.security.shiro.session.SessionDAO;
import com.hlframe.common.servlet.ValidateCodeServlet;
import com.hlframe.common.utils.CacheUtils;
import com.hlframe.common.utils.CookieUtils;
import com.hlframe.common.utils.IdGen;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.dc.schedule.service.DcTaskMainService;
import com.hlframe.modules.iim.entity.MailBox;
import com.hlframe.modules.iim.entity.MailPage;
import com.hlframe.modules.iim.service.MailBoxService;
import com.hlframe.modules.oa.entity.OaNotify;
import com.hlframe.modules.oa.service.OaNotifyService;
import com.hlframe.modules.sys.security.FormAuthenticationFilter;
import com.hlframe.modules.sys.security.SystemAuthorizingRealm.Principal;
import com.hlframe.modules.sys.utils.UserUtils;


/**
 * 登录Controller
 * @author hlframe
 * @version 2013-5-31
 */
@Controller
public class LoginController extends BaseController{
	
	@Autowired
	private SessionDAO sessionDAO;
	
	@Autowired
	private OaNotifyService oaNotifyService;
	
	@Autowired
	private MailBoxService mailBoxService;

	@Autowired	//元数据对象
	private DcObjectMainService metaDataService;
	@Autowired	//系统任务对象
	private DcTaskMainService taskService;
	
	//是否使用验证码
	public static String validateCodeFlag = Global.getConfig("system.validateCode.useFlag");
		
	/**
	 * 管理登录
	 * @throws IOException 
	 */
	@RequestMapping(value = "${adminPath}/login")
	public String login(HttpServletRequest request, HttpServletResponse response, Model model) throws IOException {
		Principal principal = UserUtils.getPrincipal();

//		// 默认页签模式
//		String tabmode = CookieUtils.getCookie(request, "tabmode");
//		if (tabmode == null){
//			CookieUtils.setCookie(response, "tabmode", "1");
//		}
		
		// 这段好像不起作用，获取不到页面传递的参数
		String message = (String)request.getAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM);
		if ("session_err".equalsIgnoreCase(message)) {
			message = "未登录或登录超时，请重新登录，谢谢！";
			model.addAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM, message);
		}
		
		if (logger.isDebugEnabled()){
			logger.debug("login, active session size: {}", sessionDAO.getActiveSessions(false).size());
		}
		
		// 如果已登录，再次访问主页，则退出原账号。
		if (Global.TRUE.equals(Global.getConfig("system.notAllowRefreshIndex"))){
			CookieUtils.setCookie(response, "LOGINED", "false");
		}
		
		// 如果已经登录，则跳转到管理首页
		if(principal != null && !principal.isMobileLogin()){
			return "redirect:" + adminPath;
		}
		
		
		 SavedRequest savedRequest = WebUtils.getSavedRequest(request);//获取跳转到login之前的URL
		// 如果是手机没有登录跳转到到login，则返回JSON字符串
		 if(savedRequest != null){
			 String queryStr = savedRequest.getQueryString();
			if(	queryStr!=null &&( queryStr.contains("__ajax") || queryStr.contains("mobileLogin"))){
				AjaxJson j = new AjaxJson();
				j.setSuccess(false);
				j.setErrorCode("0");
				j.setMsg("没有登录!");
				return renderString(response, j);
			}
		 }
		 
		//验证码是否必填  peijd
		 if(!"false".equalsIgnoreCase(validateCodeFlag)){
			 model.addAttribute("validateCodeFlag","required");
		 }
		 
		return "modules/sys/sysLogin";
	}

	/**
	 * 登录失败，真正登录的POST请求由Filter完成
	 */
	@RequestMapping(value = "${adminPath}/login", method = RequestMethod.POST)
	public String loginFail(HttpServletRequest request, HttpServletResponse response, Model model) {
		Principal principal = UserUtils.getPrincipal();
		
		// 如果已经登录，则跳转到管理首页
		if(principal != null){
			return "redirect:" + adminPath;
		}

		String username = WebUtils.getCleanParam(request, FormAuthenticationFilter.DEFAULT_USERNAME_PARAM);
		boolean rememberMe = WebUtils.isTrue(request, FormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM);
		boolean mobile = WebUtils.isTrue(request, FormAuthenticationFilter.DEFAULT_MOBILE_PARAM);
		String exception = (String)request.getAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
		String message = (String)request.getAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM);
		
		if (StringUtils.isBlank(message) || StringUtils.equals(message, "null")){
			message = "用户名或密码错误, 请重试.";
		}

		model.addAttribute(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM, username);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM, rememberMe);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_MOBILE_PARAM, mobile);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME, exception);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM, message);
		
		if (logger.isDebugEnabled()){
			logger.debug("login fail, active session size: {}, message: {}, exception: {}", 
					sessionDAO.getActiveSessions(false).size(), message, exception);
		}
		
		// 非授权异常，登录失败，验证码加1。
		if (!UnauthorizedException.class.getName().equals(exception)){
			model.addAttribute("isValidateCodeLogin", isValidateCodeLogin(username, true, false));
		}
		
		// 验证失败清空验证码
		request.getSession().setAttribute(ValidateCodeServlet.VALIDATE_CODE, IdGen.uuid());
		
		// 如果是手机登录，则返回JSON字符串
		if (mobile){
			AjaxJson j = new AjaxJson();
			j.setSuccess(false);
			j.setMsg(message);
			j.put("username", username);
			j.put("name","");
			j.put("mobileLogin", mobile);
			j.put("JSESSIONID", "");
	        return renderString(response, j.getJsonStr());
		}
		 
		//验证码是否必填  peijd
		 if(!"false".equalsIgnoreCase(validateCodeFlag)){
			 model.addAttribute("validateCodeFlag","required");
		 }
		
		return "modules/sys/sysLogin";
	}

	/**
	 * 管理登录
	 * @throws IOException 
	 */
	@RequestMapping(value = "${adminPath}/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, HttpServletResponse response, Model model) throws IOException {
		Principal principal = UserUtils.getPrincipal();
		// 如果已经登录，则跳转到管理首页
		if(principal != null){
			UserUtils.getSubject().logout();
			
		}
	   // 如果是手机客户端退出跳转到login，则返回JSON字符串
			String ajax = request.getParameter("__ajax");
			if(	ajax!=null){
				model.addAttribute("success", "1");
				model.addAttribute("msg", "退出成功");
				return renderString(response, model);
			}
//		 return "redirect:" + adminPath+"/login";
		 return "modules/dc/dataSearch/retrievalIndex";
	}

	/**
	 * 登录成功，进入管理首页
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "${adminPath}")
	public String index(HttpServletRequest request, HttpServletResponse response) {
		Principal principal = UserUtils.getPrincipal();
		// 登录成功后，验证码计算器清零
		isValidateCodeLogin(principal.getLoginName(), false, true);
		
		if (logger.isDebugEnabled()){
			logger.debug("show index, active session size: {}", sessionDAO.getActiveSessions(false).size());
		}
		
		// 如果已登录，再次访问主页，则退出原账号。
		if (Global.TRUE.equals(Global.getConfig("system.notAllowRefreshIndex"))){
			String logined = CookieUtils.getCookie(request, "LOGINED");
			if (StringUtils.isBlank(logined) || "false".equals(logined)){
				CookieUtils.setCookie(response, "LOGINED", "true");
			}else if (StringUtils.equals(logined, "true")){
				UserUtils.getSubject().logout();
				return "redirect:" + adminPath + "/login";
			}
		}
		
		// 如果是手机登录，则返回JSON字符串
		if (principal.isMobileLogin()){
			if (request.getParameter("login") != null){
				return renderString(response, principal);
			}
			if (request.getParameter("index") != null){
				return "modules/sys/sysIndex";
			}
			return "redirect:" + adminPath + "/login";
		}
		
//		// 登录成功后，获取上次登录的当前站点ID
//		UserUtils.putCache("siteId", StringUtils.toLong(CookieUtils.getCookie(request, "siteId")));

//		System.out.println("==========================a");
//		try {
//			byte[] bytes = com.hlframe.common.utils.FileUtils.readFileToByteArray(
//					com.hlframe.common.utils.FileUtils.getFile("c:\\sxt.dmp"));
//			UserUtils.getSession().setAttribute("kkk", bytes);
//			UserUtils.getSession().setAttribute("kkk2", bytes);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
////		for (int i=0; i<1000000; i++){
////			//UserUtils.getSession().setAttribute("a", "a");
////			request.getSession().setAttribute("aaa", "aa");
////		}
//		System.out.println("==========================b");
		//
		if(Global.getBooleanValue("oa.start")) {
			OaNotify oaNotify = new OaNotify();
			oaNotify.setSelf(true);
			oaNotify.setReadFlag("0");
			Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify); 
			request.setAttribute("page", page);
			request.setAttribute("count", page.getList().size());//未读通知条数
		}
		
		if(Global.getBooleanValue("mail.start")) {
			//
			MailBox mailBox = new MailBox();
			mailBox.setReceiver(UserUtils.getUser());
			mailBox.setReadstatus("0");//筛选未读
			Page<MailBox> mailPage = mailBoxService.findPage(new MailPage<MailBox>(request, response), mailBox); 
			request.setAttribute("noReadCount", mailBoxService.getCount(mailBox));
			request.setAttribute("mailPage", mailPage);
		}
		
		if(Global.getBooleanValue("system.setSkin")) {
			// 默认风格
			String indexStyle = "default";
			Cookie[] cookies = request.getCookies();
			for (Cookie cookie : cookies) {
				if (cookie == null || StringUtils.isEmpty(cookie.getName())) {
					continue;
				}
				if (cookie.getName().equalsIgnoreCase("theme")) {
					indexStyle = cookie.getValue();
				}
			}
			// 要添加自己的风格，复制下面三行即可
			if (StringUtils.isNotEmpty(indexStyle)
					&& indexStyle.equalsIgnoreCase("ace")) {
				return "modules/sys/sysIndex-ace";
			}
			if (StringUtils.isNotEmpty(indexStyle)
					&& indexStyle.equalsIgnoreCase("shortcut")) {
				return "modules/sys/sysIndex-shortcut";
			}
			if (StringUtils.isNotEmpty(indexStyle)
					&& indexStyle.equalsIgnoreCase("sliding")) {
				return "modules/sys/sysIndex-sliding";
			}
		}
		
		return "modules/sys/sysIndex";
	}
	
	/**
	 * 获取主题方案
	 */
	@RequestMapping(value = "/theme/{theme}")
	public String getThemeInCookie(@PathVariable String theme, HttpServletRequest request, HttpServletResponse response){
		if (StringUtils.isNotBlank(theme)){
			CookieUtils.setCookie(response, "theme", theme);
		}else{
			theme = CookieUtils.getCookie(request, "theme");
		}
		return "redirect:"+request.getParameter("url");
	}
	
	/**
	 * 是否是验证码登录
	 * @param useruame 用户名
	 * @param isFail 计数加1
	 * @param clean 计数清零
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static boolean isValidateCodeLogin(String useruame, boolean isFail, boolean clean){
		Map<String, Integer> loginFailMap = (Map<String, Integer>)CacheUtils.get("loginFailMap");
		if (loginFailMap==null){
			loginFailMap = Maps.newHashMap();
			CacheUtils.put("loginFailMap", loginFailMap);
		}
		Integer loginFailNum = loginFailMap.get(useruame);
		if (loginFailNum==null){
			loginFailNum = 0;
		}
		if (isFail){
			loginFailNum++;
			loginFailMap.put(useruame, loginFailNum);
		}
		if (clean){
			loginFailMap.remove(useruame);
		}
		return loginFailNum >= 3;
	}
	
	
	/**
	 * @方法名称: home 
	 * @实现功能: 登录首页调整
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws IOException
	 * @create by peijd at 2017年3月17日 下午1:54:36
	 */
	@RequestMapping(value = "${adminPath}/home")
	public String home(HttpServletRequest request, HttpServletResponse response, Model model) throws IOException {
		
		//统计元数据信息 
		Map<String, String> metaDataMap = metaDataService.buildHomePageStatMap();
//		String fileNum = metaDataMap.get("metaData_file"), folderNum = metaDataMap.get("metaData_folder");
		model.addAttribute("metaData_totle", metaDataMap.get("metaData_totle"));	//元数据总数
		model.addAttribute("metaData_table", metaDataMap.get("metaData_table"));	//数据表
		model.addAttribute("metaData_file", metaDataMap.get("metaData_file"));		//文件
		model.addAttribute("metaData_intfc", metaDataMap.get("metaData_intfc"));	//接口
		int metaData_totle = Integer.parseInt(metaDataMap.get("metaData_totle"));
		if(metaData_totle<=0){
			model.addAttribute("rate_table", 0);	//数据表	比例
			model.addAttribute("rate_file", 0);		//文件 比例
			model.addAttribute("rate_intfc", 0);	//接口 比例
			
		}else{
			model.addAttribute("rate_table", Math.round(Integer.parseInt(metaDataMap.get("metaData_table"))*100/metaData_totle));	//数据表	比例
			model.addAttribute("rate_file", Math.round(Integer.parseInt(metaDataMap.get("metaData_file"))*100/metaData_totle));		//文件 比例
			model.addAttribute("rate_intfc", Math.round(Integer.parseInt(metaDataMap.get("metaData_intfc"))*100/metaData_totle));	//接口 比例
		}
		model.addAttribute("metaData_trend_date", metaDataMap.get("dateArr"));		//数据增长趋势_日期
		model.addAttribute("metaData_trend_num", metaDataMap.get("numArr"));		//数据增长趋势_数值
	
		//统计任务信息
		Map<String, String> taskStatMap = taskService.buildHomePageStatMap();
		model.addAttribute("task_totle", taskStatMap.get("task_totle"));			//总任务数
		model.addAttribute("task_extract", taskStatMap.get("task_extract"));		//数据采集
		model.addAttribute("task_translate", taskStatMap.get("task_translate"));	//数据转换
		model.addAttribute("task_load", taskStatMap.get("task_load"));				//数据导出
		int task_totle = Integer.parseInt(taskStatMap.get("task_totle"));
		if(task_totle<=0){
			model.addAttribute("rate_extract", 0);		//数据采集
			model.addAttribute("rate_translate", 0);	//数据转换
			model.addAttribute("rate_load", 0);			//数据导出
			
		}else{
			model.addAttribute("rate_extract", Math.round(Integer.parseInt(taskStatMap.get("task_extract"))*100/task_totle));		//数据采集
			model.addAttribute("rate_translate", Math.round(Integer.parseInt(taskStatMap.get("task_translate"))*100/task_totle));	//数据转换
			model.addAttribute("rate_load", Math.round(Integer.parseInt(taskStatMap.get("task_load"))*100/task_totle));				//数据导出
		}
		model.addAttribute("task_chart_hour", taskStatMap.get("task_hour"));				//任务统计时间轴
		model.addAttribute("task_chart_extract", taskStatMap.get("task_hour_extract"));		//数据采集chart
		model.addAttribute("task_chart_translate", taskStatMap.get("task_hour_translate"));	//数据转换chart
		model.addAttribute("task_chart_load", taskStatMap.get("task_hour_load"));			//数据加载chart
		 
		return "modules/sys/sysHome";
		
	}
	
	/**
	 * @Title: top
	 * @author gaofeng
	 * @Description: shortcut头部菜单请求
	 * @return String
	 * @throws
	 */
	@RequestMapping(value  = "${adminPath}/shortcut_top")
	public String shortcut_top(HttpServletRequest request, HttpServletResponse response, Model model) throws IOException {
		/*TSUser user = ResourceUtil.getSessionUserName();
		HttpSession session = ContextHolderUtils.getSession();
		// 登陆者的权限
		if (user.getId() == null) {
			session.removeAttribute(Globals.USER_SESSION);
			return new ModelAndView(
					new RedirectView("loginController.do?login"));
		}
		request.setAttribute("menuMap", getFunctionMap(user));
		List<TSConfig> configs = userService.loadAll(TSConfig.class);
		for (TSConfig tsConfig : configs) {
			request.setAttribute(tsConfig.getCode(), tsConfig.getContents());
		}*/
		return "modules/sys/shortcut_top";
	}
	
	
	
}

