<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
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
	<!-- <div class="ibox">
	<div class="ibox-title">
			<h5>角色列表 </h5>
			<div class="ibox-tools">
				<a class="collapse-link">
					<i class="fa fa-chevron-up"></i>
				</a>
				<a class="dropdown-toggle" data-toggle="dropdown" href="form_basic.html#">
					<i class="fa fa-wrench"></i>
				</a>
				<ul class="dropdown-menu dropdown-user">
					<li><a href="#">选项1</a>
					</li>
					<li><a href="#">选项2</a>
					</li>
				</ul>
				<a class="close-link">
					<i class="fa fa-times"></i>
				</a>
			</div>
	</div> -->
	<sys:message content="${message}"/>
	<dc:bizHelp title="角色管理" label="" ></dc:bizHelp>
	
		<!-- 查询条件 -->
	<div class="row">
  <div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="role"  method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>角色名称：</span>
				<form:input path="name" value="${role.name}"  htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
				<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
	<br/>
	

	
		<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="sys:role:add">
				<table:addRow url="${ctx}/sys/role/form" title="角色"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
			<%-- <shiro:hasPermission name="sys:role:edit">
			    <table:editRow url="${ctx}/sys/role/form" id="contentTable"  title="角色"></table:editRow><!-- 编辑按钮 -->
			</shiro:hasPermission> --%>
			<shiro:hasPermission name="sys:role:del">
				<table:delRowByAjax url="${ctx}/sys/role/deleteAllByA" id="contentTable"></table:delRowByAjax><!-- 删除按钮 -->
			</shiro:hasPermission>
	 <%--      <button class="btn btn-success btn-rect btn-sm" data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
		--%>
			</div>
		
	</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
		<thead>
			<tr>
				<th><input type="checkbox" class="i-checks"></th>
				<th class="role_name">角色名称</th>
				<th class="english_name">英文名称</th>
				<th class="own_office">归属机构</th>
				<th class="data_scope">数据范围</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
	
	</div>
	<!--定义操作列按钮模板
<script id="tpl" type="text/x-handlebars-template">
    {{#each func}}
    <button type="button" class="btn btn-{{this.type}} btn-sm" onclick="{{this.fn}}">{{this.name}}</button>
    {{/each}}
</script>-->
 
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
				url : "${ctx}/sys/role/ajaxlist",
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
						"data" : "name"
					}, {
						"data" : "enname"
					}, {
						"data" : "office.name"//office.id
					}, {
						"data" : "dataScope"
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
							var html = '<a href="#" onclick="openDialogView(\'查看角色\', \'${ctx}/sys/role/roleView?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改角色\', \'${ctx}/sys/role/form?id='+a.id+'\',\'800px\', \'700px\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/sys/role/deleteA?id='+a.id+'\',\'角色\') " class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'权限设置\', \'${ctx}/sys/role/auth?id='+a.id+'\',\'800px\', \'700px\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i>权限设置</a>&nbsp;';
							html+= '<a href="#" onclick="openDialogView(\'分配用户\', \'${ctx}/sys/role/assign?id='+a.id+'\',\'800px\', \'700px\')" class="btn btn-success btn-xs"><i class="glyphicon glyphicon-plus"></i>分配用户</a>';
							return html;
						}
					}
				],
				//初始化完成回调
			"initComplete": function(settings, json) {
				//重新初始化选框
				
				 //$('.i-checks').iCheck('check');
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

	

	</script>
	
	</div>
	</div>
</body>
</html>