<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>接口访问对象</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
        //回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		function doSubmit(index,table,method){
		  	//远程验证数据是否存在
			if(!$('#objIdId').val()){
                top.layer.alert('请选择接口!', {icon: 1, title:'系统提示'});
                $("#objId").focus();
                return false;
            }
            if(!$('#userIdId').val()){
                top.layer.alert('请选择用户!', {icon: 1, title:'系统提示'});
                $("#userId").focus();
                return false;
            }
            //验证数据是否存在  不存在则提交
		  	submitData("${ctx}/dc/intfVisit/list/checkIfExist", getFormParams('inputForm'),function(data){
			  if(data.success) {
                  submitData( '${ctx}/dc/intfVisit/list/ajaxSave',getFormParams('inputForm'),function(data){
                      var icon_number;
                      if(!data.success){
                          icon_number = 8;
                      }else{
                          icon_number = 1;
                      }
                      top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
                      if(data.success){
                          //刷新表格
                          table.ajax.reload();
                          //关闭form面板
                          top.layer.close(index)
                      }else{
                          return false;
                      }
                  });
			  }else{
                  top.layer.alert(data.msg, {icon: 1, title:'系统提示'});
                  return false;
			  }
		  	});
		}

	</script>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<form:form id="inputForm" modelAttribute="visitObj" action="" method="post" class="form-horizontal" style="margin:0;">
		<form:hidden path="id"/>
		<form:hidden path="connType"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
		   <tbody>
			  <tr>
				  <td class="width-15 active"><label class="pull-right"><font color="red">*</font>接口对象:</label></td>
				  <td class="width-35">
                      <sys:gridselect
                          url="${ctx}/dc/metadata/dcObjectIntf/selectIntf"
                          id="objId"
						  name="objId"
                          value="${visitObj.objId}"
                          title="选择所属类型"
                          labelName="objName"
                          labelValue="${visitObj.objName}"
                          cssClass="form-control required"
                          fieldLabels="接口编码|接口名称|接口类型|对象描述"
                          fieldKeys="objCode|objName|intfcType|objDesc"
                          searchLabel="接口名称"
                          searchKey="objName" >
                      </sys:gridselect>
				  </td>
			  </tr>
			  <tr>
				  <td class="width-15 active"><label class="pull-right"><font color="red">*</font>访问用户:</label></td>
				  <td class="width-35">
					  <dc:treeselect
						  id="userId"
						 name="userId"
						 value="${visitObj.userId}"
						 labelName="visitObj.userName"
						 labelValue="${visitObj.userName}"
						 title="用户"
						 url="/sys/office/getUsertreeData?type=3"
						 cssClass="form-control required"
						 allowClear="true"
						 notAllowSelectParent="true"/>
			  </tr>
			  <tr>
				  <td class="width-15 active"><label class="pull-right">备注:</label></td>
				  <td class="width-35"><form:textarea path="remarks" rows="3" htmlEscape="false" class="form-control" /></td>
			  </tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>