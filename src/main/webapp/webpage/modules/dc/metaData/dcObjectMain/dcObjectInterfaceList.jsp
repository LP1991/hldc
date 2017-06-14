<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>接口对象管理</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
		/* 第一页和第二页显示有误差 */
		tr td:last-child{
			padding-right:0 !important;
		}
		tr th:last-child{
			width:100px !important;
		}
	</style>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="接口对象" label="接口对象, 用于管理数据中心的接口对象信息, 以及查看接口的使用信息." ></dc:bizHelp>
	
	<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="interface"  method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>对象名称：</span><form:input path="objName" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
			<span>对象编码：</span><form:input path="objCode" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
				<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
	<br/>
	</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>			
				<th class="objName">对象名称</th>
				<th class="objCode">对象编码</th>
				<th class="objDesc">对象描述</th>
				<th class="intfcType">接口类别</th>
				<th class="intfcUrl">接口地址</th>
				<th class="managerOrg">业务部门</th>
				<th class="managerPer">业务负责人</th>
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
			"bPaginate" : true,// 分页按钮 
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/metadata/dcObjectIntf/ajaxlist",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParams('searchForm'));
					$('th：last-child').width('100px');
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					{
						"data" : "objName"
					}, {
						"data" : "objCode"
					}, {
						"data" : "objDesc"
					},{
						"data" : "intfcType"
				    },{
						"data" : "intfcUrl"
					}, {
						"data" : "office.name"
					}, {
						"data" : "user.name"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 7,	//第9列
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看接口对象\', \'${ctx}/dc/metadata/dcObjectIntf/intfView?id='+a.id+'\',\'900px\', \'760px\')" class="btn btn-success btn-xs" title="查看对象"><i class="fa fa-search-plus"></i></a>&nbsp;';
							if(a.accre==1){
								html+= '<a href="#" onclick="openDialog(\'修改\', \'${ctx}/dc/metadata/dcObjectIntf/intfForm?id='+a.id+'\',\'800px\', \'700px\')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i></a>&nbsp;';
                                html+= '<a href="#" onclick="openDialog(\'查看调用日志\', \'${ctx}/dc/dataExport/interfaceLog/list?intfId='+a.id+'\',\'800px\', \'700px\')" class="btn btn-success btn-xs" title="查看接口访问日志"><i class="fa fa-ellipsis-h"></i></a>&nbsp;';
							}else{
								html+= '<a  onclick="getAu(\'${ctx}/dc/metadata/dcObjectMain/getAu?id='+a.id+'\',\'接口对象\') " class="btn btn-success btn-xs" title="申请权限"><i class="fa fa-ban"></i></a>&nbsp;';
							}
							
							/* html+= '<a href="#" onclick="openDialog(\'权限设置\', \'${ctx}/sys/role/auth?id='+a.id+'\',\'800px\', \'700px\')" class="btn btn-success btn-xs" title="权限设置"><i class="fa fa-edit"></i></a>&nbsp;'; */
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
		setTimeout(function(){
			$('th:last-child').width('100px');
		})
	});	
	
	function getAu(url,title,flag){//查询，页码清零
		confirmx('确认要申请该'+title+'的权限吗？', function(){
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
	
	</div>
</body>
</html>