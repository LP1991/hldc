<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>采集传输文件管理</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
	</style>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
    
	<sys:message content="${message}"/>
	<dc:bizHelp title="FTP采集" label="FTP采集作业, 主要用于采集文件服务器(支持ftp/http协议)的文件对象, 存储于本地hdfs系统." ></dc:bizHelp>
	
	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="dcJobTransFile" action="${ctx}/dataProcess/dcJobTransFile/" method="post" class="form-inline">
		<form:hidden path="id"/>
		<div class="form-group">
			<span>Job名称：</span><form:input path="jobname" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
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
			<shiro:hasPermission name="dc:dataProcess:dcJobTransFile:add">
				<table:openModalDialog url="${ctx}/dc/dataProcess/transJobFile/form" title="FTP采集" width="1000px" height="700px"></table:openModalDialog><!-- 增加按钮 -->
			</shiro:hasPermission>
			
			</div>
	</div>
	</div>
	
	<!-- 表格 -->
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
		<thead>
			<tr>
				
				<th >任务名称</th>
				<th >描述</th>
				<th >最后执行时间</th>
				<th >状态</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
</div>
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
				url : "${ctx}/dc/dataProcess/transJobFile/ajaxlist",
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
						"data" : "jobname"
					}, {
						"data" : "description"
					}, {
						"data" : "uploadTime"
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
						targets : 4,	
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看FTP采集\', \'${ctx}/dc/dataProcess/transJobFile/form?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看FTP采集"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openFrameModel(\'编辑FTP采集\', \'${ctx}/dc/dataProcess/transJobFile/form?id='+a.id+'\', \'1000px\', \'700px\')" class="btn btn-success btn-xs" title="编辑FTP采集"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/dc/dataProcess/transJobFile/ajaxDelete?id='+a.id+'\',\'JOB\') " class="btn btn-success btn-xs" title="删除FTP采集"><i class="fa fa-trash"></i></a>&nbsp;';
							html+= '<a  onclick="test(\'${ctx}/dc/dataProcess/transJobFile/FTPuploadToHDFS?id='+a.id+'\',\'JOB\') " class="btn btn-success btn-xs" title="测试"><i class="fa fa-bug"></i></a>&nbsp;';
							html+= '<a  onclick="openDialogView(\'查看日志\', \'${ctx}/dc/dataProcess/transJobFile/logForm?id='+a.id+'\', \'600px\', \'480px\')" class="btn btn-success btn-xs" title="查看日志"><i class="fa fa-book"></i></a>&nbsp;';
						//	html+= '<a href="#" onclick="openDialog(\'调度设置\', \'${ctx}/dc/dataProcess/transJobFile/scheduleForm?id='+a.id+'\', \'800px\', \'480px\')" class="btn btn-success btn-xs" title="调度设置"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="add2Schedule(\''+a.id+'\') " class="btn btn-success btn-xs" title="添加至调度任务"><i class="fa fa-tasks"></i></a>&nbsp;';
							return html;
						}
                  },{
						targets : 3,
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

	function test(url,title,flag){//查询，页码清零
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
				top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
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
	//添加至调度列表
	function add2Schedule(jobId){		
		submitData('${ctx}/dc/dataProcess/transJobFile/add2Schedule', {'jobId':jobId}, function (data) {
			//刷新表格
			//window.parent.searchA();
			//parent.document.table.ajax.reload();
				table.ajax.reload();
			top.layer.alert(data.msg, {
				title : '系统提示'
			});
		});
	}
	
	</script>
</body>
</html>