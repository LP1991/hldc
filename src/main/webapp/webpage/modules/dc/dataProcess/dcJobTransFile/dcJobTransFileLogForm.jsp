<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>采集传输文件管理</title>
	<meta name="decorator" content="default"/>
	
    <!--表单向导所需-->
    <link href="${ctxStatic}/jquery-steps/css/jquery.steps.css" rel="stylesheet">
    <script src="${ctxStatic}/jquery-steps/js/jquery.steps.min.js"></script>
    <!--表单向导中包含验证所需-->
    <script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/jquery.validate.min.js"></script>
    <script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/localization/messages_zh.min.js"></script>
    
	<script type="text/javascript">
		var validateForm;
		function doSubmit(index,table){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			if(validateForm.form()){
				top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>'});
				 submitData( '${ctx}/dc/dataProcess/transJobFile/ajaxSave',getFormParams('inputForm'),function(data){
					 top.layer.closeAll('loading'); 
						var icon_number;
						if(!data.success){
							icon_number = 8;
						}else{
							icon_number = 1;
						}
						top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
						if(data.success!=true){
						    return false;
						}else{
							//刷新表格
							table.ajax.reload();
							//关闭form面板
							top.layer.close(index)
							return true;
						}
					});
			  }    
		}
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
<body class="hideScroll">
<table class="table table-striped table-bordered table-condensed table-nowrap">
		<thead>
			<tr>
				<th>执行时间</th>
				<th>执行状况</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${dcJobHdfslogs}" var="model">
				<tr>
					<td>${model.uploadTime}</td>
					<td>${model.status}</td>
					<td>
						<a href="#" onclick="openDialogView('查看','${ctx}/dc/dataProcess/hdfs/viewContent?filePath=${model.fullpath}','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>