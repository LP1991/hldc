/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.dc.dataprocess.web;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.hlframe.modules.dc.utils.Des;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.hlframe.common.config.Global;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.utils.excel.ExportExcel;
import com.hlframe.common.utils.excel.ImportExcel;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.entity.DcJobHdfslog;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransFile;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransFileHdfs;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransFileHdfsService;
import com.hlframe.modules.dc.dataprocess.service.DcJobTransFileService;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;

/**
 * 采集传输文件Controller
 * @author phy
 * @version 2016-11-23
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/transJobFile")
public class DcJobTransFileController extends BaseController {

	@Autowired
	private DcJobTransFileService dcJobTransFileService;
	@Autowired
	private DcJobTransFileHdfsService dcJobTransFileHdfsService;

	@Autowired
	private DcTaskTimeService dcTaskTimeService;

	@ModelAttribute
	public DcJobTransFile get(@RequestParam(required=false) String id) {
		DcJobTransFile entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcJobTransFileService.get(id);
		}
		if (entity == null){
			entity = new DcJobTransFile();
		}
		return entity;
	}

	/**
	 * 采集传输文件列表页面
	 */
	@RequiresPermissions("dc:dataProcess:dcJobTransFile:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcJobTransFile dcJobTransFile, HttpServletRequest request, HttpServletResponse response, Model model) {
		model.addAttribute("dcJobTransFile", dcJobTransFile);
		return "modules/dc/dataProcess/dcJobTransFile/dcJobTransFileList";
	}

	/**
	 * 采集传输文件列表页面
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public DataTable ajaxlist(DcJobTransFile dcJobTransFile, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcJobTransFile> page = dcJobTransFileService.findPage(new Page<DcJobTransFile>(request), dcJobTransFile);
		List<DcJobTransFile> list = page.getList();

		DataTable a = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(list));
		return a;
	}

	/**
	 * 查看，增加，编辑采集传输文件表单页面
	 */
	@RequiresPermissions(value={"dc:dataProcess:dcJobTransFile:view","dc:dataProcess:dcJobTransFile:add","dc:dataProcess:dcJobTransFile:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DcJobTransFile dcJobTransFile, Model model) {
		if(dcJobTransFile.getDcJobTransFileHdfs()==null){
			DcJobTransFileHdfs dcJobTransFileHdfs = new DcJobTransFileHdfs();
			dcJobTransFileHdfs.setPort(21);
			dcJobTransFile.setDcJobTransFileHdfs(dcJobTransFileHdfs);
		}
		model.addAttribute("dcJobTransFile", dcJobTransFile);
		return "modules/dc/dataProcess/dcJobTransFile/dcJobTransFileForm";
	}
	/**
	 * 查看，增加，编辑采集传输文件表单页面
	 */
	@RequestMapping(value = "logForm")
	public String logForm(String id, Model model) {
		DcJobHdfslog dcJobHdfslog = new DcJobHdfslog();
		dcJobHdfslog.setJobId(id);
		List<DcJobHdfslog> dcJobHdfslogs = dcJobTransFileService.getHdfslogs(dcJobHdfslog);
		model.addAttribute("dcJobHdfslogs", dcJobHdfslogs);
		return "modules/dc/dataProcess/dcJobTransFile/dcJobTransFileLogForm";
	}

	/**
	 * 保存采集传输文件
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public AjaxJson ajaxSave(DcJobTransFile dcJobTransFile, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		if (!beanValidator(model, dcJobTransFile)){
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("验证失败！");
			return ajaxJson;
		}
		dcJobTransFileService.save(dcJobTransFile);//保存
		dcJobTransFile.getDcJobTransFileHdfs().setJobId(dcJobTransFile.getId());
		if(dcJobTransFileHdfsService.get(dcJobTransFile.getId())==null){
			dcJobTransFileHdfsService.save(dcJobTransFile.getDcJobTransFileHdfs());
		}else{
			dcJobTransFileHdfsService.update(dcJobTransFile.getDcJobTransFileHdfs());
		}
		ajaxJson.setMsg("保存采集传输文件'" + dcJobTransFile.getJobname() + "'成功!");
		return ajaxJson;
	}

	/**
	 * 检查job名称不重复
	 */
	@ResponseBody
	@RequestMapping(value = "checkJobName")
	public String checkJobName(String oldJobname, String jobname) {
		if (jobname !=null && jobname.equals(oldJobname)) {
			return "true";
		} else if (jobname !=null && dcJobTransFileService.getJobName(jobname) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * job功能测试
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "FTPuploadToHDFS")
	public AjaxJson ftpUploadToHDFS(DcJobTransFile dcJobTransFile, RedirectAttributes redirectAttributes) throws Exception{
		DcDataResult result = dcJobTransFileService.runTask(dcJobTransFile.getId());
		AjaxJson ajaxJson = new AjaxJson();
		ajaxJson.setMsg(result.getRst_flag()?result.getRst_std_msg():result.getRst_err_msg());
		return ajaxJson;
	}


	/**
	 * 删除采集传输文件
	 */
	@ResponseBody
	@RequestMapping(value = "ajaxDelete")
	public AjaxJson ajaxDelete(DcJobTransFile dcJobTransFile, RedirectAttributes redirectAttributes) {
		AjaxJson ajaxJson = new AjaxJson();
		try {

			dcJobTransFileService.delete(dcJobTransFile);
			ajaxJson.setMsg("删除数据对象成功!");
		} catch (Exception e) {
			ajaxJson.setSuccess(false);
			ajaxJson.setMsg("删除数据对象失败! "+e.getMessage());
			logger.error("-->ajaxDelete: ", e);
		}
		return ajaxJson;
	}
	/**
	 * 批量删除采集传输文件
	 */
	@RequiresPermissions("dc:dataProcess:dcJobTransFile:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			dcJobTransFileService.delete(dcJobTransFileService.get(id));
		}
		addMessage(redirectAttributes, "删除采集传输文件成功");
		return "redirect:"+Global.getAdminPath()+"/dataprocess/dcJobTransFile/?repage";
	}

	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("dc:dataProcess:dcJobTransFile:export")
	@RequestMapping(value = "export", method=RequestMethod.POST)
	public String exportFile(DcJobTransFile dcJobTransFile, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "采集传输文件"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
			Page<DcJobTransFile> page = dcJobTransFileService.findPage(new Page<DcJobTransFile>(request, response, -1), dcJobTransFile);
			new ExportExcel("采集传输文件", DcJobTransFile.class).setDataList(page.getList()).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出采集传输文件记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dataprocess/dcJobTransFile/?repage";
	}

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("dc:dataProcess:dcJobTransFile:import")
	@RequestMapping(value = "import", method=RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<DcJobTransFile> list = ei.getDataList(DcJobTransFile.class);
			for (DcJobTransFile dcJobTransFile : list){
				try{
					dcJobTransFileService.save(dcJobTransFile);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条采集传输文件记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条采集传输文件记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入采集传输文件失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dataprocess/dcJobTransFile/?repage";
	}

	/**
	 * 下载导入采集传输文件数据模板
	 */
	@RequiresPermissions("dc:dataProcess:dcJobTransFile:import")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "采集传输文件数据导入模板.xlsx";
			List<DcJobTransFile> list = Lists.newArrayList();
			new ExportExcel("采集传输文件数据", DcJobTransFile.class, 1).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/dataprocess/dcJobTransFile/?repage";
	}

	/**
	 * @方法名称: scheduleForm
	 * @实现功能: 调度设置表单
	 * @param file		文件采集对象
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年11月27日 上午10:44:14
	 */
	@RequestMapping(value = "scheduleForm")
	public String scheduleForm(DcJobTransFile file, HttpServletRequest request, Model model) {

		DcTaskTime param  = new DcTaskTime();
		//根据分类和ID查找  调度设置
		param.setTaskfromid(file.getId());
		param.setTaskfromtype(DcTaskMain.TASK_FROMTYPE_EXTRACT_FILE);
		List<DcTaskTime> taskList = dcTaskTimeService.findList(param);

		//没有对象则新建, 否则编辑
		if(CollectionUtils.isEmpty(taskList)){
			param.setScheduleName("文件数据采集任务_"+file.getJobname());		//任务名
			param.setScheduleDesc("文件数据采集任务_"+file.getDescription());	//描述
			param.setTaskfromname(file.getDescription());					//任务描述
		}else{
			param = taskList.get(0);
		}
		//采集任务表单
		model.addAttribute("formData", param);

		return "modules/dc/dataProcess/dcJobTransData/dcJobSchedule";
	}

	/**
	 * @方法名称: add2Schedule
	 * @实现功能: 添加至调度任务
	 * @param jobId
	 * @param request
	 * @param model
	 * @return
	 * @create by peijd at 2016年12月27日 下午8:45:58
	 */
	@ResponseBody
	@RequestMapping(value = "add2Schedule")
	public AjaxJson add2Schedule(String jobId, HttpServletRequest request, Model model) {
		AjaxJson ajaxJson = new AjaxJson();
		try {
			String msg = dcJobTransFileService.add2Schedule(jobId);
			ajaxJson.setMsg(msg);
		} catch (Exception e) {
			ajaxJson.setMsg("调度任务创建失败!</br>");
			logger.error("-->add2Schedule", e);
		}
		return ajaxJson;
	}

	/**
	 * @方法名称: testTransFile
	 * @实现功能: 添加至调度任务
	 * @param dcJobTransFile
	 * @return
	 * @create by hgw at 2016年2月15日 下午15:16
	 */
	@ResponseBody
	@RequestMapping(value = "testTransFile")
	public AjaxJson testTransFile(DcJobTransFile dcJobTransFile){
		AjaxJson ajaxJson = new AjaxJson();
		Socket socket = new Socket();
		try {
			socket.connect(new InetSocketAddress(dcJobTransFile.getDcJobTransFileHdfs().getIp(), dcJobTransFile.getDcJobTransFileHdfs().getPort()));
			FTPClient ftpClient = new FTPClient();
			//
			ftpClient.setDefaultPort(dcJobTransFile.getDcJobTransFileHdfs().getPort());
			ftpClient.connect(dcJobTransFile.getDcJobTransFileHdfs().getIp());
			ftpClient.setControlEncoding("utf-8");
			ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
			ftpClient.login(dcJobTransFile.getDcJobTransFileHdfs().getAccount(), Des.strDec(dcJobTransFile.getDcJobTransFileHdfs().getPassword()));
			ftpClient.enterLocalActiveMode();
			String pathname = dcJobTransFile.getDcJobTransFileHdfs().getPathname();//路径规则 根目录不需要/
			boolean flag = false;

			if(StringUtils.isNoneEmpty(pathname)){
				pathname = pathname.replaceAll("ftp://"+dcJobTransFile.getDcJobTransFileHdfs().getIp()+""+dcJobTransFile.getDcJobTransFileHdfs().getPort()+"/","");
				if(pathname.startsWith("/")){
					pathname=pathname.replaceFirst("/","./");
				}
				pathname = new String(pathname.getBytes("utf-8"),"iso-8859-1");
				flag = ftpClient.changeWorkingDirectory(pathname);
			}

			if(flag){
				ajaxJson.setMsg("ftp连接成功");
			}else{
				ajaxJson.setMsg("ftp路径连接失败");
			}
		} catch (IOException e) {
			e.printStackTrace();
			ajaxJson.setMsg("ip和端口连接失败");
		} finally {
			try {
				socket.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return ajaxJson;
	}

	@ResponseBody
	@RequestMapping(value="FtpPathTreeData")
	public List<Map<String,Object>> FtpPathTreeData(HttpServletRequest request,String dcJobTransFile){
		String otherParam1 = request.getParameter("otherParam1");
		String otherParam2 = request.getParameter("otherParam2");
		String otherParam3 = request.getParameter("otherParam3");
		String otherParam4 = request.getParameter("otherParam4");
		return dcJobTransFileService.treeData(otherParam1,otherParam2,otherParam3,otherParam4);
	}
}