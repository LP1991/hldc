<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>DB采集任务列表</title>
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
	<dc:bizHelp title="HDFS采集" label="HDFS采集作业, 主要用于采集HDFS服务器的文件对象, 存储于本地hdfs系统." ></dc:bizHelp>
	
	<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="dcJobTransHdfs"  method="post" class="form-inline">
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
			<shiro:hasPermission name="dc:dataProcess:dcJobTransHdfs:add">
				<table:openModalDialog url="${ctx}/dc/dataProcess/hdfsJob/form" title="HDFS采集" width="1000px" height="700px"></table:openModalDialog><!-- 增加按钮 -->
			</shiro:hasPermission>	
			<button class="btn btn-success btn-rect  btn-sm " onclick="jobMonitor()" type="button"><i class="fa fa-list-ul"></i> hadoop job日志</button>
		</div>
		
	</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
		<thead>
			<tr>
				
				<th class="jobName">任务名称</th>
				<th class="jobDesc">任务描述</th>
				<th class="srcHdfsAddress">源Hdfs地址</th>
				<th class="srcHdfsDir">源文件路径</th>
				<th class="outPutDir">目标路径</th>
				<th class="isOverride">是否覆盖</th>
				<th class="updateDate">更新时间</th>
				<th class="status">状态</th>
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
				url : "${ctx}/dc/dataProcess/hdfsJob/ajaxlist",
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
						"data" : "srcHdfsAddress"
					}, {
						"data" : "srcHdfsDir"
					}, {
						"data" : "outPutDir"
					}, {
						"data" : "isOverride"
					}, {
						"data" : "updateDate"
					}, {
						"data" : "status"
					}, {
						"data" : null 
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets :8,	
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看HDFS采集\', \'${ctx}/dc/dataProcess/hdfsJob/dataView?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看HDFS采集"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openFrameModel(\'编辑HDFS采集\', \'${ctx}/dc/dataProcess/hdfsJob/form?id='+a.id+'\', \'1000px\', \'700px\')" class="btn btn-success btn-xs" title="编辑HDFS采集"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/dc/dataProcess/hdfsJob/ajaxDelete?id='+a.id+'\',\'HDFS采集\') " class="btn btn-success btn-xs" title="删除HDFS采集"><i class="fa fa-trash"></i></a>&nbsp;';
							html+= '<a  onclick="runJob(\'${ctx}/dc/dataProcess/hdfsJob/runTask?jobId='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="测试任务"><i class="fa fa-bug"></i></a>&nbsp;';
							html+= '<a  onclick="openDialogView(\'查看采集文件\', \'${ctx}/dc/dataProcess/hdfs/listHdfsFileByHdfsJob?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看采集目录"><i class="fa fa-folder"></i></a>&nbsp;';
						//	html+= '<a href="#" onclick="openDialog(\'调度设置\', \'${ctx}/dc/dataProcess/hdfsJob/scheduleForm?id='+a.id+'\', \'800px\', \'480px\')" class="btn btn-success btn-xs" title="添加至调度任务"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="add2Schedule(\''+a.id+'\') " class="btn btn-success btn-xs" title="添加至调度任务"><i class="fa fa-tasks"></i></a>&nbsp;';
							html+= '<a  onclick="openDialogView(\'最近执行日志\', \'${ctx}/dc/dataProcess/hdfs/viewContent?filePath='+a.logDir+'\',\'800px\', \'500px\')" class="btn btn-success btn-xs" title="查看日志"><i class="fa fa-book"></i></a>&nbsp;';
							return html;
						}
					},{
						targets : 5,
						render : function (a, b) {
							return a=='1'?'√':'';
						}
					},{
						targets : 6,
						render : function (a, b) {
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
							return html;
						}
					},{
						targets :7,
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

	//运行Job TODO: ajax 调用后台任务
/* 	function runJob(jobId){
		var loading = layer.load();
		submitData('${ctx}/dc/dataProcess/hdfsJob/runTask', {'jobId':jobId}, function (data) {
			 layer.close(loading);
			//parent.document.table.ajax.reload();
			top.layer.alert(data.msg, {
				title : '运行结果',
				area: ['680px', '340px']
			});
		});
	} */
	
	function runJob(url,title,flag){//查询，页码清零
		confirmx('确认测试该'+title+'的功能？', function(){
				loading("测试中，请稍候。");
			submitData(url,{},function(data){
				closeTip();
				var icon_number;
				if(!data.success){
					icon_number = 8;
				}else{
					icon_number = 1;
				}
				top.layer.alert(data.msg, {
						icon: icon_number, 
						title:'运行结果',
						area: ['680px', '340px']
				});
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
 	
	//打开监控页面
	function jobMonitor(jobId){
		submitData('${ctx}/dc/dataProcess/hdfsJob/jobMonitor', {'jobId':jobId}, function (data) {
			if(data.msg){
				//openTab('/hlframe/page/sys/user/index','用户管理',false);
				//openTab(data.msg,'hadoop job监控',false);
				window.open(data.msg);
			}
		});
	}
	//添加至调度列表
	function add2Schedule(jobId){
		submitData('${ctx}/dc/dataProcess/hdfsJob/add2Schedule', {'jobId':jobId}, function (data) {
			//刷新表格
			//window.parent.searchA();
			//parent.document.table.ajax.reload();
			top.layer.alert(data.msg, {
				title : '系统提示'
			});
		});
	}
	</script>
	
	</div>
</body>
</html>