package com.hlframe.modules.dc.metadata.web;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.metadata.entity.DcObjectMain;
import com.hlframe.modules.dc.metadata.service.DcObjectMainService;
import com.hlframe.modules.dc.utils.DcCommonUtils;

/**
 * 元数据监控
 * @author hgw
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/metadata/dcObjectMainPie")
public class dcObjectMainPieController extends BaseController {
	private static final long serialVersionUID = -6886697421555222670L;
	
	@RequestMapping(value = {"index", ""})
	public String index( HttpServletRequest request, HttpServletResponse response, Model model) {
		//饼图
		Map<String,Object>  orientDataA = new HashMap<String,Object>();
		//柱形图
		List<String> xAxisData = new ArrayList<String>();
		Map<String,List<Double>> yAxisData = new HashMap<String,List<Double>>();
		//折线图
		List<String> xAxisData2 = new ArrayList<String>();
		Map<String,List<Double>> yAxisData2 = new HashMap<String,List<Double>>();
		StringBuffer resultSql = new StringBuffer(64);
		resultSql.append("select count(0) as count,obj_type  from dc_obj_main where obj_type in(1,2,3,4,5) and obj_type is not null group by obj_type");
		List<Map<String, Object>> resultlist = DcCommonUtils.queryDataBySql(resultSql.toString());
		
		//文件和文件夹
		int count=0;
		for(Map<String,Object> index:resultlist){
			String type = index.get("obj_type").toString();
			String counts = index.get("count").toString();
			if(DcObjectMain.OBJ_TYPE_FILE.equals(type)||DcObjectMain.OBJ_TYPE_FOLDER.equals(type)){
				count+=Integer.parseInt(counts);
			}
		}
		
		
		for(Map<String,Object> index:resultlist){
			String type = index.get("obj_type").toString();
			String counts = index.get("count").toString();
			if(DcObjectMain.OBJ_TYPE_TABLE.equals(type)){
				orientDataA.put("数据表", counts);
			}else if(DcObjectMain.OBJ_TYPE_FILE.equals(type)){//2 5
				orientDataA.put("文件", count);
			}else if(DcObjectMain.OBJ_TYPE_FIELD.equals(type)){
				//orientDataA.put("字段", counts);
			}else if(DcObjectMain.OBJ_TYPE_INTER.equals(type)){
				orientDataA.put("接口", counts);
			}else if(DcObjectMain.OBJ_TYPE_FOLDER.equals(type)){
				orientDataA.put("文件", count);
			}
		}
		request.setAttribute("orientDataA", orientDataA);
		//---------------------------------
		resultSql = new StringBuffer(64);
		resultSql.append("select count(0) as count ,db_type from dc_obj_main a left join dc_obj_table b on(a.ID=b.OBJ_ID) where a.obj_type=1 and b.db_type is not null  group by DB_TYPE");
		List<Map<String, Object>> barlist = DcCommonUtils.queryDataBySql(resultSql.toString());
		List<Double> data1 = new ArrayList<Double>();
		for(Map<String,Object> index:barlist){
				if(StringUtils.isNotEmpty(index.get("db_type").toString())){
					xAxisData.add(index.get("db_type").toString());
				}else{
					xAxisData.add("");
				}
				String tbgs = index.get("count").toString();
				data1.add(Double.parseDouble(tbgs));
		}
		yAxisData.put("个数", data1);
		request.setAttribute("xAxisData", xAxisData);
		request.setAttribute("yAxisData", yAxisData);
		
		//折线图
		//获取十五天之前并初始化所有元数据类型的数据
		List<Double> zx1 = new ArrayList<Double>();
		List<Double> zx2 = new ArrayList<Double>();
		List<Double> zx3 = new ArrayList<Double>();
		List<Double> zx4 = new ArrayList<Double>();
		for(int i=15;i>=0;i--){
			Calendar now = Calendar.getInstance();  
	        now.setTime(new Date());  
	        now.set(Calendar.DATE, now.get(Calendar.DATE) - i);  
	        xAxisData2.add(DateFormatUtils.format(now.getTime(), "yyyy-MM-dd"));
	        zx1.add(0.0);
	        zx2.add(0.0);
	        zx3.add(0.0);
	        zx4.add(0.0);
		}
		
		resultSql = new StringBuffer(64);
		resultSql.append("select count(0) as count,DATE_FORMAT(a.UPDATE_DATE,'%Y-%m-%d') as date,a.OBJ_TYPE as obj_type   from dc_obj_main a where DATE_FORMAT(a.UPDATE_DATE,'%Y-%m-%d') is not null and a.OBJ_TYPE is not null group by DATE_FORMAT(a.UPDATE_DATE,'%Y-%m-%d'),OBJ_TYPE order by a.UPDATE_DATE desc");
		List<Map<String, Object>> stackbarlist = DcCommonUtils.queryDataBySql(resultSql.toString());
		
		//文件和文件夹  时间对应 相加
		List<Integer> countList = new ArrayList<Integer>();
		for(int i=0;i<xAxisData2.size();i++){
			count=0;
			String da = xAxisData2.get(i);
			for(Map<String,Object> index2:stackbarlist){
				String type = index2.get("obj_type").toString();
				String counts = index2.get("count").toString();
				if(StringUtils.isNotBlank(index2.get("date").toString())){
					if(da.equals(index2.get("date").toString())){
						if(DcObjectMain.OBJ_TYPE_FILE.equals(type)||DcObjectMain.OBJ_TYPE_FOLDER.equals(type)){
							count+=Double.parseDouble(counts);
						}
					}
				}
			}
			countList.add(count);
		}
		//时间对应
		for(int i=0;i<xAxisData2.size();i++){
			String da = xAxisData2.get(i);
			for(Map<String,Object> index2:stackbarlist){
				String type = index2.get("obj_type").toString();
				String counts = index2.get("count").toString();
				if(StringUtils.isNotBlank(index2.get("date").toString())){
					String date = index2.get("date").toString();
					if(da.equals(date)){
						if(DcObjectMain.OBJ_TYPE_TABLE.equals(type)){
							zx1.set(i,Double.parseDouble(counts));
						}else if(DcObjectMain.OBJ_TYPE_FILE.equals(type)){//2 5
							zx2.set(i,Double.valueOf(countList.get(i)));
						}else if(DcObjectMain.OBJ_TYPE_FIELD.equals(type)){
							zx3.set(i,Double.parseDouble(counts));
						}else if(DcObjectMain.OBJ_TYPE_INTER.equals(type)){
							zx4.set(i,Double.parseDouble(counts));
						}else if(DcObjectMain.OBJ_TYPE_FOLDER.equals(type)){
							zx2.set(i,Double.valueOf(countList.get(i)));
						}
					}
				}
			}
		}
		yAxisData2.put("数据表",zx1);
		yAxisData2.put("文件",zx2);
		//yAxisData2.put("字段",zx3);
		yAxisData2.put("接口",zx4);
		List<String> colors = new ArrayList<String>();
		colors.add("#3fb1e3");
		colors.add("#6be6c1");
		colors.add("#626c91");
		request.setAttribute("colorList", colors);
		request.setAttribute("xAxisData2", xAxisData2);
		request.setAttribute("yAxisData2", yAxisData2);
		return "modules/echarts/DcObjectMainPie";
	}
	
	
	
	public static Date getDateBefore(Date d, int day) {  
        Calendar now = Calendar.getInstance();  
        now.setTime(d);  
        now.set(Calendar.DATE, now.get(Calendar.DATE) - day);  
        return now.getTime();  
    }
}
