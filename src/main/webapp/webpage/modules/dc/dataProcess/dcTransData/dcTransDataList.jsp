<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据转换任务列表</title>
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
	<dc:bizHelp title="转换脚本配置" label="通过转换脚本配置,用户可以自助实现数据转换过程." ></dc:bizHelp><%-- 业务帮助 --%>
	<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="jobInfo"  method="post" class="form-inline">
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
			<table:addRow url="${ctx}/dc/dataProcess/transData/form" title="转换脚本配置" height="300px" ></table:addRow><!-- 增加按钮 -->
		</div>
		
	</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>
				<th class="jobName" width="20%">任务名称</th>
				<th class="jobDesc" width="40%">任务描述</th>
				<th class="creater">创建者</th>
				<th class="updateTime">更新时间</th>
				<th class="status">任务状态</th>
				<th class="status">操作</th>
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
			"autoWidth" : false, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/dataProcess/transData/ajaxlist",
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
						"data" : "createBy.name"
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
						targets : 5,
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看转换脚本配置\', \'${ctx}/dc/dataProcess/transData/dataView?id='+a.id+'\',\'800px\', \'300px\')" class="btn btn-success btn-xs" title="查看转换脚本配置"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'编辑转换脚本配置\', \'${ctx}/dc/dataProcess/transData/form?id='+a.id+'\', \'800px\', \'300px\')" class="btn btn-success btn-xs" title="编辑转换脚本配置"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/dc/dataProcess/transData/ajaxDelete?id='+a.id+'\',\'转换脚本配置\') " class="btn btn-success btn-xs" title="删除转换脚本配置"><i class="fa fa-trash"></i></a>&nbsp;';
							html+= '<a  onclick="openDialog(\'处理过程\', \'${ctx}/dc/dataProcess/transData/transProcess?id='+a.id+'\', \'800px\', \'680px\') " class="btn btn-success btn-xs" title="处理过程"><i class="fa fa-cog"></i></a>&nbsp;';
							html+= '<a  onclick="jobTest(\''+a.id+'\') " class="btn btn-success btn-xs" title="测试"><i class="fa fa-bug"></i></a>&nbsp;';
							html+= '<a onclick="openDialogView(\'查看转换任务日志\', \'${ctx}/dc/dataProcess/transLog/latestTaskLog?jobId='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看日志"><i class="fa fa-book"></i></a>&nbsp;';
							html+= '<a  onclick="add2Schedule(\''+a.id+'\') " class="btn btn-success btn-xs" title="添加至调度任务"><i class="fa fa-tasks"></i></a>&nbsp;';
							return html;
						}
					},{
						targets : 4,
						render : function (a, b) {
							var html= getDataFromAjax('${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_task_status'});
							return html;
						}
					},{
                    targets : 3,
                    render : function (a, b) {
                        var d = new Date(a);
                        var tf = function(i){return (i < 10 ? '0' : '') + i};
                        var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
                        return html;
                    }
                }
				],
				//初始化完成回调
				"initComplete": function(settings, json) {
				},
			//重绘回调
			"drawCallback": function( settings ) {
			}
		});
	});	

	//运行Job  ajax 调用后台任务
	function jobTest(jobId){
		var loading = layer.load(1,{content:'<p class="loading_style">加载中，请稍后。</p>'});
		submitData('${ctx}/dc/dataProcess/transData/jobTest', {'jobId':jobId}, function (data) {
			layer.close(loading);
			//table.reload();
			top.layer.alert(data.msg, {
				title : '运行结果',
				area: ['680px', '340px']
			});
		});
	}
	
	//添加至调度列表
	function add2Schedule(jobId){
		submitData('${ctx}/dc/dataProcess/transData/add2Schedule', {'jobId':jobId}, function (data) {
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