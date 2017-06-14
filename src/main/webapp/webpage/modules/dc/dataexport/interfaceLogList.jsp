<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>接口日志</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
	</style>
	<script src="${ctxStatic}/common/contabs.js"></script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<form:form id="searchForm"  method="post" class="form-inline">
		<input type="hidden" id="intfId" name="intfId" value="${intfLog.intfId}"/>
	</form:form>

	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>
				
				<th class="callBy">调用者</th>
				<th class="clintIp">客户端IP</th>
				<th class="startTime">调用时间</th>
				<th class="responseTime">响应时长(秒)</th>
				<th class="rstFlag">结果标记</th>
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
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/dataExport/interfaceLog/ajaxlist",
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
					"data" : "callBy"
				}, {
					"data" : "clintIp"
				}, {
					"data" : "startTime"
				}, {
					"data" : "responseTime"
				}, {
					"data" : "rstFlag"
				}
			],
			columnDefs : [{
				"defaultContent": "",
				"targets": "_all"
			  },{
                targets : 4,	//数据源类型
                render : function (a, b) {
                    return a=='1'?'√':'×';
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


	</script>
	
	</div>
</body>
</html>