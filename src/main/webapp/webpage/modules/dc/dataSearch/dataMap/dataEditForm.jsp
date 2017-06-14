<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="decorator" content="default"/>
<script type="text/javascript">
		var validateForm;
		function doSubmit(index,table){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
					 submitData( '${ctx}/dc/datasearch/dataMap/saveChange',getFormParams('inputForm'),function(data){
							var icon_number;
							if(!data.success){
								icon_number = 8;
							}else{
								icon_number = 1;
							}
							top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
							if(data.success!=true){
							    return false;
							}else{
								//刷新表格
								table.ajax.reload();
								//关闭form面板
								top.layer.close(index)
								return true;
							}
						});
		};
</script>
<title>分类</title>
</head>
<body>
<form:form id="inputForm" modelAttribute="DcObjectCataRef" action="${ctx}/dc/datasearch/dataMap/saveChange" method="post" class="form-horizontal">
<tr>
<td>
<br>
<sys:treeselect id="cataId" name="cataId" value="" labelName="cataName" labelValue="请选择"
						title="公司" url="/dc/datasearch/dataMap/treeData?itemId=${cataId}" cssClass="form-control required"/>
</td>
</tr>
	<input type="hidden" name="oldCataId" value="${oldCataId}"/>
	<input type="hidden" name="ids" value="${ids}"/>
</form:form>
</body>
</html>