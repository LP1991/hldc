<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
	   <tbody>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">归属机构:</label></td>
	         <td class="width-35">${role.office.name}</td>
	         <td  class="width-15 active" class="active"><label class="pull-right">角色名称:</label></td>
	         <td class="width-35">${role.name}</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">英文名称:</label></td>
	         <td class="width-35">${role.enname}</td>
	         <td  class="width-15 active" class="active"><label class="pull-right">角色类型:</label></td>
	         <td class="width-35">
	         	<c:choose>
	         		<c:when test="${role.roleType eq 'assignment'}">任务分配</c:when>
	         		<c:when test="${role.roleType eq 'security-role'}">管理角色</c:when>
	         		<c:when test="${role.roleType eq 'user'}">普通角色</c:when>
	         	</c:choose>
	         </td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">是否系统数据:</label></td>
	         <td class="width-35">
	         	<c:choose>
	         		<c:when test="${role.sysData eq 1 }">是</c:when>
	         		<c:when test="${role.sysData eq 0 }">否</c:when>
	         	</c:choose>
	         </td>
	         <td  class="width-15 active" class="active"><label class="pull-right">是否可用</label></td>
	         <td class="width-35"> 
	         	<c:choose>
	         		<c:when test="${role.useable eq 1 }">是</c:when>
	         		<c:when test="${role.useable eq 0 }">否</c:when>
	         	</c:choose>
	         </td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">数据范围:</label></td>
	         <td class="width-35">
	         	<c:choose>
	         		<c:when test="${role.dataScope eq 1 }">所有数据</c:when>
	         		<c:when test="${role.dataScope eq 2 }">所在公司及以下数据</c:when>
	         		<c:when test="${role.dataScope eq 3 }">所在公司数据</c:when>
	         		<c:when test="${role.dataScope eq 4 }">所在部门及以下数据</c:when>
	         		<c:when test="${role.dataScope eq 5 }">所在部门数据</c:when>
	         		<c:when test="${role.dataScope eq 8 }">仅本人数据</c:when>
	         		<c:when test="${role.dataScope eq 9 }">按明细设置</c:when>
	         	</c:choose>
	         </td>
			 <td class="width-15 active"><label class="pull-right">备注:</label></td>
	         <td class="width-35">${role.remarks }</td>
	      </tr>
		</tbody>
	</table>
</body>
</html>