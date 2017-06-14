<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据转换任务</title>
	<meta name="decorator" content="default"/>
	
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<input type="hidden" id="cur_indexId"/>
	<!-- <input type="hidden" id="dbType"/> 数据库类别 -->
	<form:form id="inputForm" modelAttribute="jobInfo" autocomplete="off" action="#" method="post" class="form-horizontal" style="margin:0;"> 
		<form:hidden path="id"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer" style="margin-left: 2%;margin-right: 2%;width: 96%;">
		   <tbody>
			  <tr>
		        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>任务名称:</label></td>
				<td class="width-35">
					<input id="oldJobName" name="oldJobName" type="hidden" value="${jobInfo.jobName}">
					<form:input path="jobName" htmlEscape="false" maxlength="50" class="form-control required"/>
				</td>
		      </tr>
			  <tr>
		        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>任务描述:</label></td>
				<td class="width-35">
					<form:textarea path="jobDesc" htmlEscape="false" rows="2" maxlength="200" class="form-control required"/>
				</td>
		      </tr>
		   </tbody>
		</table>
	</form:form>
	
	<script>
		var validateForm;
        $("#jobName").focus();
		$(document).ready(function() {
			$("#jobName").focus();
			validateForm = $("#inputForm").validate({
				rules: {
					jobName: {remote: "${ctx}/dc/dataProcess/transData/checkJobName?oldJobName=" + encodeURIComponent('${jobInfo.jobName}')}//设置了远程验证，在初始化时必须预先调用一次。
				},
				messages: {
					jobName: {remote: "任务名已存在"},
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
			
			//$('#inputType').
		});
		
		//动态加载元数据对象 hdfs/impala/hive 
		function loadSrcObj(){
			console.log($('#inputType').find("option:selected").text());
			//console.log($('#inputType').val());
			var selectVal = $('#inputType').val();
			if(selectVal){
				submitData('${ctx}/dc/dataProcess/transData/ajaxSave', {}, function (data) {
					//重新加载 源对象
					$('#inputName').empty();
					
				});
			}			
		}
		
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index, table) {
			
			if(validateForm.form()){
				setTimeout(function(){
					submitData('${ctx}/dc/dataProcess/transData/ajaxSave', getFormParams('inputForm'), function (data) {
						top.layer.alert(data.msg, {
							title : '系统提示'
						});
						//刷新表格
						table.ajax.reload();
						//关闭form面板
						top.layer.close(index)
					});
					return true;
				})
				
			}
		}
	</script>
</body>
</html>