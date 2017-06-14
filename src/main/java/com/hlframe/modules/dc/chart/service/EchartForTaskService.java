package com.hlframe.modules.dc.chart.service;

import com.hlframe.common.service.CrudService;
import com.hlframe.modules.dc.schedule.dao.DcTaskMainDao;
import com.hlframe.modules.dc.schedule.entity.DcTaskMain;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @类名: EchartForTaskService
 * @职责说明:
 * @创建者: Primo
 * @创建时间: 2017/3/21
 */
@Service
@Transactional(readOnly = true)
public class EchartForTaskService extends CrudService<DcTaskMainDao, DcTaskMain> {

    public void getTaskCataAndResource(HttpServletRequest request) {
        List<Map<String,Object>> result =  dao.getTaskCataAndResource();
        List<String> xAxisData = new ArrayList<>();
        Map<String,List<Double>> yAxisData = new HashMap<>();

        List<Double> innerTask = new ArrayList<>();
        List<Double> jarTask = new ArrayList<>();
        List<Double> batTask = new ArrayList<>();

        xAxisData.add("自定义任务");
        innerTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_INNERCLASS,DcTaskMain.TASK_FROMTYPE_TASK_CUSTOM));
        jarTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_JAR,DcTaskMain.TASK_FROMTYPE_TASK_CUSTOM));
        batTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_SHELL,DcTaskMain.TASK_FROMTYPE_TASK_CUSTOM));
        xAxisData.add("DB采集任务");
        innerTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_INNERCLASS,DcTaskMain.TASK_FROMTYPE_EXTRACT_RMDB));
        jarTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_JAR,DcTaskMain.TASK_FROMTYPE_EXTRACT_RMDB));
        batTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_SHELL,DcTaskMain.TASK_FROMTYPE_EXTRACT_RMDB));
        xAxisData.add("文件采集任务");
        innerTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_INNERCLASS,DcTaskMain.TASK_FROMTYPE_EXTRACT_FILE));
        jarTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_JAR,DcTaskMain.TASK_FROMTYPE_EXTRACT_FILE));
        batTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_SHELL,DcTaskMain.TASK_FROMTYPE_EXTRACT_FILE));
        xAxisData.add("接口采集任务");
        innerTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_INNERCLASS,DcTaskMain.TASK_FROMTYPE_EXTRACT_INTF));
        jarTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_JAR,DcTaskMain.TASK_FROMTYPE_EXTRACT_INTF));
        batTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_SHELL,DcTaskMain.TASK_FROMTYPE_EXTRACT_INTF));
        xAxisData.add("HDFS采集任务");
        innerTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_INNERCLASS,DcTaskMain.TASK_FROMTYPE_EXTRACT_HDFS));
        jarTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_JAR,DcTaskMain.TASK_FROMTYPE_EXTRACT_HDFS));
        batTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_SHELL,DcTaskMain.TASK_FROMTYPE_EXTRACT_HDFS));
        xAxisData.add("数据转换设计");
        innerTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_INNERCLASS,DcTaskMain.TASK_FROMTYPE_PROCESS_DESIGN));
        jarTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_JAR,DcTaskMain.TASK_FROMTYPE_PROCESS_DESIGN));
        batTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_SHELL,DcTaskMain.TASK_FROMTYPE_PROCESS_DESIGN));
        xAxisData.add("数据转换脚本");
        innerTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_INNERCLASS,DcTaskMain.TASK_FROMTYPE_PROCESS_SCRIPT));
        jarTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_JAR,DcTaskMain.TASK_FROMTYPE_PROCESS_SCRIPT));
        batTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_SHELL,DcTaskMain.TASK_FROMTYPE_PROCESS_SCRIPT));
        xAxisData.add("数据导出");
        innerTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_INNERCLASS,DcTaskMain.TASK_FROMTYPE_EXPORT_RMDB));
        jarTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_JAR,DcTaskMain.TASK_FROMTYPE_EXPORT_RMDB));
        batTask.add(getNumByTypeAndPath(result,DcTaskMain.TASK_TYPE_SHELL,DcTaskMain.TASK_FROMTYPE_EXPORT_RMDB));


        yAxisData.put("内部类",innerTask);
        yAxisData.put("外部Jar包",jarTask);
        yAxisData.put("Shell",batTask);

        List<String> colors = new ArrayList<>();
        colors.add("#3fb1e3");
        colors.add("#6be6c1");
        colors.add("#626696");
        colors.add("#ffff00");
        colors.add("#ff00ff");
        colors.add("#00ffff");
        colors.add("#00ff00");
        colors.add("#ffffff");

        request.setAttribute("colorList", colors);
        request.setAttribute("xAxisData", xAxisData);
        request.setAttribute("yAxisData", yAxisData);
    }

    public void getTaskStatus(HttpServletRequest request) {
        List<Map<String,Object>> result =  dao.countTaskStatus();
        List<String> xAxisData = new ArrayList<String>();
        Map<String,List<Double>> yAxisData = new HashMap<String,List<Double>>();

        List<Double> init = new ArrayList<>();
        List<Double> running = new ArrayList<>();
        List<Double> error = new ArrayList<>();
        List<Double> success = new ArrayList<>();

        xAxisData.add("手动");
        init.add(getNumByStatusAndTrigger(result, DcTaskTime.TASK_STATUS_INIT,DcTaskTime.TASK_TRIGGERTYPE_AUTO));
        running.add(getNumByStatusAndTrigger(result,DcTaskTime.TASK_STATUS_RUNNING,DcTaskTime.TASK_TRIGGERTYPE_AUTO));
        error.add(getNumByStatusAndTrigger(result,DcTaskTime.TASK_STATUS_ERROR,DcTaskTime.TASK_TRIGGERTYPE_AUTO));
        success.add(getNumByStatusAndTrigger(result,DcTaskTime.TASK_STATUS_SUCCESS,DcTaskTime.TASK_TRIGGERTYPE_AUTO));
        xAxisData.add("自动");
        init.add(getNumByStatusAndTrigger(result,DcTaskTime.TASK_STATUS_INIT,DcTaskTime.TASK_TRIGGERTYPE_HAND));
        running.add(getNumByStatusAndTrigger(result,DcTaskTime.TASK_STATUS_RUNNING,DcTaskTime.TASK_TRIGGERTYPE_HAND));
        error.add(getNumByStatusAndTrigger(result,DcTaskTime.TASK_STATUS_ERROR,DcTaskTime.TASK_TRIGGERTYPE_HAND));
        success.add(getNumByStatusAndTrigger(result,DcTaskTime.TASK_STATUS_SUCCESS,DcTaskTime.TASK_TRIGGERTYPE_HAND));

        yAxisData.put("未执行",init);
        yAxisData.put("执行中",running);
        yAxisData.put("成功",error);
        yAxisData.put("失败",success);

        List<String> colors = new ArrayList<String>();
        colors.add("#3fb1e3");
        colors.add("#6be6c1");
        colors.add("#626696");
        colors.add("#ffff00");

        request.setAttribute("colorListStatus", colors);
        request.setAttribute("xAxisDataStatus", xAxisData);
        request.setAttribute("yAxisDataStatus", yAxisData);
    }

    private Double getNumByStatusAndTrigger(List<Map<String, Object>> result, String trigger, String status) {
        for(Map<String,Object> map : result){
            if (trigger.equals(map.get("TRIGGER_TYPE")) && status.equals(map.get("STATUS"))){
                String n = map.get("num").toString();
                if (null == n){
                    return 0.0;
                }
                return Double.parseDouble(map.get("num").toString());
            }
        }
        return 0.0;
    }

    private Double getNumByTypeAndPath(List<Map<String, Object>> result, String taskTypeInnerclass, String taskFromtypeTaskCustom) {
        for(Map<String,Object> map : result){
            if (taskTypeInnerclass.equals(map.get("TASKTYPE")) && taskFromtypeTaskCustom.equals(map.get("TASKPATH"))){
                String n = map.get("num").toString();
                if (null == n){
                    return 0.0;
                }
                return Double.parseDouble(map.get("num").toString());
            }
        }
        return 0.0;
    }

    private String getTypeName(Object type) {
        if(null == type){
            return null;
        }else if (DcTaskMain.TASK_TYPE_INNERCLASS.equals(type)){
            return "内部类";
        }else if (DcTaskMain.TASK_TYPE_JAR.equals(type)){
            return "外部Jar包";
        }else if (DcTaskMain.TASK_TYPE_SHELL.equals(type)){
            return "外部Bat或Shell";
        }else {
            return null;
        }
    }
}
