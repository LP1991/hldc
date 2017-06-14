<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据源设置</title>
	<meta name="decorator" content="default"/>
	<!-- 表单验证js -->
	<script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
	<script src="${ctxStatic}/dc/js/des.js"></script>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
              $('#pswd').val('XXXXXX');
			  $("#inputForm").submit();
			  return true;
		  }
	
		  return false;
		}
		
		//数据库连接测试 
		function testDB(){
		    var param = getFormParams('inputForm');
            param.pswd='XXXXXX';
			submitData('${ctx}/dc/metadata/dcDataSource/testDataSource', param, function (data) {
				top.layer.alert(data.msg, {
					title : '系统提示'
				});
			});
		}

		$(document).ready(function() {
			$("#connName").focus();
			//还原密码
			$("#pswd").val(strDec('${dcDataSource.serverPswd}'));
			validateForm = $("#inputForm").validate({
				rules: {
					connName: {remote: "${ctx}/dc/metadata/dcDataSource/checkConnName?oldConnName=" + encodeURIComponent('${dcDataSource.connName}')}//设置了远程验证，在初始化时必须预先调用一次。
				},
				messages: {
					connName: {remote: "任务名已存在"},
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
		<form:form id="inputForm" modelAttribute="dcDataSource" style="margin:0;" action="${ctx}/dc/metadata/dcDataSource/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
		   <tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>数据源名称：</label></td>
					<td class="width-35">
						<input id="oldConnName" name="oldConnName" type="hidden" value="${dcDataSource.connName}">
						<form:input path="connName" htmlEscape="false" class="form-control required "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">数据源描述：</label></td>
					<td class="width-35">
						<form:textarea path="connDesc" htmlEscape="false" rows="2" class="form-control "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>数据源类型：</label></td>
					<td class="width-35">
						<form:select path="serverType" class="form-control required">
							<form:option value="" label="请选择"/>
							<form:options items="${fns:getDictListLike('dc_datasource_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>数据库IP：</label></td>
					<td class="width-35">
						<form:input path="serverIP" htmlEscape="false" class="form-control required ip"/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>数据库端口：</label></td>
					<td class="width-35">
						<form:input path="serverPort" htmlEscape="false" class="form-control isDigitsNumber required "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>数据库连接名：</label></td>
					<td class="width-35">
						<form:input path="serverName" htmlEscape="false" class="form-control required "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>用户名：</label></td>
					<td class="width-35">
						<form:input path="serverUser" htmlEscape="false" class="form-control required"/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>密码：</label></td>
					<td class="width-35"><form:hidden path="serverPswd"/>
						<!--  <td><input id="serverPswd" name="serverPswd" type="password" value="" maxlength="50" minlength="3" class="form-control ${empty user.id?'required':''}"/> -->
						<input id="pswd" name="pswd" type="password" htmlEscape="false" class="form-control required" style="width: 550px;" onchange="des(this.value, 'serverPswd')"/>
						<a href="#" onclick="testDB()" class="btn btn-info btn-xs" ><i class="fa fa-bug"></i> 测试</a>
					</td>
				</tr>
		 	</tbody>
		</table>
	</form:form>
</body>
</html>