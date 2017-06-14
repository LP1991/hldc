package com.hlframe.modules.dc.dataprocess.service;


import com.hlframe.common.utils.StringUtils;

import com.hlframe.modules.dc.dataprocess.entity.DcJobDb2Hdfs;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransDataLinkHdfs;

import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.dc.utils.DcTransTablesUtils;
import net.neoremind.sshxcute.core.ConnBean;
import net.neoremind.sshxcute.core.Result;
import net.neoremind.sshxcute.core.SSHExec;
import net.neoremind.sshxcute.task.impl.ExecCommand;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.Map;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.CountDownLatch;

/**
 * @类名: DcJobTransTableThread
 * @职责说明:
 * @创建者: Primo
 * @创建时间: 2017/3/28
 */
public class DcJobTransTableThread extends Thread{
    private static int finishedNum = 0;
    private BlockingQueue<Map.Entry<String,String>> scripts;
    private ConnBean cb = new ConnBean(DcTransTablesUtils.SSH_SERVER,
            DcTransTablesUtils.SSH_USER,
            DcTransTablesUtils.SSH_PWD);
    private SSHExec ssh = null;

    private DcJobDb2Hdfs jobData;

    private Result res;

    private CountDownLatch _latch ;

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    public DcJobTransTableThread(BlockingQueue<Map.Entry<String,String>> scripts, DcJobDb2Hdfs jobData,CountDownLatch _latch) {
        this.scripts = scripts;
        this.jobData = jobData;
        this._latch = _latch;
        try {
            //使用反射机制创建实体类SSHExec
            Constructor<SSHExec> constructor = (Constructor<SSHExec>) Class.forName("net.neoremind.sshxcute.core.SSHExec").getDeclaredConstructor(ConnBean.class);
            constructor.setAccessible(true);
            ssh = constructor.newInstance(cb);
        } catch (InstantiationException e) {
            logger.error("instantiation",e);
        } catch (IllegalAccessException e) {
            logger.error("illegalaccess",e);
        } catch (ClassNotFoundException e) {
            logger.error("class not found",e);
        } catch (NoSuchMethodException e) {
            logger.error("no such methed",e);
        } catch (InvocationTargetException e) {
            logger.error("invocation target error",e);
        }
    }

    @Override
    public void run() {
        Map.Entry<String,String> script = scripts.poll();
        try {
            // 连接到hdfs
            ssh.connect();
            while(script != null) {
                //执行DB采集任务
                res = extractDbData(jobData, script);
                //获取下一个table
                script = scripts.poll();
                recordTheProcess();
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.error("-->extract data from DB: runTask,"+this.getClass().getName(),e);
        }finally{
            //任务结束 关闭ssh
            if(null!=ssh){
                ssh.disconnect();
            }
            _latch.countDown();
        }

    }

    /**
     * @方法名称: extractDbData
     * @实现功能: 采集Db数据(调用sqoop client 脚本)
     * @param jobData
     * @return
     * @create by Primo at 2017年3月38日 上午11:45:13
     */
    private Result extractDbData(DcJobDb2Hdfs jobData,Map.Entry<String,String> entry) {
        Result res = null;
        String script = entry.getValue();
        String table = entry.getKey();
        StringBuilder metaScript = new StringBuilder(64);
        //构建任务脚本
        //准备源路径与备份路径
        String objPath = null, bakPath = null, hdfsBakPath = null;
        if(DcJobTransData.TOLINK_HDFS.equals(jobData.getToLink())){
            objPath = jobData.getOutputDir();
            bakPath = DcPropertyUtils.getProperty("hdfs.extractJob.backupDir");
            hdfsBakPath = bakPath+ StringUtils.substringAfterLast(objPath, "/");		//Hdfs备份文件完整目录
        }else if(DcJobTransData.TOLINK_HIVE.equals(jobData.getToLink())){
            //获取hive上的表名
            String outputTable = DcTransTablesUtils.change2outputTable(table);
            // 添加schema，用于删除已存在表
            objPath = DcTransTablesUtils.hiveSchema+"."+outputTable;
            bakPath = outputTable+"_BAK";
        }
        try {
            //如果是全量采集, 先删除原有数据, 如果是全表采集 不需要删除
            if(DcJobTransDataLinkHdfs.INCREMENT_TYPE_WHOLE.equals(jobData.getIncrementType()) && !DcTransTablesUtils.ALLTABLES.equalsIgnoreCase(table)){
                logger.info("----> delete data begin !");
                if(DcJobTransData.TOLINK_HDFS.equals(jobData.getToLink())){			//备份Hdfs
                    //删除备份目录
                    ssh.exec(new ExecCommand("sudo -u hdfs hdfs dfs -rm -r "+hdfsBakPath+"; sudo -u hdfs hdfs dfs -mv "+objPath+" "+bakPath));
                }else if(DcJobTransData.TOLINK_HIVE.equals(jobData.getToLink())){	//备份Hive表
                    metaScript.setLength(0);
                    //1.删除原表
                    metaScript.append("sudo -u hdfs hive -e 'DROP TABLE IF EXISTS ").append(objPath).append(";'");
                    ssh.exec(new ExecCommand(metaScript.toString()));
                }
                logger.info("----> delete data end !");
                logger.info("metaScript: "+metaScript);
            }
            //执行采集脚本
            res = ssh.exec(new ExecCommand(script));
            //返回的永远是错误标记... 根据返回错误信息 手工判断是否执行成功
            if(checkResultErr(res)){
                logger.info("----> restore data success !");
            }else{
                logger.info("----> restore data failed !");
            }
        } catch (Exception e) {
            logger.error("-->extractDbData:", e);
        }
        return res;
    }


    /**
     * @方法名称: checkResultErr
     * @实现功能: 判断ssh是否执行成功, 如果是错误标记, 则通过result.err_msg 手动解析
     * @param res
     * @return
     * @create by Primo at 2017年3月38日 上午11:45:13
     */
    private boolean checkResultErr(Result res) {
        if(res.isSuccess){
            return true;
        }
        //手工解析error信息 判断日志中是否存在'completed successfully'
        return res.error_msg.indexOf("completed successfully")>0;
    }

    public Result getRes() {
        return res;
    }

    public void setRes(Result res) {
        this.res = res;
    }
    synchronized private void recordTheProcess(){
        finishedNum ++;
        logger.info("finished "+finishedNum+" tables! ");
    }
    public void resetCount(){
        finishedNum = 0;
    }
}
