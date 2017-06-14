<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>收藏管理</title>
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
	<dc:bizHelp title="个人收藏管理" label="个人收藏夹." ></dc:bizHelp>
	
	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="dcObjectCollect" action="${ctx}/dc/objCollect/dcObjCollect/list" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>搜索收藏：</span>
				<form:input path="dcObjectMain.objName" htmlEscape="false" maxlength="64"  class=" form-control input-sm"/>
			<%--<span>用户：</span>--%>
				<%--<form:select path="serverType" class="form-control">--%>
					<%--<form:option value="" label="全部"/>--%>
					<%--<form:options items="${fns:getDictListLike('dc_datasource_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>--%>
				<%--</form:select>--%>
			<button class="btn btn-success btn-rect  btn-sm " onclick="search()" type="button"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
	<br/>
	</div>
	</div>

	<!-- 表格 -->
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr>
				<th> <input type="checkbox" class="i-checks"></th>
				<th  class="sort-column user.name">用户名</th>
				<th  class="sort-column dcObjectMain.objName">收藏对象名</th>
				<th  class="sort-column collectTime">收藏时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="category">
			<tr>
				<td> <input type="checkbox" id="${category.id}" class="i-checks"></td>
				<%--<td><a  href="#" onclick="openDialogView('查看数据源', '${ctx}/dc/metadata/dcDataSource/view?id=${category.id}','800px', '500px')">--%>
					<%--${category.name}--%>
				<%--</a></td>--%>
				<td> ${category.user.name} </td>
				<td> ${category.dcObjectMain.objName} </td>
				<td><fmt:formatDate value="${category.collectTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
				<td>
					<shiro:hasPermission name="dc:metadata:dcDataSource:view">
						<a href="#" onclick="openDialogView('查看收藏', '${ctx}/dc/dataSearch/retrieval/view?name=${category.dcObjectMain.objName}','800px', '800px')" class="btn btn-success btn-xs" title="查看收藏"><i class="fa fa-search-plus"></i></a>
					</shiro:hasPermission>
    				<shiro:hasPermission name="dc:metadata:dcDataSource:del">
						<a href="${ctx}/dc/objCollect/dcObjCollect/delete?id=${category.id}" onclick="return confirmx('确认要删除该收藏吗？', this.href)"   class="btn btn-success btn-xs" title="删除收藏"><i class="fa fa-trash"></i></a>
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