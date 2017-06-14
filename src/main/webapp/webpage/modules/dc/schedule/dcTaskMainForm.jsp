<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>搜索标签</title>
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/webuploader-0.1.5/webuploader.css">
	<script type="text/javascript" src="${ctxStatic}/webuploader-0.1.5/webuploader.js"></script>
	<script type="text/javascript">
	 //回调函数，在编辑和保存动作时，供openDialog调用提交表单。
	function doSubmit(index, table) {
		setTimeout(function(){//TODO待后期优化
		if(validateForm.form()){
			top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>'});
		submitData('${ctx}/dc/schedule/dcTaskMain/saveA', getFormParams('inputForm'), function (data) {
			top.layer.closeAll('loading'); 
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
				taskName: {remote: "${ctx}/dc/schedule/dcTaskMain/checkTaskName?oldTaskName=" + encodeURIComponent('${dcTaskMain.taskName}')}//设置了远程验证，在初始化时必须预先调用一次。
			},
			messages: {
				taskName: {remote: "调度任务已存在 "}
			},
			submitHandler: function(form){
				if ($("input[name='taskType']").filter(':checked').val() != "1"
					&& ($("#filePath").val()==null
						|| $("#filePath").val()=="")) {
					$("#filePatherror").show();
					return false;
				} else {
					$("#filePatherror").hide();
				}
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
		if("2"==$("input[name='taskType']:checked").val()){
 				$("#uploadjars").show();
 				$("#classNameBZ").show();
				$('#className').addClass("required");
				$('#jar').show();
				$('#sh').hide();
 				$("#methodNameTitle").text("方法名：");
 				upLoader('jar','jar','.jar');
		}else if("3"==$("input[name='taskType']:checked").val()){
			 	$("#uploadjars").show();
 				$("#classNameBZ").hide();
 				$("#methodNameTitle").text("bat或者shell文件名：");
				$('#className').removeClass("required");
				$('#jar').hide();
				$('#sh').show();
				upLoader('外部bat或者shell','sh,bat','.sh,.bat');
		}else{
			$("#uploadjars").hide();
 			$("#classNameBZ").show();				
			$('#className').addClass("required");
 			$("#methodNameTitle").text("方法名：");
		}
 		$("input[name='taskType']").on('ifChanged', function(event){  
 			if("1" == $(this).val()) { // 内部类
 				$("#uploadjars").hide();
 				$("#classNameBZ").show();				
				$('#className').addClass("required");
 				$("#methodNameTitle").text("方法名：");
 			} else if("2" == $(this).val()) { // 外部jar 需要上传jar
 				$("#uploadjars").show();
 				$("#classNameBZ").show();
				$('#className').addClass("required");
				$('#jar').show();
				$('#sh').hide();
 				$("#methodNameTitle").text("方法名：");
 				upLoader('jar','jar','.jar');
 			} else { // 外部bat或者shell 需要上传bat shell
 				$("#uploadjars").show();
 				$("#classNameBZ").hide();
 				$("#methodNameTitle").text("bat或者shell文件名：");
				$('#className').removeClass("required");
				$('#jar').hide();
				$('#sh').show();
				upLoader('外部bat或者shell','sh,bat','.sh,.bat');
 			}
 			$("#methodNameBZ").show();
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
 	 	       swf: '${ctxStatic }/webupload/Uploader.swf',  
 	 	  
 	 	       // 文件接收服务端。  
 	 	       server: '${ctx}/dc/schedule/dcTaskMain/uploadJars',  
 	 	  
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
 	       $("#fileName").val(file.name);
 	  
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
 		   console.log(file);
 		   console.log(json);
 	       $( '#'+file.id ).addClass('upload-state-done');  
 	       $("#filePath").val(json.body.directoryPath);
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
		$('#delfile').click(function() {
			$list.html("");
			$("#fileName").val("");
			$("#filePath").val("");
 	       $("#delfile").hide();
 	       $("#filePicker").show();
		});
 	   
		//一开始默认隐藏 上传jar包的tr行 
		var choice_i = $('.iradio_square-green');
		$('#uploadjars').hide();
		for(var i=0;i<choice_i.length;i++){
			if(choice_i.eq(i).find('input').attr('checked')){
				if(i>0){
					$('#uploadjars').show();
					if(i==1){
						upLoader('jar文件','jar','.jar');
					}else{
						upLoader('sh或bat文件','sh,bat','.sh,.bat');
					}
				}else{
					$('#uploadjars').hide();
				}
			}
		}
	});
	</script>
 </head> 
 <body>
<form:form id="inputForm" modelAttribute="dcTaskMain" action="#" autocomplete="off" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
				<tr id="oldTaskName">
					<td  class="width-15"  class="active"><label class="pull-right"><font color="red">*</font>任务名:</label></td>
					<td  class="width-35" ><form:input path="taskName" htmlEscape="false" maxlength="200" class="form-control required"/></td>
				</tr>
				<tr>
					<td  class="width-15"  class="active"><label class="pull-right"><font color="red">*</font>任务类型:</label></td>
					<td  class="width-35" ><form:radiobuttons path="taskType" items="${fns:getDictListLike('dc_taskType')}" itemLabel="label"
						itemValue="value" htmlEscape="false" class="required i-checks "/></td>
				</tr>
				<tr id="uploadjars">
					<td  id="jar" class="width-15"  class="active"><label class="pull-right">上传Jar包:</label></td>
					<td  id="sh" class="width-15"  class="active"><label class="pull-right">上传shell(sh或者bat):</label></td>
					<td  class="width-35" >
						<div id="uploader-demo">  
							<!--用来存放item-->  
							<div id="thelist" class="uploader-list">${dcTaskMain.fileName}</div>  
							<div>  
								<div id="filePicker">选择文件</div>
								<button id="delfile" type="button" class="btn btn-w-m btn-default" style="display:none">取消文件</button>
						 	</div>  
						</div>
						<input id="fileName" name="fileName" type="hidden" value="${dcTaskMain.fileName}"/>
						<input id="filePath" name="filePath" type="hidden" value="${dcTaskMain.filePath}"/>
						<label id="filePatherror" class="label-danger" for="filePath" style="display:none">请选择上传的文件！</label>
					</td>
				</tr>
				<tr id="classNameBZ">
					<td  class="width-15"  class="active"><label class="pull-right"><font color="red">*</font>类名(含包名):</label></td>
					<td  class="width-35" >
						<form:input path="className" htmlEscape="false" maxlength="200" class="form-control"/>
						<label class="help-inline" >内部类应实现com.hlframe.modules.dc.schedule.service.task.DcTaskService接口</label>
					</td>
				</tr>	
				 <tr id="methodNameBZ">
					<td  class="width-15"  class="active"><label class="pull-right"><font color="red">*</font><span id="methodNameTitle">方法名:</span></label></td>
					<td  class="width-35" ><form:input path="methodName" htmlEscape="false" maxlength="200" class="form-control required" /></td>
				</tr>	
				<tr>
					<td  class="width-15"  class="active"><label class="pull-right"><font color="red">*</font>优先级:</label></td>
					<td  class="width-35" ><form:input path="priority" htmlEscape="false" type="number" onblur="if(!this.value || isNaN(this.value)){this.value=''}" min="0" maxlength="200" class="form-control required"/></td>
				</tr>	
				<tr>
					<td  class="width-15"  class="active"><label class="pull-right"><font color="red">*</font>参数:</label></td>
					<td  class="width-55" ><form:input path="parameter" htmlEscape="false" maxlength="200" class="form-control required"/></td>
				</tr>
				<tr>
					<td  class="width-15"  class="active"><label class="pull-right"><font color="red"></font>任务描述:</label></td>
					<td  class="width-55" ><form:textarea path="taskDesc" htmlEscape="false" rows="4" class="form-control"/></td>
				</tr>
			</tbody>
		</table>
	</form:form>
</body>

<script type="text/javascript">  

   var flag=0;       //flag作用：分两种情况提交信息，如果是修改操作，没有修改上传文件，只修改其他字段的信息时点保存也能提交信息  
    function uploadFile(){  
        $.ajaxFileUpload({  
                url:baseURL+ "/fileCatalog.do?method=save",            //需要链接到服务器地址  
                secureuri:true,  
                fileElementId:'file',                        //文件选择框的id属性  
                success: function(data, status){     
                    var results = $(data).find('body').html();  
                    var obj = eval("("+results+")");  
                    $("#fileSize").val(obj.fileSize);  
                    $("#fileUrl").val(obj.fileUrl);  
                    $('#fileCatalogForm').submit();  
                },error: function (data, status, e){  
                        showDialogWithMsg('ideaMsg','提示','文件错误！');  
                }  
            });  
    }  
          
    function getFileName(obj)  
    {  
        flag=1;  
            var pos = -1;  
            if(obj.value.indexOf("/") > -1){  
                pos = obj.value.lastIndexOf("/")*1;  
        }else if(obj.value.indexOf("\\") > -1){  
                pos = obj.value.lastIndexOf("\\")*1;  
        }  
        var fileName =  obj.value.substring(pos+1);  
        $("#fileName").val(fileName);  
      $('.files').text(fileName);  
    }  
  
        function ev_save(){  
            if(submitMyForm('fileCatalogForm')){  
             if(flag==0){  
                $('#fileCatalogForm').submit();  
             }else{  
                uploadFile();  
             }   
           }             
         }  
  
         function ev_back(){  
        window.location.href=baseURL+'/fileCatalog.do?method=list';  
    }

</script>  
</html>