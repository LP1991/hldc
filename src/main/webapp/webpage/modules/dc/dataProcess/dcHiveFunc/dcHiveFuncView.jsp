<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>HIVE函数查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
	   <tbody>
	      <tr>
	         <td class="width-15 active">	<label class="pull-right">函数名称:</label></td>
	         <td class="width-35">${dcHiveFunction.funcName}</td>
	      </tr>
	      <tr>
	         <td  class="width-15 active">	<label class="pull-right">函数描述:</label></td>
	         <td class="width-35">${dcHiveFunction.funcDesc}</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">函数类型:</label></td>
	         <td class="width-35">${fns:getDictLabel(dcHiveFunction.funcType, 'dc_hivefunc_type', '无')}</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">jar包路径:</label></td>
	         <td class="width-35">${dcHiveFunction.jarPath}</td>
	      </tr>
		  <tr>
			  <td class="width-15 active"><label class="pull-right">Class路径:</label></td>
			  <td class="width-35">${dcHiveFunction.classPath}</td>
		  </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">jar名称:</label></td>
	         <td class="width-35">${dcHiveFunction.jarName}</td>
	      </tr>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">使用示例:</label></td>
	         <td class="width-35">${dcHiveFunction.funcDemo}</td>
	      </tr>
	       <tr>
	         <td class="width-15 active"><label class="pull-right">备注:</label></td>
	         <td class="width-35">${dcHiveFunction.remarks }</td>
	      </tr>
		  <!--  -->
	     
	</table>
</body>
</html>