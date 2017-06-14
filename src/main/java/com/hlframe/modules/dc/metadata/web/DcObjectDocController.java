package com.hlframe.modules.dc.metadata.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.metadata.entity.DcSysObjm;
import com.hlframe.modules.dc.metadata.service.DcObjectAuService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.hlframe.common.json.DataTable;
import com.hlframe.common.persistence.Page;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.sys.utils.UserUtils;

@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcObjectMainDoc")
public class DcObjectDocController {
	@Autowired
	private DcObjectMainService dcObjectMainService;
	@Autowired
	private DcObjectAuService authService;      //数据权限Service
	/**
	 * @方法名称: get
	 * @实现功能: 每次请求 构建对象
	 * @param id
	 * @return
	 * @create bao gang at 2017年4月20日 上午9:56:30
	 */
	@ModelAttribute("dcObjectMainDoc")
	public DcObjectMain get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return dcObjectMainService.get(id);
		} else {
			return new DcObjectMain();
		}
		
	}

	/**
	 * @方法名称: list
	 * @实现功能: 文件和文件夹对象列表
	 * @param obj
	 * @param model
	 * @return
	 * @createbao bao gang at 2016年11月8日 下午3:33:02
	 */
	@RequiresPermissions("dc:metadata:dcObjectMainDoc:list")
	@RequestMapping(value = { "list", "" })
	public String list(DcObjectMain obj, Model model) {
		List<DcObjectMain> list = dcObjectMainService.findList(obj);
		model.addAttribute("list", list);
		model.addAttribute("objectMain", obj);
		return "modules/dc/metaData/dcObjectMain/dcObjectMainDcoList";
	}

/**
 * @方法名称: ajaxlist
 * @实现功能: ajax分页列表
 * @param obj
 * @param request
 * @param response
 * @param model
 * @return
 * @create by bao gang  2017年4月20日 下午2 :15
 */
@ResponseBody
@RequestMapping(value = "ajaxlist")
public DataTable ajaxlist(DcObjectMain obj, HttpServletRequest request, HttpServletResponse response, Model model) {
	obj.setObjType(DcObjectMain.OBJ_TYPE_FILE+","+DcObjectMain.OBJ_TYPE_FOLDER);// 文件和文件夹
	Page<DcObjectMain> page = dcObjectMainService.findPage(new Page<DcObjectMain>(request), obj);

	List<DcObjectMain> list = page.getList();
	String curUserId = UserUtils.getUser().getId();
	//查询权限列表
	List<DcSysObjm> accreList = authService.getAccreList(curUserId, null);
	List<String> hlist = new ArrayList<String>();
	for (DcSysObjm map : accreList) {
		if (StringUtils.isNotBlank(map.getObjMainId()))
			hlist.add(map.getObjMainId());
	}
	for(DcObjectMain aaa:list){
		//如果是当前用户创建, 则拥有所有权限  baog gang
		if(curUserId.equals(aaa.getCreateBy().getId())){
			aaa.setAccre(1);
		
		}else{	//申请过权限的
			for(String str :hlist){
				if(StringUtils.isNotBlank(aaa.getId()) && aaa.getId().equals(str)){
					aaa.setAccre(1);
				}
			}
		}
	}
	
	// 转换类型
	// for (DcObjectMain item : list) {
	// item.setDataScope(DictUtils.getDictLabel(role2.getDataScope(),
	// "sys_data_scope", ""));
	// }
	DataTable a = new DataTable();
	// 绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）。 要求在服务器接收到此参数后再返回
	a.setDraw(Integer.parseInt(request.getParameter("draw") == null ? "0" : request.getParameter("draw")));
	// 必要，即没有过滤的记录数（数据库里总共记录数）
	a.setRecordsTotal((int) page.getCount());
	// 必要，过滤后的记录数 不使用自带查询框就没计算必要，与总记录数相同即可
	a.setRecordsFiltered((int) page.getCount());
	a.setLength(page.getPageSize());
	Gson gson = new Gson();
	a.put("gson", gson.toJson(list));
	return a;
}
/**
 * @方法名称: view
 * @实现功能: 查看数据对象或数据表对象
 * @param obj
 * @param model
 * @return
 * @create bao gang at 2017年4月20日 下午1:36:43
 */
@RequiresPermissions(value = { "dc:metadata:dcObjectMain:view" })
@RequestMapping(value = "dataView")
public String view(DcObjectMain obj, Model model, HttpServletRequest request) {

	

	model.addAttribute("objectMain", dcObjectMainService.tnadmin(obj.getId()));
	return "modules/dc/metaData/dcObjectMain/dcObjectMainView"; // 查看页面
}

}
