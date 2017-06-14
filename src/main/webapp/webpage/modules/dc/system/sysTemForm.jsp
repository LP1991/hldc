<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/webuploader-0.1.5/webuploader.css">
	<script type="text/javascript" src="${ctxStatic}/webuploader-0.1.5/webuploader.js"></script>
	<script type="text/javascript">
	//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
	function doSubmit(index, table) {
		setTimeout(function(){//TODO待后期优化
		if(validateForm.form()){
		submitData('${ctx}//dc/system/systems/saveA', getFormParams('inputForm'), function (data) {
			top.layer.alert(data.msg, {
				title : '系统提示'
			});
			//刷新表格
			table.ajax.reload();
			//关闭form面板
			top.layer.close(index)
		});
		return true;
		}
		},1000);
	}
	
	$(document).ready(function() {
		$("#no").focus();
		validateForm = $("#inputForm").validate({
			
			rules: {
				labelName: {remote: "${ctx}/dc/schedule/dcTaskMain/checkTaskName?oldTaskName=" + encodeURIComponent('${dcTaskMain.taskName}')}//设置了远程验证，在初始化时必须预先调用一次。
			},
			messages: {
				labelName: {remote: "调度任务已存在 "}
			},
			submitHandler: function(form){
				if ($("input[name='taskType']").filter(':checked').val() != "1"
					&& ($("#filePath").val()==null
						|| $("#filePath").val()=="")) {
					$("#filePatherror").show();
					return false;
				} else {
					$("#filePatherror").hide();
				}
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
<form:form id="inputForm" modelAttribute="systems" action="#" autocomplete="off" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
				
				<tr>
				
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>系统编号:</label></td>
					<td  class="width-35" ><form:input path="number" htmlEscape="false" maxlength="200%" class="form-control required"/></td>
		              </tr>
		              <tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>系统名称:</label></td>
					<td  class="width-35" ><form:input path="name" htmlEscape="false" maxlength="200" class="form-control required"/></td>
			
				</tr>	
				<tr>
					<td  class="width-1500"  class="active"><label class="pull-right"><font color="red"></font>系统首页:</label></td>
					<td  class="width-350%" ><form:input path="bewrite" htmlEscape="false" maxlength="2000" class="form-control"/></td>
					
					
				</tr>
				<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font ont color="red"></font>系统描述:</label></td>
					<td  class="width-55" ><form:textarea path="homes" htmlEscape="false" rows="4" class="form-control"/></td>
				</tr>
				<tr>
					<<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>负责单位:</label></td>
					<td  class="width-35" ><form:input path="per" htmlEscape="pre" maxlength="200" class="form-control "/></td>
					</tr>
					<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>单位负责人:</label></td>
					<td  class="width-35" ><form:input path="pers" htmlEscape="false" maxlength="200" class="form-control "/></td>
				</tr>
				
					<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>联系方式:</label></td>
					<td  class="width-35" ><form:input path="contact" htmlEscape="false" maxlength="200" class="form-control "/></td>
				</tr>
					<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>负责厂商:</label></td>
					<td  class="width-35" ><form:input path="manuf" htmlEscape="false" maxlength="200" class="form-control "/></td>
				</tr>
				<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>厂商负责人:</label></td>
					<td  class="width-35" ><form:input path="manufs" htmlEscape="false" maxlength="200" class="form-control "/></td>
				</tr>
				<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>联系电话:</label></td>
					<td  class="width-35" ><form:input path="contacts" htmlEscape="false" maxlength="200" class="form-control "/></td>
				</tr>
			
			</tbody>
		</table>
	</form:form>
</body>


</html>