<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<title>采集Job</title>
<meta name="decorator" content="default" />

<link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css"
	rel="stylesheet">
<!-- 表单验证js -->
<script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
<!--表单向导所需-->
<link href="${ctxStatic}/jquery-steps/css/jquery.steps.css"
	rel="stylesheet">
<script src="${ctxStatic}/jquery-steps/js/jquery.steps.min.js"></script>
<!--表单向导中包含验证所需-->
<script
	src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/jquery.validate.min.js"></script>
<script
	src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/localization/messages_zh.min.js"></script>
<!-- form表单 -->
<style>
.wizard>.steps .current a, .wizard>.steps .current a:hover, .wizard>.steps .current a:active
	{
	text-align: center;
	border-radius: 30px;
}

.wizard>.steps .current a span, .wizard>.steps .current a:hover span,
	.wizard>.steps .current a:active span {
	background: #2184be;
}

.wizard>.steps .done a span, .wizard>.steps .done a:hover span, .wizard>.steps .done a:active span
	{
	background: #9dc8e2;
}

.wizard>.steps>ul>li, .wizard>.actions>ul>li {
	text-align: center;
	border-radius: 30px;
}

.wizard>.steps>ul {
	position: relative;
	overflow: hidden;
	margin-left: -3%;
	margin-right: 2%;
}

.wizard>.steps>ul li {
	position: relative;
	z-index: 100;
	left: 0;
	top: 0;
}

.wizard>.steps a, .wizard>.steps a:hover, .wizard>.steps a:active {
	margin: 0 auto !important;
	width: 50% !important;
	background-color: transparent !important;
	color: #aaa !important;
}

.position_line {
	position: absolute;
	left: 6%;
	top: 35%;
	width: 88%;
	margin: 0 auto;
	height: 6%;
	background: #388bc2;
}

.position_child {
	height: 100%;
	width: 25%;
	float: left;
	background: gray;
}

.position_child:nth-child(1) {
	background: #388bc2;
}

.form-horizontal {
	 margin-top:10px; 
}

.wizard>.steps .number {
	/* 数字序号设置  */
	display: inline-block;
	width: 30px;
	font-size: 1.429em;
	border-radius: 25px;
	text-align: center;
	background: #194f8b;
	line-height: 30px;
	color: #fafafa;
}
#inputForm fieldset{
	overflow-y:auto;
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
#inputForm .content {
	margin-bottom:0;
	margin-top:0;
}
#inputForm .actions li:nth-child(2) {
	display: block !important;
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
	<sys:message content="${message}" />
	<input type="hidden" id="cur_indexId" />
	<!-- <input type="hidden" id="dbType"/> 数据库类别 -->
	<form:form id="inputForm" modelAttribute="jobInfo" autocomplete="off"
		action="#" method="post" class="form-horizontal">
		<form:hidden path="id" />
		<h3>
			<br>创建任务
		</h3>
		<fieldset>
			<legend>任务信息</legend>
			<table
				class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
				<tbody>
					<tr>
						<td class="width-15 active"><label class="pull-right"><font
								color="red">*</font>任务名称：</label></td>
						<td class="width-35"><input id="oldJobName" name="oldJobName"
							type="hidden" value="${jobInfo.jobName}"> <form:input
								path="jobName" htmlEscape="false" maxlength="50"
								class="form-control required" /></td>
					</tr>
					<tr>
						<td class="width-15 active"><label class="pull-right"><font color="red">*</font>任务描述：</label></td>
						<td class="width-35"><form:textarea path="jobDesc" rows="2"
								htmlEscape="false" maxlength="50" class="form-control required" /></td>
					</tr>
					<tr>
						<td class="width-15 active"><label class="pull-right"><font
								color="red">*</font>数据源：</label></td>
						<td class="width-35"><form:select path="fromLink"
								class="form-control required" style="width: 500px;" onclick="cleartd()">
								<form:option value="" >请选择</form:option>
								<form:options items="${dataSourceList}" itemLabel="connName"
									itemValue="id" htmlEscape="false" />
							</form:select> <a href="#" onclick="createDBLink()" class="btn btn-info btn-xs"><i
								class="fa fa-database"></i> 创建数据源</a></td>
					</tr>
					<tr>
						<td class="width-15 active"><label class="pull-right"><font
								color="red">*</font>存储类型：</label></td>
						<td class="width-35"><form:select path="toLink"
								class="form-control required">
								<form:options
									items="${fns:getDictListLike('dc_data_store_type')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select></td>
					</tr>
					<tr>
						<td class="width-15 active"><label class="pull-right">并行任务数：</label></td>
						<td class="width-35"><form:input path="sortNum"
								htmlEscape="false" maxlength="50" value="1"
								class="form-control isIntGtZero" /> <span class="help-inline">并行处理任务数(目标hdfs文件个数),
								默认为1</span></td>
					</tr>
				</tbody>
			</table>
		</fieldset>

		<h3>
			<br>数据源设置
		</h3>
		<fieldset>
			<legend>DataBase</legend>
			<table
				class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
				<tbody>
					<tr>
						<td class="width-15 active"><label class="pull-right"><font
								color="red">*</font>连接Schema：</label></td>
						<td class="width-35"><dc:treeselect2 allowInput="true"
								clearItem="true" id="schema" name="schemaName"
								value="${jobInfo.schemaName}" labelName="数据库Schema"
								labelValue="${jobInfo.schemaName}" notAllowSelectParent="true"
								title="Schema" url="/dc/metadata/db/schemaTreeData"
								cssClass="form-control required" validateField="fromLink"
								otherParam1="fromLink" /> <span class="help-inline">关系型数据库schema</span>
						</td>
					</tr>
					<tr>
						<td class="width-15 active"><label class="pull-right"><font
								color="red">*</font>数据表名称：</label></td>
						<td class="width-35"><dc:treeselect2 allowInput="true"
								clearItem="true" id="table" name="tableName"
								value="${jobInfo.tableName}" labelName="数据表"
								labelValue="${jobInfo.tableName}" notAllowSelectParent="true"
								title="数据表" url="/dc/metadata/db/tableTreeData"
								cssClass="form-control required"
								validateField="fromLink,schemaName" otherParam1="fromLink"
								otherParam2="schemaName" /> <span class="help-inline">需采集的源数据表</span>
						</td>
					</tr>
					<tr>
						<td class="width-15 active"><label class="pull-right"><font
								color="red">*</font>字段：</label></td>
						<td class="width-35"><dc:treeselect allowInput="true"
								clearItem="true" id="tableColumn" name="tableColumn"
								value="${jobInfo.tableColumn}" labelName="数据表字段"
								labelValue="${jobInfo.tableColumn}" notAllowSelectParent="true"
								checked="true" title="数据表字段"
								url="/dc/metadata/db/tableFieldData"
								cssClass="form-control required"
								validateField="fromLink,schemaName,tableName"
								otherParam1="fromLink" otherParam2="schemaName"
								otherParam3="tableName">
							</dc:treeselect> <a href="#" onclick="selectAllField()"
							class="btn btn-info btn-xs"><i class="fa fa-database"></i>
								全选</a></td>

					</tr>
					<tr>
						<td class="width-15 active"><label class="pull-right">分区字段：</label></td>
						<td class="width-35"><dc:treeselect allowInput="true"
								clearItem="true" id="partitionColumn" name="partitionColumn"
								value="${jobInfo.partitionColumn}" labelName="分区字段"
								labelValue="${jobInfo.partitionColumn}"
								notAllowSelectParent="true" title="分区字段"
								url="/dc/metadata/db/tableFieldData" cssClass="form-control"
								validateField="fromLink,schemaName,tableName"
								otherParam1="fromLink" otherParam2="schemaName"
								otherParam3="tableName" /> <span class="help-inline">采集任务大于1时,根据分区字段进行切分,默认为主键字段(id),也可手动指定(必须为整数型字段)</span>
						</td>
					</tr>
					<!-- 
				  <tr>
					<td class="width-15 active"><label class="pull-right">采集SQL：</label></td>
					<td class="width-35">
						<form:input path="tableSql" htmlEscape="false" class="form-control"/>
						<span class="help-inline">用户通过sql脚本自定义采集的源数据</span>
					</td>
				  </tr>
				   -->
				</tbody>
			</table>
		</fieldset>

		<h3>
			<br>存储设置
		</h3>
		<fieldset>
			<legend id="storeType">HDFS</legend>
			<div id="hdfsConfig" style="display: none;">
				<table
					class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
					<tbody>
						<tr>
							<td class="width-15 active"><label class="pull-right"><font
									color="red">*</font>保存目录：</label></td>
							<td class="width-35"><form:input path="outputDir"
									htmlEscape="false" maxlength="50" class="form-control required" />
								<span class="help-inline">HDFS结果数据存储目录</span></td>
						</tr>
						<tr>
							<td class="width-15 active"><label class="pull-right"><font
									color="red">*</font>输出格式：</label></td>
							<td class="width-35"><form:select path="outputFormat"
									class="form-control required">
									<form:option value="text" label="TEXT_FILE" />
									<form:option value="sequence" label="SEQUENCE_FILE" />
								</form:select></td>
						</tr>
						<tr>
							<td class="width-15 active"><label class="pull-right">压缩格式：</label></td>
							<td class="width-35"><form:select path="compresFormat"
									class="form-control">
									<form:option value="none" label="不压缩" />
									<form:option value="gzip" label="gzip格式" />
									<form:option value="deflate" label="deflate格式" />
									<form:option value="bzip2" label="bzip2格式" />
								</form:select></td>
						</tr>
						<!-- 
					  <tr>
						 <td  class="width-15 active" ><label class="pull-right">是否覆盖NULL值：</label></td>
						 <td class="width-35"> 
							<form:select path="overRideNull" class="form-control">
								<form:option value="1" label="是"/>
								<form:option value="0" label="否"/>
							</form:select>
						 </td>
					  </tr>
					  <tr>
						 <td  class="width-15 active" ><label class="pull-right">NULL值被替换为：</label></td>
						 <td class="width-35"> 
							<form:input path="nullValue" htmlEscape="false" maxlength="50" class="form-control" />
						 </td>
					  </tr>
					  -->
					</tbody>
				</table>
			</div>
			<div id="hiveConfig" style="display: none;">
				<table
					class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
					<tbody>
						<tr>
							<td class="width-15 active"><label class="pull-right"><font color="red">*</font>目标表名：</label></td>
							<!--  -->
							<td class="width-35">
								<form:input path="tbNameHive" htmlEscape="false" maxlength="50" class="form-control required" />
								<label>是否创建表(表名不可重复)：</label><form:checkbox path="createTbHive" onchange="updatePartition(this)"/>
								<span class="help-inline">hive的表名, 不可重复</span>
							</td>
						</tr>
						<tr class="_partiInfo">
							<td  class="width-15 active" ><label class="pull-right">分区字段：</label></td>
							<td class="width-35">
								<form:input path="partitionField" htmlEscape="false" maxlength="64" class="form-control" />
								<span class="help-inline">hive表中分区字段, 暂时仅支持一个分区字段</span>
							</td>
						</tr>
						<tr class="_partiInfo">
							<td  class="width-15 active" ><label class="pull-right">分区字段值：</label></td>
							<td class="width-35">
								<form:input path="partitionValue" htmlEscape="false" maxlength="64" class="form-control" />
								<span class="help-inline">hive表中分区字段值, 支持变量</span>
								<a href="#" onclick="showParam()" class="btn btn-info btn-xs"><i class="fa fa-hand-o-right"></i> 脚本变量参考</a>
							</td>
						</tr>
						<!-- 
					  <tr>
						 <td  class="width-15 active" ><label class="pull-right">字段分隔符：</label></td>
						 <td class="width-35"> 
							<form:input path="compresFormat" htmlEscape="false" maxlength="50" class="form-control" value="\u0001"/>
						 </td>
					  </tr>
					  <tr>
						 <td  class="width-15 active" ><label class="pull-right">NULL值被替换为：</label></td>
						 <td class="width-35"> 
							<form:input path="nullValue" htmlEscape="false" maxlength="50" class="form-control" />
						 </td>
					  </tr>
					  -->
					</tbody>
				</table>
			</div>
			<div id="hbaseConfig" style="display: none;">
				<table
					class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
					<tbody>
						<tr>
							<td class="width-15 active"><label class="pull-right"><font color="red">*</font>目标表名：</label></td>
							<!--  -->
							<td class="width-35">
								<form:input path="tbNameHbase" htmlEscape="false" maxlength="50" class="form-control required" />
								<label>是否创建表(表名不可重复)：</label> <form:checkbox path="createTbHbase" />
							</td>
						</tr>
						<tr>
							<td class="width-15 active"><label class="pull-right"><font
									color="red">*</font>主键字段：</label></td>
							<td class="width-35"><dc:treeselect allowInput="true"
									clearItem="true" id="keyField" name="keyField"
									value="${jobInfo.keyField}" labelName="分区字段"
									labelValue="${jobInfo.keyField}" notAllowSelectParent="true"
									title="主键字段" url="/dc/metadata/db/tableFieldData"
									cssClass="form-control"
									validateField="fromLink,schemaName,tableName"
									otherParam1="fromLink" otherParam2="schemaName"
									otherParam3="tableName" /></td>
						</tr>
						<tr>
							<td class="width-15 active"><label class="pull-right"><font color="red">*</font>列族名称：</label></td>
							<td class="width-35">
								<form:input path="columnFamily" htmlEscape="false" maxlength="50" class="form-control required" />
								<span class="help-inline">需指定hbase数据表的列族名称(column family),没有列族则无法采集</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<legend
				style="font-size: 16px; padding-top: 10px; font-weight: bold;">增量模式</legend>
			<div id="incrementConfig">
				<table
					class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
					<tbody>
						<tr>
							<td class="width-15 active"><label class="pull-right"><font color="red">*</font>增量方式：</label></td>
							<td class="width-35"><form:select path="incrementType" class="form-control required">
									<form:option value="whole" label="全量更新" />
									<form:option value="sequence" label="按序列增量(整数类型)" />
									<form:option value="timeStamp" label="按时间增量(时间类型)" />
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="width-15 active"><label class="pull-right">递增字段：</label></td>
							<td class="width-35">
								<%--<form:input path="incrementField" htmlEscape="false" maxlength="50" class="form-control" />--%>
								<dc:treeselect allowInput="true"
									   clearItem="true" id="incrementField" name="incrementField"
									   value="${jobInfo.incrementField}" labelName="增量字段"
									   labelValue="${jobInfo.incrementField}"
									   notAllowSelectParent="true" title="增量字段"
									   url="/dc/metadata/db/tableFieldData" cssClass="form-control"
									   validateField="fromLink,schemaName,tableName"
									   otherParam1="fromLink" otherParam2="schemaName" otherParam3="tableName" />
								<span class="help-inline">递增字段类型与'增量方式'匹配, 按序列递增时该字段必须为整数型,按时间增量时该字段需为时间型</span>
							</td>
						</tr>
						<tr>
							<td class="width-15 active"><label class="pull-right">递增字段值：</label></td>
							<td class="width-35">
								<form:input path="incrementValue" htmlEscape="false" maxlength="50" class="form-control" />
								<span class="help-inline">递增字段值每次采集后自动更新</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>

		<h3>
			<br>采集脚本
		</h3>
		<fieldset>
			<legend>sqoop命令</legend>
			<div class="form-group">
				<div class="col-sm-12">
					<textarea id="remarks" name="remarks" title="sqoop脚本" style="height: 320px;" class="form-control span12">${jobInfo.remarks}</textarea>
				</div>
			</div>
		</fieldset>

	</form:form>

	<script>
		var validateForm;
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index, table) {
			setTimeout(function(){//TODO待后期优化
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
			//top.layer.load(1)
			
			top.layer.open(option);
		}
		
		//添加数据源连接选项 被子页面调用
		function appendDataLink(result){
			if (result && result.flag == '1'){
				$('#fromLink').prepend("<option value='"+result.itemValue+"' selected='selected'>"+result.itemLabel+"</option>");
			}
			return false;
		}
		
		//选择数据表 TODO: 暂不实现
		function queryTable(){
			
		}
		var table;
		//设置当前页 IndexId
		function setPIndexId(val,t){
			table=t;
			$('#cur_indexId').val(val);
		}
		function arr_max(array){ 
			return Math.max.apply( Math, array );
		}
		setTimeout(function(){
			/*---------*/
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
				//console.log(arguments);
				if (currentIndex > newIndex) {
					return true;
				}
				if (currentIndex < newIndex) {
					form.find(".body:eq(" + newIndex + ") label.error").remove();
					form.find(".body:eq(" + newIndex + ") .error").removeClass("error");
				}
				//存储设置
				if(newIndex==2){
					if($('#toLink').val()=='1'){		//hdfs
						$('#storeType').text('HDFS');
						$('#hdfsConfig').show();
						$('#hiveConfig').hide();
						$('#hbaseConfig').hide();
						$('#tbNameHive').removeClass("required");
						$('#tbNameHbase').removeClass("required");
						$('#keyField').removeClass("required");
						$('#columnFamily').removeClass("required");
						$('#outputDir').addClass("required");
						$('#outputFormat').addClass("required");
						
					}else if($('#toLink').val()=='2'){	//hive
						$('#storeType').text('HIVE');
						$('#hdfsConfig').hide();
						$('#hbaseConfig').hide();
						$('#hiveConfig').show();
						$('#tbNameHive').addClass("required");
						$('#tbNameHbase').removeClass("required");
						$('#keyField').removeClass("required");
						$('#columnFamily').removeClass("required");
						$('#outputDir').removeClass("required");
						$('#outputFormat').removeClass("required");

					}else if($('#toLink').val()=='3'){	//hbase
						$('#storeType').text('HBASE');
						$('#hdfsConfig').hide();
						$('#hiveConfig').hide();
						$('#hbaseConfig').show();
						$('#tbNameHbase').addClass("required");
						$('#keyField').addClass("required");
						$('#columnFamily').addClass("required");
						$('#tbNameHive').removeClass("required");
						$('#outputDir').removeClass("required");
						$('#outputFormat').removeClass("required");
					}
				}
				//采集脚本设置 采集脚本设置  
				//oracle: sudo -u hdfs sqoop import --connect jdbc:oracle:thin:@10.1.20.86:1521:orcl --connection-manager org.apache.sqoop.manager.OracleManager --username HZHLDC --password hzhlDC --target-dir /tmp/oracle/test_3   --table HZHLDC.T_OPERATE_LOG -m 6 --columns aa,b,cc
				//mysql: sudo -u hdfs sqoop import --connect jdbc:mysql://10.1.20.86:3306/test 
				if(newIndex==3){
				    //hdfs用户执行sqoop命令有时有异常信息: --merge-key or --append is required when using --incremental lastmodified and the output directory exists
//					var sqoopScript = 'sudo -u hdfs sqoop import -m '+$('#sortNum').val()+' --table '+$('#tableId').val();
					var sqoopScript = 'sqoop import -m '+$('#sortNum').val()+' --table '+$('#tableId').val();
					if('*'!=$('#tableColumnId').val()){
						sqoopScript+=' --columns '+$('#tableColumnId').val();
					}
					var	incrementType=$('#incrementType').val(),
						incrementField = $('#incrementFieldId').val(),
						incrementValue = $('#incrementValue').val();
					//	compresFormat = $('#compresFormat').val(),
					//	nullValue = $('#nullValue').val();
					//增量方式
					if('whole'!==incrementType){
						sqoopScript += ' --check-column '+incrementField;
						if(incrementValue){
							sqoopScript += " --last-value '"+incrementValue+"' ";
						}
						if('sequence'===incrementType){			//按序列递增 –incremental append  –check-column num_iid –last-value 0
							sqoopScript += ' --incremental append ';
						}else if('timeStamp'===incrementType){	//按时间递增 –incremental lastmodified –check-column created –last-value '2012-02-01 11:0:00'
							sqoopScript += ' --incremental lastmodified ';
						}
					}
			
					if($('#toLink').val()=='1'){	//1-hdfs存储, 采集脚本
						$('#remarks').val(buildTransHdfsScript(sqoopScript));
						
					}else if($('#toLink').val()=='2'){	//2-hive存储, 采集脚本
						$('#remarks').val(buildTransHiveScript(sqoopScript));

					}else if($('#toLink').val()=='3'){	//3-hbase存储, 采集脚本
						$('#remarks').val(buildTransHbaseScript(sqoopScript));
					}
					
				}
				//忽略隐藏字段的验证
				form.validate().settings.ignore = ":disabled,:hidden";
				return form.valid();
			},
			onStepChanged : function (event, currentIndex, priorIndex) {
				//console.log("onStepChanged!");
				//如果已经进行的最后一步
				/* $('.content').css({'minHeight':''});
				var body_height = $('body').height();
				var min_height = $('.content').find('fieldset').eq(currentIndex).innerheight();
				$('.content').css({'minHeight':min_height}); */
				if($('.steps>ul').find('li').eq(currentIndex+1).hasClass('last') || $('.steps>ul').find('li').eq(currentIndex).hasClass('last')){//进行到第三步就允许提交
					$('.actions').find('a[href=#next]').parent().show();
					$('.actions').find('a[href=#finish]').parent().removeClass('disabled');
				}				
				$('.position_line .position_child').eq(currentIndex).css({//步骤颜色改变
					"background":"#388bc2"
				});
			},
			onCanceled: function (event) { 
				top.layer.close($('#cur_indexId').val());
				//top.layer.closeAll();
			},
			onFinishing : function (event, currentIndex) {
				form.validate().settings.ignore = ":disabled";
				return form.valid();
			},
			onFinished : function (event, currentIndex) {
				top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>'});
				submitData('${ctx}/dc/dataProcess/transJob/ajaxSave', getFormParams('inputForm'), function (data) {
					top.layer.closeAll('loading');
					top.layer.alert(data.msg, {
						title : '系统提示'
					});
					if(data.success){	//保存成功
                         if(typeof(table)==='object'){
                             table.ajax.reload(); //刷新父页面
                         }
						//刷新表格
						table.ajax.reload();
						//关闭form面板 TODO
						top.layer.close($('#cur_indexId').val());
					 }
				});
			}
		});	
		
		/**
		 * 构建HDFS转换脚本 
		 */
		function buildTransHdfsScript(sqoopScript){			
			sqoopScript += ' --target-dir '+$('#outputDir').val();
			var	splitCol=$('#partitionColumn').val(),
				outputFormat = $('#outputFormat').val(),
				compresFormat = $('#compresFormat').val(),
				nullValue = $('#nullValue').val();
				
			//分区字段
			if(splitCol){
				sqoopScript += ' --split-by '+splitCol ;
			}
			//输出格式 默认为txt
			if(outputFormat=='sequence'){
				sqoopScript += ' --as-sequencefile ';
			}
			//压缩格式
			if(compresFormat && 'none'!=compresFormat){
				sqoopScript += ' -z,--compress --compression-codec '+compresFormat;
			}
			//替换null值
			if(nullValue){
				sqoopScript += ' --null-string '+nullValue;
			}
			return sqoopScript;
		}
		
		/**
		 * 构建Hive转换脚本 
		 */
		function buildTransHiveScript(sqoopScript){
			//创建表 spring form checkbox 控件转换时加1
			if($('#createTbHive1').attr('checked')){
				sqoopScript += ' --create-hive-table '
			}
			sqoopScript += ' --hive-table '+$('#tbNameHive').val()+' --hive-import ';

            if($('#partitionField').val() && $('#partitionValue').val()){	//分区信息
                sqoopScript += " --hive-partition-key '"+$('#partitionField').val()+"' --hive-partition-value '"+$('#partitionValue').val()+"' ";
            }

            /**字段分隔符
			if(compresFormat){
				sqoopScript += ' --fields-terminated-by '+compresFormat;
			}
			//NULL值被替换为
			if(nullValue){
				sqoopScript += ' --input-null-string '+nullValue+' --input-null-non-string '+nullValue;
			}**/
			
			return	sqoopScript;
		}
		/**
		 * 构建Hbase转换脚本 
		 */
		function buildTransHbaseScript(sqoopScript){
			//创建表
			if($('#createTbHbase1').attr('checked')){
				sqoopScript += ' --hbase-create-table '
			}
			sqoopScript += ' --hbase-table '+$('#tbNameHbase').val()+' --column-family '+$('#columnFamily').val()+' --hbase-row-key '+$('#keyFieldName').val();		
			
			return	sqoopScript;
		}
		
		//选择全部字段
		function selectAllField(){
			$('#tableColumnName').val('*');
			$('#tableColumnId').val('*');
		}

		//更新hive分区字段信息
        function updatePartition(obj) {
		    if(obj.checked){	//新建表时 隐藏分区字段
				$('tr._partiInfo').hide();
				$('#partitionField').val('');
				$('#partitionValue').val('');
			}else{
                $('tr._partiInfo').show();
			}
        }


        $(document).ready(function() {
			$("#jobName").focus();
			validateForm = $("#inputForm").validate({
				rules: {
					jobName: {remote: "${ctx}/dc/dataProcess/transJob/checkJobName?oldJobName=" + encodeURIComponent('${jobInfo.jobName}')}//设置了远程验证，在初始化时必须预先调用一次。
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
			
			//绑定'增量方式'选择事件, 增量采集,需设置增量字段, 
			$('#incrementType').change(function(){ 
				var incremType=$(this).children('option:selected').val();	//这就是selected的值
				if('whole'==incremType){
					$('#incrementField').removeClass("required");
					$('#incrementField-error').hide();
				}else{
					$('#incrementField').addClass("required");
				}
			})

            if($('#createTbHive1').attr('checked')){
                $('tr._partiInfo').hide();
            }else{
                $('tr._partiInfo').show();
            }
		});

        function cleartd() {

            document.getElementById('schemaName').value=' ';
            document.getElementById('tableName').value=' ';
            document.getElementById('tableColumnName').value=' ';
            document.getElementById('incrementFieldId').value=' ';

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