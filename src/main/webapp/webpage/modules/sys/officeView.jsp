<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
	   <tbody>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">上级机构:</label></td>
	         <td class="width-35">${office.parent.name}</td>
	         <td  class="width-15 active"  class="active"><label class="pull-right">归属区域:</label></td>
	         <td class="width-35">${office.area.name}</td>
	      </tr>
	       <tr>
	         <td class="width-15 active"><label class="pull-right">机构名称:</label></td>
	         <td class="width-35">${office.name }</td>
	         <td  class="width-15 active"  class="active"><label class="pull-right">机构编码:</label></td>
	         <td class="width-35">${office.code }</td>
	      </tr>
	       <tr>
	         <td class="width-15 active"><label class="pull-right">机构类型:</label></td>
	         <td class="width-35">
	         	<c:choose>
	         		<c:when test="${office.type eq 1 }">公司</c:when>
	         		<c:when test="${office.type eq 2 }">部门</c:when>
	         		<c:when test="${office.type eq 3 }">小组</c:when>
	         		<c:otherwise>其它</c:otherwise>
	         	</c:choose>
	         </td>
	         <td  class="width-15 active"  class="active"><label class="pull-right">机构级别:</label></td>
	         <td class="width-35">
	         	<c:choose>
	         		<c:when test="${office.grade eq 1 }">一级</c:when>
	         		<c:when test="${office.grade eq 2 }">二级</c:when>
	         		<c:when test="${office.grade eq 3 }">三级</c:when>
	         		<c:when test="${office.grade eq 4 }">四级</c:when>
	         	</c:choose>
	         </td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">是否可用:</label></td>
	         <td class="width-35">
	         	<c:choose>
	         		<c:when test="${office.useable eq 1}">是</c:when>
	         		<c:when test="${office.useable eq 0}">否</c:when>
	         	</c:choose>
	         </td>
	         <td class="width-15 active"  class="active"><label class="pull-right">主负责人:</label></td>
	         <td class="width-35">${office.primaryPerson.name}</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">副负责人:</label></td>
	         <td class="width-35">${office.deputyPerson.name}</td>
	         <td class="width-15 active"  class="active"><label class="pull-right">联系地址:</label></td>
	         <td class="width-35">${office.address }</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">邮政编码:</label></td>
	         <td class="width-35">${office.zipCode }</td>
	         <td  class="width-15 active" class="active"><label class="pull-right">负责人:</label></td>
	         <td class="width-35">${office.master }</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">电话:</label></td>
	         <td class="width-35">${office.phone }</td>
	         <td  class="width-15 active"  class="active"><label class="pull-right">传真:</label></td>
	         <td class="width-35">${office.fax }</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">邮箱:</label></td>
	         <td class="width-35">${office.email }</td>
	         <td  class="width-15 active" class="active"><label class="pull-right">备注:</label></td>
	         <td class="width-35">${office.remarks }</td>
	      </tr>
      </tbody>
      </table>
</body>
</html>