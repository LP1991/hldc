<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据转换任务</title>
	<meta name="decorator" content="default"/>
	 <script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<input type="hidden" id="cur_indexId"/>
	<form:form id="processForm" modelAttribute="proInfo" autocomplete="off" action="#" method="post" class="form-horizontal" > 
		<form:hidden path="id"/>
		<form:hidden path="jobId" value="${proInfo.jobId}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
			  <tr>
		        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>转换过程:</label></td>
				<td class="width-35">
					<input id="oldTransName" name="oldTransName" type="hidden" value="${proInfo.transName}">
					<form:input path="transName" htmlEscape="false" maxlength="50" class="form-control required"/>
				</td>
		        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>执行顺序:</label></td>
				<td class="width-35">
					<form:input path="sortNum" htmlEscape="false" maxlength="50" class="form-control required isIntGtZero"/>
				</td>
		      </tr>
			  <tr>
		        <td class="width-15 active"><label class="pull-right">过程描述:</label></td>
				<td class="width-85" colspan="3">
					<form:input path="transDesc" htmlEscape="false" rows="2" maxlength="50" class="form-control"/>
				</td>
		      </tr>
			  <tr>
		        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>转换引擎:</label></td>
				<td class="width-35">
					<form:select path="transEngine" class="form-control required">
						<form:options items="${fns:getDictListLike('dc_data_trans_engine')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</td>
		        <!-- <td class="width-15 active"><label class="pull-right">引擎连接:</label></td>
				<td class="width-35">
					<form:select path="transConn" class="form-control" >
						<form:option value="">默认Hive引擎</form:option>
						<form:options items="${dataSourceList}" itemLabel="connName" itemValue="id" htmlEscape="false"/>
					</form:select>
				</td>
				-->
				  <td class="width-15" colspan="2">
					  <a href="#" onclick="showParam()" class="btn btn-info btn-xs"><i class="fa fa-hand-o-right"></i> 脚本变量参考</a>
				  </td>
		      </tr>
			  <tr>
				 <td class="width-15 active"><label class="pull-right"><font color="red">*</font>转换脚本:</label></td>
				 <td class="width-85" colspan="3">
					<form:textarea path="transSql" htmlEscape="false" class="form-control required" style="height:380px"/>
				 </td>
			  </tr>
		   </tbody>
		</table>
	</form:form>
	
	<script>
		var validateForm;
		
		$(document).ready(function() {
			$("#transName").focus();
			validateForm = $("#processForm").validate({
				rules: { //设置了远程验证，在初始化时必须预先调用一次。
					transName: {remote: "${ctx}/dc/dataProcess/transData/checkProName?oldProName=" + encodeURIComponent('${proInfo.transName}')+"&jobId="+$('#jobId').val()}
				},
				messages: {
					transName: {remote: "过程名已存在"},
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
		
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index, table) {
			if(validateForm.form()){
				var processForm = {
					'id':$('#id').val(),
					'jobId':$('#jobId').val(),
					'transName': $('#transName').val(),
					'transEngine': $('#transEngine').val(),
					'transConn': $('#transConn').val(),
					'sortNum': $('#sortNum').val(),
					'transDesc': $('#transDesc').val(),
					'transSql': $('#transSql').val().replace(/(\r\n|\n|\r)/gm,'__nl__')
				};
				submitData('${ctx}/dc/dataProcess/transData/processSave', processForm, function (data) {
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
		}

        //显示脚本变量参考
        function showParam(target, o){
            var option ={
                type : 2,
                area : [ '800px', '660px' ],
                title : '数据转换脚本变量',
                maxmin : true, // 开启最大化最小化按钮
                content : '${ctx}/dc/dataProcess/transData/showScriptParam',
                btn : ['关闭' ],
                cancel : function(index) {
                    top.layer.closeAll('loading');
                }
            };
            option = $.extend({}, option, o);
            top.layer.open(option);
        }
	</script>
</body>
</html>