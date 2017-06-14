<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>字段信息设置</title>
	<meta name="decorator" content="default"/>	
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
	<script type="text/javascript">
		function doSubmit(index,table){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			var list = new Array(),data = new Array();
			
			var idx=0;
			var fieldList = $("#fieldList").text();
			for(var i=1;i<$('#fieldList tr').length;i++){//将表格中的字段取出来，
				data = $('#fieldList tr').eq(i).text().split("\n");
				list[idx]={fieldName:data[1],fieldType:data[2],fieldDesc:data[3]};//把得到的数据组成list格式
				idx++;
			}
			submitData( '${ctx}/dc/dataProcess/hiveTableData/ajaxFieldSave',{
				'remarks':JSON.stringify(list),
				'belong2Id':$("#tableId").val()
			},function(data){
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
		}
	</script>
</head>
<body class="hideScroll">
	<sys:message content="${message}"/>
	<input type="hidden" id="id"/>
    <table id="fieldList" class="change_table_margin table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;">
	    <tr>
			<td style="text-align:center;" class="active">字段名称</td>
			<td style="text-align:center;" class="active">字段类型</td>
			<td style="text-align:center;" class="active">字段描述</td>
		</tr> 
        <c:forEach items="${fieldList}" var="index">
		    <tr>	
		        <td style="text-align:center" contenteditable="true">${index.fieldName}</td>
				<td style="text-align:center" contenteditable="true">${index.fieldType}</td>
				<td style="text-align:center" contenteditable="true">${index.fieldDesc}</td>
			</tr>
		</c:forEach>	 
	</table>
	<input type="hidden" id="tableId" value="${dcHiveTable.id}">
</body>
</html>