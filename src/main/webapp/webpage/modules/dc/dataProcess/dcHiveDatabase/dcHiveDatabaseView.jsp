<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>表空间管理</title>
	<meta name="decorator" content="default"/>
</head>
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="dcHiveDatabase" action="${ctx}/dc/dataProcess/dcHiveDatabase/save" method="post" class="form-horizontal" style="margin:0;">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered change_table_margin table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		      <tr>
		      <c:if test="${empty dcHiveDatabase.database}">
		         <td  class="width-15 active"><label class="pull-right">表空间名称:</label></td>
		         <td  class="width-35" >${dcHiveDatabase.database}
		         <span class="help-inline">表空间创建后不可修改</span></td>
		         </c:if>
		         <c:if test="${not empty dcHiveDatabase.database}">
		         <td  class="width-15 active"><label class="pull-right">表空间:</label></td>
		         <td  class="width-35" >${dcHiveDatabase.database}
		         <span class="help-inline">表空间创建后不可修改</span></td>
		         </c:if>
		         <td  class="width-15 active"><label class="pull-right">备注:</label></td>
		         <td class="width-35" >${dcHiveDatabase.remarks}</td>
		</tbody>
		</table>
	</form:form>
</body>
</html>