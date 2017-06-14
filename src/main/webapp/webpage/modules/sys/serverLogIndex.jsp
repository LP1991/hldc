<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="/favicon.ico">
   <style type="text/css">
   .cmfStdout {
   border:1px solid blue;
    width: 1630px;
	height:750px;
    overflow: auto;
}

.container-fluid {
    padding-right: 20px;
    padding-left: 20px;
}
   </style>
</head>
<body class="Fill">
 
<div class="container-fluid">
<h1>服务器日志</h1>   <a href="${ctx}/dc/common/loadTomcatInformation" style="margin:-45px 180px;position:absolute;">下载日志</a>
<textarea class="cmfStdout" readonly="readonly">${tomcatInformation}</textarea>

</div>
</body>

</html>