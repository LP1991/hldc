<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>数据转换设计</title>
<meta name="decorator" content="default" />

<script type="text/javascript">
</script>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
	<div class="wrapper wrapper-content">
	<dc:bizHelp title="转换可视化设计" label="转换可视化设计, 为用户提供数据转换设计页面, 以可视化的方式设计数据转换任务" ></dc:bizHelp>
		<div class="ibox" style="margin-bottom:0;">
			<br>
			<form:form id="searchForm" modelAttribute="design"  method="post" class="form-inline">
				<div class="form-group">
					<span>转换名称：</span><form:input path="designName" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
					<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
				 </div>	
			</form:form>
			<br/>
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<button class="btn btn-success btn-rect btn-sm" data-toggle="tooltip" data-placement="left"  dataFlag="add" onclick="openFullModel('转换可视化设计','${ctx}/dc/dataProcess/process/form','auto','auto')" title="设计"><i class="fa fa-arrows-alt"></i> 设计</button>
					</div>
				</div>
			</div>
		</div>

		<table id="contentTable"
			class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable"  cellspacing="0" width="100%">
			<thead>
				<tr>
				
					<th class="designName">转换名称</th>
					<th class="designDesc">转换描述</th>
					<th class="createName">创建者</th>
					<th class="updateDate">更新时间</th>
					<th class="status">状态</th>
					<th>操作</th>
				</tr>
			</thead>			
		</table>
	
	</div>

		<script>
	var table,editDisable;
	$(document).ready(function () {
		table = $('#contentTable').DataTable({
			"processing": true,
			"serverSide" : true,
			"bPaginate" : true,// 分页按钮 
			"searching" : false, //禁用搜索
			"ordering": false, //禁用排序
			"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			"autoWidth" : true, //自动宽度
			"bFilter" : false, //列筛序功能
			"ajax" : {
				url : "${ctx}/dc/dataProcess/process/ajaxlist",
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
						"data" : "designName"
					}, {
						"data" : "designDesc"
					}, {
						"data" : "createBy.name"
					}, {
						"data" : "updateDate"
					}, {
						"data" : "status"
					}, {
						"data" : null,width: "250px"
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 5,
						render : function (a, b) {//${ctx}/dc/dataProcess/process/view?
                         	var html= '<a href="#" onclick="openFullModel(\'查看\',\'${ctx}/dc/dataProcess/process/form?id='+a.id+'&editDisable\',\'800px\', \'500px\')" class="btn btn-success btn-xs" title="查看转换可视化设计"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openFullModel(\'转换可视化设计\', \'${ctx}/dc/dataProcess/process/form?id='+a.id+'\',\'800px\', \'500px\')" 	class="btn btn-success btn-xs" title="编辑转换可视化设计"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a href="#" onclick="deleteA(\'${ctx}/dc/dataProcess/process/ajaxDelete?id='+a.id+'\',\'任务\') " class="btn btn-success btn-xs" title="删除转换可视化设计"><i class="fa fa-trash"></i></a>&nbsp;';
							html+= '<a href="#" onclick="testJob(\''+a.id+'\')" class="btn btn-success btn-xs" title="测试任务"><i class="fa fa-bug"></i></a>&nbsp;';
							html+= '<a href="#" onclick="add2Schedule(\''+a.id+'\')" class="btn btn-success btn-xs" title="添加调度任务"><i class="fa fa-tasks"></i></a>';
							return html;
						}
					},{
						targets : 3,
						render : function (a, b) {
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
							return html;
						}
					},{
						targets : 4,
						render : function (a, b) {
							var html= getDataFromAjax( '${ctx}/sys/dict/getDictLabel',{value:a, type:'dc_task_status'});
							return html;
						}
					}
				],
				//初始化完成回调
				"initComplete": function(settings, json) {
				},
			//重绘回调
			"drawCallback": function( settings ) {
// 				$('.i-checks').iCheck({
// 					checkboxClass: 'icheckbox_square-green',
// 					radioClass: 'iradio_square-green',
// 				});
			}
		});
	});
	
	//测试任务
	function testJob(jobId){
		loading("测试中，请稍候...");
		submitData('${ctx}/dc/dataProcess/process/runTask', {'jobId':jobId}, function(data){
			closeTip();
			top.layer.alert(data.msg, {
				title : '运行结果',
				area: ['680px', '340px']
			});
		});
	}
	
	//添加至调度列表
	function add2Schedule(jobId){
		confirmx('您确定要添加该调度任务？', function(){
			submitData('${ctx}/dc/dataProcess/process/add2Schedule', {'jobId':jobId},function(data){
				var icon_number;
				if(!data.success){
					icon_number = 8;
				}else{
					icon_number = 1;
				}
				top.layer.alert(data.msg, {icon: icon_number, title:'系统提示'});
				// 刷新表格数据，分页信息不会重置
				if (typeof(table) != "undefined") { 
					table.ajax.reload( null, false ); 
				}
			});
		})
	}
	
	//全屏弹出窗口
	function openFullModel(title, url, width, height) {//增加参数，判断是否可编辑
		//打开目标窗口
		if(url.indexOf('&editDisable')!==-1){
			editDisable = 'editDisable';
		}else{
			editDisable = "";
		}
	
	var pageHight = (document.body.clientHeight-10)+'px' , pageWidth= (document.body.clientWidth-20)+'px';
		console.log(pageHight, pageWidth);
		top.layer.open({
			type : 2,
			title : title,
			maxmin : false, //关闭最大化最小化按钮
			area : [ pageWidth, pageHight ],
			offset: ['60px','160px'],
			content : url,
			success : function(layero, index) {	//将index传递给目标窗口, 不然没法关闭, 目标页面需实现 function setPIndexId 设置隐藏字段'cur_indexId'
				top.layer.closeAll('loading');
				var iframeWin = layero.find('iframe')[0]; // 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
		
				if (typeof(table) == "undefined") {
					if(editDisable){
						iframeWin.contentWindow.setPIndexId(index,editDisable);
					}else{
						iframeWin.contentWindow.setPIndexId(index);
					}					
				}else{
					if(editDisable){
						iframeWin.contentWindow.setPIndexId(index,table,editDisable);
					}else{
						iframeWin.contentWindow.setPIndexId(index,table);
					}
				}				
			}
		});
		top.layer.load(1,{content:'<p class="loading_style">加载中，请稍后。</p>'});
	}
	</script>
	
</body>
</html>
