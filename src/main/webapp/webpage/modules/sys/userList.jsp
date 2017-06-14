<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
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
		
		<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="user" url="${ctx}/sys/user/ajaxlist" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<%-- <span>归属公司：</span>
				<sys:treeselect id="company" name="company.id" value="${user.company.id}" labelName="company.name" labelValue="${user.company.name}" 
				title="公司" url="/sys/office/treeData?type=1" cssClass="form-control input-sm" allowClear="true"/> --%>
			<span>登录名：</span>
				<form:input path="loginName" htmlEscape="false" maxlength="50" class="form-control input-sm"/>
			<%-- <span>归属部门：</span>
				<sys:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue="${user.office.name}" 
				title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-sm" allowClear="true" notAllowSelectParent="true"/> --%>
			<span>姓&nbsp;&nbsp;&nbsp;名：</span>
				<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-sm"/>
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
			<shiro:hasPermission name="sys:user:add">
				<table:addRow url="${ctx}/sys/user/form" title="用户" width="800px" height="625px" target="officeContent"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="sys:user:del">
				<table:delRowByAjax url="${ctx}/sys/user/deleteAllByA" id="contentTable"></table:delRowByAjax><!-- 删除按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="sys:user:import">
				<table:importExcel url="${ctx}/sys/user/import"></table:importExcel><!-- 导入按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="sys:user:export">
	       		<table:exportExcel url="${ctx}/sys/user/export"></table:exportExcel><!-- 导出按钮 -->
	       </shiro:hasPermission>
	       
			</div>
	</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>
				<th><input type="checkbox" class="i-checks"></th>
				<th class="login_name">登录名</th>
				<th class="name">姓名</th>
				<th class="phone">电话</th>
				<th class="mobile">手机</th>
				<th class="c.name">归属公司</th>
				<th class="o.name">归属部门</th>
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
				searching : false, //禁用搜索
				"ordering": false, //禁用排序
				
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p',
				"autoWidth" : true, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/sys/user/ajaxlist",
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
						"data" : "loginName"
					}, {
						"data" : "name"
					}, {
						"data" : "phone"
					}, {
						"data" : "mobile"
					}, {
						"data" : "company.name"
					}, {
						"data" : "office.name" //
					}, {
						"data" : null
					}
				],
				//定义列的初始属性
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 7,
						render : function (a, b) {
							//判断权限
							var html ='';
							html += '<a href="#" onclick="openDialogView(\'查看用户\', \'${ctx}/sys/user/userView?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改用户\', \'${ctx}/sys/user/form?id='+a.id+'\',\'800px\', \'700px\', \'officeContent\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/sys/user/deleteA?id='+a.id+'\',\'用户\') " class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>';
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

	

	</script>
</div>
</body>
</html>