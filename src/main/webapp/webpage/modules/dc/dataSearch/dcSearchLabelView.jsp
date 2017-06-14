<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>搜索标签</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="dcSearchLabel" action="${ctx}/dc/dataSearch/dcSearchLabel/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		      <tr>
		       <td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>标签名称:</label></td>
					<td  class="width-35" >${dcSearchLabel.labelName}</td>
				<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>标签描述:</label></td>
					<td  class="width-35" >${dcSearchLabel.labelDesc}</td>
			</tr>		
			<tr>		
				<td  class="width-15 active"  class="active"><label class="pull-right">备注:</label></td>
					<td  class="width-35" >${dcSearchLabel.remarks}</td>
			</tr>
		    </tbody>
		  </table>
	</form:form>
</body>
</html>