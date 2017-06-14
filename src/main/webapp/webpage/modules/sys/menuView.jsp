<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
	<meta name="decorator" content="default"/>
	
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">上级菜单:</label></td>
				<td class="width-35">${menu.parent.name}</td>
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 名称:</label></td>
				<td class="width-35">${menu.name}</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">链接:</label></td>
				<td class="width-35">${menu.href}</td>
				<td class="width-15 active"><label class="pull-right">目标:</label></td>
				<td class="width-35">${menu.target}</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">图标:</label></td>
				<td class="width-35"><i class="fa ${not empty menu.icon?menu.icon:'icon-hide'}"></i> ${menu.icon}</td>
				<td class="width-15 active"><label class="pull-right">排序:</label></td>
				<td class="width-35">${menu.sort}</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">类别:</label></td>
				<td class="width-35">${fns:getDictLabel(menu.isShow, 'menu_type', '')}</td>
				<td class="width-15 active"><label class="pull-right">权限标识:</label></td>
				<td class="width-35">${menu.permission}</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注:</label></td>
				<td class="width-35" colspan="3">${menu.remarks}</td>
			</tr>
		</tbody>
	</table>
</body>
</html>