<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据对象管理</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
	   <tbody>
		  <tr>
			 <td class="width-15 active"><label class="pull-right">对象名称：</label></td>
			 <td class="width-35">${dcObjMain.objName }</td>
			 <td  class="width-15 active" class="active"><label class="pull-right">对象编码：</label></td>
			 <td class="width-35">${dcObjMain.objCode }</td>
		  </tr>
		  <tr>
			<td  class="width-15 active" class="active"><label class="pull-right">对象类型：</label></td>
			<td class="width-35">${fns:getDictLabel(dcObjMain.objType, 'dc_datasource_type', '无')}</td>
			<td class="width-15 active"><label class="pull-right">对象描述：</label></td>
			<td class="width-35">${dcObjMain.objDesc }</td>
		  </tr>
		</tbody>
	</table>
	
	<!-- 设置数据表对象 -->
	<div id="obj_table">
	</div>
	
	<!-- 设置接口对象 -->
	<div id="obj_interface">
	</div>
	
	<!-- 设置文件对象 -->
	<div id="obj_file">
	</div>
	
	<!-- 设置非结构化文件对象 -->
	<div id="obj_nonStruct">
	</div>
</body>
</html>