<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>转换过程查看</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
	   <tbody>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">转换过程:</label></td>
	         <td class="width-35">${proInfo.transName}</td>
	         <td class="width-15 active"><label class="pull-right">执行顺序:</label></td>
	         <td class="width-35">${proInfo.sortNum}</td>
		  </tr>
		  <tr>
			<td class="width-15 active"><label class="pull-right">过程描述:</label></td>
			<td class="width-85" colspan="3"> ${proInfo.transDesc} </td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">转换引擎:</label></td>
	         <td class="width-35">${proInfo.transEngine}</td>
	         <td class="width-15 active"><label class="pull-right">引擎连接:</label></td>
	         <td class="width-35">
			 <c:choose>
				<c:when test="${empty proInfo.transConn}">默认Impala引擎</c:when>
				<c:otherwise>${proInfo.transConn}</c:otherwise>
			 </c:choose>
			 </td>
		  </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">转换脚本:</label></td>
	         <td class="width-85" colspan="3">
				<textarea class="form-control span12" style="height: 400px;" readonly="readonly" >${proInfo.transSql}</textarea>
			 </td>
		  </tr>
		</tbody>
	</table>
</body>
</html>