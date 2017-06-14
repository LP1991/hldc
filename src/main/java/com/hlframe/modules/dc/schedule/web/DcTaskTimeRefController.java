/********************** 版权声明 *************************
 * 文件名: DcTaskTimeController.java
 * 包名: com.hlframe.modules.dc.schedule.web
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:	
 ********************************************************
 *
 * 创建者：cdd  创建时间：2016年11月14日 下午2:31:46
 * 文件版本：V1.0 
 *
 *******************************************************/
package com.hlframe.modules.dc.schedule.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.schedule.entity.DcTaskTimeRef;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeRefService;
import com.hlframe.modules.dc.utils.QuartzUtil;


/** 
 * @类名: com.hlframe.modules.dc.schedule.web.DcTaskTimeController.java 
 * @职责说明: TODO
 * @创建者: cdd
 * @创建时间: 2016年11月14日 下午2:31:46
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/schedule/dcTaskTimeRef")
public class DcTaskTimeRefController extends BaseController {
	@Autowired
	private DcTaskTimeRefService dcTaskTimeRefService;
	  
/*	@Override//任务执行时
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		
		//dcTaskTimeRefService.invokeMethod(owner, methodName,args);
		TaskA();
	}*/

	
	/* @ModelAttribute("dcTaskTimeRef")
		public DcTaskTimeRef get(@RequestParam(required = false) String id) {
			if (StringUtils.isNotBlank(id)) {
				return dcTaskTimeRefService.get(id);
			} else {
				return new DcTaskTimeRef();
			}
		}*/
		@RequestMapping(value = {"index"})
		public String index( DcTaskTimeRef dcTaskTimeRef, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
			Page<DcTaskTimeRef> page = dcTaskTimeRefService.findPage(new Page<DcTaskTimeRef>(request, response), dcTaskTimeRef);
			model.addAttribute("page", page);
			/*List<DcTaskTimeRef> timeRefList = dcTaskTimeRefService.findList(dcTaskTimeRef);
			for(int i=0;i<timeRefList.size();i++){
				DcTaskTimeRef list = timeRefList.get(i);
				if(list.getParameter().length()==1){
				QuartzUtil.invokeMethod((Object)list.getClassName(), list.getMethodName(), (Object)list.getParameter());
				}else if(list.getParameter().length()!=1){
					//如果是列表，或者map数据进来时，怎么搞
				}
			}*/
			return "modules/dc/schedule/dcTaskTimeRefList";
		}
}
