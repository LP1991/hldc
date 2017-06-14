<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>元数据接口发布</title>
	<meta name="decorator" content="default"/>
</head>
<br>
    <fieldset class="change_table_margin">
        <legend>数据表</legend>
        <form:form id="tableForm" modelAttribute="objectTable" class="form-horizontal">
            <input id="tableName" name="tableName" type="hidden" value="${objectTable.tableName}"/>
            <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
                <tbody>
                <tr>
                    <td  class="width-15 active"  class="active"><label class="pull-right">表空间:</label></td>
                    <td  class="width-65" >${objectTable.dbDataBase}</td>
                <tr>
                </tr>
                    <td  class="width-15 active"  class="active"><label class="pull-right">数据表名:</label></td>
                    <td  class="width-65" >${objectTable.tableName}</td>
                </tr>
                </tr>
                    <td  class="width-15 active"  class="active"><label class="pull-right">对象描述:</label></td>
                    <td  class="width-65" >${objectTable.objDesc}</td>
                </tr>
                </tbody>
            </table>
        </form:form>
    </fieldset>
    <br/>
    <fieldset class="change_table_margin">
        <legend>接口配置</legend>
        <form:form id="inputForm" modelAttribute="objectIntf"  class="form-horizontal">
            <form:hidden path="objId"/>
            <input id="intfcSrcId" name="intfcSrcId" type="hidden" value="${objectTable.objId}"/>
            <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
               <tbody>
                  <tr>
                   <td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>接口名称:</label></td>
                    <td  class="width-65" >
                        <form:input path="objName" htmlEscape="false" maxlength="50" class="form-control required"/></td>
                </tr>
                <tr>
                    <td  class="width-15 active"  class="active"><label class="pull-right">接口描述:</label></td>
                    <td  class="width-65" ><form:input path="objDesc" htmlEscape="false" maxlength="200" class="form-control"/></td>
                </tr>
                <tr>
                    <td  class="width-15 active"  class="active"><label class="pull-right">开放字段:</label></td>
                    <td class="width-65">
                        <dc:treeselect
                                allowInput="true"
                                clearItem="true"
                                id="intfcFields"
                                name="intfcFields"
                                value="${objectIntf.intfcFields}"
                                labelName="数据表字段"
                                labelValue="${objectIntf.intfcFields}"
                                notAllowSelectParent="true"
                                checked="true"
                                title="数据表字段"
                                url="/dc/metadata/dcObjectTable/queryTableFieldList"
                                otherParam1="intfcSrcId"
                                otherParam2="tableName"
                                cssClass="form-control">
                        </dc:treeselect>
                        <span class="help-inline">接口对象列表包含的字段信息, 默认为所有字段</span>
                    </td>
                </tr>
                <tr>
                    <td  class="width-15 active"  class="active"><label class="pull-right">限制条件:</label></td>
                    <td  class="width-65" >
                        <form:input path="intfcParams" htmlEscape="false" maxlength="200" class="form-control "/>
                        <span class="help-inline">查询接口对象列表的限制条件, 填写格式:字段名|操作符|对比值,多个条件以' and '分割  e.g.fieldA='1' and fieldb>0</span>
                    </td>
                </tr>
                <tr>
                    <td  class="width-15 active"  class="active"><label class="pull-right">排序方式:</label></td>
                    <td  class="width-65" >
                        <form:input path="orderFields" htmlEscape="false" maxlength="160" class="form-control "/>
                        <span class="help-inline">指定接口数据的排序方式, 填写格式:字段名|排序方式(默认升序), 多个排序字段以','分割  e.g.fieldA, fieldB asc</span>
                    </td>
                </tr>
                </tbody>
              </table>
        </form:form>
    </fieldset>

	<script>
		//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		var validateForm;
		validateForm = $("#inputForm").validate({
			errorContainer: "#messageBox",
			errorPlacement: function(error, element) {
				$("#messageBox").text("输入有误，请先更正。");
				if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
					error.appendTo(element.parent().parent());
				} else {
					error.insertAfter(element);
				}
			}
		});
		function doSubmit(index, table) {
			if (validateForm.form()) {
                submitData('${ctx}/dc/metadata/dcObjectTable/ajaxPub2Interface', getFormParams('inputForm'), function (data) {
                    top.layer.alert(data.msg, {
                        title : '系统提示'
                    });
                    if(data.success){
                        //刷新表格
                        table.ajax.reload();
                        //关闭form面板
                        top.layer.close(index)
                    }
                });
			}
		}
	</script>
</body>
</html>