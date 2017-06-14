<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link>
    <title>${fns:getConfig('system.productName')}</title>
    <link href="${ctxStatic}/dc/css/dc.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/dc/css/global.css" rel="stylesheet" type="text/css">
	<script src="${ctxStatic}/dc/js/jquery-2.1.1.min.js"></script>
</head>
<body>
<div class="dc_container">
    <div class="dc_head">
        <div class="dc_wrap">
           <!-- logo-->
            <div class="dc_hd_logo"><a href="${homePage}"><img src="${ctxStatic}/dc/img/HLlogoBlue.png"></a></div>

            <div class="jc_hd_menu">
                <ul class="jc_hd_menu_list dc_search_ul clear">
					<li class="active on">
                        <a href="${ctx}/dc/dataSearch/retrieval/index"  class="jc_hd_list_item">首页</a>
                    </li>
					<li class="searchTo" value="table" onclick="searchTo('table')"><a class="jc_hd_list_item">数据表</a></li>
					<li class="searchTo" value="field" onclick="searchTo('field')"><a class="jc_hd_list_item">字段</a></li>
					<li class="searchTo" value="interface" onclick="searchTo('interface')"><a class="jc_hd_list_item">接口</a></li>
					<li class="searchTo" value="file" onclick="searchTo('file')"><a class="jc_hd_list_item">文件</a></li>
                    <li class="searchTo" value="folder" onclick="searchTo('folder')"><a class="jc_hd_list_item">文件夹</a></li>
                    <li class="" >
                        <a  href="${ctx}" class="jc_hd_list_item">进入控制台</a>
                    </li>				
            </div>
            <!--个人信息-->
            <div class="jc_hd_operation">
                <div class="jc_hd_login clear">

                    <div class="jc_hd_log_in" style="display: block;">
                       <span class="user"><a href="javascript:void(0)" class="user_mng"><b id="userinfo">${fns:getUser().name}</b><i class="log_in_arr"></i></a></span>
                        <span class="time" id="time" style="display:none;"></span>
                          <c:if test="${fns:getUser().name != null}">
                             <a href="${ctx}/logout" class="loginout">退出</a>
                              </c:if>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
</body>
<script >
	$(document).ready(function(){
		 tick();
	 })
	 
	function showLocale(objD)
	{
	  var hh = objD.getHours();
	   if(hh<10) hh = '0' + hh;
	  var mm = objD.getMinutes();
	   if(mm<10) mm = '0' + mm;
	  var ss = objD.getSeconds();
	   if(ss<10) ss = '0' + ss;
		   return str =  hh + ":" + mm + ":" + ss ;     
	}
	function tick()
	{
	  var today = new Date();
	  document.getElementById("time").innerHTML = showLocale(today);
	  window.setTimeout("tick()", 1000);
	}
</script>
</html>