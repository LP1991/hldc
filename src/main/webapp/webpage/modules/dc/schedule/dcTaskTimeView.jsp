<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>任务查看</title>
	<meta name="decorator" content="default"/>
</head>
<body>
		<sys:message content="${message}"/>	
		  <fieldset>
		   <legend>调度基本信息</legend>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">调度名称:</label></td>
				<td class="width-35">${dcTaskTime.scheduleName}</td>
				<td class="width-15 active"><label class="pull-right">调度时间:</label></td>
				<td class="width-35">${dcTaskTime.scheduleExpr }</td>
			</tr>	
			 <tr>
				<td class="width-15 active"><label class="pull-right">触发方式:</label></td>
				<td class="width-35">${fns:getDictLabel(dcTaskTime.triggerType, 'dc_taskTimeType', '')}</td>
				<td class="width-15  active"><label class="pull-right">状态:</label></td>
				<td class="width-35">${fns:getDictLabel(dcTaskTime.status, 'dc_taskTimeFlag', '')}</td>
			</tr>
			 <tr>
				<td class="width-15  active"><label class="pull-right">任务来源:</label></td>
				<td class="width-35">${fns:getDictLabel(dcTaskTime.taskfromtype, 'dc_taskFromType', '')}</td>
				<td class="width-15  active"><label class="pull-right">来源任务名称:</label></td>
				<td class="width-35">${dcTaskTime.taskfromname}</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">调度描述:</label></td>
				<td class="width-35">${dcTaskTime.scheduleDesc}</td>
				<td class="width-15 active"><label class="pull-right">下次运行时间:</label></td>
				<td class="width-35"><fmt:formatDate value="${dcTaskTime.nexttime}" type="both" dateStyle="full"/></td>
			</tr>	
		    </tbody>
		  </table>
		  </fieldset>
		  		<div class="tabs-container">
                    <ul class="nav nav-tabs">
                        <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">调度信息</a>
                        </li>
                        <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">任务信息</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div id="tab-1" class="tab-pane active">
                            <div class="panel-body">
                                <table id="contentTable1" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" >
                                <thead>
									<tr>
										<th class="starttime">调度开始时间</th>
										<th class="edntime">调度结束时间</th>
										<th class="status">状态</th>
										<th class="remarks">备注</th>
									</tr>
								</thead>
						</table>
                            </div>
                        </div>
                        
                        <div id="tab-2" class="tab-pane">
                            <div class="panel-body">
                                 <table id="contentTable2" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
                              <thead>
							<tr>
								<th class="startdate">任务开始时间</th>
								<th class="enddate">任务结束时间</th>
								<th class="status">状态</th>
								<th class="remarks">备注</th>
							</tr>
							</thead>
							</table>
							</div>
						</div>
					</div>
				</div>
		  <script type="text/javascript">
		    var table1;
			var table2;
	$(document).ready(function () {
		table1 = $('#contentTable1').DataTable({
		"processing": true,
			"serverSide" : true,
			"bPaginate" : true,// 分页按钮 
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : false, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url: "${ctx}/dc/task/dcTaskLogQquartz/ajaxTasklist?taskId=${dcTaskTime.id}",
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
						"data" : "starttime"
					}, {
						"data" : "edntime"
					}, {
						"data" : "status"
					}, {
						"data" : "remarks"
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 0,
						render : function (a, b) {
							if(a){
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
							return html;
							}else {
								return '';
							}
						}
					},{
						targets : 1,
						render : function (a, b) {
							if(a){								
								var d = new Date(a);
								var tf = function(i){return (i < 10 ? '0' : '') + i};
								var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
								return html;
							}else {
								return '';
							}
						}
					},{targets : 2,
					render : function (a, b) {
						var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskTimeFlag'});
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
		table2 = $('#contentTable2').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : true,// 分页按钮 
			"searching" : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" :false, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/task/dcTaskLogRun/ajaxTasklist?taskId=${dcTaskTime.id}",
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
						"data" : "startdate"
					}, {
						"data" : "enddate"
					}, {
						"data" : "status"
					}, {
						"data" : "remarks"
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 0,
						render : function (a, b) {
							if(a){
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
							return html;
							}else {
								return '';
							}
						}
					},{
						targets : 1,
						render : function (a, b) {
							if(a){
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
							return html;
							}else{
								return '';
							}
							
						}
					},{targets : 2,
					render : function (a, b) {
						var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskTimeFlag'});
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
		  </script>
</body>
</html>