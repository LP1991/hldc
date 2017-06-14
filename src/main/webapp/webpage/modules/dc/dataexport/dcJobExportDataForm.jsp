<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>采集Job</title>
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
/* 		    background: #388bc2; */
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
		#inputForm legend{
			margin-bottom:0;
		}
		#inputForm .actions {
			margin-left: -4%;
			position:fixed;
			right:4%;
			bottom:15px;
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
		#inputForm .actions li:nth-child(2){
			display:block !important;
		}
	</style>
	<script>
	$(function(){
		/* 插入进度条 */
			$('.steps>ul').append('<div class="position_line"></div>');
		var n = $('.steps>ul>li');
			for(var i=0;i<=n.length;i++){
				if(i<n.length){
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
	<form:form id="inputForm" modelAttribute="exportDataJob" autocomplete="off" action="#" method="post" class="form-horizontal" > 
		<form:hidden path="id"/>
		<h3><br>创建任务</h3>
		<fieldset>
			 <legend>任务信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active"><label class="pull-right"><font color="red">*</font>任务名称：</label></td>
					 <td class="width-35" colspan="3"> 
					 <input id="oldJobName" name="oldJobName" type="hidden" value="${exportDataJob.jobName}">
						<form:input path="jobName" htmlEscape="false" maxlength="50" class="form-control required"/>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active"  ><label class="pull-right">任务描述：</label></td>
					 <td class="width-35" colspan="3"> 
						<form:textarea path="jobDesc" rows="2" htmlEscape="false" maxlength="50" class="form-control"/>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active"  ><label class="pull-right"><font color="red">*</font>数据源：</label></td>
					 <td class="width-35" > 
						<form:select path="fromLink" class="form-control required">
							<form:option value="1">HDFS</form:option>
							<form:option value="2">HIVE</form:option>
						</form:select>
						<span class="help-inline">目前支持HDFS和HIVE数据导出</span>
					 </td>
					 <td  class="width-15 active"  ><label class="pull-right"><font color="red">*</font>数据对象：</label></td>
					 <td class="width-35"> 
						<form:input path="dataPath" htmlEscape="false" maxlength="50" class="form-control required"/>
						<span class="help-inline">如数据源为HDFS,则输入文件路径, 否则输入HIVE表名</span>
					 </td>
				  </tr>
				  <!-- 
				   <tr>
					 <td  class="width-15 active"  ><label class="pull-right">选择元数据：</label></td>
					 <td class="width-35" > 
						<form:select path="metaDataId" class="form-control">
							<form:option value="1">HDFS</form:option>
							<form:option value="2">HIVE</form:option>
						</form:select>
						<span class="help-inline">选择集群元数据对象</span>
					 </td>
				  </tr>	
					-->	
				  <tr>
					 <td  class="width-15 active"  ><label class="pull-right">并行任务数：</label></td>
					 <td class="width-35">
						<form:input path="mapNum" htmlEscape="false" maxlength="50" value="1" class="form-control isIntGtZero"/>
						<span class="help-inline">并行处理任务数, 默认为1</span>
					 </td>
					 <td  class="width-15 active"  ><label class="pull-right">字段分隔符：</label></td>
					 <td class="width-35">
						<form:input path="fieldSplitBy" htmlEscape="false" maxlength="50" class="form-control"/>
						<span class="help-inline">字段间的分隔字符, hdfs默认为','</span>
					 </td>
				  </tr>			  
				  <tr>
				  </tr>
				  <tr>
					 <td  class="width-15 active"  ><label class="pull-right">字符串空值转换：</label></td>
					 <td class="width-35">
						<form:input path="nullString" htmlEscape="false" maxlength="50" class="form-control"/>
						<span class="help-inline">指定字符串, 替换字符串类型值为null的列</span>
					 </td>
					 <td  class="width-15 active"  ><label class="pull-right">非字符串空值转换：</label></td>
					 <td class="width-35">
						<form:input path="nullNonString" htmlEscape="false" maxlength="50" class="form-control"/>
						<span class="help-inline">指定字符串, 替换非字符串类型值为null的列</span>
					 </td>
				  </tr>
				</tbody>
			</table>
		</fieldset>

		<h3><br>导出数据库设置</h3>
		<fieldset>
			 <legend>Export DataBase</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active"  ><label class="pull-right"><font color="red">*</font>导出数据源：</label></td>
					 <td class="width-35">
						<form:select path="toLink" class="form-control required" style="width: 500px;">
							<form:option value="">请选择</form:option>
							<form:options items="${dataSourceList}" itemLabel="connName" itemValue="id" htmlEscape="false"/>
						</form:select>
						<a href="#" onclick="createDBLink()" class="btn btn-info btn-xs" ><i class="fa fa-database"></i> 创建数据源</a>
					 </td>					 
				  </tr>
				  
				  <tr>
					 <td class="width-15 active"  ><label class="pull-right"><font color="red">*</font>连接Schema：</label></td>
					 <td class="width-35">
						<dc:treeselect allowInput="true" clearItem="true" id="schema" name="schemaName" value="${exportDataJob.schemaName}" labelName="数据库Schema" labelValue="${exportDataJob.schemaName}" notAllowSelectParent="true" title="Schema" url="/dc/metadata/db/schemaTreeData" cssClass="form-control required" validateField="toLink" otherParam1="toLink" />
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active"  ><label class="pull-right"><font color="red">*</font>数据表名称：</label></td>
					 <td class="width-35"> 
						<dc:treeselect allowInput="true" clearItem="true" id="table" name="tableName" value="${exportDataJob.tableName}" labelName="数据表" labelValue="${exportDataJob.tableName}" notAllowSelectParent="true" title="数据表" url="/dc/metadata/db/tableTreeData" cssClass="form-control required" validateField="toLink,schemaName" otherParam1="toLink" otherParam2="schemaName" />
						<span class="help-inline" style="font-weight:bold;">是否清空原有数据: </span> <form:checkbox path="clearDataFlag"/>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active"  ><label class="pull-right">字段：</label></td>
					 <td class="width-35"> 
						<dc:treeselect allowInput="true" clearItem="true" id="tableColumn" name="tableColumn" value="${exportDataJob.tableColumn}" labelName="数据表字段" labelValue="${exportDataJob.tableColumn}" notAllowSelectParent="true" checked="true" title="数据表字段" url="/dc/metadata/db/tableFieldData" cssClass="form-control" validateField="toLink,schemaName,tableName" otherParam1="toLink" otherParam2="schemaName" otherParam3="tableName"/>
						<span class="help-inline">可以指定数据表需要导入的字段列, 未指定的字段列需设置默认值, 或者允许插入空值</span>
					 </td>
				  </tr>	
				</tbody>
			</table>
			
			<legend style="font-size:16px; padding-top: 10px;font-weight: bold;">增量方式</legend>
			<div id="incrementConfig">
				<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
				   <tbody>
					  <tr>
						 <td  class="width-15 active"  ><label class="pull-right">增量方式: </label></td>
						 <td class="width-35"> 
							<form:select path="updateMode" class="form-control required">
								<form:option value="insertonly" label="仅新增"/>
								<form:option value="updateonly" label="仅更新"/>
								<form:option value="allowinsert" label="新增且更新"/>
							</form:select>
							<span class="help-inline">若选择更新数据, 应设置主键字段</span>					 
						 </td>
					  </tr>
					  <tr>
						 <td  class="width-15 active"  ><label class="pull-right">主键字段：</label></td>
						 <td class="width-35"> 
							<form:input path="updateKey" htmlEscape="false" maxlength="50" class="form-control"/>
							<span class="help-inline">若多个主键字段,以','分隔</span>
						 </td>
					  </tr>
					</tbody>
				</table>
			</div>			
		</fieldset>
		
		<h3><br>采集脚本</h3>
		<fieldset>
			<legend>sqoop命令</legend>
			 <div class="form-group">
				<div class="col-sm-12">
				   <textarea id="remarks" name="remarks" title="sqoop脚本" style="height: 320px;" class="form-control span12">${exportDataJob.remarks}</textarea>
				</div>
			</div>
		</fieldset>
		
	</form:form>
	
	<script>
		var validateForm;
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index, table) {
			setTimeout(function(){
				if(validateForm.form()){
					submitData('${ctx}/dc/dataExport/job/ajaxSave', getFormParams('inputForm'), function (data) {
						var icon_number;
						if(!data.success){
							icon_number = 8;
						}else{
							icon_number = 1;
						}
						top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
						if(data.success){	//保存成功
							//刷新表格
							table.ajax.reload();
							//关闭form面板
							top.layer.close(index)
						}else{
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
				},
				cancel : function(index) {
				}
			};
			option = $.extend({}, option, o);
			top.layer.open(option);
		}
		
		//添加数据源连接选项 被子页面调用
		function appendDataLink(result){
			if (result && result.flag == '1'){
				$('#toLink').prepend("<option value='"+result.itemValue+"' selected='selected'>"+result.itemLabel+"</option>");
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
			/* 新增判断，解决步骤表单留白过多导致页面出现滚动条的问题  */
			/* 判断当前的步骤内容是否超出本身高度 ，此判断需要在步骤改变时进行判断   */
			var arr = $('#inputForm').find('fieldset');
			var height_arr = [];
/* 			for(var i=0;i<arr.length;i++){
				height_arr.push(arr.eq(i).height());
			}
			maxHeight = Math.max.apply(Math, height_arr); */
			$('#inputForm').find('legend').css({'marginBottom':'0'});
/* 			var body_height = $('body').height();
			if(maxHeight < body_height && maxHeight < body_height-60){
				maxHeight = maxHeight + 60;
			}else{
				maxHeight = maxHeight + 20;
			}
			$('#inputForm').find('.content').css({'minHeight':maxHeight+'px'}); */
			$('.actions').css({'right':'4%'});
			/*---------*/
			$('.actions').find('a[href=#finish]').parent().addClass('disabled');
		},1);
		//向导表单
		var form = $("#inputForm").show();
		form.steps({
			headerTag : "h3",
			bodyTag : "fieldset",
			transitionEffect : "slideLeft",
			//enableCancelButton: false,
			onStepChanging : function (event, currentIndex, newIndex) {
				//console.log(arguments);
				if (currentIndex > newIndex) {
					return true;
				}
				if (currentIndex < newIndex) {
					form.find(".body:eq(" + newIndex + ") label.error").remove();
					form.find(".body:eq(" + newIndex + ") .error").removeClass("error");
				}
				/**存储设置
				if(newIndex==1){
					if($('#updateMode').val()=='insertonly'){		//新增模式
						$('#updateKey').removeClass("required");
						$('#updateKey-error').hide();
						
					}else {	//更新模式
						$('#updateKey').addClass("required");
					}
				} **/
				//采集脚本设置 采集脚本设置  
				// sudo -u hdfs sqoop export --connect "jdbc:mysql://sharedbdev.hleast.com:3306/test" --username hldc_h5 --password hldc_h5 --table dc_exp_userdata --columns "name,age" --export-dir /tmp/pjd3/userData.txt --input-null-string '\\N' --input-null-non-string '\\N'  --input-fields-terminated-by '\t'
				if(newIndex==2){	
					var sqoopScript = 'sudo -u hdfs sqoop export -m '+$('#mapNum').val()+' --table '+$('#tableId').val();
					if($('#tableColumnId').val()){
						sqoopScript += ' --columns '+$('#tableColumnId').val();
					}
					if($('#nullString').val()){
						sqoopScript += ' --input-null-string \''+$('#nullString').val()+'\'';
					}
					if($('#nullNonString').val()){
						sqoopScript += ' --input-null-non-string \''+$('#nullNonString').val()+'\'';
					}
					if($('#fieldSplitBy').val()){	//分隔符
						sqoopScript += ' --input-fields-terminated-by \''+$('#fieldSplitBy').val()+'\'';
					}
					//增量方式  更新数据
					if('insertonly'!==$('#updateMode').val()){
						sqoopScript += ' --update-mode '+$('#updateMode').val()+' --update-key '+$('#updateKey').val();
					}
					if($('#fromLink').val()=='1'){	//1-hdfs存储, 采集脚本
						sqoopScript += ' --export-dir '+$('#dataPath').val();
						
					}else if($('#fromLink').val()=='2'){	//2-hive存储, 采集脚本
						var hiveTable = $('#dataPath').val();
						if(hiveTable.split('.').length==2){
							//分解schema.table
							sqoopScript += ' --hcatalog-database '+hiveTable.split('.')[0]+' --hcatalog-table '+hiveTable.split('.')[1];
						}else{
							sqoopScript += ' --hcatalog-database default --hcatalog-table '+hiveTable;
						}
					}
					$('#remarks').val(sqoopScript);
				}
				//忽略隐藏字段的验证
				form.validate().settings.ignore = ":disabled,:hidden";
				return form.valid();
			},
			onStepChanged : function (event, currentIndex, priorIndex) {
				//console.log("onStepChanged!");
				if($('.steps>ul').find('li').eq(currentIndex+1).hasClass('last') || $('.steps>ul').find('li').eq(currentIndex).hasClass('last')){
					$('.actions').find('a[href=#next]').parent().show();
					$('.actions').find('a[href=#finish]').parent().removeClass('disabled');
				}				
				$('.position_line .position_child').eq(currentIndex).css({//步骤颜色改变
					"background":"#388bc2"
				});
				
				
			},
			onCanceled: function (event) { 
				// top.layer.alert('close', {title : '系统提示'});
				top.layer.close($('#cur_indexId').val());
			},
			onFinishing : function (event, currentIndex) {
				form.validate().settings.ignore = ":disabled";
				return form.valid();
			},
			onFinished : function (event, currentIndex) {
				var formData = getFormParams('inputForm');
				if($('#clearDataFlag1').is(':checked')) {	//是否清空原有数据
					formData.isClearData='1';
				}else{
					formData.isClearData='0';
				}
				submitData('${ctx}/dc/dataExport/job/ajaxSave', formData, function (data) {
					//刷新表格
					table.ajax.reload();
					//关闭form面板 
					top.layer.alert(data.msg, {title : '系统提示'});
					top.layer.close($('#cur_indexId').val());
				});
			}
		});
				
		$(document).ready(function() {
			$("#jobName").focus();
			validateForm = $("#inputForm").validate({
				rules: {
					jobName: {remote: "${ctx}/dc/dataExport/job/checkJobName?oldJobName=" + encodeURIComponent('${exportDataJob.jobName}')}//设置了远程验证，在初始化时必须预先调用一次。
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
			
			//绑定'增量方式'选择事件, 更新数据表时,需设置主键字段, 
			$('#updateMode').change(function(){ 
				var updateMode=$(this).children('option:selected').val();	//这就是selected的值
				if('insertonly'==updateMode){
					$('#updateKey').removeClass("required");
					$('#updateKey-error').hide();
				}else{
					$('#updateKey').addClass("required");
				}
			}) 
		});
	</script>
</body>
</html>