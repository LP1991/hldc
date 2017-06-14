package com.hlframe.modules.dc.task;

import java.io.File;
import java.net.URL;
import java.util.Date;

import org.codehaus.plexus.util.StringUtils;

import com.hlframe.common.utils.IdGen;
import com.hlframe.common.utils.Reflections;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.schedule.entity.DcTaskTime;
import com.hlframe.modules.dc.schedule.service.DcTaskTimeService;
import com.hlframe.modules.dc.task.entity.DcTaskLogRun;
import com.hlframe.modules.dc.task.service.DcTaskLogRunService;
import com.hlframe.modules.dc.utils.MyClassLoader;

public class TaskJars implements ITask {
	/**
	 * 执行外部多个jar包任务，需要打包rar或者zip上传，并指定执行类、方法和参数
	 * @param taskInfo
	 * @return
	 */
	public DcDataResult doTask(final TaskInfo taskInfo) {
		DcDataResult result = new DcDataResult();
		try {
			//新建线程实现
			Thread syncThread = new Thread(new Runnable() {
				public void run() {
					DcTaskLogRunService run = SpringContextHolder.getBean(DcTaskLogRunService.class);
					DcTaskLogRun runobj = new DcTaskLogRun();
					try {
						// 记录任务开始日志
						runobj.setIsNewRecord(true);
						runobj.setId(IdGen.uuid());
						runobj.setTaskid(taskInfo.getTaskid());
						runobj.setRunid(taskInfo.getRunid());
						runobj.setStartdate(new Date());
						runobj.setStatus(DcTaskTime.TASK_STATUS_RUNNING);
						run.save(runobj);
						
						// 加载jar
						URL[] urls = new URL[] {};
						MyClassLoader classLoader = new MyClassLoader(urls, null);
						File dir = new File(taskInfo.getFilePath());
						loadJar(dir, urls, classLoader);
						
						// 执行类
						Class<?> clz = classLoader.loadClass(taskInfo.getClassName());
						// Method method = clz.getMethod(taskInfo.getMethodName(), new Class[]{double.class,double.class});
						// method.setAccessible(true); // 私有的方法通过发射可以修改其访问权限
						Object[] argspara = new Object[]{};
						String programs = taskInfo.getPrograms();
						if (StringUtils.isNotEmpty(programs)) {
							argspara = programs.split(",");
						}
						Object result = Reflections.invokeMethodByName(clz.newInstance(), taskInfo.getMethodName(), argspara);
						
						// 记录任务结束日志
						runobj.setIsNewRecord(false);
						runobj.setEnddate(new Date());
						runobj.setStatus(DcTaskTime.TASK_STATUS_SUCCESS);
						if (result != null) {
							runobj.setRemarks(result.toString());
						}
						run.save(runobj);
						
						// 非自动清空下，需要将任务设置为完成状态
						if (!DcTaskTime.TASK_TRIGGERTYPE_AUTO.equalsIgnoreCase(taskInfo.getExecuteType())) {
							DcTaskTime dcTaskTime = new DcTaskTime();
							dcTaskTime.setId(taskInfo.getTaskid());
							dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_SUCCESS);
							DcTaskTimeService obj = SpringContextHolder.getBean(DcTaskTimeService.class);
							obj.updateStatus(dcTaskTime); 
						}
					} catch (Exception e) {
						e.printStackTrace();
						// 记录任务错误日志
						runobj.setIsNewRecord(false);
						runobj.setEnddate(new Date());
						runobj.setStatus(DcTaskTime.TASK_STATUS_ERROR);
						runobj.setRemarks("执行任务[" + taskInfo.getTaskName() + "]失败 : " + e.getMessage());
						run.save(runobj);
						
						// 非自动清空下，需要将任务设置为完成错误
						if (!DcTaskTime.TASK_TRIGGERTYPE_AUTO.equalsIgnoreCase(taskInfo.getExecuteType())) {
							DcTaskTime dcTaskTime = new DcTaskTime();
							dcTaskTime.setId(taskInfo.getTaskid());
							dcTaskTime.setStatus(DcTaskTime.TASK_STATUS_ERROR);
							DcTaskTimeService obj = SpringContextHolder.getBean(DcTaskTimeService.class);
							obj.updateStatus(dcTaskTime); 
						}
					}
				}
				
				/**
				 * 加载jar
				 * @param dir
				 */
				private void loadJar(File dir, URL[] urls, MyClassLoader classLoader) throws Exception {
					File[] fs = dir.listFiles();
					for (File file : fs) {
						if (file.isDirectory()) {
							loadJar(file, urls, classLoader);
						} else {
							if (file.getName().endsWith("jar") || file.getName().endsWith("JAR")) {
								classLoader.addJar(file.toURI().toURL());
							}
						}
					}
				}
			});
			syncThread.start();
			//同步执行标志, 任务执行完成再返回
			if(taskInfo.getSyncFlag()){
				syncThread.join();
			}
			result.setRst_flag(true);
			result.setRst_std_msg("任务["+taskInfo.getTaskName()+"]执行成功!");
			
		} catch (Exception e) {
			result.setRst_flag(false);
			result.setRst_err_msg("任务["+taskInfo.getTaskName()+"]执行失败! "+e.getMessage());
			logger.error("-->TaskJars["+taskInfo.getTaskName()+"].doTask: ", e);
		}
		return result;
	}
}