<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>区域管理</title>
	<meta name="decorator" content="default"/>
	
	<script>
		$(document).ready(function() {
			$(document).on('ifChecked', '#contentTable thead tr th input.i-checks',function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		  	  $('#contentTable tbody tr td input.i-checks').iCheck('check');
		  	});
	
		  $(document).on('ifUnchecked','#contentTable thead tr th input.i-checks', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		  	  $('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
		  	});
		    
		});
	</script>
</head>
<body class="gray-bg">
<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="area" url="${ctx}/sys/area/ajaxlist" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="fparent_id" name="parent_id" type="hidden" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>区域名称：</span>
				<%-- <sys:treeselect id="area" name="area.id" value="${user.area.id}" labelName="area.name" labelValue="${user.area.name}" 
				title="区域管理" url="/sys/area/treeData?type=1" cssClass="form-control input-sm" allowClear="true"/> --%>
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
			<shiro:hasPermission name="sys:area:add">
				<table:addRow url="${ctx}/sys/area/form" title="区域"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
		
		</div>
	</div>
	</div>
	
	<table id="contentTable"  class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>
				
				<th class="area_name">区域名称</th>
				<th class="area_code">区域编码</th>
				<th class="area_type">区域类型</th>
				<th class="remarks">备注</th>
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
				
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : true, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/sys/area/ajaxlist",
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
						"data" : "name"
					}, {
						"data" : "code"
					}, {
						"data" : "type"
					}, {
						"data" : "remarks"
					}, {
						"data" : null
					}
				],
				//定义列的初始属性
				columnDefs : [{
						targets : 4,
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看区域\', \'${ctx}/sys/area/form?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改区域\', \'${ctx}/sys/area/form?id='+a.id+'\',\'800px\', \'700px\',\'areaContent\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/sys/area/deleteA?id='+a.id+'\',\'区域\',true) " class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>&nbsp;';
							//html+= '<a href="#" onclick="openDialog(\'添加下级区域\', \'${ctx}/sys/area/form?parent.id='+a.id+'\',\'800px\', \'700px\')" class="btn btn-success btn-xs"><i class="fa fa-plus"></i>添加下级区域</a>';
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
// 					 $('.i-checks').iCheck({
// 			                checkboxClass: 'icheckbox_square-green',
// 			                radioClass: 'iradio_square-green',
// 			            });
				    }
			});
	
	});
	
	</script>
	</div>
</body>
</html>