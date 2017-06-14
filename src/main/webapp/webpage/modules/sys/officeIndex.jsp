<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/webpage/include/treeview.jsp" %>
	<style type="text/css">
		.ztree {overflow:auto;margin:0;_margin-top:10px;padding:10px 0 0 10px;}
	</style>
	<script type="text/javascript">
		function refresh(){//刷新			
			window.location="${ctx}/sys/office/";
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<dc:bizHelp title="机构管理" label="" ></dc:bizHelp>
	<div class="ibox">	
	<sys:message content="${message}"/>	
	<div id="content" class="row">
		<div id="left"  class="leftBox col-sm-1" style="margin-top:50px">
			<!-- <a onclick="refresh()" class="pull-right">
				<i class="fa fa-refresh"></i>
			</a> -->
			<div id="ztree" class="ztree leftBox-content" style="margin-left:20px"></div>
		</div>
		<div id="right"  class="col-sm-11  animated fadeInRight">
			<iframe id="officeContent" name="officeContent" width="100%" height="91%" frameborder="0"></iframe>
		</div>
	</div>
	</div>
	</div>
	</div>
	<script type="text/javascript">
		var userid='${fns:getUser().id }';
		var cookiestr="office_tree_"+userid;
	
		var setting = {data:{simpleData:{enable:true,idKey:"id",pIdKey:"pId",rootPId:'0'}},
			callback:{onClick:function(event, treeId, treeNode){
					var id = treeNode.id == '0' ? '' :treeNode.id;
					//$('#officeContent').attr("src","${ctx}/sys/office/list?id="+id+"&parentIds="+treeNode.pIds);
					
					window.officeContent.document.getElementById("fparent_id").value = id;
					window.officeContent.searchA("${ctx}/sys/office/ajaxlist?parent.id="+id);
				},
				onExpand: onExpand,  
                onCollapse: onCollapse
			}
		};
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
		var treeCopy;
		function refreshTree(){
			$.getJSON("${ctx}/sys/office/treeData",function(data){
				if('true'=='${fns:getUser().isAdmin()}'){
					data.push({id:0,name:'机构管理'});
					$('#officeContent').attr('src',"${ctx}/sys/office/list")
				}else{
					$('#officeContent').attr('src',"${ctx}/sys/office/list?parent.id==74eb68952a914a008d939a82b8fa4765");
					//window.officeContent.document.getElementById("parent_id").value = id;
				}
				var tree=$.fn.zTree.init($("#ztree"), setting, data);
				treeCopy=tree;
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
		refreshTree();
		 
		var leftWidth = 180; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize(){
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":"hidden", "overflow-y":"hidden"});
			mainObj.css("width","auto");
			frameObj.height(strs[0] - 120);
			var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
			$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -60);
			$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46);
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>