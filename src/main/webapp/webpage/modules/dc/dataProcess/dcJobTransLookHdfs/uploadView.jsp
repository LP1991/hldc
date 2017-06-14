<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>上传</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(index){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			   setTimeout(function() {
					//新版改造  放入form中关闭
					top.layer.close(index)
				}, 100); 
			  return true;
		  }
	
		  return false;
		} 
/* 		function doSubmit(index,table,method){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			  if(validateForm.form()){
				  submitData( '${ctx}/dc/dataProcess/hdfsLook/uploadSave',getFormParams('inputForm'),function(data){
						var icon_number;
						if(!data.success){
							icon_number = 8;
						}else{
							icon_number = 1;
						}
						top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
						//刷新表格
						table.ajax.reload();
						//刷新树
						method.refreshAllTree();
						//关闭form面板
						top.layer.close(index)
					});
			  }
			} */
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
		<form:form id="inputForm" modelAttribute="dcHdfsFileLook" enctype="multipart/form-data" action="${ctx}/dc/dataProcess/hdfsLook/uploadSave" method="post" class="form-horizontal">
		<h4>当前路径：${dcHdfsFileLook.tempPath}</h4>
		<input type="hidden" value="${dcHdfsFileLook.tempPath}" name="tempPath"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		 	</tbody>
		 	 <tr>
				 <td align="right"><font color="red">*</font>文件上传：</td>
				      <td colspan="5">
				       	<input type="file" id="file1" multiple="multiple" name="uploadfiles"  style="outline:none;" required></td>
			 </tr>
		</table>
	</form:form>
</body>
</html>