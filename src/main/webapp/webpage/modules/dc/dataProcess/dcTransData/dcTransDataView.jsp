<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>转换任务查看</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer" style="margin-left: 2%;margin-right: 2%;width: 96%;">
	   <tbody>
	      <tr>
	         <td class="width-15 active"><label class="pull-right">任务名称:</label></td>
	         <td class="width-20">${jobInfo.jobName}</td>
	         <td class="width-15 active"><label class="pull-right">任务描述:</label></td>
	         <td class="width-50">${jobInfo.jobDesc}</td>
	      </tr>
	      <tr>
			 <td class="width-15 active"><label class="pull-right">源对象类别:</label></td>
 			 <td class="width-20">${fns:getDictLabel(jobInfo.inputType, 'dc_data_trans_type', '无')}</td>
			 <td class="width-15 active"><label class="pull-right">源对象:</label></td>
			 <td class="width-50">${jobInfo.inputName}</td>
		  </tr>
		  <tr>
			 <td class="width-15 active"><label class="pull-right">转换目标类别:</label></td>
 			 <td class="width-20">${fns:getDictLabel(jobInfo.outputType, 'dc_data_trans_type', '无')}</td>
			 <td class="width-15 active"><label class="pull-right">目标对象:</label></td>
			 <td class="width-50">${jobInfo.outputName}</td>
		  </tr>
		</tbody>
	</table>
</body>
</html>