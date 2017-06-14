<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据对象管理</title>
	<meta name="decorator" content="default"/>
</head>
<body class="change_table_margin">
	<sys:message content="${message}"/>
	<%--<input id="objCata" name="objCata" type="hidden" value="${objectMain.objCata}"/>--%>
	<font size="4" style="display:block;margin-top:1%">数据表对象</font>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer"  id="css">
	   <tbody>
		  <tr>
			 <td class="width-15 active"><label class="pull-right">对象名称：</label></td>
			 <td class="width-35">${objectTable.objName }</td>

			 <td  class="width-15 active"><label class="pull-right">对象编码：</label></td>
			 <td class="width-35">${objectTable.objCode }</td>
		  </tr>
		  <tr>
			 <td  class="width-15 active"><label class="pull-right">对象类型：</label></td>
			<td class="width-35">${objectTable.objType}</td>

			<td class="width-15 active"><label class="pull-right">对象描述：</label></td>
			<td class="width-35">${objectTable.objDesc}</td>
		  </tr>
		  <tr>
			<td class="width-15 active"><label class="pull-right">业务部门：</label></td>
			<td class="width-35">${objectTable.office.name }</td>

			<td class="width-15 active"><label class="pull-right">业务负责人：</label></td>
			<td class="width-35">${objectTable.user.name }</td>
		 </tr>
		 <tr>
			<td class="width-15 active" id="applyDate"  ><label class="pull-right" >创建时间：</label></td>
			<td class="width-35"><fmt:formatDate value="${objectTable.createDate }" pattern="yyyy-MM-dd HH:mm:ss" /> </td>

		</tr>


		</tbody>
	</table>
<font size="4">数据表记录</font>
	<%--<input id="objCata" name="objCata" type="hidden" value="${objectMais.objCata}"/>--%>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer"  id="css">
	   <tbody>
		 <tr>
			<td class="width-15 active" id="applyDate"><label class="pull-right">数据表：</label></td>
			<td class="width-35">${objectMais.tableName}</td>
			<td class="width-15 active" id="applyDate"><label class="pull-right">数据源连接：</label></td>
			<td class="width-35">${objectMais.tableLink}</td>
		</tr>
		 <tr>
			<td class="width-15 active" id="applyDate"><label class="pull-right">数据量 记录数：</label></td>
			<td class="width-35">${objectMais.dataNum}</td>
			<td class="width-15 active" id="applyDate"><label class="pull-right">数据库类别：</label></td>
			<td class="width-35">${objectMais.dbType}</td>
		</tr>
		 <tr>
			<td class="width-15 active" id="applyDate"><label class="pull-right">database名称：</label></td>
			<td class="width-35">${objectMais.dbDataBase}</td>
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
	     	<c:if test="${objectTable.objType eq '1'}">
	     		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">数据表详情</a>
			 </li>
			</c:if>
			 <c:if test="${objectTable.objType eq '2'}">
	     		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">文件信息</a>
			 </li>
			 </c:if>
			<%--   <c:if test="${objectMain.objType eq '4'}">
	     		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">接口信息</a>
			 </li>
			 </c:if> --%>
			  <c:if test="${objectTable.objType eq '数据表'}">
	     		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="false">字段信息</a>
			 </li>
	     	</c:if>
			<li class=" "><a data-toggle="tab" href="#tab-2" aria-expanded="false">收藏用户</a>

			 </li>
			 <li class=""><a data-toggle="tab" href="#tab-3" aria-expanded="false">申请用户</a>

         </ul>

		 <div class="tab-content">
		 <div id="tab-1" class="tab-pane active">
			<!-- 数据表，字段表， -->
		 <!-- 字段表 -->
	<c:if test="${objectTable.objType eq '数据表'}">
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
	var tablenu;
	$(document).ready(function () {
		tablenu = $('#contentTable').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : false,// 分页按钮
			searching : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : '',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/metadata/dcObjectTable/ajaxfieldlist?belong2Id=${objectTable.id}",
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
	  <c:if test="${objectTable.objType eq '2'}">
	  </c:if>
	  	  <!-- 文件夹 -->
	  <c:if test="${objectTable.objType eq '5'}">

	  </c:if>
		</div>




				 <div id="tab-2" class="tab-pane ">
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
				url : "${ctx}/dc/metadata/dcObjectMain/ajaxliste?id=${objectTable.id}",
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


		  <!--tab3-->
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
				url : "${ctx}/dc/metadata/dcObjectMain/ajaxlists?id=${objectTable.id}",
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
                        "data": "name"
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