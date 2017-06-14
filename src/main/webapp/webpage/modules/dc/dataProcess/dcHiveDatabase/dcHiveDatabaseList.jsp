<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>主题域管理</title>
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
<body style="background-color:#f3f3f4;">
<div class="wrapper wrapper-content">
<dc:bizHelp title="主题域管理" label="主题域管理, 用于自定义HIVE中的表空间, 用户可按照自己的业务在平台中自助设置空间." ></dc:bizHelp>
	<sys:message content="${message}"/>
	
	<!-- 工具栏 -->
	
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="dc:searchContent:add">
				<table:addRow url="${ctx}/dc/dataProcess/dcHiveDatabase/form" title="主题域"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
		
		</div>
	</div>
	</div>
	
	<table id="contentTable"  class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>
				
				<th class="dcHiveDatabase_database">主题域名称</th>
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
					url : "${ctx}/dc/dataProcess/dcHiveDatabase/ajaxlist?id=${id}",
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
						"data" : "database"
					}, {
						"data" : "remarks"
					}, {
						"data" : null
					}
				],
				//定义列的初始属性
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets :2,
						render : function (a, b) {
							var html = '<a href="#" title=\'查看\' onclick="openDialogView(\'查看\', \'${ctx}/dc/dataProcess/dcHiveDatabase/view?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" title=\'修改\' onclick="openDialog(\'修改\', \'${ctx}/dc/dataProcess/dcHiveDatabase/form?id='+a.id+'\',\'800px\', \'700px\',\'dcHiveDatabase\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a title=\'删除\' onclick="deleteA(\'${ctx}/dc/dataProcess/dcHiveDatabase/deleteA?id='+a.id+'\',\'主题域\') " class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>&nbsp;';
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