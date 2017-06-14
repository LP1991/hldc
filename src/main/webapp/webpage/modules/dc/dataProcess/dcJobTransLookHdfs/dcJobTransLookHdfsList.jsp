<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>hdfs获取远程数据进行上传和下载</title>
	<meta name="decorator" content="default"/>
	<style>
		.margins{
			margin-left: 10px;
			margin-top: 3px;
		}
	</style>
	<script src="${ctxStatic}/common/contabs.js"></script>
	<script type="text/javascript">
		//1级一直往下点击时触发
		function openPath2(pathName,folderNames){
			$("#searchForm").attr("action","${ctx}/dc/dataProcess/hdfsLook/ajaxlist");
			var durl = $("#searchForm").attr("action")+"?tempPath="+pathName;
			//移除路径
			$('#appen').empty();
			var html = '';
			// /点击最少是/ 
			html+="<a onclick=\"openPath2('/','/')\">"
			html+=" <span>/</span> ";
			html+="</a>";
			//循环路径 
			var arr = pathName.split("/");
			for(var i=1;i<arr.length;i++){
				//如果为空，跳过
				if(arr[i]==""){
					continue;
				}
				//拼接路径
				var zongpath ="/";
				for(var j=1;j<=i;j++){
					zongpath+=arr[j]+"/";
				}
				//对应文件完整路径
				//var p = pathName.replace() /555/6666   555
				html+="<a onclick=\"openPath2(\'"+zongpath+"','"+arr[i]+"\')\">";
				html+=arr[i];
				html+="</a>";
				html+=" <span>/</span> ";
			}
/* 			html+="<a onclick=\"openPath2(\'"+pathName+"','"+folderNames+"\')\">";
			html+=folderNames;
			html+="</a>";
			html+="/";
 */			$('#appen').append(html);
	        $("#searchForm").attr("action",durl);
	    	table.ajax.url(durl).load();
		}
		
 		function dowloadTo(filePath,fileName){
			var form = $("<form>");
		   form.attr('style','display:none');   //在form表单中添加查询参数
		   form.attr('target','');
		   form.attr('method','post');
		   form.attr('action',"${ctx}/dc/dataProcess/hdfsLook/exportHdfsFile");
		  
		   var input1 = $('<input>'); 
		   input1.attr('type','hidden'); 
		   input1.attr('name','fileName'); 
		   input1.attr('value',fileName); 
		   
		   var input2 = $('<input>'); 
		   input2.attr('type','hidden'); 
		   input2.attr('name','filePath'); 
		   input2.attr('value',filePath); 
		  
		   $('body').append(form);  //将表单放置在web中
		   form.append(input1);   //将查询参数控件提交到表单上
		   form.append(input2);
		   form.submit();   //表单提交
		} 
 		
 		//上传
 		function uploads(){
 			var path = $("#appen").text();
 			openDialog("上传文件","${ctx}/dc/dataProcess/hdfsLook/uploads?tempPath="+path,"600px", "300px",this.name,typeof(option) == "undefined"?{}:option);
 		}
 		
 		//创建文件夹
 		function CreateDir(){
 			var path = $("#appen").text();
 			openDialog("创建文件夹","${ctx}/dc/dataProcess/hdfsLook/create?tempPath="+path+"&&fileordir=1","600px", "300px",this.name,typeof(option) == "undefined"?{}:option);
 		}
 		
 		//创建文件
 		function CreateFile(){
 			var path = $("#appen").text();
 			openDialog("创建文件","${ctx}/dc/dataProcess/hdfsLook/create?tempPath="+path+"&&fileordir=0","600px", "300px",this.name,typeof(option) == "undefined"?{}:option);
 		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<dc:bizHelp title="本地文件上传" label="本地文件上传" ></dc:bizHelp>
		<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<!-- 查询时跳转当前 路径不变-->
	<form:form id="searchForm" modelAttribute="dcHdfsFileLook" action="${ctx}/dc/dataProcess/hdfsLook/ajaxlist" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="pathName" name="pathName" type="hidden" />
		<div class="form-group">
			<span>文件路径：</span>
				<form:input path="folderName" htmlEscape="false"  class="form-control input-sm"/>
			<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
	<br/>
	</div>
	</div>
		
		<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<button class="btn btn-success btn-rect btn-sm" data-toggle="tooltip" data-placement="left"  dataFlag="add" onclick="uploads()" title="上传"><i class="fa fa-plus"></i> 上传</button>
			<button class="btn btn-success btn-rect btn-sm" data-toggle="tooltip" data-placement="left"   onclick="CreateDir()" title="创建文件夹"><i class="fa fa-plus"></i> 创建文件夹</button>
			<table:delRow url="${ctx}/dc/dataProcess/hdfsLook/deleteAll" id="contentTable"></table:delRow>
			<!-- <button class="btn btn-success btn-rect btn-sm" data-toggle="tooltip" data-placement="left"   onclick="CreateFile()" title="创建文件"><i class="fa fa-plus"></i> 创建文件</button> -->
		</div>
		
	</div>
	</div>
		<!-- 当前路径判断 可以通过循环加载路径 可以放map里，显示键，值为完整路径-->
	<c:if test="${dcHdfsFileLook.tempPath != null}">
		<input type="hidden" value="${dcHdfsFileLook.tempPath}" id="firstV">
		<input type="hidden" value="${dcHdfsFileLook.pathName}" id="firstN">
	</c:if>
	<br/>
	<br/>
	<div><div style="float:left">Edit Path&nbsp;&nbsp;&nbsp;&nbsp;</div><p style="float:left"><a onclick="openPath2('/','/')">root&nbsp;&nbsp;</a></p><p id="appen"><a onclick="openPath2('/','/')"><span>/</span></p></a></div>
		
	
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%"">
		<thead>
			<tr>
				<th><input type="checkbox" class="i-checks"></th>
				<th class="jobName">文件名</th>
				<th class="jobDesc">文件大小</th>
				<th>用户</th>
				<th>部门</th>
				<th>权限</th>
				<th>创建日期</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
 
	<script>
	var table;
	$(document).ready(function () {
		var ac="${ctx}/dc/dataProcess/hdfsLook/ajaxlist"
		var v = $("#firstV").attr("value");
		var pathName = $("#firstN").attr("value");
		if(v!=undefined){
			ac =ac+"?tempPath="+v;
			//移除路径
			$('#appen').empty();
			var html = '';
			// /点击最少是/ 
			html+="<a onclick=\"openPath2('/','/')\">"
			html+=" <span>/</span> ";
			html+="</a>";
			//循环路径 
			var arr = v.split("/");
			for(var i=1;i<arr.length;i++){
				//如果为空，跳过
				if(arr[i]==""){
					continue;
				}
				//拼接路径
				var zongpath ="/";
				for(var j=1;j<=i;j++){
					zongpath+=arr[j]+"/";
				}
				//对应文件完整路径
				html+="<a onclick=\"openPath2(\'"+zongpath+"','"+arr[i]+"\')\">";
				html+=arr[i];
				html+="</a>";
				html+=" <span>/</span> ";
			}
			$('#appen').append(html);
		}
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
				url : ac,
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParamsObj('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, {
						"data" : null
					}, {
						"data" : null
					},{
						"data" : "owner"
					},{
						"data" : "group"
					},{
						"data" : "permissions"
					},{
						"data" : "DateT"
					},{
						"data" : null
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
                	  targets : 1,
						render : function (a, b) {
							var html='';
							if(a.isDir==true){
								html='<a onclick="openPath2(\''+a.pathName+'\',\''+a.folderName+'\')"><img src="${ctxStatic}/img/dir.png" width="15" height="15"></img>'+a.folderName+"</a>";
							}else{
								var type =  a.folderName.substring(a.folderName.lastIndexOf(".")+1,a.folderName.length);
								if(type=="xlsx"||type=="xls"||type=="docx"||type=="doc"){
										html+='<a onclick="dowloadTo(\''+a.pathName+'\',\''+a.folderName+'\')",\'800px\', \'500px\')"><img src="${ctxStatic}/img/file.png" width="15" height="15"></img>'+a.folderName+"</a>";
								}else{
									html+='<a onclick="openDialogView(\'查看文件\', \'${ctx}/dc/dataProcess/hdfsLook/openHdfsFile?filePath='+a.pathName+'&&fileName='+a.folderName+'\',\'800px\', \'500px\')"><img src="${ctxStatic}/img/file.png" width="15" height="15"></img>'+a.folderName+"</a>";
								}
							}
							return html;
						}
                },{
                	  targets : 2,
						render : function (a, b) {
							var html='';
							if(a.isDir==true){
								html='';
							}else{
								html+=a.Size;
							}
							return html;
						}
                  },{
                	  targets : 6,
						render : function (a, b) {
							//a指当前的值 
							var str0 = a.toString().split(', ')[0];
							var str2 = a.toString().split(', ')[1];
							//var year = str2.split(' ').length>0 && str2.split(' ')[0];
							var year = str2.split(' ')[0];
							var month = str0.split(' ')[0];
							var day = str0.split(' ')[1]<10?'0'+str0.split(' ')[1] : str0.split(' ')[1];
							var time = str2.split(' ')[1];//小时 分钟 秒 
							var hour = time.split(':')[0]<10 ? '0'+time.split(':')[0] : time.split(':')[0];
							var minute = time.split(':')[1];
							var second = time.split(':')[2];
							var time = hour+":"+minute+":"+second;
							switch (month){
								case 'Jan':
								  month='01';
								  break;
								case 'Feb':
								  month='02';
								  break;
								case 'Mar':
								  month='03';
								  break;
								case 'Apr':
								  month='04';
								  break;
								case 'May':
								  month='05';
								  break;
								case 'Jun':
									month='06';
								  break;
								case 'Jul':
									month='07';
								  break;
								case 'Aug':
									month='08';
								  break;
								case 'Sep':
									month='09';
								  break;
								case 'Oct':
									month='10';
								  break;							
								case 'Nov':
									month='11';
								  break;							
		                  		case 'Dec':
		                  			month='12';
							  	  break;
							}
							var date = year+'-'+month+'-'+day+'   '+time;						
							return date;
						}
                  },
                  {
						targets : 7,
						render : function (a, b) {
							var html ='';
							//显示问题，如果是文件是查看，目录是下一级
							if(a.isDir==true){
							html+= '<a class="btn btn-success btn-xs" onclick="openPath2(\''+a.pathName+'\',\''+a.folderName+'\') " >下一级</a>&nbsp;&nbsp;';
							}
							if(a.isDir==false){
							//html+= '<a class="btn btn-success btn-xs" onclick="openDialogView(\'查看文件\', \'${ctx}/dc/dataProcess/hdfsLook/openHdfsFile?filePath='+a.pathName+'\',\'800px\', \'680px\')" ><i class="fa fa-search-plus"></i></a>';
							var type =  a.folderName.substring(a.folderName.lastIndexOf(".")+1,a.folderName.length);
							if(type=="xlsx"||type=="xls"||type=="docx"||type=="doc"){
								html+='<a class="btn btn-success btn-xs" onclick="dowloadTo(\''+a.pathName+'\',\''+a.folderName+'\')" ><i class="fa fa-search-plus"></i></a>&nbsp;';
							}else{
								html+='<a title="查看文件" class="btn btn-success btn-xs" onclick="openDialogView(\'查看文件\', \'${ctx}/dc/dataProcess/hdfsLook/openHdfsFile?filePath='+a.pathName+'&&fileName='+a.folderName+'\',\'800px\', \'500px\')" ><i class="fa fa-search-plus"></i></a>&nbsp;';
							}
							}
							//重命名 
							html+='<a title="重命名" class="btn btn-success btn-xs" onclick="openDialog(\'重命名\', \'${ctx}/dc/dataProcess/hdfsLook/toRename?pathName='+a.pathName+'&&folderName='+a.folderName+'\',\'800px\', \'500px\')" >重命名</a>&nbsp;';
							//删除
							if(a.isDir==true){
								html+='<a title="移除(可恢复)" onclick="return confirmx(\'确认要移除吗？（可恢复）\',\'${ctx}/dc/dataProcess/hdfsLook/remove?pathName='+a.pathName+'&&folderName='+a.folderName+'&&type=5&&tempPath='+$("#appen").text()+'\')" class="btn btn-success btn-xs"><i class="fa fa-time"></i>移除</a>&nbsp;';
								html+='<a title="彻底删除(不可恢复)" onclick="return confirmx(\'确认要永久删除该文件吗？（不可恢复）\',\'${ctx}/dc/dataProcess/hdfsLook/deletePath?pathName='+a.pathName+'&&type=5&&folderName='+a.folderName+'&&tempPath='+$("#appen").text()+'\')" class="btn btn-success btn-xs"><i class="fa fa-trash"></i>彻底删除</a>&nbsp;';
							}else{
								html+='<a title="移除(可恢复)" onclick="return confirmx(\'确认要删除吗？（可恢复）\',\'${ctx}/dc/dataProcess/hdfsLook/remove?pathName='+a.pathName+'&&folderName='+a.folderName+'&&type=2&&tempPath='+$("#appen").text()+'\')" class="btn btn-success btn-xs"><i class="fa fa-time"></i>移除</a>&nbsp;';
								html+='<a title="彻底删除(不可恢复)" onclick="return confirmx(\'确认要永久删除该文件吗？（不可恢复）\',\'${ctx}/dc/dataProcess/hdfsLook/deletePath?pathName='+a.pathName+'&&type=2&&folderName='+a.folderName+'&&tempPath='+$("#appen").text()+'\')" class="btn btn-success btn-xs"><i class="fa fa-trash"></i>彻底删除</a>&nbsp;';
							}
							//移动
							//html+='';
							//改变权限 
							//html+='';
							//下载
							if(a.isDir==false){
								html+='<a class="btn btn-success btn-xs" onclick="dowloadTo(\''+a.pathName+'\',\''+a.folderName+'\') " >下载</a>';
							}
							return html;
						}
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
</html>