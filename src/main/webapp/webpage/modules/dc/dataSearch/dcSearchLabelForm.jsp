<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>源数据分类-表单</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	var validateForm;
	function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
	  if(validateForm.form()){
		  $("#inputForm").submit();
		  return true;
	  }
	  return false;
	}
	
	$(document).ready(function() {
		$("#no").focus();
		validateForm = $("#inputForm").validate({
			rules: {
				labelName: {remote: "${ctx}/dc/dataSearch/dcSearchLabel/checkLabelName?oldLabelName=" + encodeURIComponent('${dcSearchLabel.labelName}')}//设置了远程验证，在初始化时必须预先调用一次。
			},
			messages: {
				labelName: {remote: "标签名称已存在"}
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
		$("#inputForm").validate().element($("#labelName"))
	});
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="dcSearchLabel" action="${ctx}/dc/dataSearch/dcSearchLabel/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		      <tr>
		       <td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>标签名称:</label></td>
					<td  class="width-35" ><input id="oldLabelName" name="oldLabelName" type="hidden" value="${dcSearchLabel.labelName}">
					<form:input path="labelName" htmlEscape="false" maxlength="50" class="form-control required"/></td>
				</tr>
				<tr>
				<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>标签描述:</label></td>
					<td  class="width-35" ><form:input path="labelDesc" htmlEscape="false" maxlength="50" class="form-control required"/></td>
			</tr>		
			<tr>		
				<td  class="width-15 active"  class="active"><label class="pull-right">备注:</label></td>
					<td  class="width-35" ><form:input path="remarks" htmlEscape="false" maxlength="50" class="form-control "/></td>
			</tr>
		    </tbody>
		  </table>
	</form:form>
</body>
</html>