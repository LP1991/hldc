<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>Hive函数设置</title>
	<meta name="decorator" content="default"/>
	<!-- 表单验证js -->
	<script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }
	
		  return false;
		}
		
		$(document).ready(function() {
			$("#funcName").focus();
			validateForm = $("#inputForm").validate({
				rules: {
                    funcName: {remote: "${ctx}/dc/dataProcess/dcHiveFunc/checkName?oldFuncName=" + encodeURIComponent('${dcHiveFunction.funcName}')}//设置了远程验证，在初始化时必须预先调用一次。
				},
				messages: {
                    funcName: {remote: "函数名称已存在"},
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

            var $list=$("#thelist");   //这几个初始化全局的百度文档上没说明，好蛋疼。
            function upLoader(txt,exten,mT){
                /*init webuploader*/
                //var $btn =$("#ctlBtn");   //开始上传
                var thumbnailWidth = 100;   //缩略图高度和宽度 （单位是像素），当宽高度是0~1的时候，是按照百分比计算，具体可以看api文档
                var thumbnailHeight = 100;

                var uploader = WebUploader.create({
                    // 选完文件后，是否自动上传。
                    auto: true,

                    // swf文件路径
                    swf: '${ctxStatic}/webupload/Uploader.swf',

                    // 文件接收服务端。
                    server: '${ctx}/dc/dataProcess/dcHiveFunc/uploadJars',

                    // 选择文件的按钮。可选。
                    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
                    pick: '#filePicker',

                    // 只允许选择文件。
                    accept: {
                        title:txt,
                        extensions:exten,
                        mimeTypes:mT
                    },
                    fileNumLimit: 1,
                    method:'POST',
                });
                $('#filePicker').children().eq(0).html('选择文件');
                //验证文件类型 以及报错
                uploader.on("error",function (type){
                    if (type=="Q_TYPE_DENIED"){
                        top.layer.alert("请上传"+exten+"文件", {icon: 8, title:'系统提示'})
                        //top.layer.msg("请上传"+exten+"文件");
                    }else if(type=="F_EXCEED_SIZE"){
                        top.layer.alert("文件大小不能超过限制大小 ", {icon: 8, title:'系统提示'})
                        //top.layer.msg("文件大小不能超过限制大小 ");
                    }
                });
                // 当有文件添加进来的时候
                uploader.on( 'fileQueued', function( file ) {  // webuploader事件.当选择文件后，文件被加载到文件队列中，触发该事件。等效于 uploader.onFileueued = function(file){...} ，类似js的事件定义。
                    var $li = $(
                        '<div id="' + file.id + '" class="file-item thumbnail">' +
                        '<img>' +
                        '<div class="info">' + file.name + '</div>' +
                        '</div>'
                        ),
                        $img = $li.find('img');
                    // $list为容器jQuery实例
                    $list.html("");
                    $list.append( $li );
                    $("#jarName").val(file.name);

                });
                // 文件上传过程中创建进度条实时显示。
                uploader.on( 'uploadProgress', function( file, percentage ) {
                    console.log(percentage);
                    var $li = $( '#'+file.id ),
                        $percent = $li.find('.progress span');

                    // 避免重复创建
                    if ( !$percent.length ) {
                        $percent = $('<p class="progress"><span></span></p>')
                            .appendTo( $li )
                            .find('span');
                    }

                    $percent.css( 'width', percentage * 100 + '%' );
                });

                // 文件上传成功，给item添加成功class, 用样式标记上传成功。
                uploader.on( 'uploadSuccess', function( file, json ) {

                    $( '#'+file.id ).addClass('upload-state-done');
                    $("#jarPath").val(json.body.message);
                    $("#filePicker").hide();
                    $("#delfile").show();
                });

                // 文件上传失败，显示上传出错。
                uploader.on( 'uploadError', function( file ) {
                    console.log('失败 '+file);
                    var $li = $( '#'+file.id ),
                        $error = $li.find('div.error');

                    // 避免重复创建
                    if ( !$error.length ) {
                        $error = $('<div class="error"></div>').appendTo( $li );
                    }

                    $error.text('上传失败');
                });

                // 完成上传完了，成功或者失败，先删除进度条。
                uploader.on( 'uploadComplete', function( file ) {
                    $('#'+file.id ).find('.progress').remove();
                });
            }

            upLoader('jar文件','jar','.jar');

            $('#delfile').click(function() {
                $list.html("");
                $("#jarName").val("");
                $("#jarPath").val("");
                $("#delfile").hide();
                $("#filePicker").show();
            });
		});
	</script>
</head>
<body class="hideScroll">
		<form:form id="inputForm" modelAttribute="dcHiveFunction" style="margin:0;" action="${ctx}/dc/dataProcess/dcHiveFunc/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
		   <tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>函数名称：</label></td>
					<td class="width-35">
						<input id="oldFuncName" name="oldFuncName" type="hidden" value="${dcHiveFunction.funcName}">
						<form:input path="funcName" htmlEscape="false" class="form-control required "/>
						<label class="help-inline" >使用函数时的名称</label>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">函数描述：</label></td>
					<td class="width-35">
						<form:textarea path="funcDesc" htmlEscape="false" rows="2" class="form-control "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>函数类型：</label></td>
					<td class="width-35">
						<form:select path="funcType" class="form-control required">
							<form:option value="" label="请选择"/>
							<form:options items="${fns:getDictListLike('dc_hivefunc_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr>
					<td  class="width-15 active" class="active"><label class="pull-right"><font color="red">*</font>上传jar包：</label></td>
					<td  class="width-35" >
						<div id="uploader-demo">
							<!--用来存放item-->
							<div id="thelist" class="uploader-list">${dcHiveFunction.jarName}</div>
							<div>
								<div id="filePicker">选择文件</div>
								<button id="delfile" type="button" class="btn btn-w-m btn-default" style="display:none">取消文件</button>
							</div>
						</div>
						<input id="jarName" name="jarName" type="hidden" value="${dcHiveFunction.jarName}"/>
						<input id="jarPath" name="jarPath" type="hidden" value="${dcHiveFunction.jarPath}"/>
						<label id="filePatherror" class="label-danger" for="jarPath" style="display:none">请选择上传的文件！</label>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>Class路径：</label></td>
					<td class="width-35">
						<form:input path="classPath" htmlEscape="false" class="form-control required"/>
						<label class="help-inline" >Class路径,如:com.hleast.udf.Md5</label>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">使用示例：</label></td>
					<td class="width-35">
						<form:input path="funcDemo" htmlEscape="false" class="form-control"/>
						<label class="help-inline" >如: select Md5('public')</label>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35">
						<form:input path="remarks" htmlEscape="false" class="form-control"/>
					</td>
				</tr>
		 	</tbody>
		</table>
	</form:form>
</body>
</html>