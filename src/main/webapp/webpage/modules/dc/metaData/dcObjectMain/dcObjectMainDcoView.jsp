<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>文件对象</title>
	<meta name="decorator" content="default"/>
</head>
<body style="margin: 0 1.5% 0 2%;">
	<sys:message content="${message}"/>

	<font size="4" style="display:block;margin-top:1%">文件对象</font>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer"  id="css">
	   <tbody>
		  <tr>
			 <td class="width-15 active"><label class="pull-right">对象名称：</label></td>
			 <td class="width-35">${objectMais.objName }</td>
		 
			 <td  class="width-15 active"><label class="pull-right">对象编码：</label></td>
			 <td class="width-35">${objectMais.objCode }</td>
		  </tr>
		  <tr>
			 <td  class="width-15 active"><label class="pull-right">对象类型：</label></td>
			<td class="width-35">${objectMais.objType}</td>
		
			<td class="width-15 active"><label class="pull-right">对象描述：</label></td>
			<td class="width-35">${objectMais.objDesc}</td>
		  </tr>
		  <tr>
			<td class="width-15 active"><label class="pull-right">业务部门：</label></td>
			<td class="width-35">${objectMais.office.name }</td>

			<td class="width-15 active"><label class="pull-right">业务负责人：</label></td>
			<td class="width-35">${objectMais.user.name }</td>
		 </tr>
		 <tr>
			<td class="width-15 active" id="applyDate"  ><label class="pull-right" >创建时间：</label></td>
			<td class="width-35"><fmt:formatDate value="${objectMais.createDate }" pattern="yyyy-MM-dd HH:mm:ss" /> </td>
	
		</tr>
		
		
		</tbody>
	</table>
<font size="4">文件目录</font>

	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer"  id="css">
	   <tbody>
		  <tr>
			<td class="width-15 active" id="applyDate"><label class="pull-right">文件名：</label></td>
			<td class="width-35">${objectMais.fileName}</td>
			<td class="width-15 active" id="applyDate"><label class="pull-right">文件路径：</label></td>
			<td class="width-35">${objectMais.fileUrl}</td>
		</tr>
		  <tr>
			  <td class="width-15 active"><label class="pull-right">标签:</label></td>
			  <td class="width-35" colspan="3">
				  <c:forEach items="${objLabelList}" var="lab">
					  <span class="label label-info">${lab.labelName}</span>
				  </c:forEach>
			  </td>
		  </tr>
		</tbody>
	</table>

	     <ul class="nav nav-tabs" style="margin-bottom:10px;">
	   		 <!--  数据表 -->
	     	<c:if test="${objectMain.objType eq '1'}">
	     		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">数据表详情</a>
			 </li>
			</c:if>
			 <c:if test="${objectMain.objType eq '2'}">
	     		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">文件信息</a>
			 </li>
			 </c:if>
			<%--   <c:if test="${objectMain.objType eq '4'}">
	     		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">接口信息</a>
			 </li>
			 </c:if> --%>
			  <c:if test="${objectMain.objType eq '5'}">
	     		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">文件信息</a>
			 </li>
	     	</c:if>
			<li class="active"><a data-toggle="tab" href="#tab-2" aria-expanded="true">收藏用户</a>
			 </li>
			 <li class=""><a data-toggle="tab" href="#tab-3" aria-expanded="false">申请用户</a>
			 </li>
         </ul>
		 
		 <div class="tab-content">
		 <div id="tab-1" class="tab-pane active">
			<!-- 数据表，字段表， -->
		 <!-- 字段表 -->
	<c:if test="${objectMain.objType eq '5'}">
				 <table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
		<thead>
			<tr>
					<th>字段名</th>
					<th>类型</th>
					<th>长度</th>
					<th>描述</th>
			</tr>
		</thead>
	</table>
	
	<script>
	$(function(){
		setTimeout(function(){
			$('#contentTable_wrapper').hide();
			
		})
	})
	var table;
	$(document).ready(function () {
		table = $('#contentTable').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : false,// 分页按钮 
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : '',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/metadata/dcObjectMain/ajaxfieldlist?belong2Id=${objectMain.id}",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					
					$.extend(d, getFormParams('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					{
						"data" : "fieldName"
					}, {
						"data" : "fieldType"
					}, 
					{
						"data" : "fieldLeng"
					},
					{
						"data" : "remarks"
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  }
				],
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
	

	</script>
	
	</c:if>
	  <!-- 文件 -->
	  <c:if test="${objectMain.objType eq '2'}">
	  </c:if>
	  	  <!-- 文件夹 -->
	  <c:if test="${objectMain.objType eq '5'}">
		
	  </c:if>
		</div>
		
	
	
			  <div id="tab-2" class="tab-pane active">
	 <table id="sertser" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="width:100%">
		<thead>
			<tr>
					<th>收藏用户名</th>
					<th>收藏时间</th>
					
			</tr>
		</thead>

	</table>
		 	<script>
	var table;
	$(function(){
		setTimeout(function(){
		
			$('#sertser_wrapper').hide();  
			
		})
	})
	$(document).ready(function () {
		table = $('#sertser').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : false,// 分页按钮 
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : '',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/metadata/dcObjectMain/ajaxliste?id=${objectMain.id}",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					
					$.extend(d, getFormParams('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					{
						"data" : "name"
					}, {
						"data" : "collectTime"
					} 
					
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  }
				],
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
	

	</script>
		  </div>
		 
		  
		  <!--tab2-->
			  <div id="tab-3" class="tab-pane">
	 <table id="sert" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
		<thead>
			<tr>
					<th>申请用户名</th>
				      <th>申请时间</th>
					<th>状态</th>
					
			</tr>
		</thead>

	</table>
	


	<script>
	var table;
	$(function(){
		setTimeout(function(){ 
			$('#sert_wrapper').hide();
		})
	})
	$(document).ready(function () {
		table = $('#sert').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : false,// 分页按钮 
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : '',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/metadata/dcObjectMain/ajaxlists?id=${objectMain.id}",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					
					$.extend(d, getFormParams('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					{
						"data" : "name"
                    },{
                        "data":"collectTime"
					}, {
						"data" : "status"
					} 
					
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  }
				],
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
	</script>
		  </div>
		  </div>

</body>

</html>