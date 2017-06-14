<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>分类目录</title>
	<meta name="decorator" content="default"/>
	
</head>
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="dcSearchContent" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" id="parent_id" name="parent.id"/>
		<input type="hidden" id="cataItemId" name="cataItemId" value="${dcSearchContent.cataItemId}"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		      <tr>
		         <td  class="width-15 active"><label class="pull-right">分类项目:</label></td>
		         <td  class="width-35" >${dcSearchContent.cataName}</td>
		          <td  class="width-15 active"><label class="pull-right">分类编码:</label></td>
		         <td class="width-35" >${dcSearchContent.cataCode}</td>
		      </tr>
		      <tr>
				 <td  class="width-15 active"><label class="pull-right">备注:</label></td>
		         <td class="width-35" >${dcSearchContent.remarks}</td>
		      </tr>
			<!--   <tr>
		        
		         <td  class="width-15 active"><label class="pull-right"></label></td>
		         <td  class="width-35" ></td>
		      </tr> -->
		</tbody>
		</table>
	</form:form>
</body>
</html>