<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<title>元数据修改</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
<script type="text/javascript">
	var validateForm;
	function doSubmit(index, table) {//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		setTimeout(function() {//TODO待后期优化
			if (validateForm.form()) {
                loadMsg();
				submitData('${ctx}/dc/metadata/dcObjectIntf/ajaxSaveIntf', getFormParams('inputForm'), function(data) {
                    closeLoadMsg();
					top.layer.alert(data.msg, {
						icon : 3,
						title : '系统提示'
					});
					if (data.success) {
						//刷新表格
						table.ajax.reload();
						//关闭form面板
						top.layer.close(index)
					}
				});
			}
		}, 1000);

	}
	$(document).ready(
			function() {
				validateForm = $("#inputForm").validate({
					submitHandler : function(form) {
						loading('正在提交，请稍等...');
						form.submit();
					},
					errorContainer : "#messageBox",
					errorPlacement : function(error, element) {
						$("#messageBox").text("输入有误，请先更正。");
						if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
							error.appendTo(element.parent().parent());
						} else {
							error.insertAfter(element);
						}
					}
				});
			});
</script>
<style type="text/css">
	li{
		list-style:none;
	}
	.btn_d{
		display:inline;
		float:left;
	}
</style>
</head>
<body>
	<form:form id="inputForm" modelAttribute="objectIntf" action="#" autocomplete="off" method="post" class="form-horizontal">
		<form:hidden path="objId" />
		<sys:message content="${message}" />
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>对象名称:</label></td>
					<td class="width-35"><input id="oldJobName" name="oldJobName" type="hidden" value="${objectIntf.objName}">
						<form:input path="objName" htmlEscape="false" class="form-control required" />
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>对象编码:</label></td>
					<td class="width-35"><form:input path="objCode" htmlEscape="false" class="form-control  required" /></td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>对象描述:</label></td>
					<td class="width-35"><form:input path="objDesc" htmlEscape="false" class="form-control required" /></td>
					<td class="width-15 active"><label class="pull-right">业务部门:</label></td>
					<td><sys:treeselect id="managerOrg" name="managerOrg"
							value="${objectIntf.office.id}"
							labelName="objectIntf.office.name"
							labelValue="${objectIntf.office.name}" title="业务部门"
							url="/sys/office/treeData?type=2"
							cssClass="form-control" notAllowSelectParent="true" />
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">业务负责人:</label></td>
					<td class="width-35"><dc:treeselect id="managerPer"
							name="managerPer" value="${objectIntf.user.id}"
							labelName="objectIntf.user.name"
							labelValue="${objectIntf.user.name}" title="用户"
							url="/sys/office/getUsertreeData?type=3" cssClass="form-control"
							allowClear="true" notAllowSelectParent="true" otherParam1="managerOrgId"/>
					</td>
				</tr>
				
			</tbody>
		</table>
	</form:form>
	<div class="tabs-container form-horizontal">
	     <ul class="nav nav-tabs" style="margin-bottom:10px;">
			<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">标签管理</a>
			 </li>
         </ul>

		 <div class="tab-content">
		 <div id="tab-1" class="tab-pane active">
					<div class="wrapper wrapper-content" style="padding:0;">
		<div class="row">
		<div class="col-sm-12">
		
						<div class="btn_d id">
					
							<shiro:hasPermission name="dc:searchLabel:add">
						<table:addRow url="${ctx}/dc/metadata/dcObjectMain/adds" title="标签"></table:addRow>
						<!-- 增加按钮 -->
					</shiro:hasPermission>
					
					</div>
				
		</div>
		</div>
		<table id="LabelTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
			<thead>
				<tr>
					<th><input type="checkbox" class="i-checks"></th>
					<th  class="">标签名称</th>
					<th  class="">标签描述</th>
					<th  class="">备注</th>
					<th>操作</th>
				</tr>
			</thead>
		</table>
	</div>
	
	<script type="text/javascript">
	
	var table;
	$(document).ready(function () {
		//console.log('${dcTaskQueue.id}');
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
			//初始化列表
			table = $('#LabelTable').DataTable({
				"processing": true,
				"serverSide" : true,
				"bPaginate" : true,// 分页按钮 
				"searching" : false, //禁用搜索
				"ordering": false, //禁用排序
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : true, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/dc/metadata/dcObjectMain/ajaxLabel?mainId="+$('#objId').val(),
					"data" : function (d) {
						$.extend(d, {});
					},
					"dataSrc" : function (json) {//定义返回数据对象
						return JSON.parse(json.body.gson);
					}
				},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, {
						"data" : "labelName"
					}, {
						"data" : "labelDesc"
					}, {
						"data" : "status"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
					"defaultContent": "",
					"targets": "_all"
				  },{
					targets : 4,
					render : function (a, b) {	//console.dir(a);
					
					var	html = '<a href="#" onclick="openDialog(\'编辑标签\', \'${ctx}/dc/metadata/dcObjectMain/forms?id='+a.id+'\', \'800px\', \'480px\')" class="btn btn-success btn-xs" title="编辑标签"><i class="fa fa-edit"></i></a>&nbsp;';
						html+= '<a onclick="deleteA(\'${ctx}/dc/metadata/dcObjectMain/deleteLabel?id='+a.id+'\',\'标签\') " class="btn btn-success btn-xs" title="删除标签"><i class="fa fa-trash"></i></a>&nbsp;';
						return html;
					}
				}],
				//初始化完成回调
				"initComplete": function(settings, json) {
				},
				//重绘回调
				"drawCallback": function( settings ) {
					$('.i-checks').iCheck({
						checkboxClass: 'icheckbox_square-green',
						radioClass: 'iradio_square-green',
					});
				}
			});
	});	
	//添加对象标签  add by peijd

	function addObjLabel(){	
		layer.prompt({
            formType: 3,
            value: '',
            title: '添加标签'
        }, function(value, index, elem){
			if(value){
				//保存标签
				submitData('${ctx}/dc/dataSearch/dcSearchLabel/ajaxSaveLabelRef', {
					'objId': $('#id').val(),
					'labelName':value
				}, function (data) {
					if(data.success){	//保存成功
						layer.close(index);
						$('#btn_addLabel').before('<span class="label label-info">'+value+'</span> ');				 
						//$('<span class="label label-info">'+value+'</span>').after($('#btn_addLabel'));	
					}else{
						layer.alert(data.msg, {icon: 8, title:'系统提示'});
						
						return false;
						
					}
				});
			}else{
				return false;
			}
        });
	}

	</script>
		 </div>
		  <!--tab3-->
		
		 </div>
	</div> 
</body>

</html>