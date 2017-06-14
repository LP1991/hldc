package com.hlframe.modules.dc.dataprocess.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataprocess.entity.DcHdfsFile;
import com.hlframe.modules.dc.dataprocess.entity.DcHdfsFileLook;
import com.hlframe.modules.dc.dataprocess.service.DcHdfsFileLookService;
import com.hlframe.modules.dc.dataprocess.service.DcHdfsFileService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;

/** 
 * @类名: com.hlframe.modules.dc.dataprocess.web.DcHdfsFileLookController.java 
 * @职责说明: hdfs文件远程获取处理Controller
 * @创建者: huanggw
 * @创建时间: 2017年02月16日 下午3:16:49
 */

@Controller
@RequestMapping(value = "${adminPath}/dc/dataProcess/hdfsLook")
public class DcHdfsFileLookController  extends BaseController{
	@Autowired
	private DcHdfsFileLookService dcHdfsFileLookService;
	
	@Autowired
	private DcHdfsFileService dcHdfsFileService;
	
	@ModelAttribute
	public DcHdfsFileLook get(@RequestParam(required=false) String id) {
		System.out.println("____"+DcPropertyUtils.getProperty("queryHive.result.count"));
		DcHdfsFileLook entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcHdfsFileLookService.get(id);
		}
		if (entity == null){
			entity = new DcHdfsFileLook();
		}
		return entity;
	}
	
	/**
	 * 采集传输文件列表页面
	 */
	@RequiresPermissions("dc:dataProcess:dcHdfsFileLook:list")
	@RequestMapping(value = {"list", ""})
	public String list(DcHdfsFileLook dcHdfsFileLook, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsList";
	}
	
	@ResponseBody
	@RequestMapping(value = "ajaxlist")
	public AjaxJson ajaxlist(DcHdfsFileLook dcHdfsFileLook,HttpServletRequest request,Model model){
		//其中dcHdfsFileLook可能包含查询条件
		Page<DcHdfsFileLook> page = dcHdfsFileLookService.findFtpList(new Page<DcHdfsFileLook>(request),dcHdfsFileLook);
		//往ajaxjson存放入数据
		DataTable a = new DataTable();
		//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
		a.setDraw(Integer.parseInt(request.getParameter("draw")==null?"0":request.getParameter("draw")));
		//必要，即没有过滤的记录数（数据库里总共记录数）
		a.setRecordsTotal((int)page.getCount());
		//必要，过滤后的记录数  不使用自带查询框就没计算必要，与总记录数相同即可
		a.setRecordsFiltered((int)page.getCount());
		a.setLength(page.getPageSize());
		Gson gson = new Gson();
		a.put("gson",gson.toJson(page.getList()));
		return a;
	}
	
	//查看文件
	@RequestMapping(value="openHdfsFile")
	public String openHdfsFile(DcHdfsFile file,String line,HttpServletRequest request, HttpServletResponse response) throws Exception{
		try {
			String filePath = "hdfs://"+DcPropertyUtils.getProperty("hadoop.main.address")+file.getFilePath();
			file.setFilePath(filePath);
			dcHdfsFileLookService.openFile(file.getFilePath(),response);
		} catch (Exception e) {
			logger.error("--->openHdfsFile", e);
		}
		return "modules/dc/dataProcess/dcJobTransLookHdfs/openHdfsFileView";
	}
	
	//到重命名界面
	@RequestMapping(value = "toRename")
	public String toRename(DcHdfsFileLook dcHdfsFileLook,Model model){
		model.addAttribute("isShow", "0");
		model.addAttribute("dcHdfsFileLook", dcHdfsFileLook);
		return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsForm";
	}
	
	@RequestMapping(value="save")
	public String save(String pathName,String folderName,String oldName,String Content,Model model, RedirectAttributes redirectAttributes){
		//文件名前面的路径
		String temp = pathName.substring(0,pathName.lastIndexOf("/"));
		//重命名后的路径
		String newName = pathName.substring(0,pathName.lastIndexOf("/"))+"/"+folderName;
		boolean flag = dcHdfsFileLookService.toReName(pathName, newName);
		if(flag){
			//addMessage(redirectAttributes, "重命名成功");
			model.addAttribute("message","重命名成功");
		}else{
			//addMessage(redirectAttributes, "重命名失败");
			model.addAttribute("message","重命名失败");
		}
		DcHdfsFileLook dcHdfsFileLook = new DcHdfsFileLook();
		dcHdfsFileLook.setTempPath(temp);
		dcHdfsFileLook.setPathName(temp);
		model.addAttribute("dcHdfsFileLook", dcHdfsFileLook);
		//return "redirect:"+Global.getAdminPath()+"/dc/dataProcess/hdfsLook/?repage";
		return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsList";
	}
	
	//下载
	@RequestMapping(value="exportHdfsFile")
	public void exportHdfsFile(DcHdfsFile file,String line,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String fileName = file.getFileName();
		String fileType = fileName.substring(fileName.lastIndexOf(".")+1, fileName.length());
		//加载文件内容
		dcHdfsFileService.loadFileContent(file , line);
		byte[] data = file.getContent().getBytes("UTF-8");
		response.reset();
		if("pdf".equals(fileType)){
			response.setContentType("application/pdf;charset=UTF-8");
		}else if("xlsx".equals(fileType)){
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8");
		}else if("xls".equals(fileType)){
			response.setContentType("application/vnd.ms-excel;charset=UTF-8");
		}else{
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
		response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(file.getFileName().getBytes("utf-8"),"ISO-8859-1") + "\"");
		response.addHeader("Content-Length", "" + data.length);
		dcHdfsFileLookService.downloadT(file.getFilePath(),response);
		response.flushBuffer();
	}
	
	@RequestMapping(value="uploads")
	public String uploads(DcHdfsFileLook dcHdfsFileLook,Model model){
		model.addAttribute("dcHdfsFileLook", dcHdfsFileLook);
		return "modules/dc/dataProcess/dcJobTransLookHdfs/uploadView";
	}
	
	@RequestMapping(value="uploadSave")
	public String uploadsSave(DcHdfsFileLook dcHdfsFileLook,@RequestParam MultipartFile[] uploadfiles,Model model){
		boolean flag = dcHdfsFileLookService.uploads(dcHdfsFileLook,uploadfiles);
		//boolean flag=true;
		if(flag){
			//addMessage(redirectAttributes,"上传成功");
			model.addAttribute("message", "上传成功");
		}else{
			//addMessage(redirectAttributes,"上传失败");
			model.addAttribute("message", "上传失败");
		}
		String temp = dcHdfsFileLook.getTempPath();
		if(temp.length()>1){
			temp = temp.replace(" ", "");
		}
		dcHdfsFileLook.setTempPath(temp);
		model.addAttribute("dcHdfsFileLook", dcHdfsFileLook);
		//return "redirect:"+Global.getAdminPath()+"/dc/dataProcess/hdfsLook/?repage";
		return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsList";
	}

	@RequestMapping(value="NewDirOrFile")
	public String NewDirOrFile(DcHdfsFileLook dcHdfsFileLook,String Content,String isDir2,Model model){
		boolean flag = dcHdfsFileLookService.isDirOrFile(dcHdfsFileLook,isDir2,Content);
		if(flag){
			//addMessage(redirectAttributes,"上传成功");
			model.addAttribute("message", "创建成功");
		}else{
			//addMessage(redirectAttributes,"上传失败");
			model.addAttribute("message", "创建失败");
		}
		//返回页面查询条件
		String temp = dcHdfsFileLook.getTempPath();
		if(temp.length()>1){
			temp = temp.replace(" ", "");
		}
		DcHdfsFileLook dcHdfsFileLook2 = new DcHdfsFileLook();
		dcHdfsFileLook2.setTempPath(temp);
		model.addAttribute("dcHdfsFileLook", dcHdfsFileLook2);
		return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsList";
	}
	
	@RequestMapping(value="create")
	public String create(DcHdfsFileLook dcHdfsFileLook,String fileordir,Model model){
			model.addAttribute("isShow", "1");
			model.addAttribute("fileordir", fileordir);
			model.addAttribute("dcHdfsFileLook", dcHdfsFileLook);
			return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsForm";
	}
	
	//移动文件或目录到回收站
	@RequestMapping(value="remove")
	public String remove(DcHdfsFileLook dcHdfsFileLook,String type,Model model){
		boolean flag = dcHdfsFileLookService.remove(dcHdfsFileLook,type);
		if(flag){
			model.addAttribute("message", "删除成功(恢复路径为/user/hdfs/.Trash/Current)");
		}else{
			model.addAttribute("message", "删除失败");
		}
		//返回页面查询条件
		String temp = dcHdfsFileLook.getTempPath();
		if(temp.length()>1){
			temp = temp.replace(" ", "");
		}
		DcHdfsFileLook dcHdfsFileLook2 = new DcHdfsFileLook();
		dcHdfsFileLook2.setTempPath(temp);
		model.addAttribute("dcHdfsFileLook", dcHdfsFileLook2);
		return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsList";
	}
	
	//彻底删除路径文件
	@RequestMapping(value="deletePath")
	public String deletePath(DcHdfsFileLook dcHdfsFileLook,String type,Model model){
		try {
			boolean flag = dcHdfsFileLookService.deletePath(dcHdfsFileLook,type);
			if(flag){
				model.addAttribute("message", "删除成功");
			}else{
				model.addAttribute("message", "删除失败");
			}
		} catch (Exception e) {
			model.addAttribute("message", "删除失败");
		}
		//返回页面查询条件
		String temp = dcHdfsFileLook.getTempPath();
		if(temp.length()>1){
			temp = temp.replace(" ", "");
		}
		DcHdfsFileLook dcHdfsFileLook2 = new DcHdfsFileLook();
		dcHdfsFileLook2.setTempPath(temp);
		model.addAttribute("dcHdfsFileLook", dcHdfsFileLook2);
		return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsList";
	}
	
	//批量移动文件到删除目录
	@RequestMapping(value="deleteAll")
	public String deleteA(String[] ids,DcHdfsFileLook dcHdfsFileLook,Model model){
		String Msg = dcHdfsFileLookService.deleteAll(ids,dcHdfsFileLook);
		model.addAttribute("message", Msg);
		//返回页面查询条件
		String temp = null;
		int num = ids[0].lastIndexOf("/");
		if(num>0){
			temp = ids[0].substring(0, ids[0].lastIndexOf("/")+1);
		}else{
			temp = "/";
		}
		DcHdfsFileLook dcHdfsFileLook2 = new DcHdfsFileLook();
		dcHdfsFileLook2.setTempPath(temp);
		model.addAttribute("dcHdfsFileLook", dcHdfsFileLook2);
		return "modules/dc/dataProcess/dcJobTransLookHdfs/dcJobTransLookHdfsList";
		
	}
}
