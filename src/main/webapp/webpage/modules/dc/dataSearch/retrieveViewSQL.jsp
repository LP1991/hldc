<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>查看转换语句</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<label>&nbsp;&nbsp;转换语句: </label>
	<textarea class="form-control span12" style="height:480px; width:99%; margin:auto;" readonly="readonly" >${dcTransDataSub.transSql}</textarea>
</body>
</html>