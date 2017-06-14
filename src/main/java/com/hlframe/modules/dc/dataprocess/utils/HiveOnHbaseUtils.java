/********************** 版权声明 *************************
 * 文件名: HiveOnHbaseUtils.java
 * 包名: com.hlframe.modules.dc.dataprocess.utils
 * 版权:	杭州华量软件  hldc
 * 职责: this util provide series methods for hive and hbase
 ********************************************************
 *
 * 创建者：Primo  创建时间：2017/5/16
 * 文件版本：V1.0
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.utils;

import net.neoremind.sshxcute.core.ConnBean;
import net.neoremind.sshxcute.core.Result;
import net.neoremind.sshxcute.core.SSHExec;
import net.neoremind.sshxcute.task.impl.ExecCommand;
import org.apache.commons.collections.map.HashedMap;
import org.springframework.util.Assert;

import java.util.*;

public class HiveOnHbaseUtils {
    //ssh 连接属性
    public static final String SSH_SERVER = "10.1.70.200";
    public static final String SSH_USER = "root";
    public static final String SSH_PWD = "inteast.com";

    private static ConnBean cb = new ConnBean(SSH_SERVER, SSH_USER, SSH_PWD);
    private static SSHExec ssh = null;

    private static Result res;
    /**
     * @name: createHiveTableConn2HbaseScript
     * @funciton:  create the hive table which could connect to the hbase while selecting or inserting.
     * @param hiveTName hive table name
     * @param hiveFields hive table field, the key of the Map is fieldName,the value of Map is the type of field
     * @param hbaseTName hbase table name
     * @param hbaseFields hbase table fields
     * @param ifExist if hbase table is exist.
     * @return
     * @Create by lp at 2017/5/16 20:
     * @throws
     */
    public static String createHiveTableConn2HbaseScript(String hiveTName, Map<String,Object> hiveFields,
                                                 String hbaseTName, List<String> hbaseFields,boolean ifExist){
        Assert.notNull(hiveFields);
        Assert.notNull(hiveTName);
        Assert.notNull(hbaseTName);
        Assert.notNull(hbaseFields);

        StringBuilder script = new StringBuilder(200);
        // build script for create table
        if (ifExist) {
            script.append("hive -e \"CREATE EXTERNAL TABLE "+hiveTName+"(").append("key string");
        } else {
            script.append("hive -e \"CREATE TABLE "+hiveTName+"(").append("key string");

        }

        // add hive fields;
        Iterator<String> it = hiveFields.keySet().iterator();
        while (it.hasNext()){
            String key = it.next();
            script.append(",").append(key+" "+hiveFields.get(key));
        }
        script.append(")");
        script.append("STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler' ");
        // set connection between hive fields and hbase fields
        script.append("WITH SERDEPROPERTIES('hbase.columns.mapping'=':key");
        for (int i = 0; i < hbaseFields.size(); i++) {
            script.append(",").append(hbaseFields.get(i));
        }
        //set hbase tableName
        script.append("')").append("TBLPROPERTIES('hbase.table.name'='").append(hbaseTName);
        script.append("', 'hbase.mapred.output.outputtable' = '").append(hbaseTName).append("');\"");
        return script.toString();
    }
    /**
     * @name: createHiveTableConn2Hbase
     * @funciton:   create the hive table which could connect to the hbase while selecting or inserting
     * @param hiveTName
     * @param hbaseTable
     * @param rowKey  根据rowkey选定具体的记录构建hive表
     * @return
     * @Create by lp at 2017/5/17 16:58
     * @throws
     */
    public static void createHiveTableConn2Hbase(String hiveTName,String hbaseTable, String rowKey){
//        String s = "echo \"get '"+hbaseTable+"','"+rowKey+"' \n exit \"> /home/lp/hbase.shell; hbase shell /home/lp/hbase.shell";
        //创建脚本，查询hbase表结构
        String s = "hbase shell <<EOF\n get '"+hbaseTable+"','"+rowKey+"' \n EOF";
        // 解析表结构，获取具体字段信息
        String out = exeScript(s);
        // 构建创建hive表的sql语句
        String script = resolveField(hiveTName,hbaseTable,out);
        // 执行语句
        exeScript(script);
    }
    /**
     * @name: exeScript
     * @funciton:  run shell script
     * @param
     * @return
     * @Create by lp at 2017/5/17 15:42
     * @throws
     */
    public static String exeScript(String script){
        ssh = SSHExec.getInstance(cb);
        try {
            // 连接到hdfs
            ssh.connect();
            //执行采集脚本
            res = ssh.exec(new ExecCommand(script));
            return res.sysout;
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            if(null!=ssh){
                ssh.disconnect();
            }
        }
        return null;
    }

    private static String resolveField(String hiveTName,String hbaseTName,String s){
        //存放hive 字段
        Map<String,Object> hiveFields = new HashMap<>();
        //存放hbase 字段
        List<String> hbaseFields = new ArrayList<>();
        String [] fields = s.split("\\n");
        for (int i = 0; i < fields.length; i++) {
            if (fields[i].indexOf("timestamp")>-1){
                String[] f = fields[i].split("\\s+");
                for (String s1 : f) {
                    if (s1 != null && !"".equals(s1)){
                        String[] types = s1.split(":");
                        if (types.length==2){
                            hbaseFields.add(s1);
                            //hive 字段默认都是字符串
                            hiveFields.put(types[1],"string");
                        }
                        break;
                    }
                }
            }
        }
        String script = createHiveTableConn2HbaseScript(hiveTName,hiveFields,hbaseTName,hbaseFields,true);
//        System.out.println("script= "+script);
        return script;
    }

    public static void main(String[] args) {
        String ss = "hbase shell <<EOF\n get 'tt','1865872711014914813079999' \n EOF";
//        exeScript(ss);
        String s = "echo \"get 'tt','1865872711014914813079999' \n exit \"> /home/lp/hbase.shell; hbase shell <<EOF\n get 'tt','1865872711014914813079999' \n EOF";
        String out = exeScript(ss);
        System.out.println("+++++++++++++++++++++");
        createHiveTableConn2Hbase("hiveNew","tt","2");
        System.out.println("+++++++++++++++++++++");
    }

}
