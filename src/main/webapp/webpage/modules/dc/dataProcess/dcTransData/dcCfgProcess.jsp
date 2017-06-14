<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>转换任务查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
	<input id="jobId" type="hidden" value="${jobInfo.id}"/>
	<div class="wrapper wrapper-content">	
		<!-- 任务信息 -->
		<div class="row">
			<div class="col-sm-12 ">
				<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
				   <tbody>
					  <tr>
						 <td class="width-15 active"><label class="pull-right">任务名称:</label></td>
						 <td class="width-20">${jobInfo.jobName}</td>
						 <td class="width-15 active"><label class="pull-right">任务描述:</label></td>
						 <td class="width-50">${jobInfo.jobDesc}</td>
					  </tr>
					</tbody>
				</table>			
			</div>
		</div>
		<div class="row">
		<div class="col-sm-12">
			<div class="pull-left">
				<table:addRow url="${ctx}/dc/dataProcess/transData/processForm?jobId=${jobInfo.id}" title="转换过程" label="新建转换过程" height="680px" width="800px"></table:addRow>
			</div>			
		</div>
		</div>
		<!-- 过程列表 -->
		<table id="processTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
			<thead>
				<tr>
					<th class="transName">序号</th>
					<th class="transName">转换过程</th>
					<th class="transDesc" width="30%">过程描述</th>
					<th class="transEngine">转换引擎</th>
					<th class="status">转换结果</th>
					<th class="sortNum">执行顺序</th>
					<th width="20%">操作</th>
				</tr>
			</thead>
		</table>
	</div>
	<script>
		var table;
		$(document).ready(function () {
			table = $('#processTable').DataTable({
				"processing": true,
				"serverSide" : true,
				"bPaginate" : true,// 分页按钮 
				"searching" : false, //禁用搜索
				"ordering": false, //禁用排序
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : false, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/dc/dataProcess/transData/processList?jobId="+$('#jobId').val(),
					"data" : function (d) {
						$.extend(d, {});
					},
					"dataSrc" : function (json) {//定义返回数据对象
						return JSON.parse(json.body.gson);
					}
				},
					"columns" : [
                        { "data" : null, "targets":0},
						{ "data" : "transName" },
						{ "data" : "transDesc" },
						{ "data" : "transEngine" },
						{ "data" : null },
						{ "data" : "sortNum" },
						{ "data" : null}
					],
					columnDefs : [{	                          
						"defaultContent": "",
						"targets": "_all"
					  },{
						targets : 6,	//第6列
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看过程\', \'${ctx}/dc/dataProcess/transData/processView?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看转换过程"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'编辑过程\', \'${ctx}/dc/dataProcess/transData/processForm?id='+a.id+'&jobId='+$('#jobId').val()+'\', \'800px\', \'680px\')" class="btn btn-success btn-xs" title="编辑转换过程"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a onclick="deleteA(\'${ctx}/dc/dataProcess/transData/processDelete?id='+a.id+'\',\'过程\') " class="btn btn-success btn-xs" title="删除转换过程"><i class="fa fa-trash"></i></a>&nbsp;';
							html+= '<a onclick="testProcess(\''+a.id+'\') " class="btn btn-success btn-xs" title="测试转换过程"><i class="fa fa-bug"></i></a>&nbsp;';
							html+= '<a onclick="openDialogView(\'查看转换过程日志\', \'${ctx}/dc/dataProcess/transLog/latestProLog?subId='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs" title="查看转换日志"><i class="fa fa-book"></i></a>';
						//	html+= '<a href="#" onclick="openDialogView(\'源数据预览\', \'${ctx}/dc/dataProcess/transData/previewData?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i> 源数据预览</a>&nbsp;';
						//	html+= '<a onclick="openDialogView(\'查看采集文件对象\', \'${ctx}/dc/dataProcess/hdfs/listHdfsFile?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i> 采集目录</a>&nbsp;';
							return html;
						}
					},{
                        targets : 4,
                        render : function (a, b) {
                            return a.status=='T'?'√':(a.status=='F'?'×':'-');
                        }
                    },{
                        targets : 0,
                        render : function (a, b) {
                            return a.status=='T'?'√':(a.status=='F'?'×':'-');
                        }
                    }],
					"fnDrawCallback":function(){	//给dataTable增加序号
						var api =this.api();
						var startIndex= api.context[0]._iDisplayStart;        //获取到本页开始的条数 　
						api.column(0).nodes().each(function(cell, i) {
							cell.innerHTML = startIndex + i + 1;
						});
					},
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
		
		//测试清洗过程
		function testProcess(processId){
			top.layer.load(1,{content:'<p class="loading_style">测试中，请稍候。</p>'});
			submitData('${ctx}/dc/dataProcess/transData/processTest', {'processId':processId}, function (data) {
				top.layer.closeAll('loading');
				//parent.document.table.ajax.reload();//访问不到table对象 
				top.layer.alert(data.msg, {
					title : '运行结果',
					area: ['680px', '340px']
				});
			});
		}
		
	</script>
</body>
</html>