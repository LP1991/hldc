<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta name="decorator" content="default" />

<script type="text/javascript">
</script>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
	<dc:bizHelp title="业务系统维护" label="" ></dc:bizHelp>
	<div class="wrapper wrapper-content">
		<div class="ibox">
			<br>
			<form:form id="searchForm" modelAttribute="systems" method="post" action="${ctx}/dc/system/systems/" class="form-inline">
				<!-- 支持排序 -->
				<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();" />
				<form:hidden path="id"/>
				<div class="form-group">
					<span>系统编号：</span>
					<form:input path="number" value="${systems.number}"
						htmlEscape="false" maxlength="30" class="form-control input-sm" />
					<span>系统名称：</span>
					<form:input path="name" value="${systems.name}"
						htmlEscape="false" maxlength="30" class="form-control input-sm" />
				
					<button type="button" class="btn btn-success btn-rect  btn-sm "
						onclick="searchA()">
						<i class="fa fa-search"></i> 查询
					</button>
					<br>
				</div>
			</form:form>
		
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<shiro:hasPermission name="dc:dcTaskMain:add">
							<table:addRow url="${ctx}/dc/system/systems/form" title=""></table:addRow>
						</shiro:hasPermission>
					</div>
				</div>
			</div>
		</div>
</br>
		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable"  cellspacing="0" width="100%">
			<thead>
				<tr>
				
					<th class="number">系统编号</th>
					<th class="name">系统名称</th>
					<th class="bewrite">系统首页</th>
					<th class="homes">系统描述</th>
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
				url : "${ctx}/dc/system/systems/ajaxlist",
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
						"data" : "number"
					}, {
						"data" : "name"
					}, {
						"data" : "bewrite"
					}, {
						"data" : "homes"	
					}, {
						"data" : null,width: "250px"
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets :4,
						render : function (a, b) {
                         	var html= '<a href="#" onclick="openDialogView(\'查看\',\'${ctx}/dc/system/systems/view?id='+a.id+'\',\'800px\', \'500px\')" class="btn btn-success btn-xs" title="查看任务"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改\', \'${ctx}/dc/system/systems/form?id='+a.id+'\',\'800px\', \'500px\')" 	class="btn btn-success btn-xs" title="编辑任务"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a href="#" onclick="deleteA(\'${ctx}/dc/system/systems/deleteA?id='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="删除任务"><i class="fa fa-trash"></i></a>&nbsp;';
						
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
				if(flag){
					 refreshAllTree();
				}
			});
		})
	}
	</script>
	
</body>
</html>
