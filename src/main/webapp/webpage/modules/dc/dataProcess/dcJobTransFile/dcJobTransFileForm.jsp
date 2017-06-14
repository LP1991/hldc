<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>采集传输文件管理</title>
	<meta name="decorator" content="default"/>

	<link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
	<!--表单向导所需-->
	<link href="${ctxStatic}/jquery-steps/css/jquery.steps.css" rel="stylesheet">
	<script src="${ctxStatic}/jquery-steps/js/jquery.steps.min.js"></script>
	<!--表单向导中包含验证所需-->
	<script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/jquery.validate.min.js"></script>
	<script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/localization/messages_zh.min.js"></script>
	<script src="${ctxStatic}/dc/js/des.js"></script>

	<script type="text/javascript">

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
        });


        function doSubmit(index,table){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
            setTimeout(function(){
                if(validateForm.form()){
                    var param = getFormParams('inputForm');
                    param.paswd="XXXXXX";
                    submitData( '${ctx}/dc/dataProcess/transJobFile/ajaxSave',param,function(data){
                        var icon_number;
                        if(!data.success){
                            icon_number = 8;
                        }else{
                            icon_number = 1;
                        }
                        top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
                        if(data.success!=true){
                            return false;
                        }else{
                            //刷新表格
                            table.ajax.reload();
                            //关闭form面板
                            top.layer.close(index)
                            return true;
                        }
                    });
                }
            },1000);
        }

        function cheshi(){
            var param = getFormParams('inputForm');
            param.paswd="XXXXXX";
            submitData('${ctx}/dc/dataProcess/transJobFile/testTransFile', getFormParams('inputForm'), function (data) {
                top.layer.alert(data.msg, {
                    title : '系统提示'
                });
            });
        }
        //加密字符串, 并赋值给目标字段  直接引用dcCommon.js中的同名方法 失败, 很奇怪的问题???
        function des(str, tarField) {
            console.log(str);
            if(!str){
                top.layer.alert("该字段内容不可为空!", {icon: 8, title:'系统提示'});
            }
            if(!tarField){
                top.layer.alert("加密目标字段不存在!", {icon: 8, title:'系统提示'});
            }
            $("[id='"+tarField+"']").val(strEnc(str))
            // $('#'+tarField).val(strEnc(str));
            console.log($("[id='"+tarField+"']").val());
        }
	</script>
	<style type="text/css">
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
			/* background: #388bc2; */
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
		#inputForm .actions li:nth-child(2){
			display:block !important;
		}
		#inputForm{
			height:100%;
			margin-bottom:0 !important;
			margin-top:0 !important;
		}
		#inputForm .content{
			min-height:78%;
			margin-bottom: 0;
		}
		.actions {
			bottom:0;
		}
		#inputForm{
			width:100%;
			margin-bottom: 0 !important;
			margin-top: 0 !important;
		}
	</style>
</head>
<body class="hideScroll">
<form:form id="inputForm" modelAttribute="dcJobTransFile" autocomplete="off" action="#" method="post" class="form-horizontal" >
	<form:hidden path="id"/>
	<h3><br>创建Job</h3>
	<fieldset>
		<legend>Job 信息</legend>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font>Job名称：</label></td>
				<td class="width-35">
					<input id="oldJobname" name="oldJobname" type="hidden" value="${dcJobTransFile.jobname}">
					<form:input path="jobname" htmlEscape="false" maxlength="50" class="form-control required"/>
				</td>
			</tr>
			<tr>
				<td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>Job描述：</label></td>
				<td class="width-35">
					<form:input path="description" htmlEscape="false" maxlength="50" class="form-control required"/>
				</td>
			</tr>
			<tr>
				<td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>文件类型：</label></td>
				<td class="width-35">
					<form:select path="fileType" class="form-control required">
						<form:options items="${fns:getDictListLike('dc_file__link_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</td>
			</tr>
			</tbody>
		</table>
	</fieldset>

	<h3><br>连接设置</h3>
	<fieldset>
		<legend>连接信息</legend>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
			<tr>
				<td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>IP地址：</label></td>
				<td class="width-35">
					<form:input path="dcJobTransFileHdfs.ip" htmlEscape="false" maxlength="50" class="form-control required"/>
				</td>
			</tr>
			<tr>
				<td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>端口：</label></td>
				<td class="width-35">
					<form:input path="dcJobTransFileHdfs.port" htmlEscape="false" maxlength="50" class="form-control required"/>
				</td>
			</tr>
			<tr class="ftp">
				<td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>账号：</label></td>
				<td class="width-35">
					<form:input path="dcJobTransFileHdfs.account" htmlEscape="false" maxlength="50" class="form-control required"/>
				</td>
			</tr>
			<tr class="ftp">
				<td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>密码：</label></td>
				<td class="width-35"> <form:hidden path="dcJobTransFileHdfs.password"/>
					<input id="pswd" name="pswd" htmlEscape="false" type="password" maxlength="50" class="form-control required"  onchange="des(this.value, 'dcJobTransFileHdfs.password')"/>
				</td>
			</tr>
			<tr class="ftp">
				<td  class="width-15 active" ><label class="pull-right"><font color="red">*</font>文件路径：</label></td>
				<td class="width-35">
						<%--<form:input path="dcJobTransFileHdfs.pathname" htmlEscape="false" maxlength="50" class="form-control required"/>--%>
					<dc:treeselect2 allowInput="true" clearItem="true" id="pathname" name="dcJobTransFileHdfs.pathname" value="${dcJobTransFile.dcJobTransFileHdfs.pathname}" labelName="目标路径" labelValue="${dcJobTransFile.dcJobTransFileHdfs.pathname}" otherParam1="dcJobTransFileHdfs.ip" otherParam2="dcJobTransFileHdfs.port" otherParam3="dcJobTransFileHdfs.account" otherParam4="dcJobTransFileHdfs.password" title="目标路径" url="/dc/dataProcess/transJobFile/FtpPathTreeData" cssClass="form-control required" />
				</td>
			</tr>
			<tr><td colspan="2" align="right">
				<button class="btn btn-primary" onclick="cheshi()" type="button"><i class="fa fa-search"></i> 测试</button>
			</td></tr>
			</tbody>
		</table>
	</fieldset>
</form:form>

<script>

    var table,index;
    //设置当前页 IndexId
    function setPIndexId(val,t){
        table=t;
        index=val;
    }
    setTimeout(function(){
		/* 新增判断，解决步骤表单留白过多导致页面出现滚动条的问题  */
        var arr = $('#inputForm').find('fieldset');
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
        $('.actions').css({'right':'4%'});
		/*---------*/
        $('.actions').find('a[href=#finish]').parent().addClass('disabled');
    },1);

    //向导表单
    var form = $("#inputForm").show();
    var str = $('.layui-layer-title',parent.document).text();
    if(str.indexOf('查看')!==-1){
        $('h3').hide();
        $('#inputForm fieldset').css({'marginLeft':"2%"});
        var arr = $('td').find('input');
        for(var i=0;i<arr.length;i++){
            arr.eq(i).parent().html(arr.eq(i).val());
        }
        $('td').find('button').parent();
        $('td').find('select').parent().html($('td').find('select').val());
    }else{

        form.steps({
            headerTag : "h3",
            bodyTag : "fieldset",
            transitionEffect : "slideLeft",
            //enableCancelButton: false,
            onStepChanging : function (event, currentIndex, newIndex) {
                console.log(arguments);
                if (currentIndex > newIndex) {
                    return true;
                }
                if (currentIndex < newIndex) {
                    form.find(".body:eq(" + newIndex + ") label.error").remove();
                    form.find(".body:eq(" + newIndex + ") .error").removeClass("error");
                }
                form.validate().settings.ignore = ":disabled,:hidden";
                return form.valid();
            },
            onStepChanged : function (event, currentIndex, priorIndex) {
                if($('#fileType').val()=='FTP'){
                    $('.ftp').show()
                }else{
                    $('.ftp').hide()
                };
                if($('.steps>ul').find('li').eq(currentIndex).hasClass('last')){
                    $('.actions').find('a[href=#next]').parent().show();
                    $('.actions').find('a[href=#finish]').parent().removeClass('disabled');
                }
                $('.position_line .position_child').eq(currentIndex).css({//步骤颜色改变
                    "background":"#388bc2"
                });
            },
            onCanceled: function (event) { //取消
                console.log(arguments);
                top.layer.close(index);
            },
            onFinishing : function (event, currentIndex) {
                console.log("onFinishing!");
                var param = getFormParams('inputForm');
                param.paswd="XXXXXX";
                form.validate().settings.ignore = ":disabled";
                return form.valid();
            },
            onFinished : function (event, currentIndex) {//完成按钮触发
                top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>'});
                submitData('${ctx}/dc/dataProcess/transJobFile/ajaxSave', getFormParams('inputForm'), function (data) {
                    top.layer.closeAll('loading');
                    top.layer.alert(data.msg, {
                        title : '系统提示'
                    });
                    //刷新表格
                    table.ajax.reload();
                    //关闭form面板 TODO
                    top.layer.close(index);
                    //top.layer.closeAll();
                    //window.close();

                });
            }
        });
    }


    $(document).ready(function() {
        $("#no").focus();
        //还原密码
        $("#pswd").val(strDec('${dcJobTransFile.dcJobTransFileHdfs.password}'));
        validateForm = $("#inputForm").validate({
            rules: {
                jobname: {remote: "${ctx}/dc/dataProcess/transJobFile/checkJobName?oldJobname=" + encodeURIComponent('${dcJobTransFile.jobname}')}//设置了远程验证，在初始化时必须预先调用一次。
            },
            messages: {
                jobname: {remote: "任务名已存在"},
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