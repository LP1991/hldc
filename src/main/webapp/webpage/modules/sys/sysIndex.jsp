<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <!-- <link rel="shortcut icon" href="../static/common/img/favicon.ico"> -->
    <link rel="shortcut icon" href="${ctxStatic}/common/img/favicon.ico">
    <title>${fns:getConfig('system.productName')}</title>

	<%@ include file="/webpage/include/head.jsp"%>
	<script src="${ctxStatic}/common/inspinia.js?v=3.2.0"></script>
	<script src="${ctxStatic}/common/contabs.js"></script>
	<c:if test="${fns:getConfig('system.portalMode')}">
	<script type="text/javascript">
		$(document).ready(function() {
			$(".open-small-mirror").click(function () {
		        if($('.top-menu-hide').is(':hidden')){
		            $('.top-menu-hide').show(500,function(){});
		            $('#small-mirror i').removeClass("fa-search");
		            $('#small-mirror i').addClass("fa-times");
		        }else{
		            $('.top-menu-hide').hide(500,function(){});
		            $('#small-mirror i').addClass("fa-search");
		            $('#small-mirror i').removeClass("fa-times");
		        }
		    });
			$('.one-info-detail').hover(function(e) {
					$(this).children('.delete-btn-a').css("display", "inline-block");
				}, function() {
					$(".delete-btn-a").css("display", "none");
				}), $('.delete-btn-a').click(function(e) {
					$(this).children('.delete-btn-a').css("display", "inline-block");
					$(this).parents('.one-info-detail').remove();
				})
			});
	</script>
	</c:if>
</head>

<body class="fixed-sidebar full-height-layout gray-bg fixed-nav skin-6">
    <div id="wrapper">
        <!--左侧导航开始-->
        <nav class="navbar-default navbar-static-side" role="navigation">
            <div class="nav-close"><i class="fa fa-times-circle"></i>
            </div>
            <div class="sidebar-collapse">
                <ul class="nav" id="side-menu">
                	<li class="">
                        <div class="dropdown ">
                            <a class="navbar-minimalize minimalize-styl-2 btn btn-success " href="#" style="float:none;"><i class="fa fa-bars"></i> </a>
                        </div>
                       
                    </li>
                  <t:menu  menu="${fns:getTopMenu()}"></t:menu>
                </ul>
            </div>
        </nav>
        <!--左侧导航结束-->
        <!--右侧部分开始-->
        <div id="page-wrapper" class="gray-bg dashbard-1">
            <div class="row border-bottom">
                <nav class="navbar navbar-fixed-top maxh" role="navigation" style="margin-bottom: 0">
                    <div class="navbar-header">
                    
                       <!--  <form role="search" class="navbar-form-custom" method="post" action="search_results.html">
                            <div class="form-group">
                                <input type="text" placeholder="请输入您需要查找的内容 …" class="form-control" name="top-search" id="top-search">
                            </div>
                        </form> -->
                        <a href="${ctx}/dc/dataSearch/retrieval/index"  class="pt font-bold"> <span ><img src='${ctxStatic}/dc/img/logo_dc.png'><!-- 数据平台 --></span><!-- <div class="hidden-xs logo"></div> --></a>
                        <span class="hidden-xs pt inline"><!-- 数据平台 --></span>
                    </div>
                    <ul class="nav navbar-top-links navbar-right">
						<li class="dropdown ">
                                <a data-toggle="dropdown" class="dropdown-toggle" href="#" style="padding:4px 5px 2px 5px;">
                                <span ><img alt="image" class="img-circle" src="${fns:getUser().photo }" onerror="nofind('${ctxStatic}/common/img/User1.png');"  style="width:39px;height:39px;"/></span>
                               <!-- 单行-->
                               <div class="inline">
                                   <strong class="font-bold">欢迎,</strong>
                                    <span class="text-xs ">${fns:getUser().name}<b class="caret"></b></span>
                               </div>

                                </a>
                                <ul class="dropdown-menu animated fadeInRight ">
                                    <li><a class="J_menuItem" href="${ctx}/sys/user/imageEdit">修改头像</a>
	                                </li>
	                                <li><a class="J_menuItem" href="${ctx }/sys/user/info">个人资料</a>
	                                </li>
	                                <li class="divider"></li>
	                               <!--  <li><a onclick="changeStyle('ace')" href="#">切换到ACE模式</a>
	                                </li> 
	                                
	                                <li><a onclick="changeStyle('shortcut')" href="#">切换到shortcut模式</a>
	                                </li> 
	                                
	                                <li><a onclick="changeStyle('sliding')" href="#">切换到sliding模式</a>
	                                </li>  -->
	                                <li class="divider"></li>
                                </ul>
                        </li>
                        <li class="dropdown ">
                            <a href="${ctx}/logout"><i class="fa fa fa-sign-out"></i> <span class="hidden-xs">退出</span></a>
                        </li>
                    </ul>
                </nav>
            </div>
            <div class="row content-tabs">
                <button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i>
                </button>
                <nav class="page-tabs J_menuTabs">
                    <div class="page-tabs-content">
                        <a href="javascript:;" class="active J_menuTab" data-id="${ctx}/home">首页</a>
                    </div>
                </nav>
                <button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
                </button>
                <div class="btn-group roll-nav roll-right">
                    <button class="dropdown J_tabClose"  data-toggle="dropdown">关闭操作<span class="caret"></span>

                    </button>
                    <ul role="menu" class="dropdown-menu dropdown-menu-right">
                        <li class="J_tabShowActive"><a>定位当前选项卡</a>
                        </li>
                        <li class="divider"></li>
                        <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
                        </li>
                        <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="row J_mainContent" id="content-main">
                <iframe class="J_iframe" name="iframeindex" width="100%" height="100%" src="${ctx}/home" frameborder="0" data-id="${ctx}/home" seamless></iframe>
            </div>
        </div>
        <!--右侧部分结束-->

		<c:if test="${fns:getConfig('system.portalMode')}">
		<!--门户模式开始-->
		<!-- <div id="small-mirror">
			<a class="open-small-mirror btn-small"> <i
				class="ace-icon fa fa-search"></i>
			</a>
		</div> -->

		<div class="top-menu-hide container" id="top-menu-hide"style="overflow-y: scroll;">
			<div class="row">
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">
					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							<div class="one-info-detail">
								<a href="#">角色管理1&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理2&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							
						</div>
					</div>
				</div>
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">

					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							
						</div>
					</div>
				</div>
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">

					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							
						</div>
					</div>
				</div>
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">

					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							
						</div>
					</div>
				</div>
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">

					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							
						</div>
					</div>
				</div>
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">

					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							<div class="one-info-detail">
								<a href="#">角色管理1&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理2&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理3&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理4&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理5&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理6&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理7&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理8&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
						</div>
					</div>
				</div>
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">

					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							<div class="one-info-detail">
								<a href="#">角色管理1&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理2&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理3&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理4&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理5&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理6&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理7&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理8&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
						</div>
					</div>
				</div>
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">

					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							<div class="one-info-detail">
								<a href="#">角色管理1&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理2&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理3&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理4&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理5&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理6&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理7&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理8&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
						</div>
					</div>
				</div>
				<div class="top-menu-one-div col-lg-4 col-sm-6 col-xs-12">

					<div class="top-menu-one-con row">
						<div class="top-menu-one-con-img col-sm-3">
							<i class="fa fa-desktop"></i>
							<div class="kshpt">可视化平台</div>
						</div>
						<div class="top-menu-one-con-text col-sm-9">
							<div class="one-info-detail">
								<a href="#">角色管理1&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理2&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理3&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理4&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理5&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理6&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理7&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
							<div class="one-info-detail">
								<a href="#">角色管理8&nbsp;&nbsp;2016-04-09 &nbsp;08:00AM</a> <span
									class="delete-btn-a">|&nbsp;X</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--门户模式结束-->
		</c:if>
	</div>
</body>
<c:if test="${fns:getConfig('im.start')}">
<!-- 即时聊天插件开始 -->
<link href="${ctxStatic}/layer-v2.3/layim/layui/css/layui.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript">
var currentId = '${fns:getUser().loginName}';
var currentName = '${fns:getUser().name}';
var currentFace ='${fns:getUser().photo}';
var url="${ctx}";
var static_url="${ctxStatic}";
var wsServer = 'ws://'+window.document.domain+':8668'; 

</script>
<!--webscoket接口  -->
<script src="${ctxStatic}/layer-v2.3/layim/layui/layui.js"></script>

<script src="${ctxStatic}/layer-v2.3/layim/layim.js"></script>
<!-- 即时聊天插件 结束 -->
<style>
/*签名样式*/
.layim-sign-box{
	width:95%
}
.layim-sign-hide{
  border:none;background-color:#F5F5F5;
}
</style>
</c:if>
</html>