<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>任务队列编辑</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
</head>
<body>
<form:form id="inputForm" modelAttribute="dcTaskQueue" action="#" autocomplete="off" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
				<tr>
					<td  class="width-15 active"><label class="pull-right"><font color="red">*</font>队列名称:</label></td>
					<td  class="width-35"  colspan="3">
						<input id="oldJobName" name="oldJobName" type="hidden" value="${dcTaskQueue.queueName}">
						<form:input path="queueName" htmlEscape="false" maxlength="50" class="form-control required"/>
					</td>
					<%-- <td  class="width-15 active" ><label class="pull-right">优先级:</label></td>
					<td  class="width-35" ><form:input path="priority" htmlEscape="false"  maxlength="50" class="form-control isIntGtZero"/>
					<span class="help-inline">优先级为整数值, 数字越小, 级别越高</span>
					</td> --%>
				</tr>
				<tr>
					<td  class="width-15 active" ><label class="pull-right">队列描述:</label></td>
					<td  class="width-85" colspan="3"><form:textarea path="queueDesc" htmlEscape="false" maxlength="200" rows="2" class="form-control"/></td>
				</tr>	
			</tbody>
		</table>
	</form:form>
	
	<c:if test="${!empty dcTaskQueue.id}">
	<div class="wrapper wrapper-content" >
		<div class="row">
		<div class="col-sm-12">
			<div class="pull-left">
				<table:addRow url="${ctx}/dc/schedule/dcTaskQueue/editTask?queueId=${dcTaskQueue.id}" title="添加任务" label="添加任务" width="800px" height="480px" ></table:addRow><!-- 增加按钮 -->
			</div>		
		</div>
		</div>
		<table id="taskRefTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
			<thead>
				<tr>
					<th><input type="checkbox" class="i-checks"></th>
					<th  class="taskName">任务名称</th>
					<th  class="remarks">任务描述</th>
					<th  class="taskType">任务类型</th>
					<th  class="preTaskName">前置任务</th>
					<th  class="preTaskStatus">前置任务状态</th>
					<th  class="sortNum">显示顺序</th>
					<th>操作</th>
				</tr>
			</thead>
		</table>
	</div>
	</c:if>
	
	<script type="text/javascript">
	//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
	function doSubmit(index, table) {
		
		setTimeout(function(){
			if(validateForm.form()){
				top.layer.load(1,{content:'<p class="loading_style">保存中，请稍候。</p>'});
				submitData('${ctx}/dc/schedule/dcTaskQueue/ajaxSave', getFormParams('inputForm'), function (data) {
					top.layer.closeAll('loading');
					top.layer.alert(data.msg, {
						title : '系统提示'
					});
					
					if(data.success!==true){
						return;
					}else{
						//刷新表格
						table.ajax.reload();
						//关闭form面板
						top.layer.close(index)
					}
				});
				return true;
			}
		},1000);
	}
	
	//运行任务
	function runQueueTask(taskId){
		//console.log('--->'+taskId);
		/**  **/
		var loading = layer.load();
		submitData('${ctx}/dc/schedule/dcTaskQueue/runQueueTask', {'taskId':taskId}, function (data) {
			layer.close(loading);
			top.layer.alert(data.msg, {
				title : '运行结果',
				area: ['680px', '340px']
			});
		});
	}
	
	//删除任务
	
	
	var table;
	$(document).ready(function () {
		//console.log('${dcTaskQueue.id}');
		validateForm = $("#inputForm").validate({
			rules: {
				labelName: {remote: "${ctx}/dc/schedule/dcTaskQueue/checkJobName?oldJobName=" + encodeURIComponent('${dcTaskQueue.queueName}')}//设置了远程验证，在初始化时必须预先调用一次。
			},
			messages: {
				labelName: {remote: "任务队列已存在 "}
			},
			submitHandler: function(form){
			},
			errorContainer: "#messageBox",
			errorPlacement: function(error, element) {
				$("#messageBox").text("输入有误，请先更正。");
				if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
					error.appendTo(element.parent().parent());
				} else {
					error.insertAfter(element);
				}
			}
		});
		if('${!empty dcTaskQueue.id}'){
			//初始化列表
			table = $('#taskRefTable').DataTable({
				"processing": true,
				"serverSide" : true,
				"bPaginate" : true,// 分页按钮 
				"searching" : false, //禁用搜索
				"ordering": false, //禁用排序
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : true, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/dc/schedule/dcTaskQueue/getTaskRefList?queueId="+$('#id').val(),
					"data" : function (d) {
						$.extend(d, {});
					},
					"dataSrc" : function (json) {//定义返回数据对象
						return JSON.parse(json.body.gson);
					}
				},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, {
						"data" : "task.taskName"
					}, {
						"data" : "remarks"
					}, {
						"data" : "task.taskType"
					}, {
						"data" : "preTask.remarks"
					}, {
						"data" : "preTaskStatus"
					}, {
						"data" : "sortNum"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
					"defaultContent": "",
					"targets": "_all"
				  },{
					targets : 7,
					render : function (a, b) {	//console.dir(a);
						var html = '<a href="#" onclick="openDialogView(\'查看任务\', \'${ctx}/dc/schedule/dcTaskQueue/viewTask?queueId=${dcTaskQueue.id}&id='+a.id+'\',\'800px\', \'480px\')" class="btn btn-success btn-xs" title="查看任务"><i class="fa fa-search-plus"></i></a>&nbsp;';
						html+= '<a href="#" onclick="openDialog(\'编辑任务\', \'${ctx}/dc/schedule/dcTaskQueue/editTask?queueId=${dcTaskQueue.id}&id='+a.id+'\', \'800px\', \'480px\')" class="btn btn-success btn-xs" title="编辑任务"><i class="fa fa-edit"></i></a>&nbsp;';
						html+= '<a onclick="deleteA(\'${ctx}/dc/schedule/dcTaskQueue/deleteTask?task.id='+a.task.id+'&id='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="删除任务"><i class="fa fa-trash"></i></a>&nbsp;';
						html+= '<a onclick="runQueueTask(\''+a.task.id+'\') " class="btn btn-success btn-xs" title="测试任务"><i class="fa fa-bug"></i></a>&nbsp;';
						return html;
					}
				},{
					targets : 3,
					render : function (a, b) {
						var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskType'});
						return html;
					}
				},{
					targets : 5,
					render : function (a, b) {
						var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a,type:'dc_taskqueue_prestatus'});
						return html;
					}
				}],
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
		}
	});	
	</script>
</body>

</html>