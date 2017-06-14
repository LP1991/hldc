<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/webpage/include/treeview.jsp" %>
	<script>
		$(document).ready(function() {
			$(document).on('ifChecked', '#contentTable thead tr th input.i-checks',function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		  	  $('#contentTable tbody tr td input.i-checks').iCheck('check');
		  	});
	
		  $(document).on('ifUnchecked','#contentTable thead tr th input.i-checks', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		  	  $('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
		  	});
		    
		});
	</script>
</head>
<body class="gray-bg">
	
	<div class="wrapper wrapper-content">
	<div class="ibox">
	
	<sys:message content="${message}"/>
	<dc:bizHelp title="菜单管理" label="菜单管理主要用于左侧菜单的一些设置及权限的分配" ></dc:bizHelp>
	<div id="content" class="row">
		<div id="left"  class="leftBox col-sm-1" style="margin-top:50px">
		
			<div id="ztree" class="ztree leftBox-content" style="margin-left:20px" ></div>
		</div>
		<div id="right"  class="col-sm-11  animated fadeInRight">
				<!-- 查询条件 -->
				<div class="row">
				<div class="col-sm-12">
				<form:form id="searchForm" modelAttribute="menu" url="${ctx}/sys/menu/ajaxlist" method="post" class="form-inline">
					<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
					<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
					<input id="parent_id_menu" name="parent_id_menu" type="hidden" />
					<input id="parent_id" name="parent.id" type="hidden" value='1'/>
					<input id="parent_name" name="parent.name" type="hidden" />
					<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
				</form:form>
				<br/>
				</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<shiro:hasPermission name="sys:menu:add">
								<table:addRow id="addBtn" url="${ctx}/sys/menu/form" title="菜单"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:menu:del">
								<table:delRowByAjax url="${ctx}/sys/menu/deleteAllByA" id="contentTable"></table:delRowByAjax><!-- 删除按钮 -->
							</shiro:hasPermission>
						</div>
					</div>
				</div>
				
				<table id="contentTable"  class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th>名称</th>
							<th>链接</th>
							<th style="text-align: center;">排序</th>
							<th>可见</th>
							<th>权限标识</th>
							<%-- <shiro:hasPermission name="sys:menu:edit"> --%>
								<th>操作</th>
							<%-- </shiro:hasPermission> --%>
						</tr>
					</thead>
				</table>
				
		</div>
	</div>
	</div>
	</div>
	<script type="text/javascript">
		var userid='${fns:getUser().id }';
		var cookiestr="menu_tree_"+userid;
		
		var setting = {data:{simpleData:{enable:true,idKey:"id",pIdKey:"pId",rootPId:'0'}},
			callback:{onClick:function(event, treeId, treeNode){
					var id = treeNode.id == ' 0' ? '' :treeNode.id;
					$('#parent_name').val(treeNode.name);
					$('#parent_id_menu').val(treeNode.id);
					$('#parent_id').val(treeNode.id);
					$('#addBtn').attr('onclick',"add('${ctx}/sys/menu/form?parent.id="+treeNode.id+"')");
					searchA("${ctx}/sys/menu/ajaxlist");
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
		function refreshTree(){
			$.getJSON("${ctx}/sys/menu/treeData",function(data){
				if(flag){
					if(data!=null&&data.length>0){
						$('#parent_name').val(data[0].name);
						$('#parent_id_menu').val(data[0].id);
						$('#parent_id').val(data[0].id);
						//searchA("${ctx}/sys/menu/ajaxlist?parent.id="+data[0].id);
					}
					flag=!flag;
				} 
				var tree = $.fn.zTree.init($("#ztree"), setting, data);
				
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
		//初始化iframe
		var flag=true;
		refreshTree();
		 
		var leftWidth = 180; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize(){
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":"hidden", "overflow-y":"hidden"});
			mainObj.css("width","auto");
			$("#left").css({"height":strs[0] - 120,"overflow-y":"auto","overflow-x":"scroll"});
			var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").outerWidth());
			$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -60);
			$(".ztree").width(leftWidth - 30);
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
	<script>
	var option = {
		success : function(layero, index) {
			var iframeWin = window[layero.find('iframe')[0]['name']]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
			var zbody = top.layer.getChildFrame('body', index);
			zbody.find('#parent_name_form').val($('#parent_name').val());
			zbody.find('#parent_id_form').val($('#parent_id_menu').val());
		}
	};
	var table;
	$(document).ready(function () {
		table = $('#contentTable').DataTable({
				"processing": true,
				"serverSide" : true,
				searching : false, //禁用搜索
				"ordering": false, //禁用排序	
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : true, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/sys/menu/ajaxlist",
					"data" : function (d) {
						//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
						$.extend(d, getFormParamsObj('searchForm'));
					},
					"dataSrc" : function (json) {//定义返回数据对象
						return JSON.parse(json.body.gson);
					}
				},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, 
					{
						"data" : "name"
					}, {
						"data" : "href"
					}, {
						"data" : null
					}, {
						"data" :null
					}, {
						"data" : "permission"
					}, {
						"data" : null
					}
				],
				//定义列的初始属性
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },
				 {
					targets : 3,
					render : function (a, b) {
						var html='<input type="hidden" name="ids" value="'+a.id+'"/><input name="sorts" type="text" value="'+a.sort+'" class="form-control" style="width:100px;margin:0;padding:0;text-align:center;">';
						return html;
					}
				},{
					targets : 4,
					render : function (a, b) {
						var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a.isShow,type:'menu_type'});
						return html;
					}
				},{
						targets : 6,
						render : function (a, b) {
							var html = '<a href="#" onclick="openDialogView(\'查看菜单\', \'${ctx}/sys/menu/form?id='+a.id+'\',\'800px\', \'680px\',typeof(option) == \'undefined\'?{}:option)" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改菜单\', \'${ctx}/sys/menu/form?id='+a.id+'\',\'800px\', \'700px\',\'areaContent\',typeof(option) == \'undefined\'?{}:option)" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/sys/menu/deleteA?id='+a.id+'\',\'菜单\',true) " class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>&nbsp;';
							return html;
						}
					}
				],
				//初始化完成回调
				"initComplete": function(settings, json) {
					//重新初始化选框
					 $('.i-checks').iCheck('uncheck');
					
		
				},
				//重绘回调
				"drawCallback": function( settings ) {
					 $('.i-checks').iCheck({
			                checkboxClass: 'icheckbox_square-green',
			                radioClass: 'iradio_square-green',
			            });
					 
					 $("input[name='sorts']").bind(' change  ', function() {
							var val=$.trim($(this).val());
							var ids=$(this).prev().val();
							loading('正在提交，请稍等...');
							submitData("${ctx}/sys/menu/updateSort",{sorts:val,ids:ids},function(data){
								loading('排序成功');
								setTimeout(function(){
									closeTip();
									//刷新表格
									table.ajax.reload( null, false );
								},1000);
								
							});
						});
				    }
			});
	
	});
	
	function updateSort() {
		loading('正在提交，请稍等...');
		$("#listForm").attr("action", "${ctx}/sys/menu/updateSort");
		$("#listForm").submit();
	}
	</script>
</body>
</html>