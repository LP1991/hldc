<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<body>
	   <%--       <div ><label class="pull-left">文件地址：</label></div>
	         <div ><label class="pull-left">${hdfsFile.filePath }</label></div>
	         <div ><label class="pull-left">文件内容:</label></div>
	         <div ><label class="pull-left">${hdfsFile.content }</label></div> --%>
	         <textarea id="hdfsFile_content" title="文件内容" class="form-control span12" style="height: 350px;width:750px;" disabled="disabled">${hdfsFile.content }</textarea>
</body>
</html>