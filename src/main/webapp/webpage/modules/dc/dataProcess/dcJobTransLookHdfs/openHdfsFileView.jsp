<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<meta name="decorator" content="default"/>
<title>查看文件</title>
</head>
<body>
<%-- <iframe src="${filePath}"></iframe> --%>
<textarea id="hdfsFile_content" title="文件内容" class="form-control span12" style="height: 680px;width:800px;" disabled="disabled">${hdfsFile.content }</textarea>
</body>
</html>