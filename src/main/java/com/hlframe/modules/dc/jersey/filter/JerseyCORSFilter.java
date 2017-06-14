/********************** 版权声明 *************************
 * 文件名: JerseyCORSFilter.java
 * 包名: com.hlframe.modules.dc.jersey.filter
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：peijd   创建时间：2017年2月20日 上午11:59:42
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.jersey.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/** 
 * @类名: com.hlframe.modules.dc.jersey.filter.JerseyCORSFilter.java 
 * @职责说明: jersey跨域filter
 * @创建者: peijd
 * @创建时间: 2017年2月20日 上午11:59:42
 */
public class JerseyCORSFilter implements Filter {

	/**
	 * Default constructor.
	 */
	public JerseyCORSFilter() {
	}

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletResponse httpServletResponse = (HttpServletResponse) response;
		httpServletResponse.setHeader("Access-Control-Allow-Origin", "*");
		httpServletResponse.setHeader("Access-Control-Allow-Headers", "User-Agent,Origin,Cache-Control,Content-type,Date,Server,withCredentials,AccessToken");
		httpServletResponse.setHeader("Access-Control-Allow-Credentials", "true");
		httpServletResponse.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS, HEAD");
		httpServletResponse.setHeader("Access-Control-Max-Age", "1209600");
		httpServletResponse.setHeader("Access-Control-Expose-Headers", "accesstoken");
		httpServletResponse.setHeader("Access-Control-Request-Headers", "accesstoken");
		httpServletResponse.setHeader("Expires", "-1");
		httpServletResponse.setHeader("Cache-Control", "no-cache");
		httpServletResponse.setHeader("pragma", "no-cache");
		HttpServletRequest httpServletRequest = (HttpServletRequest) request;
		if (!"OPTIONS".equals(httpServletRequest.getMethod())) {// OPTIONS方法不要拦截，不然跨域设置不成功
			/*
			 * if(!authenize()){//校验 //do something return; }
			 */
		}

		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
	}
}
