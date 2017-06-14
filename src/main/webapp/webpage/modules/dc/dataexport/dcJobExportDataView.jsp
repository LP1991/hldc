<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>Job查看</title>
	<meta name="decorator" content="default"/>	
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
	<style>
	fieldset {
		width:96% !important;
		margin-right: 1.5% !important;
		margin-left:2% !important;
	}
</style>
</head>

<body class="hideScroll">
	<sys:message content="${message}"/>
	<input type="hidden" id="id"/>
		<fieldset>
			 <legend>任务信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active"><label class="pull-right">任务名称：</label></td>
						 <td class="width-35">${exportData.jobName}</td>
				  </tr>
				  <tr>
						</tr>
						<tr>
					 <td  class="width-15 active" ><label class="pull-right">任务描述：</label></td>
						 <td class="width-35">${exportData.jobDesc }</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">数据源：</label></td>
					 
					 <td class="width-35">${exportData.fromLink eq '1'?'HDFS':'HIVE'}</td>
					 
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">数据对象：</label></td>
					 <td class="width-35">${exportData.dataPath}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">并行任务数：</label></td>
					 <td class="width-35">${exportData.mapNum}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">字段分隔符：</label></td>
					 <td class="width-35">${exportData.fieldSplitBy}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">字符串空值转换：</label></td>
					 <td class="width-35">${exportData.nullString}</td>
				  </tr>
				   <tr>
					 <td  class="width-15 active" ><label class="pull-right">非字符串空值转换：</label></td>
					 <td class="width-35">${exportData.nullNonString}</td>
				  </tr>
				
				
				
				</tbody>
			</table>
		</fieldset>

		<fieldset>
			 <legend>导出数据库设置</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <tr>
					 <td  class="width-15 active" ><label class="pull-right">导出数据源：</label></td>
					 <td class="width-35">${dcfns:getFieldByField('id',exportData.toLink,'dc_data_source','CONN_NAME')}</td>
				
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">连接Schema：</label></td>
					<td class="width-35">${exportData.schemaName}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">数据表名称：</label></td>
					 <td class="width-35">${exportData.tableName}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">字段：</label></td>
					 <td class="width-35"> ${exportData.tableColumn} </td>
				  </tr>
				    <tr>
					
						<td class="width-15 active"><label class="pull-right">增量方式:</label></td>
	         <td class="width-35">
	         	     <c:choose>
	         		<c:when test="${exportData.updateMode eq 'insertonly'}">仅新增</c:when>
	         		<c:when test="${exportData.updateMode eq 'updateonly' }">仅更新</c:when>
	         		<c:when test="${exportData.updateMode eq 'allowinsert'}">新增且更新</c:when>
	         	</c:choose>
	         	
         	 </td>
					 
				  </tr>
				   <tr>
					 <td  class="width-15 active" ><label class="pull-right">主键字段：</label></td>
					 <td class="width-35"> ${exportData.updateKey} </td>
				  </tr>
				</tbody>
			</table>
			
		</fieldset>
		
	
	
</body>

</html>