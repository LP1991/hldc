<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>Job查看</title>
	<meta name="decorator" content="default"/>	
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
	<style type="text/css">
		.f_td{
			overflow:hidden;
			white-space: nowrap;
		    text-overflow: ellipsis;
		    max-width:100px;
		    cursor: pointer;
		}
	</style>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<input type="hidden" id="id"/>

		<fieldset class="change_table_margin">
			 <legend>任务信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
				<tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right">任务名称：</label></td>
					<td class="width-35">${formData.jobName}</td>
				</tr>
				<tr>
					<td class="width-15 active" ><label class="pull-right">任务描述：</label></td>
					<td class="width-35">${formData.jobDesc}</td>
				</tr>
				<tr>
					<td class="width-15 active" ><label class="pull-right">服务端连接地址：</label></td>
					<td class="width-35">${formData.wsPath}</td>
				</tr>
				<tr>
					<td class="width-15 active" ><label class="pull-right">命名空间：</label></td>
					<td class="width-35">${formData.wsNamespace}</td>
				</tr>
				<tr>
					<td class="width-15 active" ><label class="pull-right">调用方法：</label></td>
					<td class="width-35">${formData.wsMethod}</td>
				</tr>
				<tr>
					<td class="width-15 active" ><label class="pull-right">表单参数：</label></td>
					<td class="width-35">${formData.params}</td>
				</tr>
				</tbody>
			</table>
		</fieldset>

		<fieldset  class="change_table_margin">
			 <legend>数据存储</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
				<tbody>
				<tr>
					<td  class="width-15 active" ><label class="pull-right">存储目标：</label></td>
					<td class="width-35">MySQL</td>
				</tr>
				<tr>
					<td  class="width-15 active" ><label class="pull-right">数据源连接：</label></td>
					<td class="width-35">${dcfns:getFieldByField('id',formData.connId,'dc_data_source','CONN_NAME')}</td>
				</tr>
				<tr>
					<td  class="width-15 active" ><label class="pull-right">连接Schema：</label></td>
					<td class="width-35">${formData.schemaName }</td>
				</tr>
				<tr>
					<td  class="width-15 active" ><label class="pull-right">数据表名称：</label></td>
					<td class="width-35">${formData.tarName }</td>
				</tr>
				</tbody>
			</table>
		</fieldset>	

</body>
</html>