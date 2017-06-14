<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>我的数据</title>
	<meta name="decorator" content="default"/>
	<%@include file="/webpage/include/treeview.jsp" %>
	<style type="text/css">
		.ztree {overflow:auto;margin:0;_margin-top:10px;padding:10px 0 0 10px;}
		/* 超出省略号  */
		.f_ellipses{
			display: inline-block;
		    white-space: nowrap;
		    text-overflow: ellipsis;
		    overflow: hidden;
		}
	</style>
	<script type="text/javascript">
		function refresh(){//刷新
			window.location="${ctx}/dc/metadata/dcMyObject/index";
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="我的数据分类" label="我的数据，为用户提供自定义分类收藏。" ></dc:bizHelp>
	<div id="content" class="row">
		<div id="left"  style="border:1px solid #e7eaec;" class="leftBox col-sm-1">
			<div class="" style="border-bottom:1px solid #e7eaec;text-align: center; height:32px;line-height: 32px;margin:0 -15px;">
				<span>当前分类项目：</span>
				<form:select path="curCataItem" id="curCataItem" style="width:80px;">
					<c:forEach items="${cataItemList}" var="item">
						<form:option value="${item.id}" style="width:80px;">${item.name }</form:option>
					</c:forEach>
				</form:select>
			</div>
			<div id="ztree" class="ztree leftBox-content"></div>
		</div>
		<div id="right"  class="col-sm-11  animated fadeInRight">
			<iframe id="areaContent" name="areaContent" src="${ctx}/dc/metadata/dcMyObject/list" width="100%" height="91%" frameborder="0"></iframe>
		</div>
		
	</div>
	</div>
	<script type="text/javascript">
		/**  **/
		//绑定分类项切换事件  TODO 切换分类树事件 待完善	
		$('#curCataItem').bind("change", function(){
			//console.dir(arguments)
			refreshTree($("#curCataItem").val());
			window.areaContent.searchA("${ctx}/dc/metadata/dcMyObject/ajaxlist1?objCataItem="+$(" ").val());
		});
		
		var userid='${fns:getUser().id }';
		var cookiestr="cata_tree_"+userid;
	
		var setting = {
				data:{
					simpleData:{
						enable:true,
						idKey:"id",
						pIdKey:"pId",
						rootPId:'0'
					}
				},
			callback:{
				onClick:function(event, treeId, treeNode){
					var id = treeNode.id == '0' ? '' :treeNode.id;
					window.areaContent.document.getElementById("fparent_id").value = id;
					window.areaContent.searchA("${ctx}/dc/metadata/dcMyObject/ajaxlist1?ObjType="+id);					
				},
				onExpand: onExpand,  
                onCollapse: onCollapse
			},
			view:{
				addDiyDom:addDiyDom
			}
		};
		//树节点展开事件
		function onExpand(event, treeId, treeNode){  
			var cookie = $.cookie(cookiestr);  
            var z_tree = null;  
            if(cookie){  
                z_tree = JSON.parse(cookie);  
            }  
            if(!z_tree){  
                z_tree = new Array();  
            }  
            if(jQuery.inArray(treeNode.id, z_tree)<0){  
                z_tree.push(treeNode.id);  
            }  
              
            $.cookie(cookiestr, JSON.stringify(z_tree))  
        }  
        
		//树节点收缩事件		
        function onCollapse(event, treeId, treeNode){  
        	var cookie = $.cookie(cookiestr);  
            var z_tree = null;  
            if(cookie){  
                z_tree = JSON.parse(cookie);  
            }  
            if(!z_tree){  
                z_tree = new Array();  
            }  
            var index = jQuery.inArray(treeNode.id, z_tree);  
            z_tree.splice(index, 1);  
              
            $.cookie(cookiestr, JSON.stringify(z_tree))  
        } 
		//加载数结构
	  
		function refreshTree(cataItem){
			$.getJSON("${ctx}/dc/metadata/dcMyObject/treeData?itemId="+cataItem ,function(data){
				
				//根节点(分类项)
				var tree=$.fn.zTree.init($("#ztree"), setting, data);
				var cookie = $.cookie(cookiestr);  
	            if(cookie){  //判断cookie中是否有记录
	                z_tree = JSON.parse(cookie);  
	                for(var i=0; i< z_tree.length; i++){ 
	                    var node = tree.getNodeByParam('id', z_tree[i])  
	                    tree.expandNode(node, true)  
	                }  
	            }  
			});
		}
		refreshTree('${curCataItem}');
		 
		var leftWidth = 200; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize() {
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({
				"overflow-x" : "hidden",
				"overflow-y" : "hidden"
			});
			mainObj.css("width", "auto");
			frameObj.height(strs[0] - 120);
			var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
			$("#right").width(
					$("#content").width() - leftWidth - $("#openClose").width() - 62);
			$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46-65);
		}
		//父节点字符过长而无法显示
		function addDiyDom(treeId, treeNode) {
			if(treeNode.name>10){//如果name不存在或者过长 
				$('#ztree_1_span').css({
				    'width': '64px'
				}).addClass('f_ellipses').text(treeNode.name).attr('title',treeNode.name);
			}else if(!treeNode.name){
				$('#ztree_1_span').css({
				    'width': '64px'
				}).addClass('f_ellipses').text(treeNode.id).attr('title',treeNode.id);
			}
		}
		
		
		/**
		var setting = {
			view: {
				addDiyDom: addDiyDom
			}
		}; 

		var zNodes =[
			{id:2, name:"始终显示控件", open:true,
				children:[
					   {id:21, name:"按钮1"},
					   {id:22, name:"按钮2"},
					   {id:23, name:"下拉框"},
					   {id:24, name:"文本"},
					   {id:25, name:"超链接"}
				]}
		];
		function addDiyDom(treeId, treeNode) {
			if (treeNode.parentNode && treeNode.parentNode.id!=2) return;
			var aObj = $("#" + treeNode.tId + "_a");
			if (treeNode.id == 2) {
				var editStr = "<select class='selDemo' id='diyBtn_" +treeNode.id+ "'><option value=1>1</option><option value=2>2</option><option value=3>3</option></select>";
				aObj.after(editStr);
				var btn = $("#diyBtn_"+treeNode.id);
				if (btn) btn.bind("change", function(){alert("diy Select value="+btn.attr("value")+" for " + treeNode.name);});
			}
		}

		$(document).ready(function(){
			$.fn.zTree.init($("#ztree"), setting, zNodes);
		});
		**/
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>