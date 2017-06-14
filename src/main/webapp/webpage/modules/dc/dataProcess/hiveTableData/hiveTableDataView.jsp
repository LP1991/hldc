<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据表信息查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
       window.onload=function(){openField(); }

	    function openField(){
			$("#dataList").hide();
			$("#fieldList").show();
		}
		function openData(){
			$("#dataList").show();
			$("#fieldList").hide();
		}
	</script>
	<style>
		.tabs-container{
/* 			width: 96%;
		    margin-left: 2%;
		    height: 66%; */
		}
	</style>
</head>
<body onload="openField()">
	<sys:message content="${message}"/>	
	<fieldset class="change_table_margin">
		<legend style="color:#333;">数据表基本信息</legend>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tr>
				<td class="width-15 active"><label class="pull-right">数据表名:</label></td>
				<td class="width-35">${dcHiveTable.tableName}</td>
				<td class="width-15 active"><label class="pull-right">数据表空间:</label></td>
				<td class="width-35">${dcHiveTable.tableSpace}</td>
			</tr>	
			<tr>
			    <td class="width-15  active"><label class="pull-right">文件位置:</label></td>
				<td class="width-35">${dcHiveTable.location}</td>
				<td class="width-15  active"><label class="pull-right">分割符:</label></td>
				<td>${dcHiveTable.separatorSign}</td>
			</tr>
			<tr>
	            <td class="width-15 active"><label class="pull-right">表描述:</label></td>
				<td class="width-35">${dcHiveTable.tableDesc}</td>
			</tr>
		</table>
    </fieldset>
	
	<div class="tabs-container change_table_margin">
        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab"  onclick="openField()" aria-expanded="true">字段信息</a></li>
            <li class=""><a data-toggle="tab" onclick="openData()" aria-expanded="false">数据信息</a></li>
        </ul>
        
		<div id="tab-1" >
            <table id="fieldList" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;">
	            <tr>
				    <td align="center" class="fieldName active">字段名称</td>
				    <td align="center" class="fieldType active">字段类型</td>
				    <td align="center" class="fieldDesc active">字段描述</td>
			    </tr> 
         	    <c:forEach items="${fieldList}" var="index">
			        <tr>
			            <td align="center"  id="fieldName">${index.fieldName}</td>
			            <td align="center"  id="fieldType">${index.fieldType}</td>
			            <td align="center"  id="fieldDesc">${index.fieldDesc}</td>
			        </tr>
			    </c:forEach>	 
	        </table>
        </div>
		
        <div id = "tab-2"  >            
            <table id="dataList" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;">
		        <tr>
				    <c:forEach items="${dataList}" var="index" varStatus="status">
				        <c:if test="${status.index=='0'}" >
				            <c:forEach items="${index}" var="ina" >
					            <td style="text-align:center; " class="active">${ina.key}</td>
				            </c:forEach>
				        </c:if>					
				    </c:forEach>
			    </tr> 
         	    <c:forEach items="${dataList}" var="index">
		            <tr>	
			            <c:forEach items="${index}" var="inx">
			                <td style="text-align:center">${inx.value}</td>
			            </c:forEach>
			        </tr>
			    </c:forEach>			  
	        </table>
	    </div>
	</div>
	
</body>
</html>