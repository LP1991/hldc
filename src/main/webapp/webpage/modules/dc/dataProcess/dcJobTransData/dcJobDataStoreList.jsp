<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>DB采集对象列表</title>
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
	
		<div class="ibox-content" style="padding:0;">
		<sys:message content="${message}"/>
		
		<div class="row">
			<div class="col-sm-12">
			<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			   <tbody>
				  <tr>
					 <td class="width-15 active">	<label class="pull-right">任务名称：</label></td>
					 <td class="width-35">${dcJob.jobName }</td>
					 <td class="width-15 active"><label class="pull-right">存储路径:</label></td>
					 <td class="width-35">${dcJob.outputDir }</td>
				  </tr>
			</table>
			<br/>
			</div>
		</div>
		
		<!-- 表格 -->
		<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
			<thead>
				<tr>
					<th  class="sort-column fileName">文件名称</th>
					<th  class="sort-column fileSize">文件大小</th>
					<th  class="sort-column user">所属用户</th>
					<th  class="sort-column group">用户组</th>
					<th  class="sort-column permissions">权限</th>
					<th  class="sort-column createDate">创建时间</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${list}" var="file">
				<tr>
					<td>${file.fileName}</td>
					<td>${file.fileSize}</td>
					<td>${file.user}</td>
					<td>${file.group}</td>
					<td>${file.permissions}</td>
					<td>${file.createDate}</td>
					<td>
					  <a href="#" onclick="openDialogView('查看${file.fileName}','${ctx}/dc/dataProcess/hdfs/viewContent?filePath=${file.filePath}&line=50','760px', '480px')" class="btn btn-success btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
    				  <a href="#" onclick="exportHdfsFile('${file.fileName}', '${file.filePath}')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 下载</a>
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		
		<!-- 下载form -->
		<form id="exportFm" style="display:none" target="" method="post" action="${ctx}/dc/dataProcess/hdfs/exportHdfsFile" >
			<input type="hidden" id="h_fileName" name="fileName" ></input>
			<input type="hidden" id="h_filePath" name ="filePath" ></input>
		</form>
	 
		<script>
			//下载文件
			function exportHdfsFile(fileName, filePath){
				
				$('#h_fileName').val(fileName);
				$('#h_filePath').val(filePath);
				
				//提交表单 导出数据
				$('#exportFm').submit();
			}
		</script>		
		</div>
	</div>
	</div>
</body>
</html>