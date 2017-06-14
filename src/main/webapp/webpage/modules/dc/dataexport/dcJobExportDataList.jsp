<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据导出</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
	</style>
	<script src="${ctxStatic}/common/contabs.js"></script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="数据导出" label="数据导出, 主要用于将集群环境中的数据(hdfs/hive)导出至关系型数据库, 更方便服务于其他系统." ></dc:bizHelp>
	<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="exportDataJob"  method="post" class="form-inline">
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<form:hidden path="id"/>
		<div class="form-group">
			<span>任务名称：</span><form:input path="jobName" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
			<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
	<br/>
	</div>
	</div>
	
		<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<table:openModalDialog url="${ctx}/dc/dataExport/job/form" title="数据导出配置" width="1000px" height="700px"></table:openModalDialog><!-- 增加按钮 -->
		</div>
		
	</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
		<thead>
			<tr>
				
				<th class="jobName">任务名称</th>
				<th class="jobDesc">任务描述</th>
				<th class="fromLink">数据源类型</th>
				<th class="dataPath">数据源对象</th>
				<th class="toLinkName">目标数据库</th>
				<th class="dbType">数据库类型</th>
				<th class="schemaName">数据schema</th>
				<th class="tableName">数据表</th>
				<th class="status">状态</th>
				<th class="updateDate">更新时间</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
 
	<script>
	var table;
	$(document).ready(function () {
		table = $('#contentTable').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : true,// 分页按钮 
			"searching" : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/dataExport/job/ajaxlist",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParamsObj('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
				{
						"data" : "jobName"
					}, {
						"data" : "jobDesc"
					}, {
						"data" : "fromLink"
					}, {
						"data" : "dataPath"
					}, {
						"data" : "toLinkName"
					}, {
						"data" : "dbType"
					}, {
						"data" : "schemaName"
					}, {
						"data" : "tableName"
					}, {
						"data" : "status"
					}, {
						"data" : "updateDate"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 10,	//操作按钮
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看数据对象\', \'${ctx}/dc/dataExport/job/view?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看对象"><i class="fa fa-search-plus"></i></a>&nbsp;';
							if(a.accre==1){
								html+= '<a href="#" onclick="openFrameModel(\'编辑任务\', \'${ctx}/dc/dataExport/job/form?id='+a.id+'\', \'1000px\', \'700px\')" class="btn btn-success btn-xs" title="编辑对象"><i class="fa fa-edit"></i></a>&nbsp;';
								html+= '<a  onclick="deleteA(\'${ctx}/dc/dataExport/job/ajaxDelete?id='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="删除对象"><i class="fa fa-trash"></i></a>&nbsp;';
								html+= '<a  onclick="runJob(\''+a.id+'\') " class="btn btn-success btn-xs" title="测试"><i class="fa fa-bug"></i></a>&nbsp;';
								html+= '<a href="#" onclick="openDialogView(\'导出数据预览\', \'${ctx}/dc/dataExport/job/previewData?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="导出数据预览"><i class="fa fa-file"></i></a>&nbsp;';
								html+= '<a  onclick="add2Schedule(\''+a.id+'\') " class="btn btn-success btn-xs" title="添加至调度任务"><i class="fa fa-tasks"></i></a>&nbsp;';
								html+= '<a onclick="openDialogView(\'查看DB采集日志\', \'${ctx}/dc/dataProcess/hdfs/viewContent?filePath='+a.logDir+'\',\'760px\', \'480px\')" class="btn btn-success btn-xs" title="查看日志"><i class="fa fa-book"></i></a>&nbsp;';
							}else{
								html+= '<a  onclick="getAu(\'${ctx}/dc/dataExport/job/getAu?id='+a.id+'\',\'数据库链接的操作\') " class="btn btn-success btn-xs" title="申请权限"><i class="fa fa-ban"></i></a>&nbsp;';
							}
							return html;
						}
					},{
						targets : 2,	//数据源类型
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_data_store_type'});
							return html;
						}
					},{
						targets :5,	//数据库类别
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_datasource_type'});
							return html;
						}
					},{
						targets : 9,	//更新时间
						render : function (a, b) {
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
							return html;
						}
					},{
						targets : 8,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_task_status'});
							return html;
						}
					}
				],
				//初始化完成回调
				"initComplete": function(settings, json) {
				},
			//重绘回调
			"drawCallback": function( settings ) {
// 				$('.i-checks').iCheck({
// 					checkboxClass: 'icheckbox_square-green',
// 					radioClass: 'iradio_square-green',
// 				});
			}
		});
	});	

	//运行任务
	function runJob(jobId){
			loading("测试中，请稍候。");
			submitData('${ctx}/dc/dataExport/job/runTask',{'jobId':jobId},function(data){
				closeTip();
				top.layer.alert(data.msg, {
					title : '运行结果',
					area: ['680px', '340px']
				});
			});
	}
	//预览导出数据
	function viewRstData(jobId){
			submitData('${ctx}/dc/dataExport/job/runTask',{'jobId':jobId},function(data){
				closeTip();
				top.layer.alert(data.msg, {
					title : '运行结果',
					area: ['680px', '340px']
				});
			});
	}
	
	//添加至调度列表
	function add2Schedule(jobId){
		submitData('${ctx}/dc/dataExport/job/add2Schedule', {'jobId':jobId}, function (data) {
			top.layer.alert(data.msg, {
				title : '系统提示'
			});
		});
	}
	
	//权限申请
	function getAu(url,title,flag){
		confirmx('确认要申请该'+title+'的权限吗？', function(){
			submitData(url,{},function(data){
			var icon_number;
			if(!data.success){
				icon_number = 8;
			}else{
				icon_number = 1;
			}
				top.layer.alert(data.msg, {icon: icon_number, title:'提示'});
				// 刷新表格数据，分页信息不会重置
				if (typeof(table) != "undefined") { 
					table.ajax.reload( null, false ); 
				}
				if(flag){
					refreshAllTree();
				}
			});
		})
	}
	
	</script>
	
	</div>
</body>
</html>