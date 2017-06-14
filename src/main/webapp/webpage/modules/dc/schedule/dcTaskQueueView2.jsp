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
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
				<tbody>
					<tr>
						<td  class="width-15 active"><label class="pull-right">选择任务:</label></td>
						<td  class="width-35" >
						<p>${dcTaskQueueRef.task.taskName}</p>
						</td>
					</tr>
					<tr>
						<td  class="width-15 active"><label class="pull-right">任务描述:</label></td>
						<td  class="width-35" >
						<p>${dcTaskQueueRef.remarks}</p>
						</td>
					</tr>
					<tr>
						<td  class="width-15 active" ><label class="pull-right">前置任务:</label></td>
						<td  class="width-85" colspan="3">
							<p>${dcTaskQueueRef.preTask.remarks}</p>
						</td>
					</tr>
					<tr>
						<td  class="width-15 active" ><label class="pull-right">前置任务执行状态:</label></td>
						<td  class="width-85" colspan="3">
						<c:if test="${dcTaskQueueRef.preTaskStatus eq '1'}">
						<p>执行成功</p>
						</c:if>
						<c:if test="${dcTaskQueueRef.preTaskStatus eq '2'}">
						<p>执行失败</p>
						</c:if>
						</td>
					</tr>	
					<tr>
						<td  class="width-15 active" ><label class="pull-right">显示顺序:</label></td>
						<td  class="width-35" ><p>${dcTaskQueueRef.sortNum}</p>
						</td>
					</tr>
				</tbody>
			</table>
		</form:form>

	
</body>
</html>
