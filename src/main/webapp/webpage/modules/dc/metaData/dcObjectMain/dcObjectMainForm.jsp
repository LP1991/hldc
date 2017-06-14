<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据对象管理</title>
	<meta name="decorator" content="default"/>
	
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
    <!--表单向导所需-->
    <link href="${ctxStatic}/jquery-steps/css/jquery.steps.css" rel="stylesheet">
    <script src="${ctxStatic}/jquery-steps/js/jquery.steps.min.js"></script>
    <!--表单向导中包含验证所需-->
    <script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/jquery.validate.min.js"></script>
    <script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/localization/messages_zh.min.js"></script>
	
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<!--
	<div id="inputForm">
		<h3>Keyboard</h3>
		<section>
			<p>Try the keyboard navigation by clicking arrow left or right!</p>
		</section>
		<h3>Effects</h3>
		<section>
			<p>Wonderful transition effects.</p>
		</section>
		<h3>Pager</h3>
		<section>
			<p>The next and previous buttons help you to navigate through your content.</p>
		</section>
	</div>
	
	<form id="inputForm" action="#">
		<h3>数据对象</h3>
		<fieldset>
			<legend>Account Information</legend>

			<label for="userName-2">User name *</label>
			<input id="userName-2" name="userName" type="text" class="required">
			<label for="password-2">Password *</label>
			<input id="password-2" name="password" type="text" class="required">
			<label for="confirm-2">Confirm Password *</label>
			<input id="confirm-2" name="confirm" type="text" class="required">
			<p>(*) Mandatory</p>
		</fieldset>

		<h3>数据源</h3>
		<fieldset>
			<legend>Profile Information</legend>

			<label for="name-2">First name *</label>
			<input id="name-2" name="name" type="text" class="required">
			<label for="surname-2">Last name *</label>
			<input id="surname-2" name="surname" type="text" class="required">
			<label for="email-2">Email *</label>
			<input id="email-2" name="email" type="text" class="required email">
			<label for="address-2">Address</label>
			<input id="address-2" name="address" type="text">
			<label for="age-2">Age (The warning step will show up if age is less than 18) *</label>
			<input id="age-2" name="age" type="text" class="required number">
			<p>(*) Mandatory</p>
		</fieldset>

		<h3>数据预览</h3>
		<fieldset>
			<legend>You are to young</legend>

			<p>Please go away ;-)</p>
		</fieldset>

		<h3>存储路径</h3>
		<fieldset>
			<legend>Terms and Conditions</legend>

			<input id="acceptTerms-2" name="acceptTerms" type="checkbox" class="required"> <label for="acceptTerms-2">I agree with the Terms and Conditions.</label>
		</fieldset>
	</form>
	-->
	
	<form:form id="inputForm" modelAttribute="objectMain" autocomplete="off" action="#" method="post" class="form-horizontal" > 
		<form:hidden path="id"/>
		<h3>创建数据对象</h3>
		<fieldset>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active"><label class="pull-right"><font color="red">*</font>对象名称：</label></td>
					 <td class="width-35"> 
						<form:input path="objName" htmlEscape="false" maxlength="50" class="form-control required"/>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>对象编码：</label></td>
					 <td class="width-35"> 
						<form:input path="objCode" htmlEscape="false" maxlength="50" class="form-control"/>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>对象类型：</label></td>
					 <td class="width-35">
						<form:select path="objType" class="form-control required">
							<form:option value="" label="请选择"/>
							<form:options items="${fns:getDictListLike('dc_dataobj_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					 </td>
				  </tr>
				  <tr>
					<td class="width-15 active"><label class="pull-right">对象描述：</label></td>
					<td class="width-35">
						<form:input path="objDesc" htmlEscape="false" class="form-control"/>
					</td>
				  </tr>
				  <tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>业务部门：</label></td>
					<td class="width-35">
						<form:input path="managerOrg" htmlEscape="false" class="form-control required"/>
					</td>
				  </tr>
				  <tr>
					<td class="width-15 active"><label class="pull-right">业务负责人：</label></td>
					<td class="width-35">
						<form:input path="managerPer" htmlEscape="false" class="form-control "/>
					</td>
				  </tr>
				</tbody>
			</table>
		</fieldset>

		<h3>设置数据源</h3>
		<fieldset>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active"><label class="pull-right"><font color="red">*</font>数据源连接：</label></td>
					 <td class="width-35" > 
						<form:select path="tableLink" class="form-control required" style="width: 300px;">
							<form:option value="">请选择</form:option>
							<form:options items="${dataSourceList}" itemLabel="connName" itemValue="id" htmlEscape="false"/>
						</form:select>
						<a href="#" onclick="createDBLink()" class="btn btn-info btn-xs" ><i class="fa fa-database"></i> 创建数据源</a>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>数据表名称：</label></td>
					 <td class="width-35"> 
						<form:input path="tableName" htmlEscape="false" maxlength="50" class="form-control" style="width: 500px;"/>
						<a href="#" onclick="queryTable()" class="btn btn-info btn-xs" ><i class="fa fa-database"></i> 选择数据表</a>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>更新方式：</label></td>
					 <td class="width-35">
						<form:select path="storeType" class="form-control required">
							<form:option value="1" label="全量更新"/>
							<form:option value="2" label="增量更新"/>
						</form:select>
					 </td>
				  </tr>
				  <tr>
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35">
						<form:input path="tableRemarks" htmlEscape="false" class="form-control"/>
					</td>
				  </tr>
				</tbody>
			</table>
		</fieldset>

		<h3>设置存储路径</h3>
		<fieldset>
			<label for="path-2">存储路径</label>
			<input id="storePath" name="storePath" type="text" >
		</fieldset>
		
		<h3>预览数据</h3>
		<fieldset>
			<p>Please go away ;-)</p>
		</fieldset>
	</form:form>
	
	<script>
	
		$(document).ready(function(){
			
		});
		
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index, table) {
			submitData('${ctx}/dc/metadata/dcObjectMain/ajaxSave', getFormParams('inputForm'), function (data) {
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
		
		//新建数据源连接  TODO
		function createDBLink(){
			
		}
		
		//选择数据表	TODO
		function queryTable(){
			
		}
		//设置当前页 IndexId
		function setPIndexId(val){
			index=val;
		}
		var index;
		var form = $("#inputForm").show();
		form.steps({
			headerTag : "h3",
			bodyTag : "fieldset",
			transitionEffect : "slideLeft",
			//enableCancelButton: false,
			onStepChanging : function (event, currentIndex, newIndex) {
				console.log(arguments);
				if (currentIndex > newIndex) {
					return true;
				}
				if (currentIndex < newIndex) {
					form.find(".body:eq(" + newIndex + ") label.error").remove();
					form.find(".body:eq(" + newIndex + ") .error").removeClass("error");
				}
				form.validate().settings.ignore = ":disabled,:hidden";
				return form.valid();
			},
			onStepChanged : function (event, currentIndex, priorIndex) {
				console.log("onStepChanged!");
			},
			onCanceled: function (event) { 
				console.log(11);
				top.layer.close(index);
			},
			onFinishing : function (event, currentIndex) {
				console.log("onFinishing!");
				form.validate().settings.ignore = ":disabled";
				return form.valid();
			},
			onFinished : function (event, currentIndex) {
					//刷新表格
					window.parent.searchA();
					//parent.document.table.ajax.reload();
					//关闭form面板
					 top.layer.close(1);
					//top.layer.closeAll();
					//window.close();
				// submitData('${ctx}/dc/metadata/dcObjectMain/ajaxSave', getFormParams('inputForm'), function (data) {
					// top.layer.alert(data.msg, {
						// title : '系统提示'
					// });
				// });
			}
		});
	</script>
</body>
</html>