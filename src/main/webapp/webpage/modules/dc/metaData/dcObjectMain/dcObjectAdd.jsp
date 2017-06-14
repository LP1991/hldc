<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>搜索标签</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	function found_id(){
		var parent_id = window.frameElement.id;
		var arr = $('#'+parent_id,parent.document).parent().parent().siblings().find('iframe');
		var o_id;
		for(var i=0;i<arr.length;i++){
			if(arr.eq(i).attr('src') && arr.eq(i).attr('src').indexOf('id')!==-1){
				o_id = arr.eq(i).attr('src').toString().split('id=')[1]
			}
		}
		return o_id;
	}
	$(function(){
		$('#id').val(found_id());
	})
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="dcSearchLabel" action="${ctx}/dc/metaData/dcObjectMain/ajaxSaveTab" method="post" class="form-horizontal">
	
		<form:hidden path="id" />
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
		      <tr>
		       <td  class="width-15"  class="active"><label class="pull-right"><font color="red">*</font>标签名称:</label></td>
					<td  class="width-35" ><input id="oldLabelName" name="oldLabelName" type="hidden" value="${dcSearchLabel.labelName}">
					<form:input path="labelName" htmlEscape="false" maxlength="50" class="form-control required"/></td>
				</tr>
				<tr>
				<td  class="width-15"  class="active"><label class="pull-right"><font color="red">*</font>标签描述:</label></td>
					<td  class="width-35" ><form:input path="labelDesc" htmlEscape="false" maxlength="50" class="form-control required"/></td>
			</tr>		
			<tr>		
				<td  class="width-15"  class="active"><label class="pull-right">备注:</label></td>
					<td  class="width-35" ><form:input path="remarks" htmlEscape="false" maxlength="50" class="form-control "/></td>
			</tr>
		    </tbody>
		  </table>
	</form:form>
		<script>
		
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		var validateForm;
		validateForm = $("#inputForm").validate({
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
		function doSubmit(index, table,value) {
	//var params_id = found_id();
	
	//getFormParams('inputForm').id=found_id();
	if (validateForm.form()) {
			submitData('${ctx}/dc/metadata/dcObjectMain/ajaxSaveLabeladd', getFormParams('inputForm'), function (data) {
				console.log(getFormParams('inputForm'));
				top.layer.alert(data.msg, {
						title : '系统提示'

				});
                //刷新表格
                table.ajax.reload();
                //关闭form面板
                top.layer.close(index)
			});

			//return true;
	}
		}

	</script>
</body>
</html>