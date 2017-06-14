/********************** 版权声明 *************************
 * 文件名: DcJerseyTaskServer.java
 * 包名: com.hlframe.modules.dc.jersey.rest
 * 版权:	杭州华量软件  hldc
 * 职责: 
 ********************************************************
 *
 * 创建者：Primo  创建时间：2017/5/2
 * 文件版本：V1.0
 *
 *******************************************************/
package com.hlframe.modules.dc.jersey.rest;

import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.modules.dc.common.service.DcCommonService;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;
import com.hlframe.modules.dc.task.TaskInfo;
import com.hlframe.modules.dc.utils.QuartzUtil;
import org.quartz.SchedulerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import java.util.Date;

@Path("/task")
public class DcJerseyTaskServer {
    private DcTaskTimeService dcTaskTimeService = SpringContextHolder.getBean(DcTaskTimeService.class); //不能直接注入。！！
    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    @POST
    @Path("/process")
    @Produces(MediaType.TEXT_PLAIN)
    public String process(@FormParam("id") String id,
                          @Context HttpServletRequest request) {
        DcTaskTime dcTaskTime = dcTaskTimeService.get(id);
        try {
            // 验证任务验证是否开启
            if (QuartzUtil.checkExistsJob(id)) {
                logger.info("任务正在执行，不能多次启动！date:"+new Date());
            } else {
                // 执行任务
                doTask(dcTaskTime);
            }
            logger.info("任务执行成功！date:"+new Date());
            return "success";
        } catch (Exception e) {
            dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_ERROR);// 将其状态改为异常
            dcTaskTimeService.updateStatus(dcTaskTime);
            logger.error("任务执行失败! date:"+new Date(),e);
        }
        return "error";
    }

    /**
     * 执行任务
     *
     * @param dcTaskTime
     * @throws SchedulerException
     */
    private void doTask(DcTaskTime dcTaskTime) throws SchedulerException {
        try {
            // TODO 需要加强边界验证 暂时仅支持单个String或多个String参数
            TaskInfo taskInfo = dcTaskTimeService.buildTaskInfo(dcTaskTime);
            QuartzUtil.doTaskProcess(taskInfo);

            dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_RUNNING); // 将其状态改为执行中
            dcTaskTimeService.updateStatus(dcTaskTime);
        } catch (Exception e) {
            dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_ERROR); // 将其状态改为失败
            dcTaskTimeService.updateStatus(dcTaskTime);
            logger.error("-->doTask: ", e);
            throw new SchedulerException("执行任务失败！date:"+new Date() + e.getMessage());
        }
    }
}
