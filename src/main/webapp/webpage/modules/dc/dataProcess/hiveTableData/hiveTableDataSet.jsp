<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据信息设置</title>
	<meta name="decorator" content="default"/>	
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
	<script type="text/javascript">
		function getDataFromCatalog(index,table){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			// console.log($("#ctatlogPath").val());
            // console.log($('#IsLoadData').is(':checked'));
            if(!$("#ctatlogPathId").val()){
            	top.layer.alert('请选择数据', {icon: 8, title:'系统提示'});
            	return false;
            }
			submitData( '${ctx}/dc/dataProcess/hiveTableData/getDataFromCatalog',{
				'remarks':$("#ctatlogPathId").val(),
				'IsLoadData':$('#IsLoadData').is(':checked'),
				'id':$("#objId").val()
			},function(result){
				var icon_number;
				if(result.msg.indexOf('失败')!==-1){
					icon_number = 8;
				}else{
					icon_number = 1;
				}
				top.layer.alert(result.msg, {icon: icon_number, title:'系统提示'});

				if(result.success!=true){
					return false;
				}else{
					//刷新表格
					//table.ajax.reload();
					//关闭form面板
					top.layer.close(index)
					return true;
				}
			});	
		}
	</script>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<form:form id="inputForm" action="#" autocomplete="off" method="post" class="form-horizontal">
		<input type="hidden" id="objId" value="${dcHiveTable.id}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
				<tr>
					<td  class="width-15 active"><label class="pull-right"><font color="red">*</font>hdfs文件路径：</label></td>
					<td  class="width-35" >
						<%--<input type="text" id="ctatlogPath"  maxLength="600" class="form-control required">--%>
							<dc:treeselect2 allowInput="false" clearItem="true" id="ctatlogPath" name="ctatlogPath" value="" labelName="目标路径" labelValue=""  title="目标路径" url="/dc/dataProcess/hiveTableData/HdfsPathTreeData" cssClass="form-control required" notAllowSelectParent="true"/>
							<span class="help-inline">导入hdfs文件路径</span>
					</td>
				</tr>
				<tr>
					<td  class="width-15 active" ><label class="pull-right">是否覆盖:</label></td>
					<td  class="width-35" >
						<input type="checkbox" id="IsLoadData" name="IsLoadData" ></br>
						<span class="help-inline">选择覆盖将删除原有表数据</span>
					</td>
				</tr>	
			</tbody>
		</table>
	</form:form>
<!-- 	<button class="btn btn-success btn-rect btn-sm" data-toggle="tooltip" data-placement="left"  dataFlag="add" onclick="getDataFromCatalog()" ><i class="fa fa-search"></i> 确定</button> -->			
	
  
    <table id="fieldList" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" style="overflow: scroll;">
		<thead>
			<tr>
				<c:forEach items="${dataList}" var="index" varStatus="status">
				    <c:if test="${status.index=='0'}" >
				        <c:forEach items="${index}" var="ina" >
					        <th style="text-align:center;" contenteditable="true">${ina.key}</th>
				        </c:forEach>
				    </c:if>					
				</c:forEach>
			</tr> 
		</thead>
        <c:forEach items="${dataList}" var="index">
		    <tr>	
			    <c:forEach items="${index}" var="inx">
			        <td style="text-align:center" contenteditable="true">${inx.value}</td>
			    </c:forEach>
			</tr>
		</c:forEach>			  
	</table>
</body>
</html>