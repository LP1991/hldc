package com.hlframe.modules.dc.chart.web;

import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.chart.service.DcCmLineChartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Primo
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/dc/chart/dcCmLineChart")
public class DcCmLineChartController extends BaseController {
	
	@Autowired
	private DcCmLineChartService dcCmLineChartService;
	
	@RequestMapping(value = {"index", ""})
	public String index( HttpServletRequest request) {
		dcCmLineChartService.getDcCmData(request);
		dcCmLineChartService.getDiskIOData(request);
		dcCmLineChartService.getNetIOData(request);
		dcCmLineChartService.getHdfsCapacity(request);
		List<String> colors = new ArrayList<String>();
		colors.add("#3fb1e3");
		colors.add("#6be6c1");
		colors.add("#626c91");
		request.setAttribute("colorList", colors);
		return "modules/echarts/cmDashboard";
	}

	@RequestMapping(value ="getDiskIOData")
	public String getDiskIOData( HttpServletRequest request) {
		dcCmLineChartService.getDiskIOData(request);
		return "modules/echarts/taskAnalysis";
	}

	@RequestMapping(value ="getNetIOData")
	public String getNetIOData( HttpServletRequest request) {
		dcCmLineChartService.getNetIOData(request);
		return "modules/echarts/netIOline";
	}

	@RequestMapping(value ="getHdfsCapacity")
	public String getHdfsCapacity( HttpServletRequest request) {
		dcCmLineChartService.getHdfsCapacity(request);
		return "modules/echarts/capacityOfHdfs";
	}

}
