<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>源数据分类-修改分类</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	var validateForm;
	function doSubmit(index,table){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		
		  if(validateForm.form()){
			  top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>'});
				  submitData( '${ctx}/dc/dataSearch/dcContentTable/ajaxSave',getFormParams('inputForm'),function(data){
					  top.layer.closeAll('loading');
					  var icon_number;
						if(!data.success){
							icon_number = 8;
						}else{
							icon_number = 1;
						}

						top.layer.closeAll('loading');
						top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
						
						//刷新表格
						table.ajax.reload();
						//关闭form面板
						top.layer.close(index);
						
					});
			  
		  }
		 
	}
	$(document).ready(function() {
		validateForm = $("#inputForm").validate({
			rules: {
					itemName: {remote: "${ctx}/dc/dataSearch/dcContentTable/checkItemName?oldItemName=" + encodeURIComponent('${dcContentTable.itemName}')},//设置了远程验证，在初始化时必须预先调用一次。
					itemCode: {remote: "${ctx}/dc/dataSearch/dcContentTable/checkCodeName?oldItemCode=" + encodeURIComponent('${dcContentTable.itemCode}')}//设置了远程验证，在初始化时必须预先调用一次。
			},
			messages: {
					itemName: {remote: "分类项目已存在"},
					itemCode: {remote: "分类编码已存在"},
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
	<form:form id="inputForm" modelAttribute="dcContentTable" action="${ctx}/dc/dataSearch/dcContentTable/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		      <tr>
		       <td  class="width-15 active"><label class="pull-right"><font color="red">*</font>分类项目:</label></td>
					<td  class="width-35" ><form:input path="itemName" htmlEscape="false" maxlength="50" class="form-control required"/></td>
				<td  class="width-15 active"><label class="pull-right"><font color="red">*</font>分类编码:</label></td>
					<td  class="width-35" ><form:input path="itemCode" htmlEscape="false" maxlength="50" class="form-control required"/></td>
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