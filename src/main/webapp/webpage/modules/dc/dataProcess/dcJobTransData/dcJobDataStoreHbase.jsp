<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>Hbase数据存储</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
	</style>
</head>
<body class="white-bg">
	<div class="wrapper wrapper-content">
	<div class="ibox">
	
		<div class="ibox-content">
		<sys:message content="${message}"/>
		
		<div class="row">
			<div class="col-sm-12">
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active">	<label class="pull-right">任务名称：</label></td>
					 <td class="width-35">${dcJob.jobName }</td>
					 <td class="width-15 active"><label class="pull-right">数据表名称:</label></td>
					 <td class="width-35">${dcJob.outputTable }</td>
				  </tr>
			</table>
			<br/>
			</div>
		</div>
			<table id="previewTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;width:800px;">
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
	  	 </table>	
		</div>
	</div>
	</div>
</body>
</html>