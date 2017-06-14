<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据预览</title>
	<meta name="decorator" content="default"/>	
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
	
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<input type="hidden" id="id"/>

		<fieldset>
			 <legend>数据信息</legend>
			    <table id="dataList" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;">
		   <thead>
			<tr>
				<c:forEach items="${dataList}" var="index" varStatus="status">
				<c:if test="${status.index=='0'}" >
				<c:forEach items="${index}" var="ina" >
					<th style="text-align:center; ">${ina.key}</th>
				</c:forEach>
				 </c:if>					
				</c:forEach>
			</tr> 
		  </thead>
         	<c:forEach items="${dataList}" var="index">
		    <tr>	
			   <c:forEach items="${index}" var="inx">
			   <td style="text-align:center">${inx.value}</td>
			    </c:forEach>
			</tr>
			 </c:forEach>			  
	   </table>
			<input type="button" value="更多">
		</fieldset>


</body>
</html>