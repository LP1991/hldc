<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>字典管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/webpage/include/treeview.jsp" %>
	<style type="text/css">
.ztree {
	overflow: auto;
	margin: 0;
	_margin-top: 10px;
	padding: 10px 0 0 10px;
}

.ztree li span.button.switch.level0 {
	visibility: hidden;
	width: 1px;
}

.ztree li ul.level0 {
	padding: 0;
	background: none;
}

.ztree li span.button.add {
	margin-left: 2px;
	margin-right: -1px;
	background-position: -144px 0;
	vertical-align: top;
	*vertical-align: middle
}
</style>
	<script type="text/javascript">
		function refresh(){//刷新
			window.location="${ctx}/sys/dict/index";
		}
	</script>
</head>
<body class="gray-bg">
	
	<div class="wrapper wrapper-content">
	<div class="ibox">

	<sys:message content="${message}"/>
	<dc:bizHelp title="字典管理" label="" ></dc:bizHelp>
	<div id="content" class="row">
		<div id="left" style="margin-top:50px"class="leftBox col-sm-1">
			
			<div  class="" style="border-bottom:1px solid #e7eaec;text-align: center;line-height: 30px;margin:0 -15px;font-weight: bold;" >字典类别</div>
			<div  class="" style="border-bottom:1px solid #e7eaec;text-align: center; height:32px;line-height: 32px;margin:0 -15px;">
				<a class="btn btn-success  btn-xs" data-toggle="tooltip" data-placement="left" onclick="add1()" title="添加"><i class="fa fa-plus"></i> </a>
				<%-- 使用方法： 1.将本tag写在查询的form之前；2.传入table的id和controller的url --%>
				<script type="text/javascript">
					function add1(){
						openDialog("新增类型","${ctx}/sys/dict/typeForm?parent.id="+parentId,"800px", "500px");
					}
				</script>
				<a href="#" onclick="editType()" class="btn btn-success btn-xs" style="margin:0 20px;"><i class="fa fa-edit"></i></a>
				<script type="text/javascript">
					function editType(){
						var treeObj = $.fn.zTree.getZTreeObj("ztree");
						var nodes = treeObj.getSelectedNodes();
						if(nodes.length==0){
							top.layer.alert('请选择一条数据!', {icon: 0, title:'警告'});
							return;
						}else{
							openDialog('修改类型', '${ctx}/sys/dict/typeForm?id='+nodes[0].id,'800px', '500px');
						}
						
					}
				</script>
				<a  onclick="deleteType()"   class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>
				<script type="text/javascript">
					function deleteType(){
						var treeObj = $.fn.zTree.getZTreeObj("ztree");
						var nodes = treeObj.getSelectedNodes();
						if(nodes.length==0){
							top.layer.alert('请选择一条数据!', {icon: 0, title:'警告'});
							return;
						}else if(nodes[0].id=='0'){
							top.layer.alert('请选择其他节点!', {icon: 0, title:'警告'});
							return;
						}else{
							deleteA('${ctx}/sys/dict/deleteA?id='+nodes[0].id,'类型',true);
						}
						
					}
				</script>
			</div>
			<div id="ztree" class="ztree leftBox-content"></div>
			<input type="hidden" id="typeId">
		</div>
		<div id="right"  class="col-sm-11  animated fadeInRight">
			<%@include file="/webpage/modules/sys/dictList.jsp" %>
			<%-- <iframe id="officeContent" name="officeContent" src="${ctx}/sys/dict/list?parent.id=1x1" width="100%" height="91%" frameborder="0"></iframe> --%>
		</div>
	</div>
	</div>
	</div>
	<script type="text/javascript">
		
		var setting = {
			view: {
				selectedMulti: false
			},
			data : {
				simpleData : {
					enable : true,
					idKey : "id",
					pIdKey : "pId",
					rootPId : '0'
				}
			},
			callback : {
				onClick : function(event, treeId, treeNode) {
					
					var id = treeNode.id;
					if(id=='0') return false;
					//$('#typeId').val(id);
					$("#parent_id1").val( id);
					$("#type_name").val(treeNode.name);
					$("#type_label").val(treeNode.label);
					$("#type").val(treeNode.type);
					//$('#officeContent').attr("src","${ctx}/sys/dict/list?parentDict.id=" + treeNode.id);
					
					//$('#addBtn').attr('onclick',"add('${ctx}/sys/menu/form?parent.id="+treeNode.id+"')");
					parentId=id;
					searchA("${ctx}/sys/dict/ajaxlist");
				}
			}
		};
		
		function refreshTree() {
			$.getJSON("${ctx}/sys/dict/treeData", function(data) {
				data.push({
					id : 0,
					name : '字典管理',
					showRemoveBtn :false
				});
				var tree = $.fn.zTree.init($("#ztree"), setting, data);
				tree.expandNode(tree.getNodes()[0], true, false, true);
			});
		}
		refreshTree();

		//初始化iframe
		var flag=true;
			
		var leftWidth = 180; // 左侧窗口大小
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
					$("#content").width() - leftWidth - $("#openClose").width()
							- 62);
			$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46-65);
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>