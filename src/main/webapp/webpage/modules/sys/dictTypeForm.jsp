<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>字典管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(index,table,method){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
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
					method.refreshTree();
					//关闭form面板
					top.layer.close(index);
				  }
				});
		  }
		  return false;
		}
		$(document).ready(function() {
			$("#value").focus();
			 validateForm = $("#inputForm").validate({
                 rules: {
                     label: {remote: "${ctx}/sys/dict/Labelval?oldLabel=" + encodeURIComponent("${dict.label}")}
                 },
                 messages: {
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
		});
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="dict" action="${ctx}/sys/dict/save" method="post" class="form-horizontal" style="margin:0;">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<input type="hidden"  name="parent.id" value="0"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
		   <tbody>
		      <tr>
				  <td  class="width-15 active">	<label class="pull-right"><font color="red">*</font>标签:</label></td>
				  <td  class="width-35" ><form:input  id="value" path="label" htmlEscape="false" maxlength="50" class="form-control required"/></td>
		          <td  class="width-15 active">	<label class="pull-right"><font color="red">*</font>类型:</label></td>
		         <td class="width-35" ><form:input path="type" htmlEscape="false" maxlength="50" class="form-control required abc"/></td>
		      </tr>
		       <tr>
		        
		       		<td  class="width-15 active">	<label class="pull-right">备注:</label></td>
		          <td  class="width-35" ><form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="form-control "/></td>
		    	<td  class="width-15 active">	</td>
		          <td  class="width-35" ></td> </tr>
		       <tr>
		         </tr>
		   </tbody>
		   </table>   
	</form:form>
</body>
</html>