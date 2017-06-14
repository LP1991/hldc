<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>转换任务日志查看</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr><th>序号</th><th>变量名</th><th>描述</th><th>当前变量值</th><th>使用方法</th></tr>
		</thead>
		<c:forEach items="${paramList}" var="pa" varStatus="idx">
			<tr>
				<td style="width:50px;">${idx.index+1}</td>
				<td>${pa.paramName}</td>
				<td>${pa.paramDesc}</td>
				<td>${pa.paramValue}</td>
				<td>${pa.paramUsage}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>

	<script>
	</script>
</body>
</html>