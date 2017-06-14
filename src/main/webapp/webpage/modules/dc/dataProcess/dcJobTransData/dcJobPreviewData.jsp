<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据预览</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
		table tr td:nth-child(3){
			max-width: 120px;
		    overflow: hidden;
		    text-overflow: ellipsis;
		    white-space: nowrap;
		}
	</style>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
	<div class="wrapper wrapper-content">
	   <table id="previewTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;width:100%;">
		    <c:choose>
			   <c:when test="${columnList==null || fn:length(columnList)==0}">  
				<th style="text-align:center; ">没有数据</th>     
			   </c:when>
			   <c:otherwise> 
				   <thead>
					<tr>
						<c:forEach items="${columnList}" var="index" varStatus="status">
						<c:if test="${status.index=='0'}" >
						<c:forEach items="${index}" var="ina" >
							<th style="text-align:center; ">${ina.key}</th>
						</c:forEach>
						 </c:if>					
						</c:forEach>
					</tr> 
					</thead>
					<c:forEach items="${columnList}" var="index">
					<tr>	
					   <c:forEach items="${index}" var="inx">
					   <td style="text-align:center">${inx.value}</td>
						</c:forEach>
					</tr>
					 </c:forEach>			  
				</c:otherwise>
			</c:choose>
	   </table>
	</div>
</body>
</html>