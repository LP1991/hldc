<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<title>源数据分类</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}

	function confirmx_first(title,url){
		console.log(title);
		console.log(url.toString());
		var flag_add = 0;
		var flag_cancel = 0;
		var ago_index = $(event.target).parent().parent().index()+1;//相对位置需要+1
		for(var i=0;i<$('tr').length;i++){
			if($('tr').eq(i).children("td:last-child").find('a').length>0 && i!==ago_index){//排除本身的干扰 
				var str = $('tr').eq(i).children("td:last-child").children("a:last-child").text();
				if(str.indexOf('添加')!==-1){
					flag_add++;
				}else if(str.indexOf('取消')!==-1){
					flag_cancel++;
				}
			}
		}
		if(title.indexOf('添加')!==-1){
			if(flag_cancel<5){
				return confirmx(title,url);
			}else{
				layer.msg('最多只能添加5个', {
					  icon: 5,
					  time: 2000 //2秒关闭（如果不配置，默认是3秒）
					}, function(){
					  //do something
					});
				return false;
			}
		}else {
			if(flag_cancel>0){
				return confirmx(title,url);
			}else{
				layer.msg('最少要保留一个', {
					  icon: 5,
					  time: 2000 //2秒关闭（如果不配置，默认是3秒）
					}, function(){
					  //do something
					});
				return false;
			}
		}
		
	}
	
	var table;
	
		$(document).ready(function () {
			/* 
			* 新增函数，在本页面判断 数据搜索界面显示是否已经超过5个，或者是否低于1个 
			* @fengzg
			* 规则，最多添加5个 最少要有一个 
			*/

			
			
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
					url : "${ctx}/dc/dataSearch/dcContentTable/ajaxlist",
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
							"data" : "itemName",width: "200px"
						}, {
							"data" : "itemCode",width: "200px"
						}, {
							"data" : "remarks",width: "200px"
						}, 
						{
							"data" : null
						}
					],
					columnDefs : [{	                          
	                    "defaultContent": "",
	                    "targets": "_all"
	                  },{
							targets : 4,
							render : function (a,b) {	
	                        var html= '<a href="#" onclick="openDialogView(\'查看数据分类\', \'${ctx}/dc/dataSearch/dcContentTable/view?id='+a.id+'\',\'800px\', \'500px\')"  class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i> 查看</a>&nbsp;';
								html+= '<a href="#" onclick="openDialog(\'修改数据分类\', \'${ctx}/dc/dataSearch/dcContentTable/form?id='+a.id+'\',\'800px\', \'500px\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i>修改</a>&nbsp;';
								html+= '<a href="${ctx}/dc/dataSearch/dcContentTable/delete?id='+a.id+'" onclick="return confirmx(\'确认要删除该数据分类吗？\', this.href)" class="btn btn-success btn-xs"><i class="fa fa-trash"></i>删除</a>&nbsp;';
								html+= '<a href="#" onclick="openDialogView(\'分类明细\', \'${ctx}/dc/dataSearch/dcSearchContent/index?id='+a.id+'\',\'1000px\', \'800px\')"class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i>设置明细</a>&nbsp;';
								if(a.status=='1'){
									html+= '<a href="${ctx}/dc/dataSearch/dcContentTable/delDataToDataSearch?ids='+a.id+'" onclick="return confirmx_first(\'是否取消在数据搜索界面显示?至少需要一个\', this.href\)" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i>取消在数据搜索界面显示</a>&nbsp;'
								}else{
									html+= '<a href="${ctx}/dc/dataSearch/dcContentTable/addDataToDataSearch?ids='+a.id+'" onclick="return confirmx_first(\'是否要将这个分类添加到数据搜索界面?最多只有5个\', \'${ctx}/dc/dataSearch/dcContentTable/addDataToDataSearch?ids='+a.id+'\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i>添加到数据搜索界面</a>&nbsp;';
								}
								
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
			})
		});
</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="数据分类管理" label="数据分类管理, 用于自定义数据分类项目及分类明细, 用户可按照自己的业务在平台中自助设置分类." ></dc:bizHelp>
		<div class="ibox">
			<br>
			<form:form id="searchForm" modelAttribute="dcContentTable"
				method="post" action="${ctx}/dc/dataSearch/dcContentTable/"
				class="form-inline">
				<input id="pageNo" name="pageNo" type="hidden"
					value="${page.pageNo}" />
				<input id="pageSize" name="pageSize" type="hidden"
					value="${page.pageSize}" />
				<table:sortColumn id="orderBy" name="orderBy"
					value="${page.orderBy}" callback="sortOrRefresh();" />
				<!-- 支持排序 -->
				<div class="form-group">
					<span>分类项目：</span>
					<form:input path="itemName" value="${dcContentTable.itemName}"
						htmlEscape="false" maxlength="64" class="form-control input-sm" />
					<span>分类编码：</span>
					<form:input path="itemCode" value="${dcContentTable.itemCode}"
						htmlEscape="false" maxlength="64" class="form-control input-sm" />
					<button class="btn btn-success btn-rect  btn-sm "
						onclick="search()" type="submit">
						<i class="fa fa-search"></i> 查询
					</button>
				</div>
			</form:form>
			</br>

			<!-- 工具栏 -->
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<shiro:hasPermission name="dc:contentTable:add">
							<table:addRow url="${ctx}/dc/dataSearch/dcContentTable/form"
								title="分类"></table:addRow>
							<!-- 增加按钮 -->
						</shiro:hasPermission>
						<shiro:hasPermission name="dc:contentTable:del">
							<table:delRow url="${ctx}/dc/dataSearch/dcContentTable/deleteAll"
								id="contentTable"></table:delRow>
							<!-- 删除按钮 -->
						</shiro:hasPermission>
					</div>
				</div>
			</div>

			<table id="contentTable"
				class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
				<thead>
					<tr>
						<th><input type="checkbox" class="i-checks"></th>
						<th class="itemName">分类项目</th>
						<th class="itemCode">分类编码</th>
						<th class="remarks">备注</th>
						<th>操作</th>
					</tr>
				</thead>
			</table>
			<br /> <br />
		</div>
	</div>
</body>
</html>