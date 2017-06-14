<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>调度任务</title>
<meta name="decorator" content="default" />
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
	<div class="wrapper wrapper-content">
		<sys:message content="${message}" />
		<dc:bizHelp title="调度管理"
			label="调度管理, 用于维护数据中心的调度任务, 可以将调度作业添加至数据中心调度任务, 支持手动/自动/条件触发方式"></dc:bizHelp>
		<div class="ibox">
			<br>
			<form:form id="searchForm" modelAttribute="dcTaskTime" method="post"
				action="${ctx}/dc/schedule/dcTaskTime/" class="form-inline">
				<input id="pageNo" name="pageNo" type="hidden"
					value="${page.pageNo}" />
				<input id="pageSize" name="pageSize" type="hidden"
					value="${page.pageSize}" />
				<table:sortColumn id="orderBy" name="orderBy"
					value="${page.orderBy}" callback="sortOrRefresh();" />
				<div class="form-group">
					<span>调度名称：</span>
					<form:input path="scheduleName" value="${dcTaskTime.scheduleName}"
						htmlEscape="false" maxlength="64" class="form-control input-sm" />
					<span>调度描述：</span>
					<form:input path="scheduleDesc" value="${dcTaskTime.scheduleDesc}"
						htmlEscape="false" maxlength="64" class="form-control input-sm" />
					<span>任务来源：</span>
					<form:select path="taskfromtype" class="form-control">
						<form:option value="" label="全部" />
						<form:options items="${fns:getDictListLike('dc_taskFromType')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>
					<span>状态：</span>
					<form:select path="status" class="form-control">
						<form:option value="" label="全部" />
						<form:options items="${fns:getDictListLike('dc_taskTimeFlag')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>
					<button type="button" class="btn btn-success btn-rect  btn-sm "
						onclick="searchA()" type="submit">
						<i class="fa fa-search"></i> 查询
					</button>

				</div>
			</form:form>


			<!-- <br/>
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<shiro:hasPermission name="dc:dcTaskTime:add">
							<table:addRow url="${ctx}/dc/schedule/dcTaskTime/form" width="1000px" title="任务"></table:addRow>
						</shiro:hasPermission>
					</div>
				</div>
			</div>
			-->
		</div>

		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable"
			cellspacing="0" width="100%">
			<thead>
				<tr>

					<th class="scheduleName">调度名称</th>
					<th class="triggerType">触发方式</th>
					<th class="nexttime">下次运行时间</th>
					<th class="status">状态</th>
					<th class="result">上次运行结果</th>
					<th class="taskfromtype">任务来源</th>
					<th class="taskfromname">来源任务名称</th>
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
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/schedule/dcTaskTime/ajaxlist",
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
						"data" : "scheduleName"
					}, {
						"data" : "triggerType"
					}, {
						"data" : "nexttime"
					}, {
						"data" : "status"
					}, {
						"data" : "result"
					}, {
						"data" : "taskfromtype"
					}, {
						"data" : "taskfromname"
					},{
						"data" : null,width: "330px"
					}
				],
				columnDefs : [{
					"defaultContent": "",
					"targets": "_all"
				},{ targets : 1,
					render : function (a, b) {
						
						var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskTimeType'});
						return html;
					}},
					{
					targets : 2,
					render : function (a, b) {
						if(a){							
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
							return html;
						}else{
							return '';
						}
					}},
					{targets : 3,
					render : function (a, b) {
						
						if('1'==a){			//执行中
							return '<span class="label label-warning">执行中</span>';
						}else if('8'==a){	//异常
							return '<span class="label label-danger">异常</span>'; 
						}else if('9'==a){	//完成
							return '<span class="label label-success">完成 </span>';
						}else{				//未执行
							return '<span class="label label">未执行</span>';
						}
						// var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskTimeFlag'});
						// return html;
					}},
					{targets : 4,
                        render : function (a, b) {
                            var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskTimeFlag'});
                            return html;
                        }},
					{targets : 5,
					render : function (a, b) {
						var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_task_srctype'});
						return html;
					}},
					{targets :6,
					render : function (val, disType, obj) {
						// console.dir(arguments);
						var html= '<a href="#" onclick="openFullModel(\''+val+'\', \''+obj.taskfromtype+'\', \''+obj.taskfromid+'\')">'+val+'</a>'
						return html;
					}},
					{targets : 7,
					render : function (a, b) {
						var 
						html= '<a href="#" onclick="openDialogView(\'查看\',\'${ctx}/dc/schedule/dcTaskTime/view?id='+a.id+'\',\'900px\', \'500px\')" class="btn btn-success btn-xs" title="查看任务"><i class="fa fa-search-plus"></i></a>&nbsp;';
						html+= '<a href="#" onclick="openDialog(\'修改\', \'${ctx}/dc/schedule/dcTaskTime/form?id='+a.id+'\',\'900px\', \'500px\')" class="btn btn-success btn-xs" title="编辑任务"><i class="fa fa-edit"></i></a>&nbsp;';
						html+= '<a href="#" onclick="deleteA(\'${ctx}/dc/schedule/dcTaskTime/deleteA?id='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="删除任务"><i class="fa fa-trash"></i></a>&nbsp;';
						html+= '<a href="#" onclick="addJobA(\'${ctx}/dc/schedule/dcTaskTime/addJobA?id='+a.id+'\', \'任务\')" class="btn btn-success btn-xs" title="执行任务"><i class="fa fa-play"></i></a>&nbsp;';
						html+= '<a href="#" onclick="deleteJob(\'${ctx}/dc/schedule/dcTaskTime/deleteJob?id='+a.id+'\', \'任务\')" class="btn btn-success btn-xs" title="停止任务"><i class="fa fa-stop"></i></a>';
						return html;
					}}
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
	
	//批量删除
	function deleteAll(){
		// var url = $(this).attr('data-url');
		  var str="";
		  var ids="";
		  $("#contentTable tbody tr td input.i-checks:checkbox").each(function(){
		    if(true == $(this).is(':checked')){
		      str+=$(this).attr("id")+",";
		    }
		  });
		  if(str.substr(str.length-1)== ','){
		    ids = str.substr(0,str.length-1);
		  }
		  if(ids == ""){
			top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
			return;
		  }
			top.layer.confirm('确认要彻底删除数据吗?', {icon: 3, title:'系统提示'}, function(index){
				//${ctx}适用性比/hldc/page/好
				submitData("${ctx}/dc/schedule/dcTaskTime/deleteAllBy?ids="+ids,{},function(data){
					var icon_number;
					if(!data.success){
						icon_number = 8;
					}else{
						icon_number = 1;
					}
					top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
					table.ajax.reload( null, false ); // 刷新表格数据，分页信息不会重置
					if (typeof(refreshTree) != "undefined") { 
						refreshTree();
					}
				});
				top.layer.close(index); 
		});
	}
	function addJobA(url,title,flag){//查询，页码清零
		confirmx('执行该'+title+'吗？', function(){
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
					 searchA();
				}
			});
		})
	}
	function deleteJob(url,title,flag){
		confirmx('停止该'+title+'吗？', function(){
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
					 searchA();
				}
			});
		})
	}
	
	//全屏弹出窗口
	function openFullModel(title, type, taskId) {
		console.dir(arguments);
		var url = '';
		if('11'==type){	//DB数据采集
			url = '${ctx}/dc/dataProcess/transJob/list?id='+taskId;
		}else if('01'==type){	//任务管理
			url = '${ctx}/dc/schedule/dcTaskMain/index?id='+taskId;
		}else if('14'==type){	//HDFS数据采集
			url = '${ctx}/dc/dataProcess/hdfsJob?id='+taskId;
		}else if('13'==type){	//接口数据采集
			url = '${ctx}/dc/dataProcess/interfaceJob?id='+taskId;
		}else if('12'==type){	//文件数据采集
			url = '${ctx}/dc/dataProcess/transJobFile?id='+taskId;
		}else if('02'==type){	//任务队列
			url = '${ctx}/dc/schedule/dcTaskQueue/list?id='+taskId;
		}
		/** 打开目标窗口
		top.layer.full(top.layer.open({
			type : 2,
			title : '查看任务 ['+title+']',
			maxmin : false, //关闭最大化最小化按钮
			area : [ 'auto', 'auto' ],
			content : url,
			btn : ['关闭' ],
			cancel : function(index) {
			},
			success : function(layero, index) {				//将index传递给目标窗口, 不然没法关闭, 目标页面需实现 function setPIndexId 设置隐藏字段'cur_indexId'
				var iframeWin = layero.find('iframe')[0]; 	// 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
				//debugger;
				if (typeof(table) == "undefined") { 
					iframeWin.contentWindow.setPIndexId(index);
				}else{
					iframeWin.contentWindow.setPIndexId(index,table);
				}				
			}
		}));**/
		
		var pageHight = (document.body.clientHeight-80)+'px' , pageWidth= (document.body.clientWidth-200)+'px';
		top.layer.open({
			type : 2,
			title : '查看任务 ['+title+']',
			maxmin : false, //关闭最大化最小化按钮
			area : [ pageWidth, pageHight ],
			offset: ['100px','200px'],
			content : url,
			btn : ['关闭' ],
			cancel : function(index) {
			},
			success : function(layero, index) {				//将index传递给目标窗口, 不然没法关闭, 目标页面需实现 function setPIndexId 设置隐藏字段'cur_indexId'
				var iframeWin = layero.find('iframe')[0]; 	// 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
				//debugger;
				if (typeof(table) == "undefined") { 
					iframeWin.contentWindow.setPIndexId(index);
				}else{
					iframeWin.contentWindow.setPIndexId(index,table);
				}				
			}
		});
	}
	</script>

</body>
</html>
