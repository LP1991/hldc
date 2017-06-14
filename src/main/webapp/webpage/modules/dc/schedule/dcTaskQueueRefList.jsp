<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>任务队列列表</title>
<meta name="decorator" content="default" />

<script type="text/javascript">
</script>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
	
	<div class="wrapper wrapper-content">
	<dc:bizHelp title="任务队列" label="任务队列, 用于将用户自定义的零散的任务项添加至任务队列, 以任务组的形式统一调度及监控" ></dc:bizHelp>
		<div class="ibox">
			<br>
			<form:form id="searchForm" modelAttribute="dcTaskQueue" method="post" action="${ctx}/dc/schedule/dcTaskQueue/" class="form-inline">
				<!-- 支持排序 -->
				<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();" />
				<form:hidden path="id"/>
				<div class="form-group">
					<span>队列名称：</span>
					<form:input path="queueName" value="${dcTaskQueue.queueName}" htmlEscape="false" maxlength="30" class="form-control input-sm" />
					<button type="button" class="btn btn-success btn-rect  btn-sm " onclick="searchA()">
						<i class="fa fa-search"></i> 查询
					</button>
				</div>
			</form:form>
			<br/>
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<table:addRow url="${ctx}/dc/schedule/dcTaskQueue/form" title="任务队列"></table:addRow>
					</div>
				</div>
			</div>
		</div>

		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable"  cellspacing="0" width="100%">
			<thead>
				<tr>
					<th><input type="checkbox" class="i-checks"></th>
					<th class="queueName">队列名称</th>
					<th class="queueDesc">队列描述</th>
					<th class="status">状态</th>
					<th class="createBy">创建者</th>
					<th class="updateDate">更新时间</th>
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
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/schedule/dcTaskQueue/ajaxlist",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParams('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, {
						"data" : "queueName"
					}, {
						"data" : "queueDesc"
					}, {
						"data" : "status"
					}, {
						"data" : "createBy.name"
					}, {
						"data" : "updateDate"
					}, {
						"data" : null,width: "250px"
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 6,
						render : function (a, b) {
                         	var html= '<a href="#" onclick="openDialogView(\'查看\',\'${ctx}/dc/schedule/dcTaskQueue/view?id='+a.id+'\',\'800px\', \'500px\')" class="btn btn-success btn-xs" title="查看队列"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改\', \'${ctx}/dc/schedule/dcTaskQueue/form?id='+a.id+'\',\'800px\', \'500px\')" 	class="btn btn-success btn-xs" title="编辑队列"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a href="#" onclick="deleteA(\'${ctx}/dc/schedule/dcTaskQueue/deleteA?id='+a.id+'\',\'任务队列\') " class="btn btn-success btn-xs" title="删除队列"><i class="fa fa-trash"></i></a>&nbsp;';
							html+= '<a href="#" onclick="addJobA(\'${ctx}/dc/schedule/dcTaskQueue/addJobA?id='+a.id+'\', \'任务队列\')" class="btn btn-success btn-xs" title="添加至调度列表"><i class="fa fa-plus"></i></a>';
							return html;
						}
					},{
						targets : 5,
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
				$('.i-checks').iCheck({
					checkboxClass: 'icheckbox_square-green',
					radioClass: 'iradio_square-green',
				});
			}
		});
	});
	
	function addJobA(url,title,flag){//查询，页码清零
		confirmx('您要添加该'+title+'吗？', function(){
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
			});
		})
	}
	</script>
	
</body>
</html>
