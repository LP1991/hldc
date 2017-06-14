<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>实体管理</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
		body{
			background-color:#f5f5f5;
		}
	</style>
	<script type="text/javascript">
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body class="gray-bg">
	
	    <sys:message content="${message}"/>
	    
	    <!-- 查询条件 -->
		<div class="wrapper wrapper-content">
		<dc:bizHelp title="实体管理" label="通过此功能,用户可以自助实现实体管理过程." ></dc:bizHelp> <!--业务帮助 -->
		<div class="ibox">
			<br>
	    <div class="row">
	        <div class="col-sm-12">
	            <form:form id="searchForm" modelAttribute="dcHiveTable"  method="post" class="form-inline">
				<input id="pageNo" name="pageNo" type="hidden"
					value="${page.pageNo}" />
				<input id="pageSize" name="pageSize" type="hidden"
					value="${page.pageSize}" />
				 <table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();" />
		            <div class="form-group">
			            <span>数据表名称：</span><form:input path="tableName" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
			            <span>表空间：</span>
			                <form:select path="tableSpace" id="tableSpace" class="form-control">
								<form:option value=""  label="全部"/>
					            <form:option  value="default" label="default"/>
					            <form:options items="${dbList}" itemLabel="database" itemValue="database"   htmlEscape="false"/>
				            </form:select>
			            <button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
		            </div>	
		        </form:form>
	        </div>
	    </div>
	    <br/>
	    <!-- 工具栏 -->
	    <div class="row">
	        <div class="col-sm-12">
		        <div class="pull-left">
			        <shiro:hasPermission name="dc:dataProcess:hiveTableData:add">
				        <table:addRow url="${ctx}/dc/dataProcess/hiveTableData/form" title="实体" width="800px" height="500px"/><!-- 增加按钮 -->
			        </shiro:hasPermission>	
		        </div>
	        </div>
	    </div>
		</div>
		
	    <table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		    <thead>
			    <tr>
				   
				    <th class="tableName">数据表名称</th>
				    <th class="tableDesc">数据表描述</th>
				    <th class="tableSpace">表空间</th>
				    <th class="owner">拥有者</th>
				    <th class="status">状态</th>
				   <!-- <th class="tableType">数据表类型</th>-->
				    <!--<th class="location">表位置</th>-->
				    <th class="createTime">创建时间</th>
				    <th>操作</th>
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
				    url : "${ctx}/dc/dataProcess/hiveTableData/ajaxlist",
				    "data" : function (d) {
					    //d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
						//debugger;
					    $.extend(d, getFormParams('searchForm'));
				    },
				    "dataSrc" : function (json) {//定义返回数据对象
					    return JSON.parse(json.body.gson);
				    }
			    },
				"columns" : [
					 {
						"data" : "tableName"
					}, {
						"data" : "tableDesc"
					},{
						"data" : "tableSpace"
					}, {
						"data" : "owner"
					}, {
						"data" : "status"
					}, {
						"data" : "createTime"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 6,	//第7列
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看\', \'${ctx}/dc/dataProcess/hiveTableData/dataView?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看实体信息"><i class="fa fa-search-plus"></i></a>&nbsp;';
							if('0'==a.status){	//新建
								html+= '<a href="#" onclick="openDialog(\'字段信息设置\', \'${ctx}/dc/dataProcess/hiveTableData/setFieldData?id='+a.id+'\',\'800px\', \'500px\')" class="btn btn-success btn-xs" title="字段信息设置"><i class="fa fa-columns"></i></a>&nbsp;';
								html+= '<a  onclick="createHiveTable(\''+a.id+'\') " class="btn btn-success btn-xs" title="生成hive数据表"><i class="fa fa-table"></i></a>&nbsp;';
								
							}else{
								html+= '<a href="#" onclick="openDialog(\'根据目录录入数据\', \'${ctx}/dc/dataProcess/hiveTableData/loadDataByCatalog?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="按目录导入数据"><i class="fa fa-file-text-o"></i></a>&nbsp;';
							}
							//html+= '<a href="#" onclick="openDialog(\'修改\', \'${ctx}/dc/dataProcess/hiveTableData/form?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="修改表信息"><i class="fa fa-edit"></i></a>&nbsp;';
							// html+= '<a  onclick="loadHiveData(\''+a.id+'\') " class="btn btn-success btn-xs" title="导入数据到hive数据表"><i class="fa fa-cloud-upload"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/dc/dataProcess/hiveTableData/ajaxDelete?id='+a.id+'\',\'实体\') " class="btn btn-success btn-xs" title="删除实体"><i class="fa fa-trash"></i></a>&nbsp;';
							return html;
						}
					},{
						targets : 5,
						render : function (a, b) {
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
							return html;
						}
					},{
						targets :4,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_hiveTbStatus'});
							return html;
						}
					}

				],
				//初始化完成回调
				"initComplete": function(settings, json) {
				},
			    //重绘回调
			    "drawCallback": function( settings ) {
// 				    $('.i-checks').iCheck({
// 					    checkboxClass: 'icheckbox_square-green',
// 					    radioClass: 'iradio_square-green'
// 				    });
			    }
		    });
	    });	
		
		function createHiveTable(id){
			top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>'});
            submitData('${ctx}/dc/dataProcess/hiveTableData/createHiveTable', {'id':id}, function (data) {
            	top.layer.closeAll('loading'); 
			    //刷新表格
			   //  window.parent.searchA();
			    //parent.document.table.ajax.reload();
			    table.ajax.reload();
			    top.layer.alert(data.msg, {
				    title : '系统提示'				  
			    });
		    });			
		}
		
		function loadHiveData(id){	
            submitData('${ctx}/dc/dataProcess/hiveTableData/loadHiveData', {'id':id}, function (data) {
			    //刷新表格
			    //window.parent.searchA();
			    //parent.document.table.ajax.reload();
			    top.layer.alert(data.msg, {
				    title : '系统提示'
			    });
		    });		
		}
		
	</script>
	</div>
</body>
</html>