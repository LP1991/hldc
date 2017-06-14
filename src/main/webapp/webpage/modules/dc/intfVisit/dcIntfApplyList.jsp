<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>接口申请列表</title>
	<meta name="decorator" content="default" />
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
		<sys:message content="${message}"/>
		<dc:bizHelp title="接口申请" label="该功能用于对用户提交的接口申请请求进行操作(同意或撤销)." ></dc:bizHelp>
		<div class="ibox">
			<br>
			<form:form id="searchForm" modelAttribute="applyForm"  method="post" class="form-inline">
				<div class="form-group">
					<input type="hidden" id="status" name="status" value="0"/>
					<span>接口对象：</span>
					<input id="objName" name="objName" htmlEscape="false" maxlength="64" class="form-control input-sm" />
					<span>申请用户：</span>
					<input id="userName" name="userName" htmlEscape="false" maxlength="64" class="form-control input-sm" />
					<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()"  type="button"><i class="fa fa-search"></i> 查询</button>
				</div>
			</form:form>
			</br>

			<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable ">
				<thead>
				<tr>
					<th class="objName">接口对象</th>
					<th class="userName">访问用户</th>
					<th class="updateDate">申请时间</th>
					<th class="status">申请状态</th>
					<th>操作</th>
				</tr>
				</thead>
			</table>
			<br/>
			<br/>
		</div>
	</div>

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
					url : "${ctx}/dc/intfVisit/apply/ajaxlist",
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
						"data" : "objName"
					}, {
						"data" : "userName"
					}, {
						"data" : "updateDate"
					}, {
						"data" : "status"
					}, {
						"data" : null
					}
				],
				columnDefs : [{
					"defaultContent": "",
					"targets": "_all"
				},{
					targets : 2,
					render : function (a, b) {
						var d = new Date(a);
						var tf = function(i){return (i < 10 ? '0' : '') + i};
						var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
						return html;
					}
				 },{
                    targets : 3,
                    render : function (a, b) {
                        return '0'==a?'申请中':('1'==a?'申请通过':'申请撤销');
                    }
                },{
					targets : 4,
					render : function (a, b) {
						var html = "";
						html+= '<a href="#" onclick="passApply(\'${ctx}/dc/intfVisit/apply/passApply?id='+a.id+'\')" class="btn btn-success btn-xs" title="同意"><i class="fa fa-tasks"></i> 同意</a>&nbsp;';
						html+= '<a href="#" onclick="undoApply(\'${ctx}/dc/intfVisit/apply/undoApply?id='+a.id+'\')" class="btn btn-success btn-xs" title="撤销"><i class="fa fa-tasks"></i> 撤销</a>&nbsp;';
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

		// 通过审核申请
		function passApply(url) {
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
			});
		}

		//撤销审核申请
		function undoApply(url) {
			confirmx('您确定要撤销该申请吗？', function(){
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
				});
			})
		}

	</script>
</body>

</html>