<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>重命名</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(index){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			   setTimeout(function() {
					//新版改造  放入form中关闭
					top.layer.close(index);
				}, 100); 
			  return true;
		  }
	
		  return false;
		}
		$(document).ready(function() {
			validateForm = $("#inputForm").validate({
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
			
		});
	</script>
</head>
<body>
	<!-- 创建文件夹和文件 -->
	<c:if test="${isShow eq '1'}">
	<form:form id="inputForm" modelAttribute="dcHdfsFileLook" enctype="multipart/form-data" action="${ctx}/dc/dataProcess/hdfsLook/NewDirOrFile" method="post" class="form-horizontal">
		<input type="hidden" value="${dcHdfsFileLook.tempPath}" name="tempPath"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		 	</tbody>
		 	 <tr>
		 	 <c:if test="${fileordir eq '1'}">
				 <td align="right"><font color="red">*</font>文件夹名：</td>
				      <td colspan="5">
				     	<input type="hidden" name="isDir2" value="true"/>
				       	<input type="text" name="folderName" required></td>
			 </c:if>
			 <c:if test="${fileordir eq '0'}">
			  <td align="right"><font color="red">*</font>文件名：</td>
				      <td colspan="5">
				      <input type="hidden" name="isDir2" value="false"/>
				       	<input type="text" name="folderName"  required></td>
				       		<td><textarea name="Content"></textarea></td>
			 </c:if>
			 </tr>
		</table>
	</form:form>
	</c:if>
	<!-- 重命名 -->
	<c:if test="${isShow eq '0'}">
		<form:form id="inputForm" modelAttribute="dcHdfsFileLook" enctype="multipart/form-data" action="${ctx}/dc/dataProcess/hdfsLook/save" method="post" class="form-horizontal">
		<input type="hidden" name="oldName" value="${dcHdfsFileLook.pathName}">
		<input type="hidden" name="pathName" value="${dcHdfsFileLook.pathName}">
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		 	</tbody>
			 <tr>
				 <td align="right">New Name：</td>
				      <td colspan="5">
				       	<form:input path="folderName" htmlEscape="false" rows="3" maxlength="200" class="form-control"/></td>
			 </tr>
		</table>
	</form:form>
	</c:if>
</body>
</html>