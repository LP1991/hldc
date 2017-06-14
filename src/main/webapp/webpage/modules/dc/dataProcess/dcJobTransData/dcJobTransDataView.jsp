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
						 <td class="width-35">${jobInfo.jobName}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">任务描述：</label></td>
						 <td class="width-35">${jobInfo.jobDesc }</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">数据源：</label></td>
					 <td class="width-35">${dcfns:getFieldByField('id',jobInfo.fromLink,'dc_data_source','CONN_NAME')}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">存储类型：</label></td>
					 <td class="width-35">${fns:getDictLabel(jobInfo.toLink, 'dc_data_store_type', '无')}</td>
				  </tr>
				
				</tbody>
			</table>
		</fieldset>

		<fieldset  class="change_table_margin">
			 <legend>数据源信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">连接Schema：</label></td>
					 <td class="width-35">${jobInfo.schemaName}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">数据表名称：</label></td>
					<td class="width-35">${jobInfo.tableName}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">字段：</label></td>
					 <td class="width-35 f_td" title="${jobInfo.tableColumn}">${jobInfo.tableColumn}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">分区字段：</label></td>
					 <td class="width-35"> ${jobInfo.partitionColumn} </td>
				  </tr>
				</tbody>
			</table>
		</fieldset>

	
		<fieldset  class="change_table_margin">
			<legend>存储信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">保存路径：</label></td>
					 <td class="width-35"> ${jobInfo.outputDir}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">输出格式：</label></td>
					 <td class="width-35"> ${jobInfo.outputFormat}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">压缩格式：</label></td>
					 <td class="width-35"> ${ jobInfo.compresFormat} </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">是否覆盖NULL值：</label></td>
					 <td class="width-35"> ${ jobInfo.overRideNull} </td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" ><label class="pull-right">NULL值被替换为：</label></td>
					 <td class="width-35"> ${ jobInfo.nullValue}</td>
				  </tr>
				</tbody>
			</table>
		</fieldset>
	

</body>
</html>