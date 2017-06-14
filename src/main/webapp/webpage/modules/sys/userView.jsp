<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<meta name="decorator" content="default"/>
	
</head>
<body>
	<sys:message content="${message}"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
	   <tbody>
	      <tr>
	         <td class="width-15 active">	<label class="pull-right">头像：</label></td>
	         <td class="width-35"><img src="${user.photo}" /></td>
	         <td  class="width-15 active">	<label class="pull-right">归属公司:</label></td>
	         <td class="width-35">${user.company.name}</td>
	      </tr>
	      
	      <tr>
	         <td class="width-15 active"><label class="pull-right">归属部门:</label></td>
	         <td class="width-35">${user.office.name}</td>
	         <td class="width-15 active"><label class="pull-right">工号:</label></td>
	         <td class="width-35">${user.no }</td>
	      </tr>
	      
	      <tr>
	         <td class="width-15 active"><label class="pull-right">姓名:</label></td>
	         <td class="width-35">${user.name }</td>
	         <td class="width-15 active"><label class="pull-right">登录名:</label></td>
	         <td class="width-35">${user.loginName}</td>
	      </tr>
	      
	      
	      <%-- <tr>
	         <td class="width-15 active"><label class="pull-right">密码:</label></td>
	         <td class="width-35">${user.password }</td>
	         <td class="active"><label class="pull-right"><c:if test="${empty user.id}"><font color="red">*</font></c:if>确认密码:</label></td>
	         <td><input id="confirmNewPassword" name="confirmNewPassword" type="password"  class="form-control ${empty user.id?'required':''}" value="" maxlength="50" minlength="3" equalTo="#newPassword"/></td>
	      </tr> --%>
	      
	       <tr>
	         <td class="width-15 active"><label class="pull-right">邮箱:</label></td>
	         <td class="width-35">${user.email }</td>
	         <td class="width-15 active"><label class="pull-right">电话:</label></td>
	         <td class="width-35">${user.phone }</td>
	      </tr>
	      
	      <tr>
	         <td class="width-15 active"><label class="pull-right">手机:</label></td>
	         <td class="width-35">${user.mobile }</td>
	         <td class="width-15 active"><label class="pull-right">是否允许登录:</label></td>
	         <td class="width-35">
	         	<c:choose>
	         		<c:when test="${user.loginFlag eq 1 }">是</c:when>
	         		<c:when test="${user.loginFlag eq 0 }">否</c:when>
	         	</c:choose>
         	 </td>
	      </tr>
	      
	      <tr>
	         <td class="width-15 active"><label class="pull-right">用户类型:</label></td>
	         <td class="width-35">
	         	<c:choose>
	         		<c:when test="${user.userType eq 1 }">系统管理</c:when>
	         		<c:when test="${user.userType eq 2 }">部门经理</c:when>
	         		<c:when test="${user.userType eq 3 }">普通用户</c:when>
	         		<c:otherwise>请选择</c:otherwise>
	         	</c:choose>
	         
	         </td>
	         <td class="width-15 active"><label class="pull-right">用户角色:</label></td>
	         <td class="width-35">
	         	<c:forEach items="${user.roleList }" var="role">
	         	 	${role.name }
	         	</c:forEach>
	         </td>
	      </tr>
	      
	       <tr>
	         <td class="width-15 active"><label class="pull-right">备注:</label></td>
	         <td colspan="3" class="width-35">${user.remarks }</td>
	      </tr>
	      
	      <c:if test="${not empty user.id}">
	       <tr>
	         <td class=""><label class="pull-right">创建时间:</label></td>
	         <td><span class="lbl"><fmt:formatDate value="${user.createDate}" type="both" dateStyle="full"/></span></td>
	         <td class=""><label class="pull-right">最后登陆:</label></td>
	         <td><span class="lbl">IP: ${user.loginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.loginDate}" type="both" dateStyle="full"/></span></td>
	      </tr>
	     </c:if>
</body>
</html>