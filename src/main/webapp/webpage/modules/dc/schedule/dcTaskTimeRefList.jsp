<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>调度任务</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
		<div class="ibox">
<sys:message content="${message}"/>
<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<shiro:hasPermission name="dc:dcTaskTimeRef:add">
							<table:addRow url="${ctx}/dc/schedule/dcTaskTimeRef/form" title="任务"></table:addRow>
							<!-- 增加按钮 -->
						</shiro:hasPermission>
						<shiro:hasPermission name="dc:dcTaskTime:del">
							<table:delRow url="${ctx}/dc/schedule/schedul/deleteAll"
								id="contentTable"></table:delRow>
							<!-- 删除按钮 -->
						</shiro:hasPermission>
						<shiro:hasPermission name="dc:dcTaskTime:add">
						<table:addRow url="${ctx}/dc/schedule/dcTaskTime/form" title="调度任务"></table:addRow>
						<!-- 增加按钮 -->
					</shiro:hasPermission>
						<%-- <shiro:hasPermission name="dc:schedule:del">
						<table:delRow url="${ctx}/dc/schedule/schedul/deleteAll" id="contentTable" title="调度设置"> onclick="updateObj()" </table:delRow>
						<!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="dc:schedule:del">
						<table:delRow url="${ctx}/dc/schedule/schedul/deleteAll" id="contentTable" title="立即执行"> onclick="executeTask('execute','执行')" </table:delRow>
						<!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="dc:schedule:del">
						<table:delRow url="${ctx}/dc/schedule/schedul/deleteAll" id="contentTable" title="暂停"> onclick="executeTask('pause','暂停')" </table:delRow>
						<!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="dc:schedule:del">
						<table:delRow url="${ctx}/dc/schedule/schedul/deleteAll" id="contentTable" title="恢复"> onclick="executeTask('resume','恢复')" </table:delRow>
						<!-- 删除按钮 -->
					</shiro:hasPermission> --%>
					</div>
				</div>
			</div>
		</div>

		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
			<thead>
				<tr>
					<th><input type="checkbox" class="i-checks"></th>
					<th class="className">类名称</th>
					<th class="methodName">方法名</th>
					<th class="patameter">参数</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.list}" var="dcTaskTimeRef">
					<tr>
						<td><input type="checkbox" id="${dcTaskTimeRef.id}"
							class="i-checks"></td>
						<td>${dcTaskTimeRef.className}</td>
						<td>${dcTaskTimeRef.methodName}</td>
						<td>${dcTaskTimeRef.parameter}</td>
						<td><shiro:hasPermission name="dc:dcTaskTimeRef:view">
								<a href="#"
									onclick="openDialogView('查看', '${ctx}/dc/schedule/dcTaskTimeRef/view?id=${dcTaskTimeRef.id}','800px', '500px')"
									class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i>
									查看</a>
							</shiro:hasPermission> <shiro:hasPermission name="dc:dcTaskTimeRef:edit">
								<a href="#"
									onclick="openDialog('修改', '${ctx}/dc/schedule/dcTaskTimeRef/form?id=${dcTaskTimeRef.id}','800px', '500px')"
									class="btn btn-success btn-xs"><i class="fa fa-edit"></i>修改</a>
							</shiro:hasPermission> <shiro:hasPermission name="dc:dcTaskTimeRef:del">
								<a
									href="${ctx}/dc/schedule/dcTaskTimeRef/delete?id=${dcTaskTimeRefRef.id}"
									onclick="return confirmx('确认要删除该任务吗？', this.href)"
									class="btn btn-success btn-xs"><i class="fa fa-trash"></i>删除</a>
							</shiro:hasPermission></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<table:page page="${page}"></table:page>
		<br /> <br />
	</div>
	</div>
	</div>
</body>
</html>
