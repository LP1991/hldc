<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>rest webservice采集Job</title>
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
	<!-- form表单 -->
	<style>
		.wizard > .steps .current a, .wizard > .steps .current a:hover, .wizard > .steps .current a:active{
			text-align:center;
			border-radius:30px;
		}
		.wizard > .steps .current a span, .wizard > .steps .current a:hover span, .wizard > .steps .current a:active span{
			background: #2184be;
		}
		.wizard > .steps .done a span, .wizard > .steps .done a:hover span, .wizard > .steps .done a:active span{
			background: #9dc8e2;
		}
		.wizard > .steps > ul > li, .wizard > .actions > ul > li{
			text-align:center;
			border-radius:30px;
		}
		
		.wizard > .steps > ul{
			position:relative;	
			overflow:hidden;
			margin-left:-3%;
			margin-right:2%;		
		}
		.wizard > .steps > ul li{
			position:relative;
			z-index:100;
			left:0;
			top:0;
		}
		.wizard > .steps a, .wizard > .steps a:hover, .wizard > .steps a:active{
			margin:0 auto !important;
			width:50% !important;
			background-color:transparent !important;
			color:#aaa !important;
		}
		.position_line{
			position: absolute;
		    left: 6%;
		    top: 35%;
		    width: 88%;
		    margin: 0 auto;
		    height: 6%;
		    background: #388bc2;
		}
		.position_child{
			height:100%;
			width:25%;
			float:left;
			background:gray;
		}
		.position_child:nth-child(1){
			background:#388bc2;
		}
		.form-horizontal{
			margin:10px 0 !important;
		}
		.wizard > .steps .number {
		/* 数字序号设置  */
		    display: inline-block;
		    width: 30px;
		    font-size: 1.429em;
		    border-radius: 25px;
		    text-align: center;
		    background: #194f8b;
		    line-height: 30px;
		    color:#fafafa;
		}
		#inputForm .actions{
			margin-left:-4%;
		}
		#inputForm .actions li:nth-child(2){
			display:block !important;
		}
	</style>
	<script>
	$(function(){
		/* 插入进度条 */
			$('.steps>ul').append('<div class="position_line"></div>');
			for(var i=0;i<=$('.steps>ul>li').length;i++){
				if(i<$('.steps>ul>li').length){
					$('.position_line').append('<div class="position_child"></div>');
				}				
				var str = $('.steps').find('ul li').find('a>span').eq(i).text().split(".")[0];
				$('.steps').find('ul li').find('a>span').eq(i).text(str);
			}
	})
	
	</script>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<input type="hidden" id="cur_indexId"/>
	<!-- <input type="hidden" id="dbType"/> 数据库类别 -->
	<form:form id="inputForm" modelAttribute="formData" autocomplete="off" action="#" method="post" class="form-horizontal" >
		<form:hidden path="id"/>
		<form:hidden path="jobType" value="2"/>	<!-- 任务类别: 1-restful webservice; 2-soap webservice -->
		<form:hidden path="tarType" value="0"/>	<!-- 接口数据存储目标 0-mysql; 1-hdfs; 2-hive; 3-hbase -->
		<h3><br>创建任务</h3>
		<fieldset>
			 <legend>任务信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active"><label class="pull-right"><font color="red">*</font>任务名称：</label></td>
					 <td class="width-35">
					 <input id="oldJobName" name="oldJobName" type="hidden" value="${formData.jobName}">
						<form:input path="jobName" htmlEscape="false" maxlength="50" class="form-control required"/>
					 </td>
				  </tr>
				  <tr>
					 <td class="width-15 active" ><label class="pull-right"><font color="red">*</font>任务描述：</label></td>
					 <td class="width-35"> 
						<form:textarea path="jobDesc" rows="2" htmlEscape="false" maxlength="50" class="form-control required"/>
					 </td>
				  </tr>
				  <tr>
					 <td class="width-15 active" ><label class="pull-right"><font color="red">*</font>采集接口URL：</label></td>
					 <td class="width-35">
						 <form:input path="wsPath" htmlEscape="false" class="form-control required isURL"/>
						 <span class="help-inline">soap webservice 服务端连接地址</span>
					 </td>
				  </tr>
				  <tr>
					 <td class="width-15 active" ><label class="pull-right">命名空间：</label></td>
					 <td class="width-35">
						 <form:input path="wsNamespace" htmlEscape="false" class="form-control"/>
						 <span class="help-inline">soap webservice Target namespace 目标命名空间, 客户端默认解析</span>
					 </td>
				  </tr>
				  <tr>
					 <td class="width-15 active" ><label class="pull-right"><font color="red">*</font>调用方法：</label></td>
					 <td class="width-35">
						 <form:input path="wsMethod" htmlEscape="false" class="form-control required"/>
						 <span class="help-inline">soap webservice method 目标方法</span>
					 </td>
				  </tr>
				  <tr>
					 <td class="width-15 active" ><label class="pull-right">表单参数：</label></td>
					 <td class="width-35">
						 <form:input path="params" htmlEscape="false" class="form-control"/>
						 <span class="help-inline">soap服务端接收参数, 多个参数以&进行分割,格式:[参数类型1:参数值1&参数类型2:参数值2]</span>
					 </td>
				  </tr>
				</tbody>
			</table>
		</fieldset>

		<h3><br>数据存储设置</h3>
		<fieldset>
			 <legend>DataBase</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				   <tr>
					   <td  class="width-15 active" ><label class="pull-right">存储目标：</label></td>
					   <td class="width-35">MySQL
						   <span class="help-inline">目前储存于MySQL数据库</span>
					   </td>
				   </tr>
				   <tr>
					   <td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>数据源连接：</label></td>
					   <td class="width-35" >
						   <form:select path="connId" class="form-control required" style="width: 500px;">
							   <form:option value="">请选择</form:option>
							   <form:options items="${dataSourceList}" itemLabel="connName" itemValue="id" htmlEscape="false"/>
						   </form:select>
						   <a href="#" onclick="createDBLink()" class="btn btn-info btn-xs" ><i class="fa fa-database"></i> 创建数据源</a>
					   </td>
				   </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>连接Schema：</label></td>
					 <td class="width-35">
						<dc:treeselect allowInput="false" clearItem="true"
							    id="schema" name="schemaName"
								value="${formData.schemaName}" labelName="数据库Schema"
							    labelValue="${formData.schemaName}"
								notAllowSelectParent="true" title="Schema"
							    url="/dc/metadata/db/schemaTreeData"
								cssClass="form-control required" validateField="connId" otherParam1="connId" />
						<span class="help-inline">请选择数据库schema</span>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>数据表：</label></td>
					  <td class="width-35">
						  <dc:treeselect2  allowInput="false"
										   clearItem="true" id="tar" name="tarName"
										   value="${formData.tarName}" labelName="数据表"
										   labelValue="${formData.tarName}" notAllowSelectParent="true"
										   title="数据表" url="/dc/metadata/db/tableTreeData"
										   cssClass="form-control required"
										   validateField="connId,schemaName" otherParam1="connId" otherParam2="schemaName" />
							  <%-- <form:checkbox path="createFlag" title="创建数据表"/>
                                   创建数据表:<input type="checkbox" id="createFlag" name="createFlag" value="N" onchange="updateFlag(this)"/>
						  <span class="help-inline">如果目标数据表不存在, 可根据接口字段进行初始化</span>--%>
						  <span class="help-inline">请选择需要关联的数据表</span>
					  </td>
				  </tr>
				</tbody>
			</table>
		</fieldset>
	</form:form>
	
	<script>
		var validateForm;
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index, table) {
			setTimeout(function(){
				if(validateForm.form()){
					submitData('${ctx}/dc/dataProcess/transJob/ajaxSave', getFormParams('inputForm'), function (data) {
						if(data.success){	//保存成功
							top.layer.alert(data.msg, { title : '系统提示' });
							//刷新表格
							table.ajax.reload();
							//关闭form面板
							top.layer.close(index)
						}else{
							top.layer.alert(data.msg, {icon: 3, title:'系统提示'});
							return false;
						}
					});
				}
			},1000);
		}
		
		//新建数据源连接  
		function createDBLink(target, o){
			var option ={
				type : 2,
				area : [ '800px', '600px' ],
				title : '创建数据源',
				maxmin : true, // 开启最大化最小化按钮
				content : '${ctx}/dc/metadata/dcDataSource/ajaxNewSource',
				btn : [ '确定', '关闭' ],
				yes : function(index, layero) {
					//top.layer.shadeClose = true;
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
					method.appendDataLink=appendDataLink;
					//判断执行状态, 保存成功则关闭页面并刷新下拉列表, 保存失败则不处理
					iframeWin.contentWindow.doSubmit(index,method);
					top.layer.closeAll('loading');
				},
				cancel : function(index) {
					top.layer.closeAll('loading');
				}
			};
			option = $.extend({}, option, o);
			top.layer.open(option);
		}
		
		//添加数据源连接选项 被子页面调用
		function appendDataLink(result){
			if (result && result.flag == '1'){
				$('#connId').prepend("<option value='"+result.itemValue+"' selected='selected'>"+result.itemLabel+"</option>");
			}
			return false;
		}

		var table;
		//设置当前页 IndexId
		function setPIndexId(val,t){
			table=t;
			$('#cur_indexId').val(val);
		}
		
		setTimeout(function(){
			$('.actions').find('a[href=#finish]').parent().addClass('disabled');
		},1);
		
		//向导表单
		var form = $("#inputForm").show();
		form.steps({
			headerTag : "h3",
			bodyTag : "fieldset",
			transitionEffect : "slideLeft",
			//enableCancelButton: false,//取消按钮不显示
			onStepChanging : function (event, currentIndex, newIndex) {
				if (currentIndex > newIndex) {
					return true;
				}
				if (currentIndex < newIndex) {
					form.find(".body:eq(" + newIndex + ") label.error").remove();
					form.find(".body:eq(" + newIndex + ") .error").removeClass("error");
				}
				//忽略隐藏字段的验证
				form.validate().settings.ignore = ":disabled,:hidden";
				return form.valid();
			},
			onStepChanged : function (event, currentIndex, priorIndex) {
				//如果已经进行的最后一步
				if($('.steps>ul').find('li').eq(currentIndex).hasClass('last')){
					$('.actions').find('a[href=#next]').parent().show();
					$('.actions').find('a[href=#finish]').parent().removeClass('disabled');
				}				
				$('.position_line .position_child').eq(currentIndex).css({//步骤颜色改变
					"background":"#388bc2"
				});
				
			},
			onCanceled: function (event) { 
				top.layer.close($('#cur_indexId').val());
			},
			onFinishing : function (event, currentIndex) {
				form.validate().settings.ignore = ":disabled";
				return form.valid();
			},
			onFinished : function (event, currentIndex) {
				top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>'});
				submitData('${ctx}/dc/dataProcess/transIntf/ajaxSave', getFormParams('inputForm'), function (data) {
					top.layer.closeAll('loading');
					top.layer.alert(data.msg, {
						title : '系统提示'
					});
					//失败时保存当前页面
                    if(data.success){
                        top.layer.close($('#cur_indexId').val());
                        if(typeof(table)==='object'){
                            table.ajax.reload(); //刷新父页面
                        }
                    }
				});
			}
		});

		$(document).ready(function() {
			$("#jobName").focus();
			validateForm = $("#inputForm").validate({
				rules: {
					jobName: {remote: "${ctx}/dc/dataProcess/transIntf/checkJobName?jobType=2&oldJobName=" + encodeURIComponent('${formData.jobName}')}//设置了远程验证，在初始化时必须预先调用一次。
                //    tarName: {remote: "${ctx}/dc/dataProcess/transIntf/checkTarName?tarType="+$('#tarType').val()+"&connId="+$('#connId').find('option:selected').val()+"&schemaName="+$('#schemaName').val()}
				},
				messages: {
					jobName: {remote: "任务名已存在"}
                 //   tarName: {remote: "数据表已存在"}
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
</body>
</html>