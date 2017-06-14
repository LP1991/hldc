<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<title>dc权限管理</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
		.panel-body{
			padding-left:0;
		}
	</style>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
     <dc:bizHelp title="dc权限管理" label="该功能主要用于审核/撤销用户对数据的操作权限" ></dc:bizHelp>
	
	
	<ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#tab" aria-expanded="true">未处理</a>
        </li>
        <li class=""><a data-toggle="tab" href="#tab-1" aria-expanded="false">已通过</a>
        </li>
        <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">已撤回</a>
        </li>
    </ul>
       <div class="tab-content">
		<div id="tab" class="tab-pane active">
		<div class="panel-body">
		<div class="row">
		<div class="col-sm-12">
			<div class="pull-left">
				<shiro:hasPermission name="dc:metadata:dcObjectAu:edit">
					<table:approveRow url="${ctx}/dc/metadata/dcObjectAu/approveRow" tid="contentTable"></table:approveRow>
				</shiro:hasPermission>
				<shiro:hasPermission name="dc:metadata:dcObjectAu:edit">
					<table:denyRow url="${ctx}/dc/metadata/dcObjectAu/denyRow" sid="contentTable"></table:denyRow>
				</shiro:hasPermission>
			</div>
		</div>
		</div>
		<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" style="width:100%" >
			<thead>
				<tr>
					<th><input type="checkbox" class="i-checks"></th>
					<th class="fileName">模型名称</th>
					<th class="userName">申请人</th>
					<th class="status">申请状态</th>
					<th class="from">来源</th>
					<th class="createDate">申请时间</th>
					<th>操作</th>
				</tr>
			</thead>
		</table>
	 </div>
	</div>

	<div id="tab-1" class="tab-pane">
	<div class="panel-body">
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			
			<shiro:hasPermission name="dc:metadata:dcObjectAu:edit">
				<table:denyRow url="${ctx}/dc/metadata/dcObjectAu/denyRow" sid="contentTable1"></table:denyRow>
			</shiro:hasPermission>
		</div>
	</div>
	</div>
 	<table id="contentTable1" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" style="width:100%">
		<thead>
			<tr>
				<th><input type="checkbox" class="i-checks"></th>
				<th class="fileName">模型名称</th>
				<th class="userName">申请人</th>
				<th class="status">申请状态</th>
				<th class="from">来源</th>
				<th class="createDate">申请时间</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
	</div>
	</div>
	
	<div id="tab-2" class="tab-pane">
	<div class="panel-body">
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="dc:metadata:dcObjectAu:edit">
				<table:approveRow url="${ctx}/dc/metadata/dcObjectAu/approveRow" tid="contentTable2"></table:approveRow>
			</shiro:hasPermission>
		</div>
	</div>
	</div>
 	<table id="contentTable2" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" style="width:100%" >
		<thead>
			<tr>
				<th><input type="checkbox" class="i-checks"></th>
				<th class="fileName">模型名称</th>
				<th class="userName">申请人</th>
				<th class="status">申请状态</th>
				<th class="from">来源</th>
				<th class="createDate">申请时间</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
	</div>
	</div>
	
	</div>
	</div>
	
	<script>
	var table;
	var table1;
	var table2;
	$(document).ready(function () {
		table = $('#contentTable').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : true,// 分页按钮 
			"iDisplayLength": '10',
			"bLengthChange": true,
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : false, //自动宽度
			"bFilter" : false, //列筛序功能

			"ajax" : {
				url : "${ctx}/dc/metadata/dcObjectAu/ajaxlist",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParamsObj('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, {
						"data" : "fileName"
					}, {
						"data" : "userName"
					}, {
						"data" : "status"
					}, {
						"data" : "from"
					}, {
						"data" : "createDate"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 6,	//第4列
						render : function (a, b) {
							var 
							html= '<a  onclick="accre(\'${ctx}/dc/metadata/dcObjectAu/pass?id='+a.id+'\',\'同意\') " class="btn btn-success btn-xs"><i class="fa fa-check"></i>同意申请</a>&nbsp;';
							html+= '<a  onclick="accre(\'${ctx}/dc/metadata/dcObjectAu/nopass?id='+a.id+'\',\'撤回\') " class="btn btn-success btn-xs"><i class="fa fa-close"></i>撤回申请</a>&nbsp;';
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
		table1 = $('#contentTable1').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : true,// 分页按钮 
			"iDisplayLength": '10',
			"bLengthChange": true,
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : false, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/metadata/dcObjectAu/ajaxlist1",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParamsObj('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, {
						"data" : "fileName"
					}, {
						"data" : "userName"
					}, {
						"data" : "status"
					}, {
						"data" : "from"
					}, {
						"data" : "createDate"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 6,	//第4列
						render : function (a, b) {
							var 
							html= '<a  onclick="accre(\'${ctx}/dc/metadata/dcObjectAu/nopass?id='+a.id+'\',\'撤回\') " class="btn btn-success btn-xs"><i class="fa fa-close"></i>撤回申请</a>&nbsp;';
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
					},
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
		table2 = $('#contentTable2').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : true,// 分页按钮 
			"iDisplayLength": '10',
			"bLengthChange": true,
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : false, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/metadata/dcObjectAu/ajaxlist2",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParamsObj('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, {
						"data" : "fileName"
					}, {
						"data" : "userName"
					}, {
						"data" : "status"
					}, {
						"data" : "from"
					}, {
						"data" : "createDate"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 6,	//第4列
						render : function (a, b) {
							var 
							html= '<a  onclick="accre(\'${ctx}/dc/metadata/dcObjectAu/pass?id='+a.id+'\',\'同意\') " class="btn btn-success btn-xs"><i class="fa fa-check"></i>同意申请</a>&nbsp;';
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
	
	function accre(url,title,flag){//查询，页码清零
		confirmx('确认'+title+'该模型的权限吗？', function(){
			submitData(url,{},function(data){
				var icon_number;
				if(!data.success){
					icon_number = 8;
				}else {
                    icon_number = 1;
                }
				top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
				// 刷新表格数据，分页信息不会重置
                table2.ajax.reload();
                table.ajax.reload();
                table1.ajax.reload();
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