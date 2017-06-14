<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据转换设计</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td  class="width-15 active"><label class="pull-right">转换名称:</label></td>
				<td  class="width-35" >${design.designName }</td>
			</tr>
			<tr>
				<td  class="width-15 active"><label class="pull-right">转换描述:</label></td>
				<td  class="width-35" >${design.designDesc }</td>
			</tr>
		</tbody>
	</table>
</body>
</html>