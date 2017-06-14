<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/webpage/include/treetable.jsp" %>
	<script type="text/javascript">
		/* $(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, rootId = "${not empty office.id ? office.id : '0'}";
			addRow("#treeTableList", tpl, data, rootId, true);
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							type: getDictLabel(${fns:toJson(fns:getDictList('sys_office_type'))}, row.type)
						}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
		function refresh(){//刷新或者排序，页码不清零
    		
			window.location="${ctx}/sys/office/list";
    	} */
	</script>
</head>
<body class="gray-bg">
<div class="wrapper wrapper-content">
	<div class="wrapper wrapper-content">
	
	<sys:message content="${message}"/>
	
	<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="office" url="${ctx}/sys/office/ajaxlist" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="fparent_id" name="parent_id" type="hidden" />
		<input id="parentid" name="parent.id" type="hidden"  value="${parent.id}"/>${parent.id}
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>机构名称：</span>
				<%-- <sys:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue="${user.office.name}" 
				title="区域管理" url="/sys/office/treeData?type=1" cssClass="form-control input-sm" allowClear="true"/> --%>
				<input name="name" class="form-control input-sm"/>
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
			<shiro:hasPermission name="sys:office:add">
				<table:addRow url="${ctx}/sys/office/form?parent.id=${office.id}" title="机构" width="800px" height="620px" target="officeContent"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
			</div>
	</div>
	</div>
	<table id="treeTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr>
			<th>机构名称</th>
			<th>归属区域</th>
			<th>机构编码</th>
			<th>机构类型</th>
			<th>备注</th>
			<%-- <shiro:hasPermission name="sys:office:edit"> --%>
			<th>操作</th>
			<%-- </shiro:hasPermission> --%>
			</tr>
		</thead>
		<!-- <tbody id="treeTableList"></tbody> -->
	</table>
</div>
</div>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a  href="#" onclick="openDialogView('查看机构', '${ctx}/sys/office/officeView?id={{row.id}}','800px', '620px')">{{row.name}}</a></td>
			<td>{{row.office.name}}</td>
			<td>{{row.code}}</td>
			<td>{{dict.type}}</td>
			<td>{{row.remarks}}</td>
			<td>
				<shiro:hasPermission name="sys:office:view">
					<a href="#" onclick="openDialogView('查看机构', '${ctx}/sys/office/officeView?id={{row.id}}','800px', '620px')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i></a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:office:edit">
					<a href="#" onclick="openDialog('修改机构', '${ctx}/sys/office/form?id={{row.id}}','800px', '620px', 'officeContent')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:office:del">
					<a href="${ctx}/sys/office/delete?id={{row.id}}" onclick="return confirmx('要删除该机构及所有子机构项吗？', this.href)" class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:office:add">
					<a href="#" onclick="openDialog('添加下级机构', '${ctx}/sys/office/form?parent.id={{row.id}}','800px', '620px', 'officeContent')" class="btn  btn-success btn-xs"><i class="fa fa-plus"></i> 添加下级机构</a>
				</shiro:hasPermission>
			</td>
		</tr>
	</script>
	
	<script>
	var table;
	$(document).ready(function () {
		table = $('#treeTable').DataTable({
				"processing": true,
				"serverSide" : true,
				searching : false, //禁用搜索
				"ordering": false, //禁用排序
				
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : true, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/sys/office/ajaxlist",
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
					},{
						"data" : "area.name"
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
				columnDefs : [ {	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 5,
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看区域\', \'${ctx}/sys/office/form?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改区域\', \'${ctx}/sys/office/form?id='+a.id+'\',\'800px\', \'700px\',\'officeContent\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/sys/office/deleteA?id='+a.id+'\',\'区域\',true) " class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>&nbsp;';
							//html+= '<a href="#" onclick="openDialog(\'添加下级区域\', \'${ctx}/sys/office/form?parent.id='+a.id+'\',\'800px\', \'700px\')" class="btn btn-success btn-xs"><i class="fa fa-plus"></i>添加下级区域</a>';
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
</body>
</html>