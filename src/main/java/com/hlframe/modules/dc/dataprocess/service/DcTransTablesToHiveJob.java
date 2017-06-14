/********************** 版权声明 *************************
 * 文件名: DcTransTablesToHiveJob.java
 * 包名: com.hlframe.modules.dc.dataprocess.service
 * 版权:	杭州华量软件  hldc_bigdata
 * 职责:
 ********************************************************
 *
 * 创建者：Primo   创建时间：2017/3/28
 * 文件版本：V1.0
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.service;

import com.hlframe.common.utils.DateUtils;
import com.hlframe.common.utils.StringUtils;
import com.hlframe.modules.dc.common.DcConstants;
import com.hlframe.modules.dc.common.dao.DcDataResult;
import com.hlframe.modules.dc.dataprocess.entity.DcJobDb2Hdfs;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.metadata.entity.*;
import com.hlframe.modules.dc.utils.DcFileUtils;
import com.hlframe.modules.dc.utils.DcTransTablesUtils;
import net.neoremind.sshxcute.core.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;

import java.util.Date;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.CountDownLatch;

/**
 * @类名: DcTransTablesToHiveJob
 * @职责说明: This Class use for transfor db tables to hive
 * @创建者: Primo
 * @创建时间: 2017/3/28
 */

public class DcTransTablesToHiveJob {
    //the num of threads
    public final static int THREADSIZE = 4;

    private DcJobDb2Hdfs jobData;

    private DcDataSource dataSource;

    private DcJobTransDataService transDataService = new DcJobTransDataService();

    private CountDownLatch _latch = null;

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    public DcDataResult runTask(String taskId) throws Exception {

        DcDataResult taskResult = new DcDataResult();
        StringBuilder result = new StringBuilder(1024);
        //构建数据对象
        Assert.notNull(jobData);
        try {
            //开始执行时间
            Date beginDate = new Date();
            //执行DB采集任务
            Result res = extractDbData(jobData);

            result.append("-->任务名称: ").append(jobData.getJobName());
            result.append("<br>-->开始时间: ").append(DateUtils.formatDateTime(beginDate));
            result.append("<br>-->结束时间: ").append(DateUtils.formatDateTime(new Date()));
            result.append("<br>-->调用结果: ").append(res.rc);
            result.append("<br>-->简要日志: <br>  ").append(DcFileUtils.formatSqoopLog(res.sysout, "<br>", "Import"));
            result.append("<br>-->详细日志: <br>  ").append(DcFileUtils.formatSqoopLog(res.error_msg, "<br>", "Import"));

            //将日志记录到HDFS  默认为采集目录
//            String logDir = hdfsService.buildBizLoggerPath("initDbTables2hdfs", "extract_DB_"+beginDate.getTime());
//            logger.info("-->record the logdir"+logDir);
//            hdfsService.writeData2Hdfs(logDir, result.toString().replaceAll("<br>", "\r\n"));
            taskResult.setRst_flag(true);
            taskResult.setRst_std_msg(result.toString());
        }catch (Exception e){
            e.printStackTrace();
            logger.error("-->extract data from DB: runTask,"+this.getClass().getName(),e);
            taskResult.setRst_err_msg(e.getMessage());
            taskResult.setRst_flag(false);
        }
        return taskResult;
    }

    /**
     * @方法名称: extractDbData
     * @实现功能: 采集Db数据(调用sqoop client 脚本)
     * @param jobData
     * @return
     * @create by Primo at 2017年3月38日 上午11:45:13
     */
    private Result extractDbData(DcJobDb2Hdfs jobData) throws InterruptedException {
        Result res = null;

        //构建任务脚本,每一张表为一个任务脚本
        BlockingQueue<Map.Entry<String,String>> sqoopScripts = buildTaskScript(jobData, dataSource);
        //默认4个线程 线程数不大于脚本数。
        int threadSize = THREADSIZE;
        if(sqoopScripts.size()<THREADSIZE){
            threadSize = sqoopScripts.size();
        }
        // countdownlatch 确定线程是否全部完成。
        _latch = new CountDownLatch(threadSize);

        DcJobTransTableThread dcJobTransTableThread = new DcJobTransTableThread(sqoopScripts,jobData,_latch);
        //初始化记录完成总进度的标示
        dcJobTransTableThread.resetCount();
        dcJobTransTableThread.start();
        for(int i=1;i<threadSize;i++){
            new DcJobTransTableThread(sqoopScripts,jobData,_latch).start();
        }
        //返回结果以第一个线程为主， 具体执行细节需要参考日志信息。
//        dcJobTransTableThread.join();
        _latch.await();
        res = dcJobTransTableThread.getRes();
        return res;
    }

    /**
     * @方法名称: buildTaskScript
     * @实现功能: 构建任务执行脚本
     * @param jobData		任务信息
     * @param dataSource	数据源连接
     * @return
     * @create by Primo at 2017年3月38日 上午11:45:13
     */
    private BlockingQueue<Map.Entry<String,String>> buildTaskScript(DcJobDb2Hdfs jobData, DcDataSource dataSource) {

        String[] tables = jobData.getTableName().toUpperCase().split(",");
        //创建脚本集合，使用阻塞队列，用于多线程。
        BlockingQueue<Map.Entry<String,String>> scripts = new ArrayBlockingQueue<>(tables.length);
        for(String table : tables){
            if(table==null || table.length()==0){
                continue;
            }

            StringBuilder taskScript = new StringBuilder(200);
            if(StringUtils.isBlank(jobData.getRemarks())){
                if(DcTransTablesUtils.ALLTABLES.equalsIgnoreCase(table)){
                    taskScript.append("sudo -u hdfs sqoop-import-all-tables");
                }else{
                    taskScript.append("sudo -u hdfs sqoop import");

                    //指定数据表
                    taskScript.append(" --table ").append(table);
                }

                //设置线程数
                if(jobData.getSortNum()>0){
                    taskScript.append(" -m ").append(jobData.getSortNum());
                }
                //存储到hdfs
                if(DcJobTransData.TOLINK_HDFS.equals(jobData.getToLink())){
                    //指定分区字段
                    taskScript.append(" --split-by ").append(jobData.getPartitionColumn());
                    //指定输出目录
                    taskScript.append(" --target-dir ").append(jobData.getOutputDir());
                    //指定输出格式(默认为textFile)
                    if("sequence".equalsIgnoreCase(jobData.getOutputFormat())){
                        taskScript.append(" --as-sequencefile ");
                    }
                    //指定压缩格式
                    String compresFormat = jobData.getCompresFormat();
                    if(!"none".equalsIgnoreCase(compresFormat)){
                        taskScript.append(" -z,--compress --compression-codec ").append(compresFormat);
                    }
                    //替换null值
                    if(StringUtils.isNotBlank(jobData.getNullValue())){
                        taskScript.append(" --null-string ").append(jobData.getNullValue());
                    }
                    //存储到Hive
                }else if(DcJobTransData.TOLINK_HIVE.equals(jobData.getToLink())){
                    //如果是全表导入 不需要写对应的hive名称
                    if (!DcTransTablesUtils.ALLTABLES.equalsIgnoreCase(table)){
                        taskScript.append(" --hive-table ").append(DcTransTablesUtils.change2outputTable(table));
                    }
                    taskScript.append(" --hive-import ");
                    //是否建表
                    if(DcConstants.DC_RESULT_FLAG_TRUE.equals(jobData.getIsCreateTable())){
                        taskScript.append(" --create-hive-table ");
                    }
                    if(!"default".equals(DcTransTablesUtils.hiveSchema)){
                        taskScript.append(" --hive-database "+DcTransTablesUtils.hiveSchema);
                    }
                    //存储到hbase
                }else if(DcJobTransData.TOLINK_HBASE.equals(jobData.getToLink())){
                    taskScript.append(" --hbase-table ").append(jobData.getOutputDir());
                    //列族
                    if(StringUtils.isNotEmpty(jobData.getColumnFamily())){
                        taskScript.append(" --column-family ").append(jobData.getColumnFamily());
                    }
                    //主键字段
                    if(StringUtils.isNotEmpty(jobData.getKeyField())){
                        taskScript.append(" --hbase-row-key ").append(jobData.getKeyField());
                    }
                    //是否建表
                    if(DcConstants.DC_RESULT_FLAG_TRUE.equals(jobData.getIsCreateTable())){
                        taskScript.append(" --hbase-create-table ");
                    }
                }
            }else{
                String remarkScript = jobData.getRemarks();
                taskScript.append(remarkScript);
            }

            //构建数据源 连接信息
            transDataService.buildDataBaseLink(jobData, taskScript, dataSource);

            logger.debug("--> sqoop task script: "+taskScript.toString());
            Map.Entry<String,String> entry = new Entry<>(table,taskScript.toString());
            scripts.offer(entry);
        }

        return scripts;
    }

    public DcJobDb2Hdfs getJobData() {
        return jobData;
    }

    public void setJobData(DcJobDb2Hdfs jobData) {
        this.jobData = jobData;
    }

    public DcDataSource getDataSource() {
        return dataSource;
    }

    public void setDataSource(DcDataSource dataSource) {
        this.dataSource = dataSource;
    }

    private class Entry<K,V> implements Map.Entry<K,V>{
        private K key;
        private V value;

        public Entry(K key, V value) {
            this.key = key;
            this.value = value;
        }

        @Override
        public K getKey() {
            return this.key;
        }

        @Override
        public V getValue() {
            return value;
        }

        @Override
        public V setValue(V value) {
            V oldValue = value;
            this.value = value;
            return oldValue;
        }
        public final boolean equals(Object o) {
            if (!(o instanceof Map.Entry))
                return false;
            Map.Entry e = (Map.Entry)o;
            Object k1 = getKey();
            Object k2 = e.getKey();
            if (k1 == k2 || (k1 != null && k1.equals(k2))) {
                Object v1 = getValue();
                Object v2 = e.getValue();
                if (v1 == v2 || (v1 != null && v1.equals(v2)))
                    return true;
            }
            return false;
        }

        public final int hashCode() {
            return (key==null   ? 0 : key.hashCode()) ^
                    (value==null ? 0 : value.hashCode());
        }

        public final String toString() {
            return getKey() + "=" + getValue();
        }
    }
}
