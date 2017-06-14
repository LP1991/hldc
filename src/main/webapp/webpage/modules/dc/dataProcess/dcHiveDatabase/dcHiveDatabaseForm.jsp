<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>表空间管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(index,table,method){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  //$("#inputForm").submit();
			  //$('#parent_id').val( window.areaContent.document.getElementById("parent_id").value );
			  submitData( '${ctx}/dc/dataProcess/dcHiveDatabase/saveA',getFormParams('inputForm'),function(data){
				  	var icon_number;
					if(!data.success){
						icon_number = 8;
					}else{
						icon_number = 1;
					}
					top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
					if(data.success!==true){
						return;
					}else{
						//刷新表格
						table.ajax.reload();
						//刷新树
						method.refreshAllTree();
						//关闭form面板
						top.layer.close(index)
					}
				});
			}
		}
		$(document).ready(function() {
			$("#name").focus();
			validateForm = $("#inputForm").validate({
				rules: {
					database: {remote: "${ctx}/dc/dataProcess/dcHiveDatabase/checkDatabase" }
				},
				messages: {
					database: {remote: "表空间名称书写不规范,首字符不能为数字,且不允许输入汉字"}
				},
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
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="dcHiveDatabase" action="${ctx}/dc/dataProcess/dcHiveDatabase/save" method="post" class="form-horizontal" style="margin:0;">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
		   <tbody>
		      <tr>
		      <c:if test="${empty dcHiveDatabase.database}">
		         <td  class="width-15 active"><label class="pull-right"><font color="red">*</font>表空间名称:</label></td>
		         <td  class="width-35" ><form:input path="database" htmlEscape="false" maxlength="50" class="form-control required"/>
		         <span class="help-inline">表空间创建后不可修改</span></td>
		         </c:if>
		         <c:if test="${not empty dcHiveDatabase.database}">
		         <td  class="width-15 active"><label class="pull-right"><font color="red">*</font>表空间名称:</label></td>
		         <td  class="width-35" ><form:input path="database" htmlEscape="false" maxlength="50" class="form-control required" readonly="true"/>
		         <span class="help-inline">表空间创建后不可修改</span></td>
		         </c:if>
		         <td  class="width-15 active"><label class="pull-right">备注:</label></td>
		         <td class="width-35" ><form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="form-control"/></td>
		</tbody>
		</table>
	</form:form>
</body>
</html>