<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>Hdfs数据采集</title>
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
		#inputForm .actions {
 			margin-left: -4%;
			position:fixed;
			bottom:15px; 
			right:4%;
		}
		#inputForm legend{
			margin-bottom:0;
		}
		#inputForm fieldset{
			overflow-y:auto;
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
			
			/*如果编辑时存在*/
			var srcHdfsAddress = document.getElementById("srcHdfsAddress").value;
			$("#srcHdfsDirp").attr("value",srcHdfsAddress);
		    $("#outPutDirp").attr("value",srcHdfsAddress);
	})
	/* 拼接hdfs数据源地址 */
	function appAddress(){
		var srcHdfsAddress = document.getElementById("srcHdfsAddress").value;
		$("#srcHdfsDirp").attr("value",srcHdfsAddress);
		$("#outPutDirp").attr("value",srcHdfsAddress);
	}
    debugger
    /*function changeval() {
        if ($('#sqr').attr('checked')) {
            checkbox:$("#sqr").attr("checked", true);

              return sqr=true;
        }else{
            checkbox :$("#sqr").attr("checked",false);
            return sqr=false;
        }
    }*/
	function cheshi(){
		var srcHdfsAddress = document.getElementById("srcHdfsAddress").value;
		top.layer.load(1,{content:'<p class="loading_style">测试中，请稍候。</p>'});		
			submitData('${ctx}/dc/dataProcess/hdfsJob/cheshi?srcHdfsAddress='+srcHdfsAddress, '', function (data) {
				top.layer.closeAll('loading'); 
				top.layer.alert(data.msg, {
					title : '系统提示'
				});
			});
	}
	</script>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<input type="hidden" id="cur_indexId"/>
	<!-- <input type="hidden" id="dbType"/> 数据库类别 -->
	<form:form id="inputForm" modelAttribute="hdfsJob" autocomplete="off" action="#" method="post" class="form-horizontal" >
		<form:hidden path="id"/>
		<h3><br>数据源设置</h3>
		<fieldset>
			<legend>源HDFS</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>源Hdfs地址：</label></td>
					 <td class="width-35"> 
					 <div class="input-group">
					 	<form:input path="srcHdfsAddress" htmlEscape="false" maxlength="50" class="form-control required" onchange="appAddress()"/>
						<span class="input-group-btn" style="vertical-align: top;">
							<button title="测试连接" onclick="cheshi()" type="button" class="btn btn-primary">
								<i class="fa fa fa-bug"></i>
							</button>
						</span>						
					 </div>
						<span class="help-inline">此处填写源Hdfs地址，填写规则例如10.10.10.10:8020</span>
					 	
					 </td>
				  </tr>
				  <tr>
					  <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>文件路径：</label></td>
					  <td class="width-35">
						  <dc:treeselect3 allowInput="true" clearItem="true" id="srcHdfsDir" name="srcHdfsDir" value="${hdfsJob.srcHdfsDir}" labelName="文件路径" labelValue="${hdfsJob.srcHdfsDir}"  title="文件路径" url="/dc/dataProcess/hdfsJob/HdfsPathTreeData" cssClass="form-control required" />
					  </td>
				  </tr>
				  <td class="active"><label class="pull-right">是否是文件夹:</label></td>
				  <td>
					  <%--<input id="sqr" name="sqr" type="checkbox" value="sqr" onchange="changeval()"  />--%>
					  <input id="sqr" name="sqr" type="checkbox" />
				  </td>
				   <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>源Hdfs版本：</label></td>
					 <td class="width-35"> 
					 <form:select path="srcHdfsVersion" class="form-control required">
							<%-- <form:option value="1" label="1.x"/> --%>
							<form:option value="0" label="2.x"/>
						</form:select>
					 </td>
				  </tr>	
			   </tbody>
			</table>
		</fieldset>
		
		<h3><br>存储设置</h3>
		<fieldset>
			<legend>目标HDFS</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
			       <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>目标路径：</label></td>
					 <td class="width-35"> 
						<%--<form:input path="outPutDir" htmlEscape="false"  maxlength="50" class="form-control required" />--%>
							<dc:treeselect2 allowInput="true" clearItem="true" id="outPutDir" name="outPutDir" value="${hdfsJob.outPutDir}" labelName="目标路径" labelValue="${hdfsJob.outPutDir}"  title="目标路径" url="/dc/dataProcess/hdfsJob/HdfsPathTreeData2" cssClass="form-control required" />
					 </td>
				  </tr>	
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>并行拷贝数：</label></td>
					 <td class="width-35">
						<form:input path="copyNum" htmlEscape="false" placeholder="请输入数字" maxlength="50" class="form-control isIntGtZero required"/>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right">是否覆盖：</label></td>
					 <td class="width-35"> 
						<form:select path="isOverride" class="form-control">
							<form:option value="1" label="是"/>
							<form:option value="0" label="否"/>
						</form:select>
					 </td>
				  </tr>
			   </tbody>
			</table>
		</fieldset>
		<h3><br>创建任务</h3>
		<fieldset>
			 <legend>任务信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active"><label class="pull-right"><font color="red">*</font>任务名称：</label></td>
					 <td class="width-35"> 
					 <input id="oldJobName" name="oldJobName" type="hidden" value="${jobInfo.jobName}">
						<form:input path="jobName" htmlEscape="false" maxlength="50" class="form-control required"/>
					 </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>任务描述：</label></td>
					 <td class="width-35"> 
						<form:input path="jobDesc" htmlEscape="false" maxlength="50" class="form-control required"/>
					 </td>
				  </tr>	
				</tbody>
			</table>
		</fieldset>
		<h3><br>采集脚本</h3>
		<fieldset>
			<legend>hadoop脚本</legend>
			 <div class="form-group">
				<div class="col-sm-12">
				   <textarea id="remarks" name="remarks" title="sqoop脚本" style="height: 320px;" class="form-control span12">${hdfsJob.remarks}</textarea>
				</div>
			</div>
		</fieldset>		
	</form:form>
	
	<script>
		
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index, table) {
			setTimeout(function(){//TODO待后期优化
			if(validateForm.form()){
			submitData('${ctx}/dc/dataProcess/hdfsJob/ajaxSave', getFormParams('inputForm'), function (data) {
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
		
		
		var table;
		//设置当前页 IndexId
		function setPIndexId(val,t){
			table=t;
			$('#cur_indexId').val(val);
		}
		
		//设置完成按钮为不可选中
		setTimeout(function(){
			/* 新增判断，解决步骤表单留白过多导致页面出现滚动条的问题  */
			/* var arr = $('#inputForm').find('fieldset');
			var height_arr = [];
			for(var i=0;i<arr.length;i++){
				height_arr.push(arr.eq(i).height());
			}
			maxHeight = Math.max.apply(Math, height_arr);
			$('#inputForm').find('legend').css({'marginBottom':'0'});
			var body_height = $('body').height();
			if(maxHeight < body_height && maxHeight < body_height-60){
				maxHeight = maxHeight + 60;
			}else{
				maxHeight = maxHeight + 20;
			}
			$('#inputForm').find('.content').css({'minHeight':maxHeight+'px'});
			$('.actions').css({'right':'4%'}); */
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
				
				//初始化采集命令  
				//sudo -u hdfs hadoop distcp -overwrite hdfs://10.1.20.137:8020/tmp/yzh hdfs://10.1.20.137:8020/tmp/yzh3
				if(newIndex==3){
					var hdfsScript = 'sudo -u hdfs hadoop distcp ';
					//是否覆盖
					if($('#isOverride').val()=='1'){
						hdfsScript += ' -overwrite ';
						
					}
					//并行采集数
					if($('#copyNum').val() && $('#copyNum').val()>0){
						hdfsScript += ' -m '+$('#copyNum').val();
			
					}
					//源HDFS版本
					if($('#srcHdfsVersion')==1){
						hdfsScript += ' hftp';
						
					}else{
						hdfsScript += ' hdfs';
						
					}
					
					//设置源&目标
					hdfsScript +='://'+$('#srcHdfsAddress').val()+$('#srcHdfsDirId').val()+' '+$('#outPutDirId').val();
					$('#remarks').val(hdfsScript);
				}
				
				form.validate().settings.ignore = ":disabled,:hidden";
				return form.valid();
			},
			onStepChanged : function (event, currentIndex, priorIndex) {
				//console.log("onStepChanged!");
				//如果已经进行的最后一步
				if($('.steps>ul').find('li').eq(currentIndex).hasClass('last') || $('.steps>ul').find('li').eq(currentIndex+1).hasClass('last')){
					$('.actions').find('a[href=#next]').parent().show();
					$('.actions').find('a[href=#finish]').parent().removeClass('disabled');
				}		
				$('.position_line .position_child').eq(currentIndex).css({//步骤颜色改变
					"background":"#388bc2"
				})
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
				var formData = getFormParams('inputForm');
                formData.sqr=$('#sqr').is(':checked')?"true":"false";
				submitData('${ctx}/dc/dataProcess/hdfsJob/ajaxSave', formData, function (data) {
					//刷新表格
					table.ajax.reload();
					top.layer.alert(data.msg, {
						title : '系统提示'
					});
					//关闭form面板 TODO
					top.layer.close($('#cur_indexId').val());
				});
			}
		});
		
		$(document).ready(function() {
			$("#no").focus();
			validateForm = $("#inputForm").validate({
				rules: {
					jobName: {remote: "${ctx}/dc/dataProcess/hdfsJob/checkJobName?oldJobName=" + encodeURIComponent('${hdfsJob.jobName}')},//设置了远程验证，在初始化时必须预先调用一次。
					srcHdfsAddress:{remote: "${ctx}/dc/dataProcess/hdfsJob/checkSrcHdfsAddress"}
					//srcHdfsDir :{remote:"${ctx}/dc/dataProcess/hdfsJob/checkSrcHdfsDir"},
					//outPutDir :{remote:"${ctx}/dc/dataProcess/hdfsJob/checkOutPutDir"}
					
				},
				messages: {
					jobName: {remote: "任务名已存在"},
					srcHdfsAddress :{remote:"源hdfs地址书写错误"}
					//srcHdfsDir :{remote:"文件路径书写错误"},
					//outPutDir:{remote:"目标路径填写错误"}
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
			//默认勾选目录标记
			if("${hdfsJob.sqr}"=="true"){
                $("#sqr").attr("checked", true);
            }
		});

	</script>
</body>
</html>