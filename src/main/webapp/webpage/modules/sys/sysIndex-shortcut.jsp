<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE html >
<html>
<head>
<title>Jeecg 快速开发平台</title>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script type="text/javascript" src="${ctxStatic}/jquery/jquery-1.8.3.js" ></script>
<script type="text/javascript" src="${ctxStatic}/jquery-plugin/storage/jquery.storageapi.min.js">
</script>
<script type="text/javascript" src="${ctxStatic}/tools/dataformat.js"></script>
<link id="easyuiTheme" rel="stylesheet" href="${ctxStatic}/easyui/themes/default/easyui.css" type="text/css"></link>
<link id="easyuiTheme" rel="stylesheet" href="${ctxStatic}/easyui/themes/icon.css" type="text/css"></link>
<link rel="stylesheet" type="text/css" href="${ctxStatic}/accordion/css/accordion.css">
<link rel="stylesheet" type="text/css" href="${ctxStatic}/accordion/css/icons.css">
<script type="text/javascript" src="${ctxStatic}/easyui/jquery.easyui.min.1.3.2.js"></script>
<script type="text/javascript" src="${ctxStatic}/easyui/locale/zh-cn.js"></script>
<script type="text/javascript" src="${ctxStatic}/tools/syUtil.js"></script>
<script type="text/javascript" src="${ctxStatic}/easyui/extends/datagrid-scrollview.js"></script>
<link rel="stylesheet" href="${ctxStatic}/tools/css/common.css" type="text/css"></link>
<script type="text/javascript" src="${ctxStatic}/lhgDialog/lhgdialog.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/tools/curdtools_zh-cn.js"></script>
<script type="text/javascript" src="${ctxStatic}/tools/easyuiextend.js"></script>
<script type="text/javascript" src="${ctxStatic}/jquery-plugin/hftable/jquery-hftable.js"></script>
<script type="text/javascript" src="${ctxStatic}/tools/json2.js" ></script>
<link rel="stylesheet" href="${ctxStatic}/jquery/jquery-autocomplete/jquery.autocomplete.css" type="text/css"></link>
<script type="text/javascript" src="${ctxStatic}/jquery/jquery-autocomplete/jquery.autocomplete.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/easyui/portal/jquery.portal.js"></script>
<link rel="stylesheet" type="text/css" href="${ctxStatic}/easyui/portal/portal.css">
<link rel="shortcut icon" href="${ctxStatic}/common/img/favicon.ico">
<link rel="stylesheet" href="${ctxStatic}/accordion/css/icons.css" type="text/css"></link>
<link rel="stylesheet" href="${ctxStatic}/accordion/css/accordion.css" type="text/css"></link>
<script type="text/javascript" src="${ctxStatic}/mutiLang/zh-cn.js"></script>
<script type="text/javascript" src="${ctxStatic}/accordion/js/left_shortcut_menu.js"></script>
<style type="text/css">
a {
	color: Black;
	text-decoration: none;
}

a:hover {
	color: black;
	text-decoration: none;
}
.tree-node-selected{
    background: #eaf2ff;
}
</style>
<SCRIPT type="text/javascript">

	$(function() {
		/* $('#layout_jeecg_onlineDatagrid').datagrid({
			url : 'systemController.do?datagridOnline&field=ip,logindatetime,user.userName,',
			title : '',
			iconCls : '',
			fit : true,
			fitColumns : true,
			pagination : true,
			pageSize : 10,
			pageList : [ 10 ],
			nowarp : false,
			border : false,
			idField : 'id',
			sortName : 'logindatetime',
			sortOrder : 'desc',
			frozenColumns : [ [ {
				title : '编码',
				field : 'id',
				width : 150,
				hidden : true
			} ] ],
			columns : [ [ {
				title : '登录名',
				field : 'user.userName',
				width : 130,
				align : 'center',
				sortable : true,
				formatter : function(value, rowData, rowIndex) {
					return formatString('<span title="{0}">{1}</span>', value, value);
				}
			}, {
				title : 'IP',
				field : 'ip',
				width : 150,
				align : 'center',
				sortable : true,
				formatter : function(value, rowData, rowIndex) {
					return formatString('<span title="{0}">{1}</span>', value, value);
				}
			}, {
				title : '登录时间',
				field : 'logindatetime',
				width : 150,
				sortable : true,
				formatter : function(value, rowData, rowIndex) {
					return formatString('<span title="{0}">{1}</span>', value, value);
				},
				hidden : true
			} ] ],
			onClickRow : function(rowIndex, rowData) {
			},
			onLoadSuccess : function(data) {
				$('#layout_jeecg_onlinePanel').panel('setTitle', '( ' + data.total + ' )' + ' 人在线');
			}
		}).datagrid('getPager').pagination({
			showPageList : false,
			showRefresh : false,
			beforePageText : '',
			afterPageText : '/{pages}',
			displayMsg : ''
		});		 */
		
		$('#layout_jeecg_onlinePanel').panel({
			tools : [ {
				iconCls : 'icon-reload',
				handler : function() {
					$('#layout_jeecg_onlineDatagrid').datagrid('load', {});
				}
			} ]
		});
		
		$('#layout_east_calendar').calendar({
			fit : true,
			current : new Date(),
			border : false,
			onSelect : function(date) {
				$(this).calendar('moveTo', new Date());
			}
		});
		$(".layout-expand").click(function(){
			$('#layout_east_calendar').css("width","auto");
			$('#layout_east_calendar').parent().css("width","auto");
			$("#layout_jeecg_onlinePanel").find(".datagrid-view").css("max-height","200px");
			$("#layout_jeecg_onlinePanel .datagrid-view .datagrid-view2 .datagrid-body").css("max-height","180px").css("overflow-y","auto");
		});
	});
	var onlineInterval;
	
	function easyPanelCollapase(){
		window.clearTimeout(onlineInterval);
	}
	function easyPanelExpand(){
		onlineInterval = window.setInterval(function() {
			$('#layout_jeecg_onlineDatagrid').datagrid('load', {});
		}, 1000 * 20);
	}

    function panelCollapase(){
        $(".easyui-layout").layout('collapse','north');
    }
	
	/* $(document).ready(function(){
		var url = "noticeController.do?getNoticeList";
		var roll = false;
		$.ajax({
    		url:url,
    		type:"GET",
    		dataType:"JSON",
    		async: false,
    		success:function(data){
    			if(data.success){
    				var noticeList = data.attributes.noticeList;
    				var noticehtml = "";
    				if(noticeList.length > 0){
    					noticehtml = noticehtml + "<marquee behavior='scroll'><a href='javascript:goNotice(1);'>";
        				for(var i=0;i<noticeList.length;i++){
        					noticehtml = noticehtml + noticeList[i].noticeTitle + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        				}
        				noticehtml = noticehtml + "</a></marquee>";
        				$("#notice").html(noticehtml);
    					roll = true;
    					$("#noticeTitle").show();
    					$("#notice").show();
    				}else{
    					$("#noticeTitle").hide();
    					$("#notice").hide();
    				}
    			}
    		}
    	});
	}); */
    
    function goNotice(id){
    	var addurl = "noticeController.do?noticeList";
  		createdetailwindow("通知公告", addurl, 800, 400);
    }
</SCRIPT>
</head>
<body class="easyui-layout" style="overflow-y: hidden" scroll="no">
<!-- 顶部-->
<div region="north" border="false" title="" style="BACKGROUND: #A8D7E9; height: 100px; padding: 1px; overflow: hidden;">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td align="left" style="vertical-align: text-bottom">
    <img src="${ctxStatic}/login/images/logo.jpg"> 
    <!--
        <img src="${ctxStatic}/login/images/toplogo.png" width="550" height="52" alt="">-->
        <div style="position: absolute; top: 75px; left: 33px;">JEECG Framework <span style="letter-spacing: -1px;"> 3.6.5</span></div>
    </td>
    <td align="right" nowrap>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr style="height: 25px;" align="right">
                <td style="" colspan="2">
                    <div style="background: url(${ctxStatic}/login/images/top_bg.jpg) no-repeat right center; float: right;">
                    <div style="float: left; line-height: 25px; margin-left: 70px;">
                    	<div style="float: left; line-height: 25px; margin-left: 70px;">
							<div id="noticeTitle" style="display:none;float:left;text-align:center;color: rgb(255, 255, 255);width: 40px; background: rgb(90, 166, 40);">公告</div>
							<div id="notice" style="display:none;float:left;width: 240px; background: rgb(0, 160, 160);margin-right: 20px; height: 25px;">	
						</div>
                        <span style="color: #386780"><img src="${ctxStatic}/login/images/user.png"></span> 
                        <span style="color: #FFFFFF">admin</span>&nbsp;&nbsp;&nbsp;&nbsp;
                        <span style="color: #386780">机构:</span>
                        <span style="color: #FFFFFF">JEECG开源社区</span>&nbsp;&nbsp;&nbsp;&nbsp;
                        <span style="color: #386780">角色:</span>
                        <span style="color: #FFFFFF">管理员</span>
                    </div>
                    <div style="float: left; margin-left: 18px;">
                        <div style="right: 0px; bottom: 0px;">
                            <a href="javascript:void(0);" class="easyui-menubutton" menu="#layout_north_kzmbMenu" iconCls="icon-comturn" style="color: #FFFFFF">
                                控制面板
                            </a>&nbsp;&nbsp;
                            <a href="javascript:void(0);" class="easyui-menubutton" menu="#layout_north_zxMenu" iconCls="icon-exit" style="color: #FFFFFF">
                                注销
                            </a>
                        </div>
                        <div id="layout_north_kzmbMenu" style="width: 100px; display: none;">
                            <div onclick="openwindow('个人信息','userController.do?userinfo')">
                                个人信息
                            </div>
                            <div class="menu-sep"></div>
                            <div onclick="add('修改密码','userController.do?changepassword','',550,200)">
                                修改密码
                            </div>
                            <div class="menu-sep"></div>
                            <div onclick="openwindow('系统消息','tSSmsController.do?getSysInfos')">
                                系统消息
                            </div>
                            <div class="menu-sep"></div>
                            <div onclick="add('切换页面风格','userController.do?changestyle','',550,200)">
                                切换页面风格
                            </div>
                            <div onclick="changeStyle('default')">
                       		 	默认主题
                   			 </div>
                             <div onclick="clearLocalstorage()">
                       		 	清除缓存
                   			 </div>
                        </div>
                        <div id="layout_north_zxMenu" style="width: 100px; display: none;">
                            <div onclick="exit('loginController.do?logout','确定退出该系统吗 ?',1);">
                                退出
                            </div>
                        </div>
                    </div>
                    <div style="float: left; margin-left: 8px;margin-right: 5px; margin-top: 5px;">
                        <img src="${ctxStatic}/easyui/themes/default/images/layout_button_up.gif"
                             style="cursor:pointer" onclick="panelCollapase()" />
                    </div>
                    </div>
                </td>
            </tr>
            <!-- <tr style="height: 80px;">
                <td colspan="2">
                    <ul class="shortcut">
                        动态生成并赋值过来
                    </ul>
                </td>
            </tr> -->
            <tr style="height: 80px;">
                <td colspan="2">
                   <ul class="shortcut">
                        <!-- 动态生成并赋值过来 -->
                    </ul>
                </td>
            </tr>
        </table>
    </td>
</tr>
</table>
</div>
<!-- 左侧-->
<div region="west" split="true"  title="导航菜单" style="width: 200px; padding: 1px;">
<t:shortcutMenu menu="${fns:getTopMenu()}"></t:shortcutMenu>
</div>
<!-- 中间-->
<div id="mainPanle" region="center" style="overflow: hidden;">
    <div id="maintabs" class="easyui-tabs" fit="true" border="false">
        <div class="easyui-tab" title="首页" href="${ctx}/home" style="padding: 2px;"></div>
    </div>
</div>
<!-- 右侧 -->
<div collapsed="true" region="east" iconCls="icon-reload" title="辅助工具" split="true" style="width: 190px;"
	data-options="onCollapse:function(){easyPanelCollapase()},onExpand:function(){easyPanelExpand()}">
	<!--
    <div id="tabs" class="easyui-tabs" border="false" style="height: 240px">
        <div title='日历' style="padding: 0px; overflow: hidden; color: red;">
            <div id="layout_east_calendar"></div>
        </div>
    </div>
    <div id="layout_jeecg_onlinePanel" data-options="fit:true,border:false" title=用户在线列表>
        <table id="layout_jeecg_onlineDatagrid"></table>
    </div>
    -->
    <div class="easyui-layout" fit="true" border="false">
		<div region="north" border="false" style="height:180px;overflow: hidden;">
			<div id="tabs" class="easyui-tabs" border="false" style="height: 240px">
				<div title='日历' style="padding: 0px; overflow: hidden; color: red;">
					<div id="layout_east_calendar"></div>
				</div>
			</div>
		</div>
		<div region="center" border="false" style="overflow: hidden;">
			<div id="layout_jeecg_onlinePanel" fit="true" border="false" title='用户在线列表'>
				<table id="layout_jeecg_onlineDatagrid"></table>
			</div>
		</div>
	</div>
</div>
<!-- 底部 -->
<div region="south" border="false" style="height: 25px; overflow: hidden;">
    <div align="center" style="color: #1fa3e5; padding-top: 2px">&copy;
        JEECG 版权所有
        <span class="tip">
            <a href="http://www.jeecg.org" title="JEECG Framework  3.6.5">JEECG Framework  3.6.5</a>
            (推荐谷歌浏览器，获得更快响应速度) 技术支持:
            <a href="#" title="JEECG Framework  3.6.5">JEECG Framework  3.6.5</a>
        </span>
    </div>
</div>

<div id="mm" class="easyui-menu" style="width: 150px;">
    <div id="mm-tabupdate">刷新缓存</div>
    <div id="mm-tabclose">关闭</div>
    <div id="mm-tabcloseall">全部关闭</div>
    <div id="mm-tabcloseother">除此之外全部关闭</div>
    <div class="menu-sep"></div>
    <div id="mm-tabcloseright">当前页右侧全部关闭</div>
    <div id="mm-tabcloseleft">当前页左侧全部关闭</div>
</div>
		<script type="text/javascript">
			function changeStyle(style) {
				var url='${pageContext.request.contextPath}/theme/'+style+'?url='+ window.top.location.href;
				$.get(url, function(result) {
					window.location.reload();
				});
			}
		</script>
</body>
</html>