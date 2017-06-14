<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>Rest WebService采集任务</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
		.ago_add2Schedule{
			background: #E0E0E0;
		    border-color: gray;
		    cursor: not-allowed;
		}
		.ago_add2Schedule:hover{
			background: #E0E0E0;
			border-color: gray;
			cursor: not-allowed;
		}
	</style>

	<script src="${ctxStatic}/common/contabs.js"></script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="Rest WebService数据采集" label="Rest WebService数据采集作业, 主要用于采集服务端为Restful 架构的webservice的业务数据, 目前存储于mysql数据库." ></dc:bizHelp>
	<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="dcJobTransIntf"  method="post" class="form-inline">
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<form:hidden path="jobType" value="1"/>
		<div class="form-group">
			<span>任务名称：</span><form:input path="jobName" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
			<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
	<br/>
	</div>
	</div>
	
		<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<table:openModalDialog url="${ctx}/dc/dataProcess/transIntf/dataForm?jobType=1" title="rest webservice采集任务配置" width="1000px" height="700px"></table:openModalDialog><!-- 增加按钮 -->
		</div>
		
	</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>
				<th class="jobName">任务名称</th>
				<th class="jobDesc">任务描述</th>
				<th class="restUrl">采集接口URL</th>
				<th class="restType">接口调用方式</th>
				<th class="tarName">存储目标表</th>
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
				url : "${ctx}/dc/dataProcess/transIntf/ajaxlist",
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
						"data" : "jobName"
					}, {
						"data" : "jobDesc"
					}, {
						"data" : "restUrl"
					}, {
						"data" : "restType"
					}, {
						"data" : "tarName"
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
						targets : 7,
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看数据对象\', \'${ctx}/dc/dataProcess/transIntf/dataView?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看对象"><i class="fa fa-search-plus"></i></a>&nbsp;';
							if(a.accre==1){
								html+= '<a href="#" onclick="openFrameModel(\'编辑任务\', \'${ctx}/dc/dataProcess/transIntf/dataForm?id='+a.id+'\', \'1000px\', \'700px\')" class="btn btn-success btn-xs" title="编辑对象"><i class="fa fa-edit"></i></a>&nbsp;';
								html+= '<a onclick="deleteA(\'${ctx}/dc/dataProcess/transIntf/ajaxDelete?id='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="删除对象"><i class="fa fa-trash"></i></a>&nbsp;';
								html+= '<a onclick="openDialog(\'接口字段关联\', \'${ctx}/dc/dataProcess/transIntf/initTarTable?id='+a.id+'\',\'1000px\', \'680px\')" class="btn btn-success btn-xs" title="接口字段关联"><i class="fa fa-folder"></i></a>&nbsp;';
                                if("2"==a.status || "1"==a.status || "9"==a.status){ //列表按钮控制  '测试','添加至自定义任务'

                                    html+= '<a onclick="runJob(\''+a.id+'\') " class="btn btn-success btn-xs" title="测试"><i class="fa fa-bug"></i></a>&nbsp;';
                                    html+= '<a onclick="add2Schedule(\''+a.id+'\') " class="btn btn-success btn-xs" title="添加至自定义任务"><i class="fa fa-tasks"></i></a>&nbsp;';
                                    if("1"==a.status || "9"==a.status){		//列表按钮控制  '数据预览','查看日志'
                                        html+= '<a href="#" onclick="openDialogView(\'数据预览\', \'${ctx}/dc/dataProcess/transIntf/previewData?id='+a.id+'\',\'1060px\', \'680px\')" class="btn btn-success btn-xs" title="数据预览"><i class="fa fa-file"></i></a>&nbsp;';
                                        html+= '<a onclick="openDialogView(\'查看日志\', \'${ctx}/dc/dataProcess/transIntf/logInfo?id='+a.id+'\',\'760px\', \'480px\')" class="btn btn-success btn-xs" title="查看采集日志"><i class="fa fa-book"></i></a>&nbsp;';
                                    }
                                }
							}else{
								html+= '<a  onclick="getAu(\'${ctx}/dc/dataProcess/transIntf/getAu?id='+a.id+'\',\'申请权限\') " class="btn btn-success btn-xs" title="申请权限"><i class="fa fa-ban"></i></a>&nbsp;';
							}
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
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_intftask_status'});
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
	
	function runJob(jobId){//查询，页码清零
		loading("测试中，请稍候。");
		submitData('${ctx}/dc/dataProcess/transIntf/runTask',{'jobId':jobId},function(data){
			closeTip();
			top.layer.alert(data.msg, {
				title : '运行结果',
				area: ['680px', '340px']
			});
		});
	}
	//添加至调度列表
	function add2Schedule(jobId){
		if($(event.target).hasClass('ago_add2Schedule')){
			return;
		}
		var a_dom = $(event.target);
		submitData('${ctx}/dc/dataProcess/transIntf/add2Schedule', {'jobId':jobId}, function (data) {
			//刷新表格
			top.layer.alert(data.msg, {
				title : '系统提示'
			});
			/* 已添加的按钮变灰色 */
			if(data.msg.indexOf('成功')!==-1){
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
				if(data.msg.indexOf('失败')!==-1){
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