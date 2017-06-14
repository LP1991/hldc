<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<title>数据库采集</title>
<meta name="decorator" content="default" />
<style>
.margins {
	margin-left: 10px;
	margin-top: 3px;
}

.ago_add2Schedule {
	background: #9ee061;
	border-color: gray;
	cursor: not-allowed;
}

.ago_add2Schedule:hover {
	background: #5b1de0;
	border-color: gray;
	cursor: not-allowed;
}
</style>

<script src="${ctxStatic}/common/contabs.js"></script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
		<sys:message content="${message}" />
		<dc:bizHelp title="数据库采集" label="数据库采集作业, 主要用于采集关系型数据库(oracle/mysql/sql server/db2等)的业务数据, 存储于hdfs系统或者hive数据库."></dc:bizHelp>
		<!-- 查询条件 -->
		<div class="row">
			<div class="col-sm-12">
				<form:form id="searchForm" modelAttribute="dcJobTransData"
					method="post" class="form-inline">
					<table:sortColumn id="orderBy" name="orderBy"
						value="${page.orderBy}" callback="sortOrRefresh();" />
					<!-- 支持排序 -->
					<form:hidden path="id" />
					<div class="form-group">
						<span>任务名称：</span>
						<form:input path="jobName" htmlEscape="false" maxlength="64"
							class="form-control input-sm" />
						<button class="btn btn-success btn-rect  btn-sm "
							onclick="searchA()" type="button">
							<i class="fa fa-search"></i> 查询
						</button>
					</div>
				</form:form>
				<br />
			</div>
		</div>

		<!-- 工具栏 -->
		<div class="row">
			<div class="col-sm-12">
				<div class="pull-left">
					<shiro:hasPermission name="dc:dataProcess:dcJobTransData:add">
						<table:openModalDialog url="${ctx}/dc/dataProcess/transJob/form"
							title="数据库采集" width="1000px" height="700px"></table:openModalDialog>
						<!-- 增加按钮 -->
					</shiro:hasPermission>
					<button  class="btn btn-success btn-rect  btn-sm "
						onclick="jobMonitor()" type="button" style="display:none;"><!--style="display:none;只是隐藏了这个button按钮要用时可以直接拿掉-->
						<i class="fa fa-list-ul"></i> hadoop job日志
					</button>
				</div>

			</div>
		</div>

		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display"
			cellspacing="0" width="100%">
			<thead>
				<tr>

					<th class="jobName">任务名称</th>
					<th class="jobDesc">任务描述</th>
					<th class="dbConnName">数据源</th>
					<th class="dbServerType">数据库类型</th>
					<th class="toLink">存储类型</th>
					<th class="updateDate">更新时间</th>
					<th class="status">状态</th>
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
			"searching" : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/dataProcess/transJob/ajaxlist",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParamsObj('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					console.log(json);
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					{
						"data" : "jobName"
					}, {
						"data" : "jobDesc"
					}, {
						"data" : "dbConnName"
					}, {
						"data" : "dbServerType"
					}, {
						"data" : "toLink"
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
						targets : 7,	//第7列
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看数据库采集\', \'${ctx}/dc/dataProcess/transJob/dataView?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看数据库采集"><i class="fa fa-search-plus"></i></a>&nbsp;';
							if(a.accre==1){
								html+= '<a href="#" onclick="openFrameModel(\'编辑数据库采集\', \'${ctx}/dc/dataProcess/transJob/form?id='+a.id+'\', \'1000px\', \'700px\')" class="btn btn-success btn-xs" title="编辑数据库采集"><i class="fa fa-edit"></i></a>&nbsp;';
								html+= '<a  onclick="deleteA(\'${ctx}/dc/dataProcess/transJob/ajaxDelete?id='+a.id+'\',\'数据库采集\') " class="btn btn-success btn-xs" title="删除数据库采集"><i class="fa fa-trash"></i></a>&nbsp;';
								html+= '<a  onclick="runJob(\''+a.id+'\') " class="btn btn-success btn-xs" title="测试"><i class="fa fa-bug"></i></a>&nbsp;';
								html+= '<a href="#" onclick="openDialogView(\'源数据预览\', \'${ctx}/dc/dataProcess/transJob/previewData?id='+a.id+'\',\'1060px\', \'680px\')" class="btn btn-success btn-xs" title="源数据预览"><i class="fa fa-file"></i></a>&nbsp;';
							//	html+= '<a  onclick="previewStoreDir(\''+a.id+'\') " class="btn btn-success btn-xs"><i class="fa fa-folder-open-o"></i> 采集目录</a>&nbsp;';
								html+= '<a  onclick="openDialogView(\'查看采集文件对象\', \'${ctx}/dc/dataProcess/hdfs/listHdfsFile?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看采集目录"><i class="fa fa-folder"></i></a>&nbsp;';
							//	html+= '<a href="#" onclick="openDialog(\'调度设置\', \'${ctx}/dc/dataProcess/transJob/scheduleForm?id='+a.id+'\', \'800px\', \'480px\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i> 调度设置</a>&nbsp;';
								html+= '<a  onclick="add2Schedule(\''+a.id+'\') " class="btn btn-success btn-xs" title="添加至自定义任务"><i class="fa fa-tasks"></i></a>&nbsp;';
								html+= '<a onclick="openDialogView(\'查看DB采集日志\', \'${ctx}/dc/dataProcess/hdfs/viewContent?filePath='+a.logDir+'\',\'760px\', \'480px\')" class="btn btn-success btn-xs" title="查看日志"><i class="fa fa-book"></i></a>&nbsp;';
							}else{
								html+= '<a  onclick="getAu(\'${ctx}/dc/dataProcess/transJob/getAu?id='+a.id+'\',\'数据库链接的操作\') " class="btn btn-success btn-xs" title="申请权限"><i class="fa fa-ban"></i></a>&nbsp;';
							}
							return html;
						}
					},{
						targets : 3,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_datasource_type'});
							return html;
						}
					},{
						targets : 4,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_data_store_type'});
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
						targets : 6,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_task_status'});
							return html;
						}
					}
				],
				//初始化完成回调
				"initComplete": function(settings, json) {
					for(var j=0;j<$('tbody').find('tr').length;j++){
						var td_arr = $('tbody').find('tr').eq(j).find('td');
						var td_arr_L = $('tr').eq(j).find('td').length;
						if(td_arr.eq(td_arr_L-2).text().indexOf('发布任务')!==-1){
							var arr_text = td_arr.eq(td_arr_L-1).find('a');
							for(var i=0;i<arr_text.length;i++){
							if(arr_text.eq(i).attr('title').indexOf('调度任务')!==-1){
								arr_text.eq(i).addClass('ago_add2Schedule');
							}
							}
						}
					}
				},
			//重绘回调
			"drawCallback": function( settings ) {
				for(var j=0;j<$('tbody').find('tr').length;j++){
					var td_arr = $('tbody').find('tr').eq(j).find('td');
					var td_arr_L = $('tr').eq(j).find('td').length;
					if(td_arr.eq(td_arr_L-2).text().indexOf('发布任务')!==-1){
						var arr_text = td_arr.eq(td_arr_L-1).find('a');
						for(var i=0;i<arr_text.length;i++){
						if(arr_text.eq(i).attr('title').indexOf('调度任务')!==-1){
							arr_text.eq(i).addClass('ago_add2Schedule');
						}
						}
					}
				}
/* 				$('.i-checks').iCheck({
					checkboxClass: 'icheckbox_square-green',
					radioClass: 'iradio_square-green',
				}); */
			}
		});	
	});	
	

	
/* 	//运行Job TODO: ajax 调用后台任务
	function runJob(jobId){
		//alert(jobId);
		//top.layer.alert('任务已提交后台测试!', {  title : '系统提示' });
		var loading = layer.load();
		submitData('${ctx}/dc/dataProcess/transJob/runTask', {'jobId':jobId}, function (data) {
			 layer.close(loading);
			//parent.document.table.ajax.reload();
			top.layer.alert(data.msg, {
				title : '运行结果',
				area: ['680px', '340px']
			});
		});
	} */
	function runJob(jobId){//查询，页码清零
				loading("测试中，请稍候。");
			submitData('${ctx}/dc/dataProcess/transJob/runTask',{'jobId':jobId},function(data){
				closeTip();
				top.layer.alert(data.msg, {
					title : '运行结果',
					area: ['680px', '340px']
				});
			});
	}
	//源数据预览
	function previewData(jobId){
		//alert(jobId);
		submitData('${ctx}/dc/dataProcess/transJob/previewData', {'jobId':jobId}, function (data) {
			//刷新表格
			window.parent.searchA();
			//parent.document.table.ajax.reload();
			top.layer.alert(data.msg, {
				title : '系统提示'
			});
		});
	} 
	
	//打开监控页面
	function jobMonitor(jobId){
		submitData('${ctx}/dc/dataProcess/transJob/jobMonitor', {'jobId':jobId}, function (data) {
			if(data.msg){
				//console.log(data.msg);
				//openTab('/hlframe/page/sys/user/index','用户管理',false);
				//openTab(','hadoop job监控',false);
				//openTab(data.msg,'hadoop job监控',false);
				window.open(data.msg);
			}
		});
	}
	//打开hdfs存储页面
	function previewStoreDir(jobId){
		submitData('${ctx}/dc/dataProcess/transJob/previewStoreDir', {'jobId':jobId}, function (data) {
			if(data.msg){
				//console.log(data.msg);
				window.open(data.msg);
			}
		});
	}
	//添加至调度列表
	function add2Schedule(jobId){
		if($(event.target).hasClass('ago_add2Schedule')){
			return;
		}
		var a_dom = $(event.target);
		submitData('${ctx}/dc/dataProcess/transJob/add2Schedule', {'jobId':jobId}, function (data) {
			//刷新表格
			//window.parent.searchA();
			//parent.document.table.ajax.reload();
			//刷新表格
			table.ajax.reload();
			top.layer.alert(data.msg, {
				title : '系统提示'
			});
			
			/* 已添加的按钮变灰色 */
			if(!data.success){
				if(a_dom.hasClass('fa-tasks')){
					a_dom.parent().addClass('ago_add2Schedule');
				}else{
					a_dom.addClass('ago_add2Schedule');
				}				
			}
			
		});
	}
	
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



