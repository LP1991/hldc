<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据源管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		//打开数据源测试 窗口
		function openTestDBDialog(url2,title,url,width,height,target,o){
			if(navigator.userAgent.match(/(iPone|iPod|Android|iso)/i)) { // 如果是移动端，就使用自适应大小弹窗
				width='auto';
				height='auto';
			} else { // 如果是PC端，根据用户设置的width和height显示
				if (width && $(top.window).width() < width.replace('px', '')) {
					width = ($(top.window).width() - 20) + 'px';
				}
				if (height && $(top.window).height() < height.replace('px', '')) {
					height = ($(top.window).height() - 20) + 'px';
				}
			}
			
			var option ={
				type : 2,
				area : [ width, height ],
				title : title,
				maxmin : true, // 开启最大化最小化按钮
				content : url,
				btn : [ '确定', '关闭', '测试' ],
				yes : function(index, layero) {
					var body = top.layer.getChildFrame('body', index);
					var iframeWin = layero.find('iframe')[0]; // 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
					var inputForm = body.find('#inputForm');
					var top_iframe;
					if (target) {
						top_iframe = target;	// 如果指定了iframe，则在改frame中跳转
					} else {
						top_iframe = top.getActiveTab().attr("name");// 获取当前active的tab的iframe
					}
					inputForm.attr("target", top_iframe);// 表单提交成功后，从服务器返回的url在当前tab中展示
					
					var method={};
					if (typeof(refreshTree) != "undefined") { 
						method.refreshTree=refreshTree;
					}
					if (typeof(refreshAllTree) != "undefined") { 
						method.refreshAllTree=refreshAllTree;
					}
					/*if( typeof window.parent.refreshTree === 'function' ){
						window.parent.refreshTree();
					}*/
					if (typeof(table) == "undefined") { 
						if (iframeWin.contentWindow.doSubmit(index,method)){
							//刷新树1
							if( typeof window.parent.refreshTree === 'function' ){
								window.parent.refreshTree();
							}
							// top.layer.close(index);//关闭对话框。
							setTimeout(function() {
								//新版改造  放入form中关闭
								top.layer.close(index)
							}, 100);// 延时0.1秒，对应360 7.1版本bug
						}
					} else{
						
						if ($('#fparent_id').size()>0) { //为iframe服务
							iframeWin.contentWindow.setPId($('#fparent_id').val());
						}
						if (iframeWin.contentWindow.doSubmit(index,table,method)){
						}
					} 
					
				}, cancel : function(index) {
					
				}, btn3:function(index,layero){	//TODO: 平台没有参考例子, 待完善
					var body = top.layer.getChildFrame('body', index);
					var iframeWin = layero.find('iframe')[0]; // 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
					var inputForm = body.find('#inputForm');
					var top_iframe;
					
					 $.ajax({
					   type: "POST",
					   url: url2,
					   data: inputForm.serialize(),
					   success: function(msg){
						   if(msg){
							   body.find('#content').css('color','green');
							   body.find('#content').html("连接成功！");
						   }else{
							   body.find('#content').css('color','red');
							   body.find('#content').html("连接失败！");
						   }
					   },
					   error: function(error){
						   body.find('#content').html(error);
					   }
					});
				}
			};
			option = $.extend({}, option, o);
			top.layer.open(option);
		}
		
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="数据库连接" label="数据库连接, 用于维护远程数据源连接信息, 为数据采集提供前提条件." ></dc:bizHelp>
	
	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="dcDataSource" action="${ctx}/dc/metadata/dcDataSource/" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>数据源名称：</span>
				<form:input path="connName" htmlEscape="false" maxlength="64"  class=" form-control input-sm"/>
			<span>数据源类型：</span>
				<form:select path="serverType" class="form-control">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictListLike('dc_datasource_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			<button class="btn btn-success btn-rect  btn-sm " onclick="search()" type="button"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
	<br/>
	</div>
	</div>
	
	
	<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="dc:metadata:dcDataSource:add">
				<table:addRow url="${ctx}/dc/metadata/dcDataSource/form" title="数据库连接" height="600px"></table:addRow><!-- 增加按钮 -->
				<!-- <table:addTestDBRow url="${ctx}/dc/metadata/dcDataSource/form" testDbUrl="${ctx}/dc/metadata/dcDataSource/testDataSource" title="新建数据源"></table:addTestDBRow> 增加按钮 -->
			</shiro:hasPermission>
		</div>
	</div>
	</div>
	
	<!-- 表格 -->
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr>
				
				<th  class="sort-column connName">数据源名称</th>
				<th  class="sort-column connDesc">数据源描述</th>
				<th  class="sort-column serverType">数据源类型</th>
				<th  class="sort-column serverIP">数据库IP</th>
				<th  class="sort-column serverPort">数据库端口</th>
				<th  class="sort-column serverName">数据库连接名</th>
				<th  class="sort-column serverUser">用户名</th>
				<th  class="sort-column remarks">连接状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="category">
			<tr>
			<!--  	<td> <input type="checkbox" id="${category.id}" class="i-checks"></td>-->
				<td><a  href="#" onclick="openDialogView('查看数据库连接', '${ctx}/dc/metadata/dcDataSource/view?id=${category.id}','800px', '500px')">
					${category.connName}
				</a></td>
				<td> ${category.connDesc} </td>
				<td>${fns:getDictLabel(category.serverType, 'dc_datasource_type', '无')}</td>
				<td>${category.serverIP}</td>
				<td>${category.serverPort}</td>
				<td>${category.serverName}</td>
				<td>${category.serverUser}</td>
				<td>${category.remarks eq '1'?'√':(category.remarks eq '0'?'×':'-')}</td>
				<td>
					<shiro:hasPermission name="dc:metadata:dcDataSource:view">
						<a href="#" onclick="openDialogView('查看数据库连接', '${ctx}/dc/metadata/dcDataSource/view?id=${category.id}','800px', '500px')" class="btn btn-success btn-xs" title="查看数据库连接"><i class="fa fa-search-plus"></i></a>
					</shiro:hasPermission>
					<shiro:hasPermission name="dc:metadata:dcDataSource:edit">
    					<a href="#" onclick="openDialog('编辑数据库连接', '${ctx}/dc/metadata/dcDataSource/form?id=${category.id}','800px', '600px')" class="btn btn-success btn-xs" title="编辑数据库连接"><i class="fa fa-edit"></i></a>
    				</shiro:hasPermission>
    				<shiro:hasPermission name="dc:metadata:dcDataSource:del">
						<a href="${ctx}/dc/metadata/dcDataSource/delete?id=${category.id}" onclick="return confirmx('确认要删除该数据库连接吗？', this.href)"   class="btn btn-success btn-xs" title="删除数据库连接"><i class="fa fa-trash"></i></a>
					</shiro:hasPermission>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	
		<!-- 分页代码 -->
	<table:page page="${page}"></table:page>
	<br/>
	<br/>
	</div>
</body>
</html>