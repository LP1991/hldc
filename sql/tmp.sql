/*
Navicat MySQL Data Transfer

Source Server         : 10.1.20.130
Source Server Version : 50635
Source Host           : 10.1.20.130:3306
Source Database       : tmp

Target Server Type    : MYSQL
Target Server Version : 50635
File Encoding         : 65001

Date: 2017-06-14 18:05:04
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for applyau
-- ----------------------------
DROP TABLE IF EXISTS `applyau`;
CREATE TABLE `applyau` (
  `id` varchar(32) NOT NULL,
  `userId` varchar(64) DEFAULT NULL,
  `fileId` varchar(64) DEFAULT NULL,
  `status` varchar(64) DEFAULT NULL,
  `from_where` varchar(8) DEFAULT NULL,
  `create_by` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(32) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for calendar
-- ----------------------------
DROP TABLE IF EXISTS `calendar`;
CREATE TABLE `calendar` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `title` varchar(64) DEFAULT NULL COMMENT '事件标题',
  `starttime` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '事件开始时间',
  `endtime` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '事件结束时间',
  `allday` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '是否为全天时间',
  `color` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '时间的背景色',
  `userid` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日历';

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '类型名',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='商品类型';

-- ----------------------------
-- Table structure for dc_cata_detail
-- ----------------------------
DROP TABLE IF EXISTS `dc_cata_detail`;
CREATE TABLE `dc_cata_detail` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `CATA_ITEM_ID` varchar(32) DEFAULT NULL COMMENT '关联分类项目表',
  `CATA_NAME` varchar(64) DEFAULT NULL COMMENT '分类名称',
  `CATA_CODE` varchar(32) DEFAULT NULL COMMENT '分类编码',
  `PARENT_ID` varchar(32) DEFAULT NULL COMMENT '上级分类',
  `CATA_FULLPATH` varchar(200) DEFAULT NULL COMMENT '分类显示全路径,便于查询/定位',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据分类对象';

-- ----------------------------
-- Table structure for dc_cata_item
-- ----------------------------
DROP TABLE IF EXISTS `dc_cata_item`;
CREATE TABLE `dc_cata_item` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `ITEM_NAME` varchar(64) DEFAULT NULL COMMENT '分类项目名称',
  `ITEM_CODE` varchar(32) DEFAULT NULL COMMENT '分类项目编码',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `STATUS` char(2) DEFAULT '0' COMMENT '检索页面显示状态(1-显示；0-不显示)',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='分类项目:文件/业务部门/时间轴/应用系统/... 等用户自定义';

-- ----------------------------
-- Table structure for dc_data_interface
-- ----------------------------
DROP TABLE IF EXISTS `dc_data_interface`;
CREATE TABLE `dc_data_interface` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `OBJ_ID` varchar(32) DEFAULT NULL COMMENT '对象ID',
  `OBJ_TYPE` char(1) DEFAULT NULL COMMENT '对象类型(1-数据表; 2-接口)',
  `obj_range` char(1) DEFAULT NULL COMMENT '访问范围(1-公有; 2-私有)',
  `INTF_TYPE` char(1) DEFAULT '1' COMMENT '接口类别(1-rest; 2-webservice)',
  `INTF_NAME` varchar(200) DEFAULT NULL COMMENT '接口名称',
  `INTF_DESC` varchar(400) DEFAULT NULL COMMENT '接口描述',
  `CALL_TYPE` varchar(8) DEFAULT NULL COMMENT '接口传参方式(POST/GET)',
  `INTF_FIELDS` varchar(400) DEFAULT NULL COMMENT '接口字段',
  `CONTENT_TYPE` varchar(64) DEFAULT NULL COMMENT '接口参数字符集',
  `INTF_PARAMS` varchar(1000) DEFAULT NULL COMMENT '接口参数',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='元数据接口';

-- ----------------------------
-- Table structure for dc_data_interface_auth
-- ----------------------------
DROP TABLE IF EXISTS `dc_data_interface_auth`;
CREATE TABLE `dc_data_interface_auth` (
  `INTF_ID` varchar(32) DEFAULT NULL COMMENT '接口对象ID',
  `CALL_USER` varchar(64) DEFAULT NULL COMMENT '访问用户ID',
  `CALL_PSWD` varchar(64) DEFAULT NULL COMMENT '访问密码',
  `CALL_FREQ` varchar(200) DEFAULT NULL COMMENT '访问频度',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='元数据接口权限';

-- ----------------------------
-- Table structure for dc_data_interface_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_data_interface_log`;
CREATE TABLE `dc_data_interface_log` (
  `INTF_ID` varchar(32) DEFAULT NULL COMMENT '接口对象ID',
  `CALL_BY` varchar(64) DEFAULT NULL COMMENT '调用者',
  `CALL_PARAM` varchar(1000) DEFAULT NULL COMMENT '客户端调用参数',
  `RTN_FIELDS` varchar(400) DEFAULT NULL COMMENT '接口字段(多个以,分割)',
  `CLINT_IP` varchar(32) DEFAULT NULL COMMENT '客户端IP',
  `START_TIME` varchar(32) DEFAULT NULL COMMENT '调用开始时间',
  `END_TIME` varchar(32) DEFAULT NULL COMMENT '调用结束时间',
  `RESPONSE_TIME` int(11) DEFAULT NULL COMMENT '响应时长(单位:秒)',
  `RST_FLAG` char(1) DEFAULT NULL COMMENT '调用结果标记(1-成功; 0-失败)',
  `RST_MSG` varchar(2000) DEFAULT NULL COMMENT '调用结果明细',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='元数据接口日志';

-- ----------------------------
-- Table structure for dc_data_process_design
-- ----------------------------
DROP TABLE IF EXISTS `dc_data_process_design`;
CREATE TABLE `dc_data_process_design` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `DESIGN_NAME` varchar(64) DEFAULT NULL COMMENT '设计名称',
  `DESIGN_DESC` varchar(200) DEFAULT NULL COMMENT '设计描述',
  `DESIGN_JSON` longtext COMMENT '设计json',
  `DESIGN_SCRIPT` text COMMENT '转换脚本',
  `REMARKS` text COMMENT '备注',
  `STATUS` char(2) DEFAULT '0' COMMENT '状态',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据转换过程设计';

-- ----------------------------
-- Table structure for dc_data_source
-- ----------------------------
DROP TABLE IF EXISTS `dc_data_source`;
CREATE TABLE `dc_data_source` (
  `ID` varchar(32) NOT NULL COMMENT '连接ID',
  `CONN_NAME` varchar(100) DEFAULT NULL COMMENT '连接名称',
  `CONN_DESC` varchar(32) DEFAULT NULL COMMENT '连接描述',
  `SERVER_TYPE` varchar(32) DEFAULT NULL COMMENT '数据库类型',
  `SERVER_IP` varchar(32) DEFAULT NULL COMMENT '服务器IP',
  `SERVER_PORT` int(11) DEFAULT NULL COMMENT '服务器端口',
  `SERVER_NAME` varchar(32) DEFAULT NULL COMMENT '数据库名称',
  `DRIVER_CLASS` varchar(100) DEFAULT NULL COMMENT '驱动类',
  `SERVER_URL` varchar(200) DEFAULT NULL COMMENT '连接串',
  `SERVER_USER` varchar(32) DEFAULT NULL COMMENT '用户名',
  `SERVER_PSWD` varchar(200) DEFAULT NULL COMMENT '密码',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `STATUS` char(1) DEFAULT NULL COMMENT '状态',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '排序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据源连接';

-- ----------------------------
-- Table structure for dc_hive_database
-- ----------------------------
DROP TABLE IF EXISTS `dc_hive_database`;
CREATE TABLE `dc_hive_database` (
  `ID` varchar(32) NOT NULL,
  `DATABASESPACE` varchar(64) DEFAULT NULL,
  `REMARKS` varchar(128) DEFAULT NULL,
  `CREATE_BY` varchar(32) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(32) DEFAULT NULL,
  `UPDATE_DATE` datetime DEFAULT NULL,
  `DEL_FLAG` char(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dc_hive_field
-- ----------------------------
DROP TABLE IF EXISTS `dc_hive_field`;
CREATE TABLE `dc_hive_field` (
  `ID` varchar(32) NOT NULL COMMENT '字段ID',
  `BELONG2_ID` varchar(32) NOT NULL DEFAULT '' COMMENT '属于哪个表/文件/接口',
  `FIELD_NAME` varchar(64) DEFAULT NULL COMMENT '字段名称',
  `FIELD_DESC` varchar(100) DEFAULT NULL COMMENT '字段描述',
  `FIELD_TYPE` varchar(200) DEFAULT NULL COMMENT '字段类型',
  `IS_KEY` tinyint(1) DEFAULT NULL COMMENT '是否主键',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  KEY `dc_hive_field_ibfk_1` (`BELONG2_ID`),
  CONSTRAINT `dc_hive_field_ibfk_1` FOREIGN KEY (`BELONG2_ID`) REFERENCES `dc_hive_table` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字段对象';

-- ----------------------------
-- Table structure for dc_hive_function
-- ----------------------------
DROP TABLE IF EXISTS `dc_hive_function`;
CREATE TABLE `dc_hive_function` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `FUNC_NAME` varchar(32) DEFAULT NULL COMMENT '函数名称',
  `FUNC_DESC` varchar(200) DEFAULT NULL COMMENT '函数描述',
  `FUNC_TYPE` char(1) DEFAULT NULL COMMENT '函数类别(UDF/UDAF/UDTF)',
  `JAR_PATH` varchar(100) DEFAULT NULL COMMENT 'jar包路径',
  `JAR_NAME` varchar(32) DEFAULT NULL COMMENT 'jar包名字',
  `CLASS_PATH` varchar(100) DEFAULT NULL COMMENT 'CLASS PATH',
  `FUNC_DEMO` varchar(200) DEFAULT NULL COMMENT '使用示例',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='HIVE自定义函数';

-- ----------------------------
-- Table structure for dc_hive_query_history
-- ----------------------------
DROP TABLE IF EXISTS `dc_hive_query_history`;
CREATE TABLE `dc_hive_query_history` (
  `h_sql` varchar(1000) DEFAULT NULL,
  `h_date` datetime DEFAULT NULL,
  `h_type` varchar(255) DEFAULT NULL,
  `h_user` varchar(100) DEFAULT NULL,
  `h_dbName` varchar(255) DEFAULT NULL,
  `del_flag` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dc_hive_table
-- ----------------------------
DROP TABLE IF EXISTS `dc_hive_table`;
CREATE TABLE `dc_hive_table` (
  `ID` varchar(32) NOT NULL COMMENT '连接ID',
  `TABLE_NAME` varchar(200) DEFAULT NULL COMMENT '表名',
  `TABLE_DESC` varchar(200) DEFAULT NULL COMMENT '数据表描述',
  `TABLE_SPACE` varchar(200) DEFAULT NULL COMMENT '表空间',
  `SEPARATOR_SIGN` varchar(200) DEFAULT NULL COMMENT '分隔符',
  `OWNER` varchar(200) DEFAULT NULL COMMENT '拥有者',
  `TABLE_TYPE` varchar(200) DEFAULT NULL COMMENT '表类型',
  `LOCATION` varchar(200) DEFAULT NULL COMMENT '表位置',
  `ISLOAD_DATA` varchar(200) DEFAULT NULL COMMENT '是否导入数据',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  `STATUS` char(1) DEFAULT NULL COMMENT '状态(0-新建;1-生成表;9-导入数据)',
  PRIMARY KEY (`ID`),
  CONSTRAINT `dc_hive_table_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `dc_obj_main` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='存储数据字段/对象的链路关系';

-- ----------------------------
-- Table structure for dc_hive_udf
-- ----------------------------
DROP TABLE IF EXISTS `dc_hive_udf`;
CREATE TABLE `dc_hive_udf` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `UDF_NAME` varchar(32) DEFAULT NULL COMMENT 'UDF 名称',
  `UDF_DESC` varchar(100) DEFAULT NULL COMMENT 'UDF 描述',
  `PATH` varchar(100) DEFAULT NULL COMMENT 'HDFS路径',
  `STATUS` char(1) DEFAULT NULL COMMENT '状态: 1. 未注册 2. 已注册',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dc_intf_visit_apply
-- ----------------------------
DROP TABLE IF EXISTS `dc_intf_visit_apply`;
CREATE TABLE `dc_intf_visit_apply` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `OBJ_ID` varchar(32) DEFAULT '' COMMENT '接口ID',
  `STATUS` char(1) DEFAULT NULL COMMENT '申请状态(0-申请中;1-已申请;9-已撤销)',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `APPLY_RESULT` varchar(200) DEFAULT NULL COMMENT '申请结果',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='接口访问申请表';

-- ----------------------------
-- Table structure for dc_intf_visit_list
-- ----------------------------
DROP TABLE IF EXISTS `dc_intf_visit_list`;
CREATE TABLE `dc_intf_visit_list` (
  `ID` varchar(32) NOT NULL COMMENT 'id(如果是用户申请,该ID=申请ID)',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `OBJ_ID` varchar(32) DEFAULT '' COMMENT '接口ID',
  `CONN_TYPE` char(1) DEFAULT NULL COMMENT '访问类别(1-白名单;0-黑名单)',
  `DATA_SRC` char(1) DEFAULT NULL COMMENT '数据来源(1-添加;2-用户申请)',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='接口访问列表(白名单/黑名单)';

-- ----------------------------
-- Table structure for dc_job_exportdata
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_exportdata`;
CREATE TABLE `dc_job_exportdata` (
  `id` varchar(32) NOT NULL,
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_desc` varchar(200) DEFAULT NULL COMMENT '任务描述',
  `from_link` char(1) DEFAULT NULL COMMENT '源数据类型(1-hdfs;2-hive)',
  `metaData_id` varchar(32) DEFAULT NULL COMMENT '元数据Id',
  `data_path` varchar(200) DEFAULT NULL COMMENT '源数据路径/表名',
  `map_num` int(4) DEFAULT NULL COMMENT '并行任务数',
  `field_split_by` varchar(16) DEFAULT NULL COMMENT '字段分隔符',
  `null_string` varchar(16) DEFAULT NULL COMMENT 'null字符串列替换值',
  `null_non_string` varchar(16) DEFAULT NULL COMMENT 'null非字符串列替换值',
  `to_link` varchar(32) DEFAULT NULL COMMENT '目标数据源连接',
  `schema_name` varchar(32) DEFAULT NULL,
  `table_name` varchar(32) DEFAULT NULL,
  `assign_column` char(1) DEFAULT NULL COMMENT '是否指定列',
  `table_column` varchar(1000) DEFAULT NULL,
  `is_clear_data` char(1) DEFAULT NULL COMMENT '是否清空目标表数据(1-是;0-否)',
  `is_update` char(1) DEFAULT '0' COMMENT '是否更新(1-是;0-否)',
  `update_key` varchar(64) DEFAULT NULL COMMENT '主键更新列,更新模式下以该字段作为更新依据',
  `update_mode` varchar(32) DEFAULT NULL COMMENT '更新策略, updateonly(默认) allowinsert',
  `log_dir` varchar(200) DEFAULT NULL COMMENT '日志目录',
  `remarks` varchar(2000) DEFAULT NULL COMMENT '备注(sqoop脚本)',
  `status` char(2) DEFAULT NULL COMMENT '状态',
  `del_flag` char(1) DEFAULT NULL COMMENT '删除标记',
  `sort_num` int(4) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据导出';

-- ----------------------------
-- Table structure for dc_job_hdfslog
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_hdfslog`;
CREATE TABLE `dc_job_hdfslog` (
  `job_id` varchar(64) DEFAULT NULL,
  `upload_time` datetime DEFAULT NULL,
  `fullpath` varchar(64) DEFAULT NULL,
  `status` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dc_job_transdata
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transdata`;
CREATE TABLE `dc_job_transdata` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `job_name` varchar(64) DEFAULT '' COMMENT '任务名称',
  `job_desc` varchar(200) DEFAULT NULL COMMENT '任务描述',
  `from_link` varchar(32) DEFAULT NULL COMMENT '连接源',
  `to_link` varchar(32) DEFAULT NULL COMMENT '连接目标',
  `append_type` char(1) DEFAULT NULL COMMENT '采集模式(1-全量;2-增量)',
  `log_dir` varchar(200) DEFAULT NULL COMMENT 'hdfs日志路径',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(2000) DEFAULT NULL COMMENT '备注(采集脚本)',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据采集Job';

-- ----------------------------
-- Table structure for dc_job_transdata_link_db
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transdata_link_db`;
CREATE TABLE `dc_job_transdata_link_db` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `job_id` varchar(32) NOT NULL COMMENT 'jobId',
  `schema_name` varchar(64) DEFAULT NULL COMMENT '连接schema名称',
  `table_NAME` varchar(100) DEFAULT '' COMMENT '数据表名称',
  `table_sql` varchar(500) DEFAULT NULL COMMENT '查询脚本',
  `table_column` varchar(2000) DEFAULT NULL COMMENT '字段',
  `partition_column` varchar(64) DEFAULT NULL COMMENT '分区字段',
  `partition_null` char(1) DEFAULT NULL COMMENT '分区字段是否可为空值',
  `boundary_query` varchar(200) DEFAULT NULL COMMENT 'Boundary query',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(1) DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`ID`),
  KEY `ref_dc_job_link_db` (`job_id`),
  CONSTRAINT `ref_dc_job_link_db` FOREIGN KEY (`job_id`) REFERENCES `dc_job_transdata` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据采集jod-连接源设置';

-- ----------------------------
-- Table structure for dc_job_transdata_link_hdfs
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transdata_link_hdfs`;
CREATE TABLE `dc_job_transdata_link_hdfs` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `job_id` varchar(32) DEFAULT NULL COMMENT 'jobId',
  `output_format` varchar(8) DEFAULT NULL COMMENT '输出格式',
  `overRide_Null` char(1) DEFAULT NULL COMMENT '是否覆盖null',
  `null_value` varchar(32) DEFAULT NULL COMMENT 'null值替代',
  `compres_format` varchar(32) DEFAULT NULL COMMENT '压缩格式',
  `output_dir` varchar(200) DEFAULT NULL COMMENT '输出路径',
  `output_table` varchar(64) DEFAULT NULL COMMENT '数据表(hive/hbase)',
  `is_create_table` char(1) DEFAULT NULL COMMENT '是否建表(hbase/hive)',
  `key_field` varchar(64) DEFAULT NULL COMMENT '主键字段(hbase)',
  `column_family` varchar(64) DEFAULT NULL COMMENT '列族名称(hbase)',
  `increment_type` varchar(32) DEFAULT NULL COMMENT '增量方式',
  `increment_field` varchar(32) DEFAULT NULL COMMENT '增量字段',
  `increment_value` varchar(32) DEFAULT NULL COMMENT '增量字段值',
  `partition_field` varchar(64) DEFAULT NULL COMMENT '分区字段(hive中使用)',
  `partition_value` varchar(64) DEFAULT NULL COMMENT 'hive分区值(支持变量引入)',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `status` char(2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ref_dc_job_link_hdfs` (`job_id`),
  CONSTRAINT `ref_dc_job_link_hdfs` FOREIGN KEY (`job_id`) REFERENCES `dc_job_transdata` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据采集jod-连接目标设置';

-- ----------------------------
-- Table structure for dc_job_transfile
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transfile`;
CREATE TABLE `dc_job_transfile` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `description` varchar(64) DEFAULT NULL COMMENT '描述',
  `jobname` varchar(64) DEFAULT NULL COMMENT '任务名称',
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='采集传输文件';

-- ----------------------------
-- Table structure for dc_job_transfile_hdfs
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transfile_hdfs`;
CREATE TABLE `dc_job_transfile_hdfs` (
  `job_id` varchar(64) NOT NULL DEFAULT '',
  `ftp_ip` varchar(64) DEFAULT NULL,
  `port` int(64) DEFAULT NULL,
  `account` varchar(64) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `pathname` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dc_job_transhdfs
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transhdfs`;
CREATE TABLE `dc_job_transhdfs` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `job_name` varchar(64) DEFAULT '' COMMENT '任务名称',
  `job_desc` varchar(200) DEFAULT NULL COMMENT '任务描述',
  `copy_num` tinyint(4) DEFAULT NULL COMMENT '并发拷贝数',
  `is_override` char(1) DEFAULT 'N' COMMENT '是否覆盖',
  `src_hdfs_address` varchar(100) DEFAULT NULL COMMENT '源HDFS地址',
  `src_hdfs_dir` varchar(400) DEFAULT NULL COMMENT '文件路径',
  `src_hdfs_version` varchar(32) DEFAULT NULL COMMENT '源HDFS版本',
  `output_dir` varchar(400) DEFAULT NULL COMMENT '目标HDFS路径',
  `log_dir` varchar(200) DEFAULT NULL COMMENT 'hdfs日志目录',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(600) DEFAULT NULL COMMENT '备注(采集脚本)',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  `sqr` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='HDFS采集任务';

-- ----------------------------
-- Table structure for dc_job_transintf
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transintf`;
CREATE TABLE `dc_job_transintf` (
  `id` varchar(32) NOT NULL,
  `job_name` varchar(64) DEFAULT NULL COMMENT '任务名称',
  `job_desc` varchar(200) DEFAULT NULL COMMENT '任务描述',
  `job_type` char(1) DEFAULT NULL COMMENT '接口类别(1-restful ws; 2-soap ws)',
  `tar_type` char(1) DEFAULT NULL COMMENT '目标类别(0-mysql; 1-hdfs; 2-hive; 3-hbase)',
  `log_dir` varchar(200) DEFAULT NULL COMMENT '日志路径',
  `del_flag` char(1) DEFAULT NULL COMMENT '删除标记',
  `status` char(2) DEFAULT NULL,
  `remarks` varchar(2000) DEFAULT NULL,
  `sort_num` tinyint(4) DEFAULT NULL,
  `create_by` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(32) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='接口数据采集';

-- ----------------------------
-- Table structure for dc_job_transintf_src
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transintf_src`;
CREATE TABLE `dc_job_transintf_src` (
  `id` varchar(32) NOT NULL,
  `jobId` varchar(32) NOT NULL COMMENT '任务ID',
  `ws_path` varchar(400) DEFAULT NULL COMMENT 'wsdl路径path',
  `ws_namespace` varchar(200) DEFAULT NULL COMMENT 'ws端口',
  `ws_method` varchar(64) DEFAULT NULL COMMENT 'ws调用方法',
  `rest_url` varchar(400) DEFAULT NULL COMMENT 'restUrl',
  `rest_type` varchar(8) DEFAULT NULL COMMENT 'rest传参方式(post/get)',
  `rest_contentType` varchar(64) DEFAULT NULL COMMENT 'rest参数类型',
  `params` varchar(400) DEFAULT NULL COMMENT '参数列表多个参数以&分割',
  PRIMARY KEY (`id`),
  KEY `pk_srcIntf_objId` (`jobId`),
  CONSTRAINT `pk_srcIntf_objId` FOREIGN KEY (`jobId`) REFERENCES `dc_job_transintf` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='接口数据采集源配置';

-- ----------------------------
-- Table structure for dc_job_transintf_tar
-- ----------------------------
DROP TABLE IF EXISTS `dc_job_transintf_tar`;
CREATE TABLE `dc_job_transintf_tar` (
  `id` varchar(32) NOT NULL,
  `jobId` varchar(32) NOT NULL COMMENT 'jobId',
  `connId` varchar(32) DEFAULT NULL COMMENT '数据源链接Id',
  `schemaName` varchar(64) DEFAULT NULL COMMENT '数据库Schema',
  `tarName` varchar(200) DEFAULT NULL COMMENT '目标名称',
  `create_flag` char(1) DEFAULT 'N' COMMENT '创建标记',
  PRIMARY KEY (`id`),
  KEY `pk_tarIntf_objId` (`jobId`),
  CONSTRAINT `pk_tarIntf_objId` FOREIGN KEY (`jobId`) REFERENCES `dc_job_transintf` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='接口数据采集目标端';

-- ----------------------------
-- Table structure for dc_obj_auth
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_auth`;
CREATE TABLE `dc_obj_auth` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `OBJ_ID` varchar(32) DEFAULT NULL COMMENT '数据对象ID',
  `AUTH_TIME` datetime DEFAULT NULL COMMENT '授权时间',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='存储数据表的用户授权信息, 用户表与数据对象表关系为N:N';

-- ----------------------------
-- Table structure for dc_obj_cata_ref
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_cata_ref`;
CREATE TABLE `dc_obj_cata_ref` (
  `OBJ_ID` varchar(128) NOT NULL COMMENT '数据对象ID',
  `CATA_ID` varchar(128) NOT NULL COMMENT '分类ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据对象-分类 N:N的关系';

-- ----------------------------
-- Table structure for dc_obj_collect
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_collect`;
CREATE TABLE `dc_obj_collect` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `USER_ID` varchar(32) NOT NULL COMMENT '用户ID',
  `OBJ_ID` varchar(32) NOT NULL COMMENT '数据对象ID',
  `COLLECT_TIME` datetime DEFAULT NULL COMMENT '收藏时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表与数据对象表关系为N:N';

-- ----------------------------
-- Table structure for dc_obj_field
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_field`;
CREATE TABLE `dc_obj_field` (
  `OBJ_ID` varchar(32) NOT NULL COMMENT '字段ID',
  `BELONG2_ID` varchar(32) NOT NULL COMMENT '属于哪个表/文件/接口',
  `FIELD_NAME` varchar(64) DEFAULT NULL COMMENT '字段名称',
  `FIELD_DESC` varchar(100) DEFAULT NULL COMMENT '字段描述',
  `FIELD_TYPE` varchar(200) DEFAULT NULL COMMENT '字段类型',
  `FIELD_LENG` int(11) DEFAULT NULL COMMENT '字段长度',
  `DECIMAL_NUM` int(11) DEFAULT NULL COMMENT '小数位数',
  `IS_KEY` tinyint(1) DEFAULT NULL COMMENT '是否主键',
  `VALIDATE_RULE` varchar(32) DEFAULT NULL COMMENT '字段验证规则',
  `IS_NULL` char(1) DEFAULT NULL COMMENT '是否为空(1-非空;0-允许空)',
  `DEFAULT_VALUE` varchar(64) DEFAULT NULL COMMENT '默认值',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`OBJ_ID`),
  KEY `dc_obj_field_ibfk_1` (`BELONG2_ID`),
  CONSTRAINT `dc_obj_field_ibfk_1` FOREIGN KEY (`BELONG2_ID`) REFERENCES `dc_obj_table` (`OBJ_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字段对象';

-- ----------------------------
-- Table structure for dc_obj_file
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_file`;
CREATE TABLE `dc_obj_file` (
  `OBJ_ID` varchar(32) NOT NULL COMMENT '文件ID',
  `FILE_NAME` varchar(100) DEFAULT NULL COMMENT '文件名称',
  `FILE_BELONG` varchar(100) DEFAULT NULL,
  `FILE_URL` varchar(200) DEFAULT NULL COMMENT '文件路径',
  `IS_STRUCT` binary(1) DEFAULT NULL COMMENT '是否结构化',
  `SPLITTER` varchar(32) DEFAULT NULL COMMENT '内容分隔符',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`OBJ_ID`),
  CONSTRAINT `dc_obj_file_ibfk_1` FOREIGN KEY (`OBJ_ID`) REFERENCES `dc_obj_main` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文件对象';

-- ----------------------------
-- Table structure for dc_obj_folder
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_folder`;
CREATE TABLE `dc_obj_folder` (
  `OBJ_ID` varchar(64) NOT NULL,
  `FOLDER_NAME` varchar(64) DEFAULT NULL,
  `FOLDER_URL` varchar(200) DEFAULT NULL,
  `IS_STRUCT` binary(1) DEFAULT NULL,
  `REMARKS` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`OBJ_ID`),
  CONSTRAINT `dc_obj_folder_ibfk_1` FOREIGN KEY (`OBJ_ID`) REFERENCES `dc_obj_main` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dc_obj_interface
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_interface`;
CREATE TABLE `dc_obj_interface` (
  `OBJ_ID` varchar(32) NOT NULL COMMENT '接口ID',
  `INTFC_TYPE` varchar(18) DEFAULT NULL COMMENT '接口类型(1-rest;2-soap)',
  `INTFC_SRC_ID` varchar(32) DEFAULT NULL COMMENT '元数据对象ID(通过元数据发布接口关联)',
  `INTFC_PROTOCAL` char(2) DEFAULT NULL COMMENT '接口协议',
  `INTFC_URL` varchar(200) DEFAULT NULL COMMENT '接口地址',
  `INTFC_NAMESPACE` varchar(200) DEFAULT NULL COMMENT '空间名称',
  `INTFC_USER` varchar(32) DEFAULT NULL COMMENT '连接用户',
  `INTFC_PSWD` varchar(32) DEFAULT NULL COMMENT '连接密码',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `INTFC_METHOD` varchar(64) DEFAULT NULL COMMENT '接口方法',
  `INTFC_CALLTYPE` varchar(16) DEFAULT NULL COMMENT '调用方式(get; post; put; delete)',
  `INTFC_CONTYPE` varchar(64) DEFAULT NULL COMMENT '传参方式(rest post调用时传参)',
  `INTFC_PARAMS` varchar(400) DEFAULT NULL COMMENT '参数列表(多个参数以&分割)',
  `INTFC_FIELDS` varchar(400) DEFAULT NULL COMMENT '字段列表',
  `ORDER_FIELDS` varchar(200) DEFAULT NULL COMMENT '排序字段(指定接口数据的排序方式)',
  PRIMARY KEY (`OBJ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据接口对象';

-- ----------------------------
-- Table structure for dc_obj_label
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_label`;
CREATE TABLE `dc_obj_label` (
  `ID` varchar(32) NOT NULL COMMENT '标签ID',
  `LABEL_NAME` varchar(64) DEFAULT NULL COMMENT '标签名称',
  `LABEL_DESC` varchar(200) DEFAULT NULL COMMENT '标签描述',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(200) DEFAULT NULL,
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='存储数据标签信息';

-- ----------------------------
-- Table structure for dc_obj_label_ref
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_label_ref`;
CREATE TABLE `dc_obj_label_ref` (
  `OBJ_ID` varchar(32) NOT NULL COMMENT '数据对象ID',
  `LABEL_ID` varchar(32) NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`OBJ_ID`,`LABEL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据对象-标签 N:N的关系';

-- ----------------------------
-- Table structure for dc_obj_link
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_link`;
CREATE TABLE `dc_obj_link` (
  `ID` varchar(32) NOT NULL COMMENT '连接ID',
  `DATA_SOURCE` varchar(32) DEFAULT NULL COMMENT '数据来源(extract_db-db采集,trans_job-转换任务)',
  `PROCESS_ID` varchar(32) DEFAULT NULL COMMENT '转换过程Id',
  `LINK_TYPE` varchar(16) DEFAULT NULL COMMENT '连接类型(对象/字段)',
  `SRC_OBJ_ID` varchar(400) DEFAULT NULL COMMENT '源对象ID',
  `TAR_OBJ_ID` varchar(100) DEFAULT NULL COMMENT '目标对象ID',
  `TAR_OBJ_TYPE` varchar(32) DEFAULT NULL COMMENT '目标字段类型',
  `RELATION_EXP` varchar(100) DEFAULT NULL COMMENT '关系表达式',
  `TRANS_PARAM` varchar(100) DEFAULT NULL COMMENT '转换参数',
  `LINK_JSON` varchar(400) DEFAULT NULL COMMENT '链路全路径, json格式存储',
  `SORT_NUM` int(4) DEFAULT NULL COMMENT '排序(输出任务序号)',
  `OUTPUT_SCRIPT` text COMMENT '输出脚本',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='存储数据字段/对象的链路关系';

-- ----------------------------
-- Table structure for dc_obj_main
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_main`;
CREATE TABLE `dc_obj_main` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `OBJ_CODE` varchar(32) DEFAULT NULL COMMENT '对象编码',
  `OBJ_NAME` varchar(100) DEFAULT '' COMMENT '对象名称',
  `OBJ_TYPE` varchar(32) DEFAULT NULL COMMENT '对象类型(数据表/接口/文件/字段)',
  `SYSTEM_ID` varchar(32) DEFAULT NULL COMMENT '所属应用',
  `OBJ_DESC` varchar(200) DEFAULT NULL COMMENT '对象描述',
  `MANAGER_PER` varchar(32) DEFAULT NULL COMMENT '业务负责人',
  `MANAGER_ORG` varchar(32) DEFAULT NULL COMMENT '业务部门',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `JOB_ID` varchar(32) DEFAULT NULL COMMENT '任务ID',
  `JOB_TYPE` char(2) DEFAULT NULL COMMENT '任务类别(01-DB采集,02-文件采集,03-hdfs采集;11-数据转换)',
  `JOB_SRC_FLAG` char(1) DEFAULT NULL COMMENT '是否JOB源数据(T-是;F-否)',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dc_obj_table
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_table`;
CREATE TABLE `dc_obj_table` (
  `OBJ_ID` varchar(32) NOT NULL DEFAULT '' COMMENT '对象表ID',
  `TABLE_NAME` varchar(100) DEFAULT NULL COMMENT '数据表来源',
  `TABLE_LINK` varchar(32) DEFAULT NULL COMMENT '数据源连接',
  `DATA_NUM` int(11) DEFAULT NULL COMMENT '数据量',
  `DB_TYPE` varchar(32) DEFAULT NULL COMMENT '数据库类别',
  `DB_DATABASE` varchar(64) DEFAULT NULL COMMENT 'database名称',
  `STORE_TYPE` char(2) DEFAULT NULL COMMENT '增量更新/全表更新',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`OBJ_ID`),
  CONSTRAINT `dc_obj_table_ibfk_1` FOREIGN KEY (`OBJ_ID`) REFERENCES `dc_obj_main` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据表对象';

-- ----------------------------
-- Table structure for dc_obj_version
-- ----------------------------
DROP TABLE IF EXISTS `dc_obj_version`;
CREATE TABLE `dc_obj_version` (
  `id` varchar(32) NOT NULL,
  `JOB_ID` varchar(32) DEFAULT NULL,
  `OBJ_NAME` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `active` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `OBJ_TYPE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dc_task_detail
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_detail`;
CREATE TABLE `dc_task_detail` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `IN_DATA` varchar(200) DEFAULT NULL COMMENT '输入数据对象',
  `OUT_DATA` varchar(200) DEFAULT NULL COMMENT '输出数据对象',
  `TASK_ID` varchar(32) DEFAULT NULL COMMENT '任务ID',
  `TASK_DESC` varchar(200) DEFAULT NULL COMMENT '任务描述',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `REMARKS` varchar(200) DEFAULT NULL COMMENT '备注',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='负责数据处理过程明细';

-- ----------------------------
-- Table structure for dc_task_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_log`;
CREATE TABLE `dc_task_log` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `className` varchar(200) DEFAULT '1' COMMENT '类名',
  `methodName` varchar(255) DEFAULT '' COMMENT '方法名',
  `status` varchar(2) DEFAULT NULL COMMENT '状态',
  `results` varchar(255) DEFAULT NULL COMMENT '运行结果',
  `params` text COMMENT '参数',
  `exception` text COMMENT '异常信息',
  `start_date` datetime DEFAULT NULL COMMENT '开始时间',
  `end_date` datetime DEFAULT NULL COMMENT '结束时间',
  PRIMARY KEY (`id`),
  KEY `sys_log_create_by` (`start_date`),
  KEY `sys_log_type` (`className`),
  KEY `sys_log_create_date` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日志表';

-- ----------------------------
-- Table structure for dc_task_log_next
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_log_next`;
CREATE TABLE `dc_task_log_next` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `taskid` varchar(64) DEFAULT NULL COMMENT '调度主键',
  `nexttime` datetime DEFAULT NULL COMMENT '下次执行时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度任务下次执行时间';

-- ----------------------------
-- Table structure for dc_task_log_quartz
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_log_quartz`;
CREATE TABLE `dc_task_log_quartz` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `taskid` varchar(64) DEFAULT NULL COMMENT '调度主键',
  `starttime` datetime DEFAULT NULL COMMENT '开始时间',
  `edntime` datetime DEFAULT NULL COMMENT '结束时间',
  `status` varchar(64) DEFAULT NULL COMMENT '状态',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度日志';

-- ----------------------------
-- Table structure for dc_task_log_run
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_log_run`;
CREATE TABLE `dc_task_log_run` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `taskid` varchar(64) DEFAULT NULL COMMENT '调度主键',
  `runid` varchar(64) DEFAULT NULL COMMENT '调度任务主键',
  `startdate` datetime DEFAULT NULL COMMENT '开始时间',
  `enddate` datetime DEFAULT NULL COMMENT '结束时间',
  `status` varchar(64) DEFAULT NULL COMMENT '状态',
  `remarks` varchar(888) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度子任务执行情况';

-- ----------------------------
-- Table structure for dc_task_main
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_main`;
CREATE TABLE `dc_task_main` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `TASK_NAME` varchar(200) DEFAULT NULL COMMENT '类名',
  `METHOD_NAME` varchar(64) DEFAULT NULL COMMENT '方法名',
  `TASK_DESC` varchar(200) DEFAULT NULL COMMENT '调度描述',
  `PRIORITY` char(10) DEFAULT NULL COMMENT '优先级',
  `STATUS` char(1) DEFAULT NULL COMMENT '状态',
  `PARAMETER` varchar(200) DEFAULT NULL COMMENT '参数',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  `CLASSNAME` varchar(200) DEFAULT NULL,
  `TASKTYPE` varchar(2) DEFAULT NULL,
  `TASKPATH` varchar(500) DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  `filename` varchar(100) DEFAULT NULL,
  `filePATH` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度时间配置';

-- ----------------------------
-- Table structure for dc_task_queue
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_queue`;
CREATE TABLE `dc_task_queue` (
  `id` varchar(32) NOT NULL,
  `queue_name` varchar(64) DEFAULT NULL COMMENT '队列名称',
  `queue_desc` varchar(200) DEFAULT NULL COMMENT '队列描述',
  `status` char(1) DEFAULT '0' COMMENT '状态(0-新建;9-添加调度)',
  `priority` int(4) DEFAULT NULL COMMENT '优先级,数字越小越高',
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT NULL,
  `create_by` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(32) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务队列';

-- ----------------------------
-- Table structure for dc_task_queue_ref
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_queue_ref`;
CREATE TABLE `dc_task_queue_ref` (
  `id` varchar(32) NOT NULL COMMENT 'ID',
  `queue_id` varchar(32) NOT NULL COMMENT '队列Id',
  `task_Id` varchar(32) NOT NULL COMMENT '任务Id',
  `pre_task_id` varchar(32) DEFAULT NULL COMMENT '前置任务Id',
  `pre_task_status` varchar(32) DEFAULT NULL COMMENT '前置任务状态',
  `task_result` char(1) DEFAULT NULL COMMENT '运行结果(1-成功;2-失败;0-未运行)',
  `task_status` char(1) DEFAULT '0' COMMENT '运行状态',
  `sort_num` int(6) DEFAULT NULL COMMENT '显示顺序',
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT NULL COMMENT '删除标记',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) DEFAULT NULL COMMENT '修改者',
  `update_date` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务队列关联表';

-- ----------------------------
-- Table structure for dc_task_time
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_time`;
CREATE TABLE `dc_task_time` (
  `ID` varchar(32) NOT NULL COMMENT 'ID',
  `SCHEDULE_NAME` varchar(200) DEFAULT NULL COMMENT '调度名称',
  `SCHEDULE_EXPR` varchar(64) DEFAULT NULL COMMENT '调度时间(quartz表达式)',
  `URL_LINK` varchar(64) DEFAULT NULL,
  `SCHEDULE_DESC` varchar(200) DEFAULT NULL COMMENT '调度描述',
  `TRIGGER_TYPE` char(1) DEFAULT '1',
  `DEL_FLAG` char(1) DEFAULT '0' COMMENT '删除标记',
  `STATUS` char(1) DEFAULT '0' COMMENT '状态',
  `RESULT` varchar(200) DEFAULT NULL,
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建者',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  `CREATE_DEPT` varchar(200) DEFAULT NULL,
  `taskfromtype` char(2) DEFAULT NULL,
  `taskfromid` varchar(32) NOT NULL,
  `taskfromname` varchar(200) DEFAULT NULL,
  `nexttime` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度时间配置';

-- ----------------------------
-- Table structure for dc_task_time_ref
-- ----------------------------
DROP TABLE IF EXISTS `dc_task_time_ref`;
CREATE TABLE `dc_task_time_ref` (
  `TASK_ID` varchar(32) NOT NULL COMMENT '调度任务ID',
  `TIME_ID` varchar(32) NOT NULL COMMENT '调度时间ID',
  `METHOD_NAME` varchar(200) DEFAULT NULL COMMENT '方法名',
  `CLASS_NAME` varchar(200) DEFAULT NULL COMMENT '类名',
  `TRIGGER` varchar(20) DEFAULT NULL,
  `PARAMETER` varchar(500) DEFAULT NULL COMMENT '参数',
  `TASK_DESC` varchar(200) DEFAULT NULL COMMENT '调度描述',
  PRIMARY KEY (`TASK_ID`,`TIME_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度任务-时间 N:N的关系';

-- ----------------------------
-- Table structure for dc_transdata_main
-- ----------------------------
DROP TABLE IF EXISTS `dc_transdata_main`;
CREATE TABLE `dc_transdata_main` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `job_name` varchar(64) DEFAULT '' COMMENT '任务名称',
  `job_desc` varchar(200) DEFAULT NULL COMMENT '任务描述',
  `job_path` varchar(200) DEFAULT NULL COMMENT '任务路径(存放过程文件)',
  `input_type` tinyint(4) DEFAULT NULL COMMENT '输入类别(1-hdfs;2-impala;)',
  `input_name` varchar(200) DEFAULT NULL COMMENT '输入对象',
  `output_type` tinyint(4) DEFAULT NULL COMMENT '输出类别(1-hdfs;2-impala;)',
  `output_name` varchar(200) DEFAULT NULL COMMENT '输出对象',
  `trans_type` varchar(16) DEFAULT NULL COMMENT '转换策略(1-异常继续/2-异常终止)',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(600) DEFAULT NULL COMMENT '备注',
  `SORT_NUM` int(11) DEFAULT NULL COMMENT '显示顺序',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  `RESULT_STATUS` char(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据转换任务';

-- ----------------------------
-- Table structure for dc_transdata_main_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_transdata_main_log`;
CREATE TABLE `dc_transdata_main_log` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `job_id` varchar(32) DEFAULT '' COMMENT '任务id',
  `begin_time` datetime DEFAULT NULL COMMENT '任务开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '任务结束时间',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(1) DEFAULT NULL COMMENT '状态',
  `REMARKS` text COMMENT '备注',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据转换任务日志';

-- ----------------------------
-- Table structure for dc_transdata_sub
-- ----------------------------
DROP TABLE IF EXISTS `dc_transdata_sub`;
CREATE TABLE `dc_transdata_sub` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `job_id` varchar(32) DEFAULT '' COMMENT '任务ID',
  `trans_name` varchar(100) DEFAULT NULL COMMENT '转换名称',
  `trans_desc` varchar(200) DEFAULT NULL COMMENT '转换描述',
  `trans_engine` varchar(16) DEFAULT NULL COMMENT '转换引擎',
  `trans_conn` varchar(32) DEFAULT NULL COMMENT '转换引擎连接',
  `trans_sql` text COMMENT '转换脚本',
  `trans_filter` varchar(400) DEFAULT NULL COMMENT '转换过滤条件',
  `trans_type` char(2) DEFAULT NULL COMMENT '转换类别(10-数据转换;20-数据采集;30-数据导出)',
  `trans_rst` varchar(100) DEFAULT NULL COMMENT '转换结果名(impala名)',
  `sort_num` tinyint(4) DEFAULT NULL COMMENT '排序',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(2) DEFAULT NULL COMMENT '状态',
  `REMARKS` varchar(600) DEFAULT NULL COMMENT '备注',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据转换过程';

-- ----------------------------
-- Table structure for dc_transdata_sub_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_transdata_sub_log`;
CREATE TABLE `dc_transdata_sub_log` (
  `ID` varchar(32) NOT NULL COMMENT 'id',
  `job_id` varchar(32) DEFAULT '' COMMENT '任务id',
  `sub_id` varchar(32) DEFAULT '' COMMENT '过程id',
  `begin_time` datetime DEFAULT NULL COMMENT '过程开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '过程结束时间',
  `DEL_FLAG` char(1) DEFAULT NULL COMMENT '删除标记',
  `STATUS` char(1) DEFAULT NULL COMMENT '状态',
  `REMARKS` text COMMENT '备注',
  `CREATE_BY` varchar(32) DEFAULT NULL COMMENT '创建人',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `UPDATE_BY` varchar(32) DEFAULT NULL COMMENT '修改者',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据转换过程日志';

-- ----------------------------
-- Table structure for form_leave
-- ----------------------------
DROP TABLE IF EXISTS `form_leave`;
CREATE TABLE `form_leave` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `user_id` varchar(64) DEFAULT NULL COMMENT '员工',
  `office_id` varchar(64) DEFAULT NULL COMMENT '归属部门',
  `area_id` varchar(64) DEFAULT NULL COMMENT '归属区域',
  `begin_date` datetime DEFAULT NULL COMMENT '请假开始日期',
  `end_date` datetime DEFAULT NULL COMMENT '请假结束日期',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='请假单';

-- ----------------------------
-- Table structure for gen_scheme
-- ----------------------------
DROP TABLE IF EXISTS `gen_scheme`;
CREATE TABLE `gen_scheme` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `category` varchar(2000) DEFAULT NULL COMMENT '分类',
  `package_name` varchar(500) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `sub_module_name` varchar(30) DEFAULT NULL COMMENT '生成子模块名',
  `function_name` varchar(500) DEFAULT NULL COMMENT '生成功能名',
  `function_name_simple` varchar(100) DEFAULT NULL COMMENT '生成功能名（简写）',
  `function_author` varchar(100) DEFAULT NULL COMMENT '生成功能作者',
  `gen_table_id` varchar(200) DEFAULT NULL COMMENT '生成表编号',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `gen_scheme_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='生成方案';

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `comments` varchar(500) DEFAULT NULL COMMENT '描述',
  `class_name` varchar(100) DEFAULT NULL COMMENT '实体类名称',
  `parent_table` varchar(200) DEFAULT NULL COMMENT '关联父表',
  `parent_table_fk` varchar(100) DEFAULT NULL COMMENT '关联父表外键',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  `issync` varchar(45) DEFAULT NULL COMMENT '同步',
  `table_type` varchar(45) DEFAULT NULL COMMENT '表类型',
  PRIMARY KEY (`id`),
  KEY `gen_table_name` (`name`),
  KEY `gen_table_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业务表';

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `gen_table_id` varchar(64) DEFAULT NULL COMMENT '归属表编号',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `comments` varchar(500) DEFAULT NULL COMMENT '描述',
  `jdbc_type` varchar(100) DEFAULT NULL COMMENT '列的数据类型的字节长度',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键',
  `is_null` char(1) DEFAULT NULL COMMENT '是否可为空',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段',
  `query_type` varchar(200) DEFAULT NULL COMMENT '查询方式（等于、不等于、大于、小于、范围、左LIKE、右LIKE、左右LIKE）',
  `show_type` varchar(200) DEFAULT NULL COMMENT '字段生成方案（文本框、文本域、下拉框、复选框、单选框、字典选择、人员选择、部门选择、区域选择）',
  `dict_type` varchar(200) DEFAULT NULL COMMENT '字典类型',
  `settings` varchar(2000) DEFAULT NULL COMMENT '其它设置（扩展字段JSON）',
  `sort` decimal(10,0) DEFAULT NULL COMMENT '排序（升序）',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  `is_form` varchar(45) DEFAULT NULL COMMENT '是否表单显示',
  `tableName` varchar(45) DEFAULT NULL COMMENT '管理的查询表名',
  `fieldLabels` varchar(512) DEFAULT NULL,
  `fieldKeys` varchar(512) DEFAULT NULL,
  `searchLabel` varchar(45) DEFAULT NULL,
  `searchKey` varchar(45) DEFAULT NULL,
  `validateType` varchar(45) DEFAULT NULL,
  `min_Length` varchar(45) DEFAULT NULL,
  `max_Length` varchar(45) DEFAULT NULL,
  `min_Value` varchar(45) DEFAULT NULL,
  `max_Value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gen_table_column_table_id` (`gen_table_id`),
  KEY `gen_table_column_name` (`name`),
  KEY `gen_table_column_sort` (`sort`),
  KEY `gen_table_column_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业务表字段';

-- ----------------------------
-- Table structure for gen_template
-- ----------------------------
DROP TABLE IF EXISTS `gen_template`;
CREATE TABLE `gen_template` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `category` varchar(2000) DEFAULT NULL COMMENT '分类',
  `file_path` varchar(500) DEFAULT NULL COMMENT '生成文件路径',
  `file_name` varchar(200) DEFAULT NULL COMMENT '生成文件名',
  `content` text COMMENT '内容',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `gen_template_del_falg` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代码模板表';

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '' COMMENT '主键',
  `name` varchar(64) DEFAULT NULL COMMENT '商品名称',
  `category_id` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '所属类型',
  `price` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '价格',
  `create_by` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for group_user
-- ----------------------------
DROP TABLE IF EXISTS `group_user`;
CREATE TABLE `group_user` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `user_id` varchar(64) DEFAULT NULL COMMENT '用户',
  `group_id` varchar(64) DEFAULT NULL COMMENT '群组id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='群组成员';

-- ----------------------------
-- Table structure for iim_chat_history
-- ----------------------------
DROP TABLE IF EXISTS `iim_chat_history`;
CREATE TABLE `iim_chat_history` (
  `id` varchar(64) NOT NULL,
  `userid1` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `userid2` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `msg` varchar(1024) CHARACTER SET utf8 DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for iim_mail
-- ----------------------------
DROP TABLE IF EXISTS `iim_mail`;
CREATE TABLE `iim_mail` (
  `id` varchar(64) NOT NULL,
  `title` varchar(128) DEFAULT NULL COMMENT '标题',
  `overview` varchar(128) DEFAULT NULL COMMENT '内容概要',
  `content` longblob COMMENT '内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件';

-- ----------------------------
-- Table structure for iim_mail_box
-- ----------------------------
DROP TABLE IF EXISTS `iim_mail_box`;
CREATE TABLE `iim_mail_box` (
  `id` varchar(64) NOT NULL,
  `readstatus` varchar(45) DEFAULT NULL COMMENT '状态 0 未读 1 已读',
  `senderId` varchar(64) DEFAULT NULL COMMENT '发件人',
  `receiverId` varchar(6400) DEFAULT NULL COMMENT '收件人',
  `sendtime` datetime DEFAULT NULL COMMENT '发送时间',
  `mailid` varchar(64) DEFAULT NULL COMMENT '邮件外键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收件箱';

-- ----------------------------
-- Table structure for iim_mail_compose
-- ----------------------------
DROP TABLE IF EXISTS `iim_mail_compose`;
CREATE TABLE `iim_mail_compose` (
  `id` varchar(64) NOT NULL,
  `status` varchar(45) DEFAULT NULL COMMENT '状态 0 草稿 1 已发送',
  `readstatus` varchar(45) DEFAULT NULL COMMENT '状态 0 未读 1 已读',
  `senderId` varchar(64) DEFAULT NULL COMMENT '发送者',
  `receiverId` varchar(6400) DEFAULT NULL COMMENT '接收者',
  `sendtime` datetime DEFAULT NULL COMMENT '发送时间',
  `mailId` varchar(64) DEFAULT NULL COMMENT '邮件id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发件箱 草稿箱';

-- ----------------------------
-- Table structure for monitor
-- ----------------------------
DROP TABLE IF EXISTS `monitor`;
CREATE TABLE `monitor` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `cpu` varchar(64) DEFAULT NULL COMMENT 'cpu使用率',
  `jvm` varchar(64) DEFAULT NULL COMMENT 'jvm使用率',
  `ram` varchar(64) DEFAULT NULL COMMENT '内存使用率',
  `toemail` varchar(64) DEFAULT NULL COMMENT '警告通知邮箱',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='系统监控';

-- ----------------------------
-- Table structure for oa_notify
-- ----------------------------
DROP TABLE IF EXISTS `oa_notify`;
CREATE TABLE `oa_notify` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `type` char(1) DEFAULT NULL COMMENT '类型',
  `title` varchar(200) DEFAULT NULL COMMENT '标题',
  `content` varchar(2000) DEFAULT NULL COMMENT '内容',
  `files` varchar(2000) DEFAULT NULL COMMENT '附件',
  `status` char(1) DEFAULT NULL COMMENT '状态',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `oa_notify_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='通知通告';

-- ----------------------------
-- Table structure for oa_notify_record
-- ----------------------------
DROP TABLE IF EXISTS `oa_notify_record`;
CREATE TABLE `oa_notify_record` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `oa_notify_id` varchar(64) DEFAULT NULL COMMENT '通知通告ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '接受人',
  `read_flag` char(1) DEFAULT '0' COMMENT '阅读标记',
  `read_date` date DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`),
  KEY `oa_notify_record_notify_id` (`oa_notify_id`),
  KEY `oa_notify_record_user_id` (`user_id`),
  KEY `oa_notify_record_read_flag` (`read_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='通知通告发送记录';

-- ----------------------------
-- Table structure for systemconfig
-- ----------------------------
DROP TABLE IF EXISTS `systemconfig`;
CREATE TABLE `systemconfig` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `smtp` varchar(64) DEFAULT NULL COMMENT '邮箱服务器地址',
  `port` varchar(64) DEFAULT NULL COMMENT '邮箱服务器端口',
  `mailname` varchar(64) DEFAULT NULL COMMENT '系统邮箱地址',
  `mailpassword` varchar(64) DEFAULT NULL COMMENT '系统邮箱密码',
  `smsname` varchar(64) DEFAULT NULL COMMENT '短信用户名',
  `smspassword` varchar(64) DEFAULT NULL COMMENT '短信密码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='系统配置';

-- ----------------------------
-- Table structure for sys_area
-- ----------------------------
DROP TABLE IF EXISTS `sys_area`;
CREATE TABLE `sys_area` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `parent_id` varchar(64) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(2000) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `sort` decimal(10,0) NOT NULL COMMENT '排序',
  `code` varchar(100) DEFAULT NULL COMMENT '区域编码',
  `type` char(1) DEFAULT NULL COMMENT '区域类型',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_area_parent_id` (`parent_id`),
  KEY `sys_area_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='区域表';

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `value` varchar(100) DEFAULT NULL COMMENT '数据值',
  `label` varchar(100) DEFAULT NULL COMMENT '标签名',
  `type` varchar(100) DEFAULT NULL COMMENT '类型',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `sort` decimal(10,0) DEFAULT NULL COMMENT '排序（升序）',
  `parent_id` varchar(64) NOT NULL DEFAULT '0' COMMENT '父级编号',
  `parent_ids` varchar(2000) CHARACTER SET utf8 COLLATE utf8_icelandic_ci DEFAULT NULL COMMENT '所有父级编号',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`,`parent_id`),
  KEY `sys_dict_value` (`value`),
  KEY `sys_dict_label` (`label`),
  KEY `sys_dict_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典表';

-- ----------------------------
-- Table structure for sys_dict_bak
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_bak`;
CREATE TABLE `sys_dict_bak` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `value` varchar(100) DEFAULT NULL COMMENT '数据值',
  `label` varchar(100) DEFAULT NULL COMMENT '标签名',
  `type` varchar(100) NOT NULL COMMENT '类型',
  `description` varchar(100) NOT NULL COMMENT '描述',
  `sort` decimal(10,0) DEFAULT NULL COMMENT '排序（升序）',
  `parent_id` varchar(64) DEFAULT '0' COMMENT '父级编号',
  `parent_ids` varchar(2000) CHARACTER SET utf8 COLLATE utf8_icelandic_ci DEFAULT NULL COMMENT '所有父级编号',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_dict_value` (`value`),
  KEY `sys_dict_label` (`label`),
  KEY `sys_dict_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典表';

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `type` char(1) DEFAULT '1' COMMENT '日志类型',
  `title` varchar(255) DEFAULT '' COMMENT '日志标题',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `remote_addr` varchar(255) DEFAULT NULL COMMENT '操作IP地址',
  `user_agent` varchar(255) DEFAULT NULL COMMENT '用户代理',
  `request_uri` varchar(255) DEFAULT NULL COMMENT '请求URI',
  `method` varchar(5) DEFAULT NULL COMMENT '操作方式',
  `params` text COMMENT '操作提交的数据',
  `exception` text COMMENT '异常信息',
  PRIMARY KEY (`id`),
  KEY `sys_log_create_by` (`create_by`),
  KEY `sys_log_request_uri` (`request_uri`),
  KEY `sys_log_type` (`type`),
  KEY `sys_log_create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日志表';

-- ----------------------------
-- Table structure for sys_mdict
-- ----------------------------
DROP TABLE IF EXISTS `sys_mdict`;
CREATE TABLE `sys_mdict` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `parent_id` varchar(64) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(2000) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `sort` decimal(10,0) NOT NULL COMMENT '排序',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_mdict_parent_id` (`parent_id`),
  KEY `sys_mdict_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='多级字典表';

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `parent_id` varchar(64) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(2000) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `sort` decimal(10,0) NOT NULL COMMENT '排序',
  `href` varchar(2000) DEFAULT NULL COMMENT '链接',
  `target` varchar(20) DEFAULT NULL COMMENT '目标',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `is_show` char(1) NOT NULL COMMENT '是否在菜单中显示',
  `permission` varchar(200) DEFAULT NULL COMMENT '权限标识',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_menu_parent_id` (`parent_id`),
  KEY `sys_menu_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单表';

-- ----------------------------
-- Table structure for sys_objm
-- ----------------------------
DROP TABLE IF EXISTS `sys_objm`;
CREATE TABLE `sys_objm` (
  `role_id` varchar(64) DEFAULT '',
  `obj_main_id` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sys_office
-- ----------------------------
DROP TABLE IF EXISTS `sys_office`;
CREATE TABLE `sys_office` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `parent_id` varchar(64) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(2000) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `sort` decimal(10,0) NOT NULL COMMENT '排序',
  `area_id` varchar(64) NOT NULL COMMENT '归属区域',
  `code` varchar(100) DEFAULT NULL COMMENT '区域编码',
  `type` char(1) NOT NULL COMMENT '机构类型',
  `grade` char(1) NOT NULL COMMENT '机构等级',
  `address` varchar(255) DEFAULT NULL COMMENT '联系地址',
  `zip_code` varchar(100) DEFAULT NULL COMMENT '邮政编码',
  `master` varchar(100) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(200) DEFAULT NULL COMMENT '电话',
  `fax` varchar(200) DEFAULT NULL COMMENT '传真',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `USEABLE` varchar(64) DEFAULT NULL COMMENT '是否启用',
  `PRIMARY_PERSON` varchar(64) DEFAULT NULL COMMENT '主负责人',
  `DEPUTY_PERSON` varchar(64) DEFAULT NULL COMMENT '副负责人',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_office_parent_id` (`parent_id`),
  KEY `sys_office_del_flag` (`del_flag`),
  KEY `sys_office_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构表';

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `office_id` varchar(64) DEFAULT NULL COMMENT '归属机构',
  `name` varchar(100) NOT NULL COMMENT '角色名称',
  `enname` varchar(255) DEFAULT NULL COMMENT '英文名称',
  `role_type` varchar(255) DEFAULT NULL COMMENT '角色类型',
  `data_scope` char(1) DEFAULT NULL COMMENT '数据范围',
  `is_sys` varchar(64) DEFAULT NULL COMMENT '是否系统数据',
  `useable` varchar(64) DEFAULT NULL COMMENT '是否可用',
  `create_by` varchar(64) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_role_del_flag` (`del_flag`),
  KEY `sys_role_enname` (`enname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` varchar(64) NOT NULL COMMENT '角色编号',
  `menu_id` varchar(64) NOT NULL COMMENT '菜单编号',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-菜单';

-- ----------------------------
-- Table structure for sys_role_office
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_office`;
CREATE TABLE `sys_role_office` (
  `role_id` varchar(64) NOT NULL COMMENT '角色编号',
  `office_id` varchar(64) NOT NULL COMMENT '机构编号',
  PRIMARY KEY (`role_id`,`office_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-机构';

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `company_id` varchar(64) DEFAULT NULL COMMENT '归属公司',
  `office_id` varchar(64) DEFAULT NULL COMMENT '归属部门',
  `login_name` varchar(100) DEFAULT NULL COMMENT '登录名',
  `password` varchar(100) DEFAULT NULL COMMENT '密码',
  `no` varchar(100) DEFAULT NULL COMMENT '工号',
  `name` varchar(100) DEFAULT NULL COMMENT '姓名',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(200) DEFAULT NULL COMMENT '电话',
  `mobile` varchar(200) DEFAULT NULL COMMENT '手机',
  `user_type` char(1) DEFAULT NULL COMMENT '用户类型',
  `photo` varchar(1000) DEFAULT NULL COMMENT '用户头像',
  `login_ip` varchar(100) DEFAULT NULL COMMENT '最后登陆IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登陆时间',
  `login_flag` varchar(64) DEFAULT NULL COMMENT '是否可登录',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `qrcode` varchar(1000) DEFAULT NULL COMMENT '二维码',
  `sign` varchar(450) DEFAULT NULL COMMENT '个性签名',
  PRIMARY KEY (`id`),
  KEY `sys_user_office_id` (`office_id`),
  KEY `sys_user_login_name` (`login_name`),
  KEY `sys_user_company_id` (`company_id`),
  KEY `sys_user_update_date` (`update_date`),
  KEY `sys_user_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Table structure for sys_user_friend
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_friend`;
CREATE TABLE `sys_user_friend` (
  `id` varchar(64) NOT NULL,
  `userId` varchar(64) NOT NULL,
  `friendId` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` varchar(64) NOT NULL COMMENT '用户编号',
  `role_id` varchar(64) NOT NULL COMMENT '角色编号',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-角色';

-- ----------------------------
-- Table structure for testnote
-- ----------------------------
DROP TABLE IF EXISTS `testnote`;
CREATE TABLE `testnote` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `title` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '标题',
  `contents` longblob COMMENT '内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='富文本测试';

-- ----------------------------
-- Table structure for test_data_main
-- ----------------------------
DROP TABLE IF EXISTS `test_data_main`;
CREATE TABLE `test_data_main` (
  `id` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '' COMMENT '编号',
  `user_id` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '归属用户',
  `office_id` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '归属部门',
  `area_id` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '归属区域',
  `name` varchar(255) DEFAULT NULL COMMENT '名称',
  `sex` char(1) CHARACTER SET latin1 DEFAULT NULL COMMENT '性别',
  `in_date` date DEFAULT NULL COMMENT '加入日期',
  `create_by` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) CHARACTER SET latin1 DEFAULT NULL COMMENT '删除标记'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for test_interface
-- ----------------------------
DROP TABLE IF EXISTS `test_interface`;
CREATE TABLE `test_interface` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `type` varchar(16) DEFAULT NULL COMMENT '接口类型',
  `url` varchar(256) DEFAULT NULL COMMENT '请求URL',
  `body` varchar(2048) DEFAULT NULL COMMENT '请求body',
  `successmsg` varchar(512) DEFAULT NULL COMMENT '成功时返回消息',
  `errormsg` varchar(512) DEFAULT NULL COMMENT '失败时返回消息',
  `remarks` varchar(512) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) CHARACTER SET latin1 DEFAULT '0' COMMENT '删除标记',
  `name` varchar(1024) DEFAULT NULL COMMENT '接口名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='接口列表';

-- ----------------------------
-- Table structure for test_validation
-- ----------------------------
DROP TABLE IF EXISTS `test_validation`;
CREATE TABLE `test_validation` (
  `id` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '' COMMENT '主键',
  `num` double DEFAULT NULL COMMENT '浮点数字',
  `num2` int(11) DEFAULT NULL COMMENT '整数',
  `str` varchar(6) CHARACTER SET latin1 DEFAULT NULL COMMENT '字符串',
  `email` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '邮件',
  `url` varchar(64) CHARACTER SET latin1 DEFAULT NULL COMMENT '网址',
  `new_date` datetime DEFAULT NULL COMMENT '日期',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tuwymaina
-- ----------------------------
DROP TABLE IF EXISTS `tuwymaina`;
CREATE TABLE `tuwymaina` (
  `main_id` varchar(64) DEFAULT NULL COMMENT 'main_id',
  `test` varchar(64) DEFAULT NULL COMMENT '测试',
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='tuwymaina';

-- ----------------------------
-- Table structure for t_group
-- ----------------------------
DROP TABLE IF EXISTS `t_group`;
CREATE TABLE `t_group` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT '主键',
  `groupname` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '群组名',
  `avatar` varchar(256) DEFAULT NULL COMMENT '群头像',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注信息',
  `del_flag` varchar(64) DEFAULT NULL COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='群组';
