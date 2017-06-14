<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>任务查看</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td  class="width-15 active"><label class="pull-right">系统编号:</label></td>
				<td class="width-35">${systems.number }</td>
			</tr>
			<tr>
				<td  class="width-15 active"><label class="pull-right">系统名称:</label></td>
				<td class="width-35">${systems.name}</td>
			</tr>
			<tr>
				<td  class="width-15 active"><label class="pull-right">系统首页:</label></td>
				<td class="width-35">${systems.bewrite}</td>
			</tr>
			<tr>
				<td  class="width-15 active"><label class="pull-right">系统描述:</label></td>
				<td class="width-35">${systems.homes}</td>
			</tr>	
			<tr>
				<td  class="width-15 active"><label class="pull-right">负责单位:</label></td>
				<td class="width-35">${systems.per }</td>
			</tr>	
			 <tr>
				<td  class="width-15 active"><label class="pull-right">单位负责人:</label></td>
				<td class="width-35">${systems.pers }</td>
			</tr>
			<tr>
				<td  class="width-15 active"><label class="pull-right">联系方式:</label></td>
				<td class="width-35">${systems.contact }</td>
			</tr>
			<tr>
				<td  class="width-15  active"><label class="pull-right">负责厂商:</label></td>
				<td class="width-35">${systems.manufs}</td>
			</tr>
			<tr>
				<td  class="width-15  active"><label class="pull-right">厂商负责人:</label></td>
				<td class="width-35">${systems.manufs}</td>
			</tr>
			<tr>
				<td  class="width-15  active"><label class="pull-right">联系电话:</label></td>
				<td class="width-35">${systems.contacts}</td>
			</tr>
		</tbody>
	</table>
</body>
</html>