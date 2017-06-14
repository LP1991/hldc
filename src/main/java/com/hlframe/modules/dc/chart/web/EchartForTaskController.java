package com.hlframe.modules.dc.chart.web;

import com.hlframe.common.web.BaseController;
import com.hlframe.modules.dc.chart.service.EchartForTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/**
 * @类名: EchartForTaskController
 * @职责说明:
 * @创建者: Primo
 * @创建时间: 2017/3/21
 */

@Controller
@RequestMapping(value = "${adminPath}/dc/chart/taskChart")
public class EchartForTaskController  extends BaseController {
    @Autowired
    private EchartForTaskService echartForTaskService;

    @RequestMapping(value ="getTaskCataAndResource")
    public String getTaskCataAndResource( HttpServletRequest request) {
        echartForTaskService.getTaskCataAndResource(request);
        echartForTaskService.getTaskStatus(request);
        return "modules/echarts/taskAnalysis";
    }
}
