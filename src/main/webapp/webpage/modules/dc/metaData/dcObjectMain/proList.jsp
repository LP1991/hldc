<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>配置信息修改</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	function save(key){
//		debugger;
		var value = document.getElementById(key).value;
		submitData("${ctx}/dc/metadata/properties/save?key="+key+"&&value="+value,{},function(data){
			document.all[key].style.border = 'solid 3px red';
		});
	}
	</script>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
		<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<!-- 查询时跳转当前 路径不变-->
	<form:form id="searchForm" modelAttribute="Pro" action="${ctx}/dc/metadata/properties/ajaxlist" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
	</form:form>
	<br/>
	</div>
	</div>
	
	<div class="wrapper wrapper-content">
		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable"  cellspacing="0" width="100%">
			<thead>
				<tr>
					<th>键</th>
					<th>值</th>
					<th>备注</th>
				</tr>
			</thead>			
		</table>
	
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
				url : "${ctx}/dc/metadata/properties/ajaxlist",
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
						"data" : "key"
					}, {
						"data" : null
					}, {
						"data" : "desc"
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 1,
						render : function (a, b) {//${ctx}/dc/dataProcess/process/view?
                         	var html= '<input type="text" value="'+a.value+'" id="'+a.key+'" name="'+a.key+'" onchange="save(\''+a.key+'\')"/>&nbsp;';
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
	
</body>
</html>