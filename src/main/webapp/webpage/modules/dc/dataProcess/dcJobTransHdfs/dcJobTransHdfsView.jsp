<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>Job查看</title>
	<meta name="decorator" content="default"/>
	
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
    <!--表单向导所需-->
    <link href="${ctxStatic}/jquery-steps/css/jquery.steps.css" rel="stylesheet">
    <script src="${ctxStatic}/jquery-steps/js/jquery.steps.min.js"></script>
    <!--表单向导中包含验证所需-->
    <script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/jquery.validate.min.js"></script>
    <script src="${ctxStatic}/jquery-steps/js/jquery-validation/1.14.0/localization/messages_zh.min.js"></script>
	<style type="text/css">
		.hideScroll fieldset{
			margin:0 2%;
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
						 <td class="width-35">${hdfsJob.jobName}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right">任务描述：</label></td>
						 <td class="width-35">${hdfsJob.jobDesc}</td>
				  </tr>
				  </tbody>
			</table>
		</fieldset>
		<fieldset>
			 <legend>源HDFS信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right">源Hdfs地址：</label></td>
					 <td class="width-35">${hdfsJob.srcHdfsAddress}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right">文件路径：</label></td>
					<td class="width-35">${hdfsJob.srcHdfsDir}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right">源Hdfs版本：</label></td>
					 <td class="width-35">${hdfsJob.srcHdfsVersion eq '1'?'1.x':'2.x'}</td>
				  </tr>
				  </tbody>
			</table>
		</fieldset>
		<fieldset>
			 <legend>HDFS存储信息</legend>
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody> 
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right">目标路径：</label></td>
					 <td class="width-35"> ${hdfsJob.outPutDir} </td>
				  </tr>
			
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right">并发拷贝数：</label></td>
					 <td class="width-35"> ${hdfsJob.copyNum}</td>
				  </tr>
				  <tr>
					 <td  class="width-15 active" class="active"><label class="pull-right">是否覆盖：</label></td>
					 <td class="width-35"> ${hdfsJob.isOverride eq '1'?'是':'否'}</td>
				  </tr>
				</tbody>
			</table>
		</fieldset>
</body>
</html>