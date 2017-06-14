<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>任务查看</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer" style="width: 96%;margin: 0 2%;">
		<tbody>
			<tr>
				<td  class="width-15 active"><label class="pull-right">任务名:</label></td>
				<td class="width-35">${dcTaskMain.taskName }</td>
			</tr>
			<tr>
				<td  class="width-15 active"><label class="pull-right">任务类型:</label></td>
				<td class="width-35">${fns:getDictLabel(dcTaskMain.taskType, 'dc_taskType', '')}</td>
			</tr>
			<tr>
				<td  class="width-15 active"><label class="pull-right">类名:</label></td>
				<td class="width-35">${dcTaskMain.className }</td>
			</tr>
			<tr>
				<td  class="width-15 active"><label class="pull-right">方法名:</label></td>
				<td class="width-35">${dcTaskMain.methodName }</td>
			</tr>	
			<tr>
				<td  class="width-15 active"><label class="pull-right">优先级:</label></td>
				<td class="width-35">${dcTaskMain.priority }</td>
			</tr>	
			 <tr>
				<td  class="width-15 active"><label class="pull-right">参数:</label></td>
				<td class="width-35">${dcTaskMain.parameter }</td>
			</tr>
			<c:if test="${dcTaskMain.taskType ne '1'}">
			<tr>
				<td  class="width-15 active"><label class="pull-right">上传文件名:</label></td>
				<td class="width-35">${dcTaskMain.fileName }</td>
			</tr>
			</c:if>
			<tr>
				<td  class="width-15  active"><label class="pull-right">任务描述:</label></td>
				<td class="width-35">${dcTaskMain.taskDesc }</td>
			</tr>
		</tbody>
	</table>
	</fieldset>
	<div class="tabs-container">
		<ul class="nav nav-tabs">
			<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">任务走向队列任务</a>
			</li>
			<li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">任务走向调度任务</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="tab-1" class="tab-pane active">
				<div class="panel-body">
					<table id="contentTable1" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" >
						<thead>
						<tr>
							<th class="queueName">队列名称</th>
							<th  class="taskName">任务名称</th>
							<th  class="preTaskStatus">任务状态</th>

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
							<th class="scheduleName">调度名称</th>
							<th class="status">操作状态</th>
							<th class="result">上次运行结果</th>

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
                    url: "${ctx}/dc/schedule/dcTaskQueue/getTaskRefList?taskId=${dcTaskMain.id}",
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
                        "data" :"queueName"
                    }, {
                        "data" : "task.taskName"
                    }, {
                        "data" : "preTaskStatus"

                    }
                ],
                columnDefs : [{
                    "defaultContent": "",
                    "targets": "_all"
                },{
                    targets : 2,
                    render : function (a, b) {
                        var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskqueue_prestatus'});
                        return html;
                    }
                },
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
                    url : "${ctx}/dc/schedule/dcTaskTime/ajaxlist?taskfromid=${dcTaskMain.id}",
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
                        "data" : "scheduleName"
                    }, {
                        "data" : "status"
                    }, {
                        "data" : "result"

                    }
                ],
                columnDefs : [{
                    "defaultContent": "",
                    "targets": "_all"
                },{targets :1,
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
                    }},{targets : 2,
                    render : function (a, b) {
                        var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskTimeFlag'});
                        return html;
                    }},
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