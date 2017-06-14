<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(index,table,method){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  //$("#inputForm").submit();
			  setTimeout(function(){
			  submitData( '${ctx}/sys/office/saveA',getFormParams('inputForm'),function(data){
				  var icon_number;
					if(!data.success){
						icon_number = 8;
					}else{
						icon_number = 1;
					}
					top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});

					//刷新表格
					table.ajax.reload();
					//刷新树
					method.refreshAllTree();
					//关闭form面板
					top.layer.close(index)
				});
			 
			  })
		  }
	
		
		}
		function setPId (val){
			$('#parent_id').val( val);
		}
		$(document).ready(function() {
			$("#name").focus();
			validateForm = $("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			})
			if($('#useable').find('option').length>1){
				/* 默认显示第二个 */
				$('#useable').find('option').eq(1).attr('selected',"selected");
			}
		});

		
		/* function isEmail(str){
		       var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
		       if(!reg.test(str){
		            alert(“邮件格式不正确!”);
		            return false;

		        }
		        return true;
		}
		
		function checkMobile(){ 
			var sMobile = document.mobileform.mobile.value 
			if(!(/^1[3|4|5|8][0-9]\d{4,8}$/.test(sMobile))){ 
			alert("不是完整的11位手机号或者正确的手机号前七位"); 
			document.mobileform.mobile.focus(); 
			return false; 
			} 
		} */
	</script>
</head>
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="office" action="${ctx}/sys/office/save" method="post" style="margin:0;" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" id="parent_id" name="parent.id"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer change_table_margin">
		   <tbody>
		      <tr>
		        <%--  <td class="width-15 active"><label class="pull-right">上级机构:</label></td>
		         <td class="width-35"><sys:treeselect id="office" name="parent.id" value="${office.parent.id}" labelName="parent.name" labelValue="${office.parent.name}"
					title="机构" url="/sys/office/treeData" extId="${office.id}"  cssClass="form-control" allowClear="${office.currentUser.admin}"/></td> --%>
		         <td  class="width-15 active"><label class="pull-right"><font color="red">*</font>归属区域:</label></td>
		         <td class="width-35"><sys:treeselect id="area" name="area.id" value="${office.area.id}" labelName="area.name" labelValue="${office.area.name}"
					title="区域" url="/sys/area/treeData" cssClass="form-control required"/></td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>机构名称:</label></td>
		         <td class="width-35"><form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/></td>
		      </tr>
		       <tr>
		         
		         <td  class="width-15 active"><label class="pull-right">机构编码:</label></td>
		         <td class="width-35"><form:input path="code" htmlEscape="false" maxlength="50" class="form-control"/></td>
		           <td  class="width-15 active"><label class="pull-right">机构级别:</label></td>
		         <td class="width-35"><form:select path="grade" class="form-control">
					<form:options items="${fns:getDictListLike('sys_office_grade')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select></td>
		      </tr>
		       <tr>
		         <td class="width-15 active"><label class="pull-right">机构类型:</label></td>
		         <td class="width-35"><form:select path="type" class="form-control">
					<form:options items="${fns:getDictListLike('sys_office_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select></td>
		        <td class="width-15 active"><label class="pull-right">是否可用:</label></td>
		         <td class="width-35"><form:select path="useable" class="form-control">
					<form:options items="${fns:getDictListLike('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline">“是”代表此账号允许登陆，“否”则表示此账号不允许登陆</span></td>
		      </tr>
		      <tr>
		        
		         <td class="width-15 active"><label class="pull-right">主负责人:</label></td>
		         <td class="width-35"><sys:treeselect id="primaryPerson" name="primaryPerson.id" value="${office.primaryPerson.id}" labelName="office.primaryPerson.name" labelValue="${office.primaryPerson.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/></td>
		     	 <td class="width-15 active"><label class="pull-right">副负责人:</label></td>
		         <td class="width-35"><sys:treeselect id="deputyPerson" name="deputyPerson.id" value="${office.deputyPerson.id}" labelName="office.deputyPerson.name" labelValue="${office.deputyPerson.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/></td>
		      </tr>
		      <tr>
		         <td class="width-15 active"><label class="pull-right">邮箱:</label></td>
		         <td class="width-35"><form:input path="email" htmlEscape="false" maxlength="50" cssClass="form-control" /></td>
		         <td class="width-15 active"><label class="pull-right">联系地址:</label></td>
		         <td class="width-35"><form:input path="address" htmlEscape="false" maxlength="50" cssClass="form-control" /></td>
		      </tr>
		      <tr>
		         <td class="width-15 active"><label class="pull-right">邮政编码:</label></td>
		         <td class="width-35"><form:input path="zipCode" htmlEscape="false" maxlength="50" onkeyup="this.value=this.value.replace(/[^\d]/g,'') " onafterpaste="this.value=this.value.replace(/[^\d]/g,'') " cssClass="form-control" /></td>
		         <td  class="width-15 active"><label class="pull-right">负责人:</label></td>
		         <td class="width-35"><form:input path="master" htmlEscape="false" maxlength="50" cssClass="form-control" /></td>
		      </tr>
		      <tr>
		         <td class="width-15 active"><label class="pull-right">电话:</label></td>
		         <td class="width-35"><form:input path="phone" htmlEscape="false" maxlength="50" onkeyup="this.value=this.value.replace(/[^\d]/g,'') " onafterpaste="this.value=this.value.replace(/[^\d]/g,'') " cssClass="form-control" /></td>
		         <td  class="width-15 active"><label class="pull-right">传真:</label></td>
		         <td class="width-35"><form:input path="fax" htmlEscape="false" maxlength="50" cssClass="form-control" /></td>
		      </tr>
		      <tr>
		         <td  class="width-15 active"><label class="pull-right">备注:</label></td>
		         <td class="width-35"><form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="form-control"/></td>
		      	<td  class="width-15 active"><label class="pull-right"></label></td>
		         <td  class="width-35" ></td>
		      </tr>
	      </tbody>
	      </table>
	</form:form>
</body>
</html>