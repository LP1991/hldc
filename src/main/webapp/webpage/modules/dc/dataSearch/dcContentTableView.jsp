<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>搜索分类</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="dcContentTable" action="${ctx}/dc/dataSearch/dcContentTable/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		      <tr>
		       <td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>分类项目:</label></td>
					<td  class="width-35" >${dcContentTable.itemName}</td>
				<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>分类编码:</label></td>
					<td  class="width-35" >${dcContentTable.itemCode}</td>
			</tr>		
			<tr>		
				<td  class="width-15 active"  class="active"><label class="pull-right">备注:</label></td>
					<td  class="width-35" >${dcContentTable.remarks}</td>
			</tr>
		    </tbody>
		  </table>
	</form:form>
</body>
</html>