package com.hlframe.modules.dc.datasearch.web;


import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.MediaType;

import com.hlframe.modules.dc.dataprocess.entity.DcHdfsFile;
import com.hlframe.modules.dc.dataprocess.entity.DcHdfsFileLook;
import com.hlframe.modules.dc.dataprocess.service.DcHdfsFileLookService;
import com.hlframe.modules.dc.metadata.entity.*;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.dc.neo4j.service.Neo4jService;
import com.hlframe.modules.dc.utils.DcStringUtils;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.core.util.MultivaluedMapImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.hlframe.common.json.AjaxJson;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.dataprocess.entity.DcTransDataSub;

import com.hlframe.modules.dc.dataprocess.service.DcTransDataSubService;
import com.hlframe.modules.dc.datasearch.entity.DcSearchLabel;
import com.hlframe.modules.dc.datasearch.entity.DcSearchParam;
import com.hlframe.modules.dc.datasearch.service.DataSearchService;
import com.hlframe.modules.dc.datasearch.service.DcSearchLabelService;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import com.hlframe.modules.dc.metadata.service.DcObjectLinkService;
import com.hlframe.modules.dc.neo4j.entity.Neo4j;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.sys.entity.User;
import com.hlframe.modules.sys.utils.UserUtils;
import com.sun.jersey.api.client.Client;

/**
 * @类名: DataSearchController
 * @职责说明: 数据搜索处理
 * @创建者: cdd
 * @创建时间: 2016年11月5日 下午3:10:11
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/dataSearch/retrieval")
public class DataSearchController extends BaseController{

	/**
	 * create by yzh at 2017/1/4
	 */
	@Autowired
	private DcTransDataSubService dcTransDataSubService;

	@Autowired
	private DataSearchService dataSearchService;

	@Autowired
	private DcObjectAuService dcObjectAuService;
	@Autowired
	private DcHdfsFileLookService dcHdfsFileLookService;
	@Autowired
	private DcSearchLabelService labelService;	//数据标签关系Service
	@Autowired
	private DcObjectLinkService dcObjectLinkService;
	@Autowired
	private Neo4jService neo4jService;
	@Autowired
	private DcObjectMainService mainService;

	//@RequiresPermissions("es:retrieval:index")
	@RequestMapping(value = {"index"})
	public String index(User user, Model model) {
		return "modules/dc/dataSearch/retrievalIndex";
	}

	//@RequiresPermissions("es:retrieval:index")
	@ResponseBody
    @RequestMapping(value = {"findData"})
	public AjaxJson  findData(DcSearchParam param, Model model) throws Exception {
		 AjaxJson ajaxJson = new AjaxJson();
	        if(0==param.getPageSize() ){
	            param.setPageSize(Integer.parseInt(DcPropertyUtils.getProperty("extractdb.preview.datanum", "20")));
	        }
	        if(1>param.getPageNo()){
	            param.setPageNo(1);
	        }
	        Map<String,Object> searchMap  = dataSearchService.findDataByName(param);
	        List<Map<String,Object>>  categoryTree = dataSearchService.getCategoryTree();
	        ajaxJson.put("searchMap", searchMap);
	        ajaxJson.put("categoryTree", categoryTree);
	        ajaxJson.put("count", searchMap.get("count"));
	        ajaxJson.put("pageNum", searchMap.get("pageNum"));
	        model.addAttribute("result_flag", "Y");
	        return ajaxJson;
	}

	/**
	 *
	 * @方法名称: getSQL
	 * @实现功能: 查看转换语句
	 * @param id
	 * @param model
	 * @return
	 * @create by yuzh at 2017年1月4日 上午10:40:11
	 */
	@RequestMapping(value = {"getSQL"})
	public String getSQL(String id,Model model){
		DcTransDataSub dcTransDataSub = new DcTransDataSub();

		DcObjectLink dcObjectLink = new DcObjectLink();
		dcObjectLink.setProcessId(id);

		String transSql = dcObjectLinkService.get(dcObjectLink).getOutputScript();
		if(StringUtils.isNotBlank(transSql)){
			dcTransDataSub.setTransSql(transSql);
		}
		model.addAttribute("dcTransDataSub",dcTransDataSub);
		return "modules/dc/dataSearch/retrielalViewSQL";
	}


	/**
	 *
	 * @方法名称: view
	 * @实现功能: TODO
	 * @param name
	 * @param model
	 * @return
	 * @create by
	 * @update by yuzh at 2017年1月4日 上午10:33:57
	 */
	//@RequiresPermissions("es:retrieval:view")
	@RequestMapping(value = {"view"})
	public String view(String name, Model model,String id,Neo4j neo4j,HttpServletResponse response) throws Exception {

		DcObjectMain dcObjectMain = mainService.get(id);

		if(dcObjectMain!=null){
			DcHdfsFile  dcHdfsFile=new DcHdfsFile();
			DcHdfsFileLook dcHdfsFileLook=new DcHdfsFileLook();
			dcHdfsFileLook.setTempPath(dcObjectMain.getObjName());
			dcHdfsFileLook.setFolderName("");
			dcHdfsFileLook.setPathName("");
			  List<Map<String, Object>> dcObjectFeildList = dataSearchService.getFieldDataById(dcObjectMain.getJobId());
			  //数据预览
			  List<Map<String, Object>> jobList = dataSearchService.previewDbData(dcObjectMain.getId());

			  //文件读取
			dcHdfsFileLookService.JSopenFile(dcObjectMain.getObjName(),dcHdfsFile);

			List<DcHdfsFileLook> list=dcHdfsFileLookService.findListfile(dcHdfsFileLook);
			  Client client = Client.create();
			  try {
				  String curUserId = UserUtils.getUser().getId();
				  List<DcSysObjm> sysObjList = dcObjectAuService.getAccreList(curUserId, null);
				  List<String> hlist = new ArrayList<String>();
				  for (DcSysObjm map : sysObjList) {
					  if (StringUtils.isNotBlank(map.getObjMainId()))
						  hlist.add(map.getObjMainId());
				  }

				  //如果是当前用户创建, 则拥有所有权限  baog gang
				  if (curUserId.equals(dcObjectMain.getCreateBy().getId())) {
					  dcObjectMain.setAccre(1);

				  } else {    //申请过权限的
					  for (String str : hlist) {
						  if (StringUtils.isNotBlank(dcObjectMain.getId()) && dcObjectMain.getId().equals(str)) {
							  dcObjectMain.setAccre(1);
						  }
					  }
				  }


				} catch (Exception e) {
					logger.error("-->view", e);
				}
				try {
                    String result = neo4jService.getObjsAndLinksById(dcObjectMain.getId());
//					URI u = new URI("http://" + DcPropertyUtils.getProperty("jersey.neo4j") + "/rest/neo4J/getData");
//					WebResource resource = client.resource(u);
//					MultivaluedMapImpl params = new MultivaluedMapImpl();
//					params.add("data", name);
//					String result = resource.type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, params);
				  model.addAttribute("graphData", result);
				  // neo4jservice.queryHiveSql(neo4j);
			  } catch (Exception e) {
				  logger.error("-->view", e);
				  model.addAttribute("graphData", "''");
			  }

			  //neo4jservice.queryHiveSql(dcObjectMain.getDbName(), dcObjectMain.getId(), dcObjectMain.getDbName(), dcObjectMain.getDbName(), dcObjectMain.getObjName());

			  model.addAttribute("columnList", jobList);    //数据预览
			  model.addAttribute("dcObjectMain", dcObjectMain);// 表信息
			  model.addAttribute("dcObjectFeildList", dcObjectFeildList);// 字段信息
			  model.addAttribute("hdfsFile",dcHdfsFile);//文件信息预览
			 model.addAttribute("list",list);//文件夹预览
			  //添加标签信息  modify by peijd 0327
			  List<DcSearchLabel> labelList = labelService.findLabelListByObjId(dcObjectMain.getId());
			  model.addAttribute("objLabelList", labelList);
		  }

		return "modules/dc/dataSearch/retrievalView";
	}


	/**
	 *
	 * @方法名称: view
	 * @实现功能: 下载文件或打包目录
	 * @param objType
	 * @param id
	 * @param line
	 * @return
	 * @create by hgw
	 */
	@RequestMapping(value = {"exportFileOrZip"})
	public String exportFileOrZip(String objType,String id,String line, HttpServletResponse response,Model model) throws Exception{
		String name = null;
		//2是文件 5是文件夹
		if("文件".equals(objType)){
			DcObjectFile dcObjectFile = dcHdfsFileLookService.getFile(id);
			name = dcObjectFile.getFileUrl().replaceFirst("hdfs://"+DcPropertyUtils.getProperty("hdfs.datanode.address"), "");
			boolean flag = dataSearchService.exportFile(id,line,response);
			if(!flag){
				model.addAttribute("message", "文件超出大小不允许下载");
			}
		}else if("文件夹".equals(objType)){
			DcObjectFolder dcObjectFolder = dcHdfsFileLookService.getFolder(id);
			name = dcObjectFolder.getFolderUrl();
			dataSearchService.exportZip(id,response);
			model.addAttribute("message", "niwagnl");
		}
		DcObjectMain dcObjectMain  = dataSearchService.findDataByObjName(name);
		List<Map<String,Object>>  dcObjectFeildList = dataSearchService.getFieldDataById(name);


		Client client = Client.create();
		try{
			URI u = new URI("http://"+DcPropertyUtils.getProperty("jersey.neo4j")+"/rest/neo4J/getData");
			WebResource resource = client.resource(u);
			MultivaluedMapImpl params = new MultivaluedMapImpl();
			params.add("data", name);
			String result = resource.type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class,params);
			model.addAttribute("graphData",result);
		}catch(Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("dcObjectMain",dcObjectMain);//表信息
		model.addAttribute("dcObjectFeildList",dcObjectFeildList);//字段信息
		return "modules/dc/dataSearch/retrievalView";
	}
	@ResponseBody
	@RequestMapping(value = "getAu")
	public AjaxJson getAu(DcObjectMain obj,String fileId, RedirectAttributes redirectAttributes){
		AjaxJson ajaxJson = new AjaxJson();
		DcObjectAu dcObjectAu = new DcObjectAu();
		dcObjectAu.setUserId(UserUtils.getUser().getId());
		dcObjectAu.setFileId(obj.getId());
		dcObjectAu.setStatus("未处理");
		dcObjectAu.setFrom("1");
     if(DcStringUtils.isNotNull(dcObjectAuService.get(dcObjectAu))){
		 ajaxJson.setMsg("等待审批!");
	 }else {
//		 dataSearchService.getAu(mainService.get(obj));
		 ajaxJson.setMsg("已向管理员申请该任务操作权限!");
	 }
		return ajaxJson;
	}

}
