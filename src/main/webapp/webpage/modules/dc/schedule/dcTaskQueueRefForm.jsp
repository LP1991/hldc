<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>任务队列编辑</title>
	<meta name="decorator" content="default" />
	<script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
		<form:form id="refForm" modelAttribute="dcTaskQueueRef" action="" autocomplete="off" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<form:hidden path="queueId" value="${taskQueueId}"/>
			<sys:message content="${message}"/>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
				<tbody>
					<tr>
						<td  class="width-15 active"><label class="pull-right"><font color="red">*</font>选择任务:</label></td>
						<td  class="width-35" >
							<form:select path="taskId" class="form-control required" >
								<form:option value="">请选择</form:option>
								<form:options items="${taskList}" itemLabel="taskName" itemValue="id" htmlEscape="false"/>
							</form:select>
							<span class="help-inline">选择添加自定义任务</span>
						</td>
					</tr>
					<tr>
						<td  class="width-15 active"><label class="pull-right"><font color="red">*</font>任务描述:</label></td>
						<td  class="width-35" >
						<form:textarea path="remarks" rows="2" htmlEscape="false" maxlength="200" class="form-control required"/>
						</td>
					</tr>
					<tr>
						<td  class="width-15 active" ><label class="pull-right">前置任务:</label></td>
						<td  class="width-85" colspan="3">
							<form:select path="preTaskId" class="form-control" >
								<form:option value="">请选择</form:option>
								<form:options items="${preTaskList}" itemLabel="remarks" itemValue="id" htmlEscape="false"/>
							</form:select>
							<span class="help-inline">只有前置任务执行之后, 才能执行该任务</span>
						</td>
					</tr>
					<tr>
						<td  class="width-15 active" ><label class="pull-right">前置任务执行状态:</label></td>
						<td  class="width-85" colspan="3">
							<form:select path="preTaskStatus" class="form-control">
								<form:option value="0">请选择</form:option>
								<form:options items="${fns:getDictListLike('dc_taskqueue_prestatus')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							<span class="help-inline">前置任务执行状态符合该设置条件后, 才能执行该任务</span>
						</td>
					</tr>	
					<tr>
						<td  class="width-15 active" ><label class="pull-right">显示顺序:</label></td>
						<td  class="width-35" ><form:input path="sortNum" htmlEscape="false" maxlength="50" class="form-control isIntGtZero"/>
						</td>
					</tr>
				</tbody>
			</table>
		</form:form>

	<script>
		var validateForm;
		
		$(document).ready(function() {
			validateForm = $("#refForm").validate({
				rules: { 
				},
				messages: {
				},
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
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
			
			//绑定'选择任务'选择事件, 默认带入项目描述 
			$('#taskId').change(function(){ 
				if($('#remarks').val()){
					return;
				}
				var selectTask=$(this).children('option:selected').text();	//这就是selected的值
				if(selectTask){
					$('#remarks').val(selectTask);
				}
			})
		});
		
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index, table) {
			//判断任务是否已存在  存在则提示 TODO:
			
			if(validateForm.form()){
				submitData('${ctx}/dc/schedule/dcTaskQueue/saveTask', {
					'id':$('#id').val(),
					'queueId':$('#queueId').val(),
					'taskId': $('#taskId').val(),
					'remarks': $('#remarks').val(),
					'preTaskId': $('#preTaskId').val(),
					'sortNum': $('#sortNum').val(),
					'preTaskStatus': $('#preTaskStatus').val()
				}, function (data) {
					top.layer.alert(data.msg, {
						title : '系统提示'
					});
					//刷新表格
					table.ajax.reload();
					//关闭form面板
					top.layer.close(index)
				});
				return true;
			}
		}
	</script>
	
</body>
</html>
