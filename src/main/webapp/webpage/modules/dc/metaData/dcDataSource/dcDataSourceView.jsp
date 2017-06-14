<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据源查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
	   <tbody>
	      <tr>
	         <td class="width-15 active">	<label class="pull-right">数据源名称:</label></td>
	         <td class="width-35">${dcDataSource.connName }</td>
	      </tr>
	      <tr>
	         <td  class="width-15 active">	<label class="pull-right">数据源描述:</label></td>
	         <td class="width-35">${dcDataSource.connDesc}</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">数据源类型:</label></td>
	         <td class="width-35">${fns:getDictLabel(dcDataSource.serverType, 'dc_datasource_type', '无')}</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">数据库IP:</label></td>
	         <td class="width-35">${dcDataSource.serverIP }</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">数据库端口:</label></td>
	         <td class="width-35">${dcDataSource.serverPort }</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">数据库连接名:</label></td>
	         <td class="width-35">${dcDataSource.serverName}</td>
	      </tr>
	       <tr>
	         <td class="width-15 active"><label class="pull-right">用户名:</label></td>
	         <td class="width-35">${dcDataSource.serverUser }</td>
	      </tr>
		  <!--  -->
	     
	</table>
</body>
</html>