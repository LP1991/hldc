<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>数据采集任务</title>
<meta name="decorator" content="default" />

<script type="text/javascript">
</script>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
	
	<div class="wrapper wrapper-content">
	<dc:bizHelp title="任务单元管理" label="任务单元管理, 用于维护数据中心的调度作业对象, 调度作业类型包括内部类,外部可执行jar和系统运行脚本(bat文件, sh文件)" ></dc:bizHelp>
		<div class="ibox" style="margin-bottom:0;">
			<br>
			<form:form id="searchForm" modelAttribute="dcTaskMain" method="post" action="${ctx}/dc/schedule/dcTaskMain/" class="form-inline">
				<!-- 支持排序 -->
				<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();" />
				<form:hidden path="id"/>
				<div class="form-group">
					<span>任务名：</span>
					<form:input path="taskName" value="${dcTaskMain.taskName}"
						htmlEscape="false" maxlength="30" class="form-control input-sm" />
					<span>任务类型：</span>
					<form:select path="taskType" class="form-control">
						<form:option value="" label="全部"/>
						<form:options items="${fns:getDictListLike('dc_taskType')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<button type="button" class="btn btn-success btn-rect  btn-sm "
						onclick="searchA()">
						<i class="fa fa-search"></i> 查询
					</button>
					<br>
				</div>
			</form:form>
			<br>
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<shiro:hasPermission name="dc:dcTaskMain:add">
							<table:addRow url="${ctx}/dc/schedule/dcTaskMain/form" title="任务单元"></table:addRow>
						</shiro:hasPermission>
					</div>
				</div>
			</div>
		</div>

		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable"  cellspacing="0" width="100%">
			<thead>
				<tr>
		
					<th class="taskName">任务名</th>
					<th class="taskType">任务类型</th>
					<th class="taskPath">任务来源</th>
					<th class="methodName">方法名</th>
					<th class="priority">优先级</th>
					<th class="parameter">参数</th>
					<th class="status">状态</th>
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
				url : "${ctx}/dc/schedule/dcTaskMain/ajaxlist",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParams('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					{
						"data" : "taskName"
					}, {
						"data" : "taskType"
					}, {
						"data" : "taskPath"
					}, {
						"data" : "methodName"
					}, {
						"data" : "priority"
					}, {
						"data" : "parameter"
					}, {
						"data" : "status"
					}, {
						"data" : null,width: "250px"
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 1,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskType'});
							return html;
						}
					},{
						targets : 2,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_task_srctype'});
							return html;
						}
					},{
						targets : 6,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskMain_status'});
							return html;
						}
					},{
						targets : 7,
						render : function (a, b) {
                         	var html= '<a href="#" onclick="openDialogView(\'查看\',\'${ctx}/dc/schedule/dcTaskMain/view?id='+a.id+'\',\'800px\', \'500px\')" class="btn btn-success btn-xs" title="查看任务单元"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改\', \'${ctx}/dc/schedule/dcTaskMain/form?id='+a.id+'\',\'800px\', \'500px\')" 	class="btn btn-success btn-xs" title="编辑任务单元"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a href="#" onclick="deleteA(\'${ctx}/dc/schedule/dcTaskMain/deleteA?id='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="删除任务单元"><i class="fa fa-trash"></i></a>&nbsp;';
							html+= '<a href="#" onclick="addJobA(\'${ctx}/dc/schedule/dcTaskMain/addJobA?id='+a.id+'\', \'任务\')" class="btn btn-success btn-xs" title="添加调度"><i class="fa fa-tasks"></i></a>';
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
	
	function addJobA(url,title,flag){
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
					table.ajax.reload( null, false); 
				}
				if(flag){
					 refreshAllTree();
				}
			});
		})
	}
	</script>
	
</body>
</html>
