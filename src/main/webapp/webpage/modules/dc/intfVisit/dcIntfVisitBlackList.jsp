<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>接口访问黑名单</title>
	<meta name="decorator" content="default" />
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
		<sys:message content="${message}"/>
		<dc:bizHelp title="接口访问黑名单" label="该功能用于配置接口访问的黑名单, 黑名单中的用户禁止访问相应接口数据." ></dc:bizHelp>
		<div class="ibox">
			<!-- 搜索 -->
			<br>
			<form:form id="sf_black" method="post" class="form-inline">
				<!-- 支持排序 -->
				<div class="form-group">
					<input type="hidden" id="connType_black" name="connType" value="0"/>
					<span>接口对象：</span>
					<input id="objId_black" name="objName" htmlEscape="false" maxlength="64" class="form-control input-sm" />
					<span>访问用户：</span>
					<input id="userId_black" name="userName" htmlEscape="false" maxlength="64" class="form-control input-sm" />
					<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
				</div>
			</form:form>
			</br>
			<!-- 工具栏 -->
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<table:addRow id="add_black" url="${ctx}/dc/intfVisit/list/form?connType=0" title="接口访问黑名单" label="添加黑名单" height="320px"></table:addRow>
					</div>
				</div>
			</div>

			<table id="tb_black" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" style="width:100%" >
				<thead>
				<tr>
					<th class="objName">接口对象</th>
					<th class="userName">访问用户</th>
					<th class="dataSrc">数据来源</th>
					<th class="updateDate">申请时间</th>
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
			table = $('#tb_black').DataTable({
				"processing": true,
				"serverSide" : true,
				"bPaginate" : true,// 分页按钮
				"iDisplayLength": '10',
				"bLengthChange": true,
				"searching" : false, //禁用搜索
				"ordering": false, //禁用排序
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : false, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/dc/intfVisit/list/ajaxlist",
					"data" : function (d) {
						//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
						$.extend(d, getFormParamsObj('sf_black'));
	//                        d.userId=$("#userId_black").val();
	//                        d.objId=$("#objId_black").val();
	//                        d.connType='0';
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
						"data" : "dataSrc"
					}, {
						"data" : "updateDate"
					}, {
						"data" : null
					}
				],
				columnDefs : [{
					"defaultContent": "",
					"targets": "_all"
				},{
					targets : 4,
					render : function (a, b) {
						var html= '<a href="#" onclick="openDialog(\'修改数据对象\', \'${ctx}/dc/intfVisit/list/form?id='+a.id+'\',\'800px\', \'320px\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i> 修改</a>&nbsp;';
						html+= '<a href="#" onclick="deleteA(\'${ctx}/dc/intfVisit/list/ajaxDelete?id='+a.id+'\',\'数据对象\') " class="btn btn-success btn-xs" title="删除数据对象"><i class="fa fa-trash"></i> 删除</a>&nbsp;';
						html+= '<a href="#" onclick="add2White(\'${ctx}/dc/intfVisit/list/move?id='+a.id+'&connType=0\')" class="btn btn-success btn-xs" title="移至白名单"><i class="fa fa-sticky-note-o"></i> 移至白名单</a>';
						return html;
					}
				},{
					targets : 3,
					render : function (a, b) {
						var d = new Date(a);
						var tf = function(i){return (i < 10 ? '0' : '') + i};
						var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
						return html;
					}
				},{
                    targets : 2,
                    render : function (a, b) {
                        return '1'==a?'管理员添加':('2'==a?'用户申请':'');
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
						radioClass: 'iradio_square-green'
					});
				}
			});
		});

		//移至白名单
		function add2White(url){
			confirmx('您确定要将该对象添加至白名单吗？', function(){
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