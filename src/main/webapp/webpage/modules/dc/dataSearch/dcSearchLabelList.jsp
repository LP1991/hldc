<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<title>搜索标签</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
function page(n,s){
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").submit();
	return false;
}
</script>
</head>
<body class="gray-bg">
<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="数据标签管理" label="数据标签管理, 用于自助维护数据标签, 创建企业自己的标签库." ></dc:bizHelp>
<div class="ibox">
<!-- 搜索 -->
<br>
<form:form id="searchForm" modelAttribute="dcSearchLabel"  method="post" action="${ctx}/dc/dataSearch/dcSearchLabel/" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>标签名称：</span>
				<form:input path="labelName" value="${dcSearchLabel.labelName}"  htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
			<span>标签描述：</span>
				<form:input path="labelDesc" value="${dcSearchLabel.labelDesc}"  htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
				<button class="btn btn-success btn-rect  btn-sm " onclick="search()" type="submit"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
</br>
		<!-- 工具栏 -->
		<div class="row">
			<div class="col-sm-12">
				<div class="pull-left">
					<shiro:hasPermission name="dc:searchLabel:add">
						<table:addRow url="${ctx}/dc/dataSearch/dcSearchLabel/form" title="数据标签"></table:addRow>
						<!-- 增加按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="dc:searchLabel:del">
						<table:delRow url="${ctx}/dc/dataSearch/dcSearchLabel/deleteAll" id="contentTable"></table:delRow>
						<!-- 删除按钮 -->
					</shiro:hasPermission>
				</div>
			</div>
		</div>

		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable ">
			<thead>
				<tr>
					<th><input type="checkbox" class="i-checks"></th>
					<th class="labelName">标签名称</th>
					<th class="labelDesc">标签描述</th>
					<th class="remarks">备注</th>
					<th>操作</th>
				</tr>
			</thead>
			<c:choose> 
			<c:when test="${dcSearchLabel==null || fn:length(page.list)==0}">  
					<td class="dataTables_empty" valign="top" colspan="9">没有数据</td>
			</c:when>
			<c:otherwise> 
			<tbody>
			
				<c:forEach items="${page.list}" var="dcSearchLabel">
					<tr>
						<td><input type="checkbox" id="${dcSearchLabel.id}" class="i-checks"></td>
						<td>${dcSearchLabel.labelName}</td>
						<td>${dcSearchLabel.labelDesc}</td>
						<td>${dcSearchLabel.remarks}</td>
						<td><shiro:hasPermission name="dc:contentTable:view">
								<a href="#" onclick="openDialogView('查看数据标签', '${ctx}/dc/dataSearch/dcSearchLabel/view?id=${dcSearchLabel.id}','800px', '500px')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i> 查看</a>
							</shiro:hasPermission> 
							<shiro:hasPermission name="dc:contentTable:edit">
								<a href="#" onclick="openDialog('修改数据标签', '${ctx}/dc/dataSearch/dcSearchLabel/form?id=${dcSearchLabel.id}','800px', '500px')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i>修改</a>
							</shiro:hasPermission> 
							<shiro:hasPermission name="dc:contentTable:del">
								<a href="${ctx}/dc/dataSearch/dcSearchLabel/delete?id=${dcSearchLabel.id}" onclick="return confirmx('确认要删除该数据标签吗？', this.href)" class="btn btn-success btn-xs"><i class="fa fa-trash"></i>删除</a>
							</shiro:hasPermission></td>
					</tr>
				</c:forEach>
			</tbody>
			</c:otherwise> 
			</c:choose> 
		</table>
		<table:page page="${page}"></table:page>
		<br/>
		<br/>
	</div>
	</div>
	</div>
</body>
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
                CONSTANT.DATA_TABLES.COLUMN.CHECKBOX,{
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
                     	var html= '<a href="#" onclick="openDialogView(\'查看\',\'${ctx}/dc/schedule/dcTaskMain/view?id='+a.id+'\',\'800px\', \'500px\')" class="btn btn-success btn-xs" title="查看任务"><i class="fa fa-search-plus"></i></a>&nbsp;';
						html+= '<a href="#" onclick="openDialog(\'修改\', \'${ctx}/dc/schedule/dcTaskMain/form?id='+a.id+'\',\'800px\', \'500px\')" 	class="btn btn-success btn-xs" title="编辑任务"><i class="fa fa-edit"></i></a>&nbsp;';
						html+= '<a href="#" onclick="deleteA(\'${ctx}/dc/schedule/dcTaskMain/deleteA?id='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="删除任务"><i class="fa fa-trash"></i></a>&nbsp;';
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
				$('.i-checks').iCheck({
					checkboxClass: 'icheckbox_square-green',
					radioClass: 'iradio_square-green',
				});
		}
	});
});

</script>
</html>