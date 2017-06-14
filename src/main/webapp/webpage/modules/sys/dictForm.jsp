<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>字典管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(index,table){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			if(validateForm.form()){
				  submitData( '${ctx}/sys/dict/saveA',getFormParams('inputForm'),function(data){
					  var icon_number;
						if(!data.success){
							icon_number = 8;
						}else{
							icon_number = 1;
						}
						top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
					  if(data.success){
						//刷新表格
						table.ajax.reload();
						//关闭form面板
						top.layer.close(index);
					  }
					});
				
			  }
			 
		}
		$(document).ready(function() {
			$("#value").focus();
			 validateForm = $("#inputForm").validate({
				 rules: {
				     value: {remote: "${ctx}/sys/dict/checkValue?parentId="+encodeURIComponent("${dict.parentId}")+"&oldValue=" + encodeURIComponent("${dict.value}")},//设置远程检验
					label: {remote: "${ctx}/sys/dict/checkLabel?parentId="+encodeURIComponent("${dict.parentId}")+"&oldLabel=" + encodeURIComponent("${dict.label}")}
					},
					messages: {
						value: {remote: "键值已存在"},
					  label: {remote:"标签已存在"}
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
			 //$("#inputForm").validate().element($("#label"));
		         
		});
		function setPId (val){
			$('#parent_id').val( val);
			$('#parentid').val( val);
		}
	</script>
</head>
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="dict" method="post" class="form-horizontal" style="margin:0;">
		<form:hidden path="id"/>
		<input type="hidden" id="parentId" name="parentId"/>
		<input type="hidden" id="parent_id" name="parent.id" value="${dict.parentId}"/>
		<input type="hidden" id="type" name="type"/>
		<input type="hidden" id="flag" name="flag"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
		   <tbody>
		      <tr id="ser">
		         <td  class="width-15 active">	<label class="pull-right"><font color="red">*</font>键值:</label></td>
		         <td class="width-35" ><form:input id="value" path="value" htmlEscape="false" maxlength="50" class="form-control required"/></td>
		         <td  class="width-15 active">	<label class="pull-right"><font color="red">*</font>标签:</label></td>
		          <td  class="width-35" ><form:input id="label" path="label" htmlEscape="false" maxlength="50" class="form-control required"/></td>
		      </tr>
		       <tr>
		        <%--  <td  class="width-15 active">	<label class="pull-right">类型:</label></td>
		         <td class="width-35" ><form:input disabled="true" path="type" id="type" htmlEscape="false" maxlength="50" class="form-control required abc"/></td> --%>
		        <td  class="width-15 active">	<label class="pull-right">备注:</label></td>
		          <td  class="width-35" ><form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="form-control "/></td>
		      <td  class="width-15 active">	<label class="pull-right"><font color="red">*</font>排序:</label></td>
		         <td class="width-35" ><form:input path="sort" htmlEscape="false" maxlength="11" class="form-control required digits"/></td>
		         
		      </tr>
		       <tr>
		         </tr>
		   </tbody>
		   </table>   
	</form:form>
</body>
</html>