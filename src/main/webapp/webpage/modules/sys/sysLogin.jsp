<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="shortcut icon" href="${ctxStatic}/common/img/favicon.ico">
    <title>${fns:getConfig('system.productName')}</title>
    <link href="${ctxStatic}/dc/css/login.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/dc/css/global.css" rel="stylesheet" type="text/css">
    <script src="${ctxStatic}/dc/js/jquery-2.1.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="${ctxStatic}/dc/login/login/js/jquery-1.5.1.min.js"></script>
    <script src="${ctxStatic}/dc/login/js/jquery-1.7.2.js"></script>
	<script src="${ctxStatic}/jquery-validation/1.14.0/jquery.validate.js" type="text/javascript"></script>
	<script src="${ctxStatic}/jquery-validation/1.14.0/localization/messages_zh.min.js" type="text/javascript"></script>
	<link rel="stylesheet" href="${ctxStatic}/dc/login/login/bootstrap.min.css" />
	<link rel="stylesheet" href="${ctxStatic}/dc/login/login/css/camera.css" />
	<link rel="stylesheet" href="${ctxStatic}/dc/login/login/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="${ctxStatic}/dc/login/login/matrix-login.css" />
	<link href="${ctxStatic}/dc/login/login/font-awesome.css" rel="stylesheet" />
	<script type="text/javascript" src="${ctxStatic}/dc/login/login/js/jquery-1.5.1.min.js"></script>

	<style>
		.error label  {
			color: #fff;
			display: inline-block;
			margin-left: 5px;
		}
	</style>

	<style type="text/css">
    /*
   body{
    -webkit-transform: rotate(-3deg);
    -moz-transform: rotate(-3deg);
    -o-transform: rotate(-3deg);
	padding-top:20px;
    }
    */
      .cavs{
    	z-index:1;
    	position: fixed;
    	width:95%;
    	margin-left: 20px;
    	margin-right: 20px;
    }
   /*  canvas{
   	background: url(login/images/5267c323f.jpg) center no-repeat;
   } */

  </style>
  <script>
	function doSubmit(){
		if(validateForm.form()){
			return true;
		}else{
			return false;
		}
	}
  		//window.setTimeout(showfh,3000);
  		//window.setTimeout(showfh,3000);
  		var timer;
		function showfh(){
			fhi = 1;
			//关闭提示晃动屏幕，注释掉这句话即可
			timer = setInterval(xzfh2, 10);
		};
		var current = 0;
		function xzfh(){
			current = (current)%360;
			document.body.style.transform = 'rotate('+current+'deg)';
			current ++;
			if(current>360){current = 0;}
		};
		var fhi = 1;
		var current2 = 1;
		function xzfh2(){
			if(fhi>50){
				document.body.style.transform = 'rotate(0deg)';
				clearInterval(timer);
				return;
			}
			current = (current2)%360;
			document.body.style.transform = 'rotate('+current+'deg)';
			current ++;
			if(current2 == 1){current2 = -1;}else{current2 = 1;}
			fhi++;
		};
	</script>
</head>
<body>

	<canvas class="cavs"></canvas>
	<div style="width:100%;text-align: center;margin: 0 auto;position: absolute;">
	<div class="dc_wrap" style="z-index:1 ; margin-top: 16%">
	<form id="loginForm" class="form-signin dc_wrap" action="${ctx}/login" method="post" style="width:0px;height:0px;margin-right:40%" onsubmit = "return doSubmit();">
		<div class="login" style="border:none">
			<ul>
				 <li style="margin-right: 23%"><input type="text"  id="username" name="username" class="linput required"  value="${username}" placeholder="用户名" ></li>
				 <li style="margin-right: 23%"><input type="password" id="password" name="password" class="linput required" placeholder="密码"></li>
				 <li style="margin-right: 25%"><input value="8888" placeholder="验证码" type="text" id="validateCode" name="validateCode" maxlength="5" class="sinput ${validateCodeFlag}" style="width:199px;">
					<sys:validateCode name="validateCode" inputCssStyle="margin-bottom:5px;"/></li>
				 <li> <button type="submit" class="blue_btn"><i class="ace-icon fa fa-key"></i>登录</button></li>
				 <p class="text-center error">
					<label id="message" style="margin-left: -18%">${message}</label>
					<label id="messageBox"></label>
				 </p>
			</ul>
			
		</div>
	</form></div>
</div>
	 <div id="templatemo_banner_slide" class="container_wapper">
		 <div class="camera_wrap camera_emboss" id="camera_slide">
			<div data-src="${ctxStatic}/dc/login/login/images/5267c323f.jpg"></div>
			<div data-src="${ctxStatic}/dc/login/login/images/5267c323f.jpg"></div>
			<div data-src="${ctxStatic}/dc/login/login/images/5267c323f.jpg"></div>
			<!-- 背景图片 -->
			<!-- <c:choose>
				<c:when test="${not empty pd.listImg}">
					<c:forEach items="${pd.listImg}" var="var" varStatus="vs">
						<div data-src="login/images/${var.FILEPATH }"></div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div data-src="login/images/banner_slide_01.jpg"></div>
					<div data-src="login/images/banner_slide_02.jpg"></div>
					<div data-src="login/images/banner_slide_03.jpg"></div>
					<div data-src="login/images/banner_slide_04.jpg"></div>
					<div data-src="login/images/banner_slide_05.jpg"></div>
				</c:otherwise>
			</c:choose> -->
		 </div>
		<!-- #camera_wrap_3 -->
	</div>


	<script src="${ctxStatic}/dc/login/login/js/bootstrap.min.js"></script>

	<script src="${ctxStatic}/dc/login/login/js/jquery.easing.1.3.js"></script>
	<script src="${ctxStatic}/dc/login/login/js/jquery.mobile.customized.min.js"></script>
	<script src="${ctxStatic}/dc/login/login/js/camera.min.js"></script>
	<script src="${ctxStatic}/dc/login/login/js/templatemo_script.js"></script>
	<script src="${ctxStatic}/dc/login/login/js/ban.js"></script>
	<script type="text/javascript" src="${ctxStatic}/dc/login/js/jQuery.md5.js"></script>
	<script type="text/javascript" src="${ctxStatic}/dc/login/js/jquery.tips.js"></script>
	<script type="text/javascript" src="${ctxStatic}/dc/login/js/jquery.cookie.js"></script>

</body>
	<script type="text/javascript">
	var validateForm;
		$(document).ready(function() {

			validateForm = $("#loginForm").validate({
				 rules: {
					validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
				},
				messages: {
					username: {required: "请填写用户名."},
					password: {required: "请填写密码."} ,
					validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
				},
				errorPlacement: function(error, element) { 
					$("#message").empty();
					error.appendTo($("#messageBox"));  
				}
			});
		});
	</script>
</html>