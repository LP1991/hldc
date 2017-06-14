package com.hlframe.modules.dc.utils;

import com.hlframe.modules.dc.dataprocess.entity.DcJobDb2Hdfs;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransData;
import com.hlframe.modules.dc.dataprocess.entity.DcJobTransDataLinkHdfs;
import com.hlframe.modules.dc.dataprocess.service.DcTransTablesToHiveJob;
import com.hlframe.modules.dc.metadata.entity.DcDataSource;

/**
 * @类名: DcTransTablesUtils
 * @职责说明: transfor db tables to hive,hbase and so on
 * @创建者: Primo
 * @创建时间: 2017/3/29
 */
public class DcTransTablesUtils {
// jobData 参数配置
    private DcJobDb2Hdfs jobData;


    public static final String ALLTABLES = "all-tables";

    /**
     * 导入整个schema ： tables = "all-tables"
     *  condition : 1、每个表必须都只有一个列作为主键；
     2、必须将每个表中所有的数据导入，而不是部分；
     3、你必须使用默认分隔列，且WHERE子句无任何强加的条件
     满足以上条件才能全表导入。
     不推荐使用（只能单线程，效率很低）使用一下sql获取全部表名的字符串
     select GROUP_CONCAT(TABLE_NAME) from information_schema.tables where TABLE_SCHEMA = "test_lp"
     */
//db config
    private String tables = "dept_t,fanwe_area,fanwe_deal,fanwe_deal_cate,fanwe_deal_cate_type,fanwe_deal_cate_type_deal_link,fanwe_deal_cate_type_link,fanwe_deal_cate_type_location_link,table_t,user_t"; // 需要配置的表 , 全部表使用 ALLTABLES 不推荐使用（只能单线程，效率很低）
    private int sortNum = 2;
    private String toLink = DcJobTransData.TOLINK_HIVE;
    private String schemaName = "test_lp";  //mysql sechema

// 连接参数配置
    private String serveType = DcDataSource.DB_SERVER_TYPE_MYSQL;
    private String serveIp = "10.1.20.86";  // 数据库IP
    private String servePort = "3306";    // 端口
    private String userName = "hldc_h5";    // 连接用户名
    private String password = "hldc_h5";    // 连接密码

// 上传指定hive schema
    public static final String hiveSchema = "test"; // hive 数据库

    //ssh 连接属性
    public static final String SSH_SERVER = "172.16.110.200";
    public static final String SSH_USER = "root";
    public static final String SSH_PWD = "123456";

    private DcDataSource dataSource;

    private void testSqoopJob() throws Exception {
        DcTransTablesToHiveJob service = new DcTransTablesToHiveJob();
        // 查找到对应业务类， 调用方法
        service.setDataSource(dataSource);
        service.setJobData(jobData);

        service.runTask(null);
    }
    /**
     * @name: main
     * @funciton: 主程序
     * @param 
     * @return
     * @Create by lp at 2017/3/30 16:18
     * @throws 
     */
    public static void main(String[] args){
        //  main method
        try {
            DcTransTablesUtils instance = new DcTransTablesUtils();
            instance.initData();
            instance.testSqoopJob();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /**
     * @name: initData
     * @funciton: 初始化数据
     * @param
     * @return
     * @Create by lp at 2017/3/30 16:17
     * @throws
     */
    private void initData(){
        // 参数配置实例化
        jobData = new DcJobDb2Hdfs();
        jobData.setJobName("initTables2hdfs");
        jobData.setTableName(tables);
        jobData.setSortNum(sortNum);
        jobData.setToLink(toLink);
        jobData.setSchemaName(schemaName);
        jobData.setIncrementType(DcJobTransDataLinkHdfs.INCREMENT_TYPE_WHOLE);

        // 参数配置实例化
        dataSource = new DcDataSource();
        dataSource.setServerType(serveType);
        dataSource.setServerIP(serveIp);
        dataSource.setServerPort(servePort);
        dataSource.setServerUser(userName);
        dataSource.setServerPswd(password);
    }

    /**
     * @name: change2outputTable
     * @funciton: 开放接口，用于修改上传至hive时，table的名称
     * @param
     * @return
     * @Create by lp at 2017/3/29 14:48
     * @throws
     */
    public static String change2outputTable(String table) {
        if(DcTransTablesUtils.ALLTABLES.equals(table)){
            //全表采集不能修改对应的名称
            return table;
        }else{
            // 多表或单表采集可以自定义hive表的名称规则
            return table;
        }
    }
}
