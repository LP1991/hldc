<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>hive数据表新增</title>
	<meta name="decorator" content="default"/>
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
	<!-- 表单验证js -->
    <script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
    <!--表单向导所需-->
    <link href="${ctxStatic}/jquery-steps/css/jquery.steps.css" rel="stylesheet">
    <script src="${ctxStatic}/jquery-steps/js/jquery.steps.min.js"></script>
    <!--表单向导中包含验证所需-->
    <script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/jquery.validate.min.js"></script>
    <script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/localization/messages_zh.min.js"></script>
	
	<script type="text/javascript">
	var validateForm;
		function doSubmit(index,table){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			
			
			setTimeout(function(){
			if(validateForm.form()){
				top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>'});
				 submitData( '${ctx}/dc/dataProcess/hiveTableData/ajaxTableSave',getFormParams('inputForm'),function(data){

					top.layer.closeAll('loading'); 
					 var icon_number;
						if(!data.success){
							icon_number = 8;
						}else{
							icon_number = 1;
						}
					 top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
						if(data.success!=true){
						    return;
						}else{
							//刷新表格
							table.ajax.reload();
							//关闭form面板
							top.layer.close(index)
							return true;
						}
					});
			  }    
			},1000);
		}
		function setPId (val){
			$('#cur_indexId').val( val);
		}
		$(document).ready(function() {
			$("#tableName").focus();
			validateForm = $("#inputForm").validate({
				rules: {
					tableName: {remote: "${ctx}/dc/dataProcess/hiveTableData/checkTable"}//设置了远程验证，在初始化时必须预先调用一次。
				},
				messages: {
					tableName: {remote: "数据表名书写不规范，首字符不能为数字，且不能输入汉字"},
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
		
		function preViewData(){
		    var location = $("#locationId").val();
		    var separatorSign = $("#separatorSign").val();
		    openDialogView('数据预览','${ctx}/dc/dataProcess/hiveTableData/loadData?location='+location+'&separatorSign='+separatorSign,'760px', '480px');
	    }
	</script>
</head>

<body class="hideScroll">
    <input type="hidden" id="cur_indexId"/>
	<form:form id="inputForm" modelAttribute="dcHiveTable" autocomplete="off" action="#" method="post" class="form-horizontal" style="margin:0;"> 
		<form:hidden path="id"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
			<tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>数据表名：</label></td>
					<td class="width-35">
					    <input id="oldTableName" name="oldTableName" type="hidden" value="${dcHiveTable.tableName}">
						<form:input path="tableName" id="tableName" htmlEscape="false" maxlength="50" class="form-control required"/></td>
				</tr>
				<tr>
					<td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>数据表空间：</label></td>
				    <td class="width-35">
						<form:select path="tableSpace" class="form-control required">
							<form:option  value="default" htmlEscape="false" >default</form:option>
							<form:options items="${dbList}" itemLabel="database" itemValue="database"   htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr>
					<td  class="width-15 active" class="active"><label class="pull-right">数据表描述：</label></td>
				    <td class="width-35"><form:input path="tableDesc" htmlEscape="false" maxlength="50" class="form-control"/></td>
				</tr>
				<tr>
					<td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>文件位置：</label></td>
					<td class="width-35" > 
					   <%--  <form:input path="location"  id="location" htmlEscape="false"  class="form-control required"/> --%>
					    <dc:treeselect2 allowInput="true" clearItem="true" id="location" name="location" value="${dcHiveTable.location}" labelName="文件路径" labelValue="${dcHiveTable.location}" notAllowSelectParent="true" title="文件路径" url="/dc/dataProcess/hiveTableData/HdfsPathTreeData" cssClass="form-control required" />
					</td>
				</tr>
			<!--	<tr>
					<td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>导入文件数据</label></td>
					<td class="width-35"><input type="radio"  value="loadData" id="IsLoadData" name="IsLoadData"></td>
				</tr>-->
				<tr>
					<td  class="width-15 active" class="active"><label class="pull-right">分隔符：</label></td>
					<td class="width-35">
						<form:select path="separatorSign" id="separatorSign" class="form-control">
							<form:options items="${fns:getDictListLike('dc_hive_separator')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
						 <a href="#" onclick="preViewData()" class="btn btn-info btn-xs"><i class="fa fa-bug"></i>数据预览</a>
					</td>
                </tr>
			</tbody>
		</table>
	</form:form>
</body>
</html>