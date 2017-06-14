<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>搜索标签</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
	function doSubmit(index, table) {
		setTimeout(function(){//TODO待后期优化
		if(validateForm.form()){
		submitData('${ctx}/dc/schedule/dcTaskTime/saveA', getFormParams('inputForm'), function (data) {
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
				labelName: {remote: "${ctx}/dc/schedule/dcTaskTime/checkScheduleName?oldScheduleName=" + encodeURIComponent('${dcTaskTime.scheduleName}')}//设置了远程验证，在初始化时必须预先调用一次。
			},
			messages: {
				labelName: {remote: "调度任务已存在 "}
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
 
	setTimeout(function(){
		var selected_i = $('select option:selected').val();
		if(selected_i == 2){
			$('#schedul').hide();
            $('#urllink').show();
		}else if(selected_i == 0){
			$('#schedul').show();
            $('#urllink').hide();
		}else{
            $('#schedul').hide();
            $('#urllink').hide();
        }
		
		$('#triggerType').change(function(){
			var i = $(this).val();
			console.log($(this).find('option').eq(i).text());
			if(i==2){
                $('#schedul').hide();
                $('#urllink').show();
			}else if(i==0){
                $('#schedul').show();
                $('#urllink').hide();
            }else{
                $('#schedul').hide();
                $('#urllink').hide();
			}
		})
	});
	</script>
</head>
<body>
<form:form id="inputForm" modelAttribute="dcTaskTime" action="#" autocomplete="off" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" name="taskfromtype" value="99"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
				<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>调度名称:</label></td>
					<td  class="width-35" ><form:input path="scheduleName" htmlEscape="false" maxlength="200" class="form-control required"/></td>
				</tr>
				<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>触发方式:</label></td>
					<td  class="width-35" >
						<form:select path="triggerType" class="form-control required">
							<form:options items="${fns:getDictListLike('dc_taskTimeType')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>			
				<tr id="schedul">				
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>调度时间:</label></td>
					<td  class="width-35" >
						<form:input path="scheduleExpr" htmlEscape="false" maxlength="200" class="form-control required"/>
						<a href="#" onclick="cronEditor()" class="btn btn-success btn-xs">
						<i class="fa fa-edit"></i> 在线编辑
						</a>
					</td>
				</tr>
				<tr id="urllink">
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>URL:</label></td>
					<td  class="width-35" >
						<form:input path="urlLink" htmlEscape="false" maxlength="200" class="form-control required"/>
					</td>
				</tr>
				<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red"></font>调度描述:</label></td>
					<td  class="width-55" ><form:textarea path="scheduleDesc" htmlEscape="false" rows="4" class="form-control"/></td>
				</tr>
		    </tbody>
		  </table>
	</form:form>
	
	
	<script>
	$(document).ready(function () {
		// $("#cronEditor").contents.find("#cron").val("2 * * * * ?");
		
	});

//在线编辑Cron表达式
		function cronEditor(){
			var expression = $('#scheduleExpr').val();
			openFrameModel('编辑调度表达式', '${ctx}/dc/dataProcess/transJob/editExpress?cronExpr='+expression, '800px', '600px');
			//openDialog('编辑调度表达式', '${ctx}/dc/dataProcess/transJob/editExpress?cronExpr='+expression, '800px', '600px');
		}
		
		//保存Cron表达式
		function updateCronExpr(cronExpr){
			if(cronExpr) $('#scheduleExpr').val(cronExpr);
		}
		
		function openFrameModel(title, url, width, height,target,o) {
			if(navigator.userAgent.match(/(iPone|iPod|Android|iso)/i)) { // 如果是移动端，就使用自适应大小弹窗
				width='auto';
				height='auto';
			} else { // 如果是PC端，根据用户设置的width和height显示
				if (width && $(top.window).width() < width.replace('px', '')) {
					width = ($(top.window).width() - 20) + 'px';
				}
				if (height && $(top.window).height() < height.replace('px', '')) {
					height = ($(top.window).height() - 20) + 'px';
				}
			}
			
			//打开目标窗口
			top.layer.open({
				type : 2,
				title : title,
				//shadeClose : true,
				//shade : false,
				maxmin : true, //开启最大化最小化按钮
				area : [ width, height ],
				content : url,
				btn : [ '确定', '关闭' ],
				yes : function(index, layero) {
					var body = top.layer.getChildFrame('body', index);
					var iframeWin = layero.find('iframe')[0]; // 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
					var inputForm = body.find('#inputForm');
					var top_iframe;
					if (target) {
						top_iframe = target;// 如果指定了iframe，则在改frame中跳转
					} else {
						top_iframe = top.getActiveTab().attr("name");// 获取当前active的tab的iframe
					}
					inputForm.attr("target", top_iframe);// 表单提交成功后，从服务器返回的url在当前tab中展示
					
					var method={};
					method.updateCronExpr = updateCronExpr;
					if (typeof(table) == "undefined") { 
						if (iframeWin.contentWindow.doSubmit(index,method)){
							// top.layer.close(index);//关闭对话框。
							setTimeout(function() {
								//新版改造  放入form中关闭
								top.layer.close(index)
							}, 100);// 延时0.1秒，对应360 7.1版本bug
						}
					} 					
				},
				cancel : function(index) {
					
				},success : function(layero, index) {	//将index传递给目标窗口, 不然没法关闭, 目标页面需实现 function setPIndexId 设置隐藏字段'cur_indexId'
					var iframeWin = layero.find('iframe')[0]; // 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
					if (typeof(table) == "undefined") { 
						iframeWin.contentWindow.setPIndexId(index);
					}else{
						iframeWin.contentWindow.setPIndexId(index,table);
					}					
				}
			});
		}
	</script>

</body>
</html>