<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>转换任务日志查看</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
	   <tbody>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">开始时间:</label></td>
	         <td class="width-20"><fmt:formatDate value='${taskLog.beginTime}' pattern='yyyy-MM-dd HH:mm:ss'/></td>
	         <td class="width-15 active"><label class="pull-right">结束时间:</label></td>
	         <td class="width-20"><fmt:formatDate value='${taskLog.endTime}' pattern='yyyy-MM-dd HH:mm:ss' /></td>
	         <td class="width-15 active"><label class="pull-right">处理结果:</label></td>
	         <td class="width-15 active">
				 <c:choose>
					<c:when test="${taskLog.status eq 'T'}">√</c:when>
					<c:when test="${taskLog.status eq 'F'}">×</c:when>
					<c:otherwise>-</c:otherwise>
				 </c:choose>
		  </tr>
		</tbody>
	</table>
	<label>&nbsp;&nbsp;日志明细: </label>
	<textarea class="form-control span12" style="height:480px; width:99%; margin:auto;" readonly="readonly" >${taskLog.remarks}</textarea>
	
</body>
</html>