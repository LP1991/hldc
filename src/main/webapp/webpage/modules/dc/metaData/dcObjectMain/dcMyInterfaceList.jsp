<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>接口对象管理</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
	</style>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="我的接口对象" label="用于查看当前用户可以访问的接口对象." ></dc:bizHelp>
	
	<!-- 查询条件 -->
	<div class="row">
		<div class="col-sm-12">
			<form:form id="searchForm" modelAttribute="interface"  method="post" class="form-inline">
				<div class="form-group">
					<span>对象名称：</span><form:input path="objName" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
					<span>对象编码：</span><form:input path="objCode" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
					<span>数据来源：</span>
					<form:select path="applySrc" class="form-control input-sm">
						<form:option value="">全部</form:option>
						<form:option value="1">管理员添加</form:option>
						<form:option value="2">业务申请</form:option>
					</form:select>
					<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
				 </div>
			</form:form>
			<br/>
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<button class="btn btn-success btn-rect  btn-sm " onclick="viewMyKey()"  type="button"><i class="fa fa-key"></i> 查看我的密钥</button>
						<button class="btn btn-success btn-rect  btn-sm " onclick="downDesJar()"  type="button"><i class="fa fa-download"></i> 下载解密jar包</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>			
				<th class="objName">对象名称</th>
				<th class="objCode">对象编码</th>
				<th class="objDesc">对象描述</th>
				<th class="intfcType">接口类别</th>
				<th class="intfcUrl">接口地址</th>
				<th class="managerOrg">业务部门</th>
				<th class="managerPer">业务负责人</th>
				<th class="applySrc">数据来源</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
 
	<script>
		var table;
		$(document).ready(function () {
			table = $('#contentTable').DataTable({
				"processing": true,
				"serverSide" : true,
				"bPaginate" : true,// 分页按钮
				searching : false, //禁用搜索
				"ordering": false, //禁用排序
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : true, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/dc/metadata/dcObjectIntf/myAjaxlist",
					"data" : function (d) {
						//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
						$.extend(d, getFormParams('searchForm'));
						$('th：last-child').width('100px');
					},
					"dataSrc" : function (json) {//定义返回数据对象
						return JSON.parse(json.body.gson);
					}
				},
					"columns" : [
						{
							"data" : "objName"
						}, {
							"data" : "objCode"
						}, {
							"data" : "objDesc"
						},{
							"data" : "intfcType"
						},{
							"data" : "intfcUrl"
						}, {
							"data" : "office.name"
						}, {
							"data" : "user.name"
						}, {
							"data" : "applySrc"
                        }, {
                            "data" : null
						}
					],
					columnDefs : [{
						"defaultContent": "",
						"targets": "_all"
					  },{
							targets : 7,
							render : function (a, b) {
								return a=='1'?'管理员添加':'业务申请';
							}
						},{
							targets : 8,
							render : function (a, b) {
								var html = '<a href="#" onclick="openDialogView(\'查看接口对象\', \'${ctx}/dc/metadata/dcObjectIntf/intfView?id='+a.id+'\',\'900px\', \'760px\')" class="btn btn-success btn-xs" title="查看对象"><i class="fa fa-search-plus"></i></a>&nbsp;';
								return html;
							}
						}
					],
					//初始化完成回调
					"initComplete": function(settings, json) {
					},
				//重绘回调
				"drawCallback": function( settings ) {
				}
			});
			setTimeout(function(){
				$('th:last-child').width('100px');
			})
		});

		//查看我的密钥
		function viewMyKey() {
            submitData("${ctx}/dc/metadata/dcObjectIntf/viewMyKey",{},function(data){
                var icon_number;
                if(!data.success){
                    top.layer.alert(data.msg, {icon: 8, title:'提示'});
                }else{
                    top.layer.alert('您的密钥为: '+data.msg, {icon: 1, title:'提示'});
                }
            });
        }

        //下载解密jar
        function downDesJar(){
            var form = $("<form>");
            form.attr('style','display:none');   //在form表单中添加查询参数
            form.attr('target','');
            form.attr('method','post');
            form.attr('action',"${ctx}/dc/metadata/dcObjectIntf/downDesJar");

            $('body').append(form);  //将表单放置在web中
            form.submit();   //表单提交
		}

	</script>
	
	</div>
</body>
</html>