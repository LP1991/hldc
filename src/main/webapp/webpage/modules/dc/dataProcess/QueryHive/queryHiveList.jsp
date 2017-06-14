
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<title>信息查阅</title>
<meta name="decorator" content="default"/>
	<script type="text/javascript">
		 $(document).ready(function(){
			openField();
			getAllHiveTableNames();
			
			$("#tableSpace").change(function(){
				getAllHiveTableNames();
			});
			$('.assist-table li').css({
				"list-style":"none",
				"margin-left":"1em"
				});		
			$('#_help_Content-Main label').eq(0).css({"fontSize":"2.5em"});
			
			$('#_help_Content-Main label').eq(1).css({"fontSize":"2.08em"});
		 });

	    function openField(){
			$("#tab_2").removeClass("active");
			$("#tab_1").addClass("active");
			$("#dataResults").hide();
			$("#sqlResults").show();
		}
		function openData(){
			$("#tab_1").removeClass("active");
			$("#tab_2").addClass("active");
			$("#dataResults").show();
			$("#sqlResults").hide();
		} 
	
        function getAllHiveTableNames(){
			submitData("${ctx}/dc/dataProcess/queryHive/getAllHiveTableNames?dbName="+$("#tableSpace").val(),null,function(result){
				var tableNameList = result.body.tableNames;
				$('#tableName').empty();
				var html='';
				for(var i=0;i<tableNameList.length;i++){
				    if(tableNameList[i]['tab_name']!=undefined){
                        html +='<li class="assist-table" style="list-style:none;margin-left:1%;"><a href="#" class="assist-entry assist-table-link" id="'+tableNameList[i]['tab_name']+'" ><i class="fa fa-fw fa-table muted valign-middle"></i><span> '+tableNameList[i]['tab_name']+'</span></a></li>';
					}
				}
				
                $("#tableName").append(html);
		    },null,'get','json',false);
		}
		
		function runSql(){
/*  			var date = new Date();
            var str =  date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+' '+date.getHours()+':'+ date.getMinutes()+':'+date.getSeconds();
			var data = $('#sqlResults').val();
	
			var html='';
	            html +='<li class=""><a href="#" class="">'+str+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+$("#sql").val()+'</a></li>';		
			$("#sqlResults").append(html);  */


			var tableSpace = $("#tableSpace").val();
			
			submitData("${ctx}/dc/dataProcess/queryHive/runSql?sql="+$("#sql").val()+"&dbName="+tableSpace,null,function(result){
				var dataList = result.body.dataList;
				var html1 = '';
				$('#dataResults').empty();
				html1 +=' <table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" >';
				html1+='<thead>';
                html1+='<tr>';
				for(key in dataList[0]){
					html1+='<th>'+key+'</th>';
				}
				html1+='</tr>';
				html1+='</thead>';
				html1+='<tbody>';
				for(var i=0;i<dataList.length;i++){
					html1+='<tr>';
					for(key in dataList[i]){
						html1+='<td>'+dataList[i][key]+'</td>';
					}
					html1+='</tr>';
				}
				html1+='</tbody>';
				html1 +='</table>';
				$("#dataResults").append(html1);
				openData();
				getAllHiveTableNames();
				loadTable();
		    },null,'get','json',false);
			
			submitData("${ctx}/dc/dataProcess/queryHive/getHistory",null,function(result){
				var dataList = result.body.dataList;
				var html = '';
				$("#sqlResults").empty();
				html += '<table id="history" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: auto;">';
				html+='<tbody>';
				for(var i=0;i<dataList.length;i++){
					html+='<tr style="cursor:pointer;" onclick="QuerySql(\''+dataList[i]['hsql']+'\',\''+dataList[i]['hdbName']+'\')">';
					html+='<td>'+dataList[i]['hdate']+'</td>';
					if(dataList[i]['htype']=="success"){
						html+='<td>success</td>'
					}else{
						html+='<td>error</td>'
					}
					html+='<td>'+dataList[i]['hsql']+'</td>';
					html+='</tr>';
				}
				html+='</tbody>';
				html+='</table>'
				$("#sqlResults").append(html); 
			},null,'get','json',false);
			
		}
		
		function hiveDS(){
			submitData("${ctx}/dc/dataProcess/queryHive/hiveDS",null,function(result){
				
				alert("数据同步成功");
               
		    },null,'get','json',false);
			
		}
		
		//点击 
		function QuerySql(sql,dbname){
			document.getElementById("sql").value = sql;
			//提交sql到后台,返回查询结果值
			submitData("${ctx}/dc/dataProcess/queryHive/runSql?sql="+sql+"&dbName="+dbname,null,function(result){
				var dataList = result.body.dataList;
				var html1 = '';
				$('#dataResults').empty();
				html1 +=' <table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0">';
				html1+='<thead>';
                html1+='<tr>';
				for(key in dataList[0]){
					html1+='<th>'+key+'</th>';
				}
				html1+='</tr>';
				html1+='</thead>';
				html1+='<tbody>';
				for(var i=0;i<dataList.length;i++){
					html1+='<tr>';
					for(key in dataList[i]){
						html1+='<td>'+dataList[i][key]+'</td>';
					}
					html1+='</tr>';
				}
				html1+='</tbody>';
				html1 +='</table>';
				$("#dataResults").append(html1);
				openData();
				loadTable();
			},null,'get','json',false);
			
			submitData("${ctx}/dc/dataProcess/queryHive/getHistory",null,function(result){
				var dataList = result.body.dataList;
				var html = '';
				$("#sqlResults").empty();
				html += '<table id="history" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: auto;">';
				html+='<tbody>';
				for(var i=0;i<dataList.length;i++){
					html+='<tr style="cursor:pointer;" onclick="QuerySql(\''+dataList[i]['hsql']+'\',\''+dataList[i]['hdbName']+'\')">';
					html+='<td>'+dataList[i]['hdate']+'</td>';
					if(dataList[i]['htype']=="success"){
						html+='<td>success</td>';
					}else{
						html+='<td>error</td>';
					}
					html+='<td>'+dataList[i]['hsql']+'</td>';
					html+='</tr>';
				}
				html+='</tbody>';
				html+='</table>';
				$("#sqlResults").append(html); 
			},null,'get','json',false);
		}
		
		function loadTable(){
			$('#contentTable').DataTable( {
				bPaginate : false,// 分页按钮 
				"searching" : "true", //禁用搜索
				ordering: false, //禁用排序
			    scrollY: "350px",
			    scrollX: "350px",
			    "scrollCollapse": "true",
			    "dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
			     paging: false
			  } );
		}
		$(function(){
			var _move=false;//移动标记  
			var _x,_y;//鼠标离控件左上角的相对位置  
			var top_width;
			    $(".dragLine").click(function(){    
			        }).mousedown(function(e){  
			        _move=true;  
			        _x=e.pageX-parseInt($(".dragLine").css("left"));  
			        //_y=e.pageY-parseInt($(".dragLine").css("top"));  
			        //$(".drag").fadeTo(20, 0.5);//点击后开始拖动并透明显示  
			    });  
			    $(document).mousemove(function(e){  
			        if(_move){  
			        	$('body').css({"cursor":"e-resize"});
			        	$('body').css({"-moz-user-select": "none", "-khtml-user-select": "none", "user-select": "none"});
			            var x=e.pageX-_x;//移动时根据鼠标位置计算控件左上角的绝对位置  
			            var z = $('.wrapper-content').innerWidth()-x-20;
			            top_width = $('.wrapper-content').innerWidth();
			            var n_x = parseInt(x/top_width * 100);
			            var n_z = parseInt((z/top_width) * 100);
			            x = parseInt(x/top_width * 100)+'%';
			            z = parseInt((z/top_width) * 100)+'%';
			            //var y=e.pageY-_y;  
			            //增加最小宽度限制,
			            if(n_x>6&&n_x<92&&n_z>20){
			            	$(".choice_table").css({'width':x});//控件新位置  
				            $('.write_textarea').css({'width':z});
				            $('.history_result').css({'width':z});
			            }
			        }  
			    }).mouseup(function(){ 
			    	$('body').css({"cursor":"auto"});
			    	_move=false;  
			    })
			    window.onresize=function(){
			    	
			    }
		})
	</script>
	<style type="text/css">

		html,body,ul,li,ol,dl,dd,dt,p,h1,h2,h3,h4,h5,h6,form,fieldset,legend,img {
		    margin: 0;
		    padding: 0
		}
		fieldset,img {
		    border: 0
		}
		img {
		    display: block
		}
		address,caption,cite,code,dfn,th,var {
		    font-style: normal;
		    font-weight: normal
		}
		ul,ol {
		    list-style: none
		}
		input {
		    padding-top: 0;
		    padding-bottom: 0;
		    font-family: "SimSun","宋体"
		}
		input::-moz-focus-inner {
		    border: 0;
		    padding: 0
		}
		select,input {
		    vertical-align: middle
		}
		select,input,textarea {
		    font-size: 12px;
		    margin: 0;
		}
		input[type="text"],input[type="password"],textarea {
		    outline-style: none;
		    -webkit-appearance: none
		}
		textarea {
		    resize: none
		}
		table {
		    border-collapse: collapse
		}
		/* 私有样式 */
		.muted {
	   	 color: #999;
		}
		.valign-middle {
		    vertical-align: middle;
		}
		.assist-inner-header {
		    width: 100%;
		    color: #737373;
		    margin-left: 0.4em;
		    margin-bottom: 2px;
		    font-weight: bold;
		    margin-top: 0.4em;    
		}
		.hive_name{
			font-size: 2em;line-height: 2em;float: left;
		}
		.assist-table>li{
			position: relative;
		    padding-top: 0.2em;
		    padding-bottom: 0.2em;
		    padding-left: 1.4em;
		    margin-right: 1.5em;
		    overflow-x: hidden;		    
		}
		.assist-table li{
			list-style: none;
		}
		.assist-table-link, .assist-table-link:focus {
		    color: #444;
		}
		.gray-bg{
			font-size:62.5%;
			/* 设置相对长度 */
		}
		.choice_table{
			width: 15%;
			float: left;
			background:#fff;
			border: solid 1px rgb(169, 169, 169);
			margin-right:20px;
			position:relative;
		}
		.choice_table .add_style_tableName{
			width:98%;
			height: 55em;
			margin-left:1%;
			overflow :auto;
		}
		.change_btn{
		    overflow:hidden;
		    margin:6px 0;
		    /* 清除浮动 */
		}
		.change_btn i:active{
			color:#23527C !important;
		}
		.change_btn button:active{
			background-color:#23527C !important;
		}
		.tb_btn{
		    padding: 0.6em 0;
		    width: 3.6em ;
		    text-align: center;
		    font-size: 10px;
		    line-height: 1.5;
		    background: #337ab7;
		    color: white;
		    outline: none;
		    border: none;
		    margin-right:0.2em;
		    margin-left:0.2em;
		}
		.change_btn .fresh{
			background: transparent;
    		border-color: transparent;
		    height: 3em;
		    text-align: center;
		    line-height: 3em;
		    margin-right:0.4em;
		    margin-left:0.4em;
		}
		.change_btn .fa-refresh{
			color: #1c84c6 !important;
    		font-size: 2.8em !important;
		}
		.change_btn .run_sql{
		    height: 3em;
		    text-align: center;
		    line-height: 3em;
		     margin-right:0.4em;
		    margin-left:0.4em;
		}
		.change_btn .run_sql>i{
			font-size:2.8em;
		}
		.write_textarea{
			width:83%;
			margin:0 !important;
			float:right;
			margin-bottom: 1%;
		}
		.write_textarea>textarea{
			width: 100%;
			margin: 0px; 
			min-height: 160px;
			max-height: 600px;
			resize: vertical;
		}
		.history_result{
			width:83%;
		    margin: 0 !important;
		    float: RIGHT;
		    height:auto;
		}
		.history_result .tabs-container{
			background:#fff;
			min-height:300px;
		}
		.history_result .tabs-container>ul{
			background:#f5f5f5;
		}
		.dragLine{
			height: 100%;
		    width: 6px;
		    position: absolute;
		    right: -3px;
		    top: 0;
		    cursor: e-resize;
		}
		
		@media screen and (max-width: 1250px) {
		    .hive_name {
		        float:none;
		    }
		    .assist-inner-header{
		    	overflow:auto;
		    	height:auto;
		    }
		    body{
		    	overflow-y:auto;
		    }
		}
		@media screen and (max-width: 610px) {
		    .history_result{
		    	width:67% !important;
		    }
		    .write_textarea{
		    	width: 70% !important;
		    }
		    body{
		    	overflow-y:auto;
		    }
		}
		@media screen and (max-width: 1520px) {
		    .hive_name{
		    	font-size: 0.6em;
    			width: 6em;
		    }

		    select{
		    	appearance:none;
			    -moz-appearance:none;
			    -webkit-appearance:none;
		    }
		    select::-ms-expand { display: none; }
		    select{
		    	font-size: 1.6em;
			    height: 1.9em;
			    width: 4em;
		    }
		    #tableSpace option{
		    	width:3.2em;
		    	padding-right:0;
		    	padding-left:0;
		    }
		}
	</style>	
</head>
<body class="gray-bg" style="overflow: hidden;overflow-y:auto;">
   <sys:message content="${message}"/>
<div class="wrapper wrapper-content">
 	<dc:bizHelp title="信息查阅"  label="通过此功能,用户可以自助实现信息查阅过程." ></dc:bizHelp> <!--业务帮助 -->
    <div class="choice_table" style="height:80%;">
    	<div class="assist-inner-header">
        	<p class="hive_name">hive表空间：</p>
				<select  id="tableSpace"  style="font-size:1.6em;height:1.9em;">
		    		<option  value="default">default</option>
				<c:forEach items="${dbList}" var="index" >
			   	 	<option value="${index.database}">${index.database}</option>
				</c:forEach>
			</select>
			<button class="btn btn-success btn-rect btn-sm" style="padding:0;padding: 0.1em 0.6em;" data-toggle="tooltip" data-placement="left"  dataFlag="add" onclick="getAllHiveTableNames()" ><i class="fa fa-search"></i> 确定</button>			
        </div>
        <ul class="add_style_tableName" id="tableName">
        	<li class="assist-table" style="list-style:none;"><a href="#" class="assist-entry assist-table-link" id="" ><i class="fa fa-fw fa-table muted valign-middle"></i><span>customer</span></a></li>
			<%-- <c:forEach items="${dbList}" var="index">
				<li class=""><a href="#" class="" id="${index.database}" >${index.database}</a></li>
			</c:forEach> --%>
			</li>
		</ul>
		<div class="dragLine"></div>
    </div>

    <div class="write_textarea">
        <textarea id="sql" style="width:100%;height:100%;"></textarea>
    </div>
    <div class="history_result">
    <div class="change_btn">
		<a class="fresh" data-toggle="tooltip" data-placement="left"  dataFlag="add" onclick="getAllHiveTableNames()"><i class="fa fa-refresh"></i></a> 
		<button class="tb_btn" data-toggle="tooltip" data-placement="left" dataFlag="add" onclick="hiveDS()" >同步</button>
	    <a href="javascript:;" class="run_sql" data-toggle="tooltip" data-placement="left"  dataFlag="search" onclick="runSql()"><i class="fa fa-play"></i></a>
	</div>
        <div class="tabs-container">
            <ul class="nav nav-tabs">
                <li class="active" id="tab_1"><a data-toggle="tab"  onclick="openField()" aria-expanded="true">历史信息</a></li>
                <li class="" id="tab_2"><a data-toggle="tab" onclick="openData()" aria-expanded="false">结果数据</a></li>
            </ul>
        
		<div id ="sqlResults" style="overflow:auto;height:auto">
			<table class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: auto;">
				<c:forEach items="${hisList}" var="map">
					<tr style="cursor:pointer;" onclick="QuerySql('${map.HSql}','${map.HDbName}')">
						<td>
							${map.HDate}
						</td>
						<td>
							<c:if test="${map.HType eq 'success'}">success</c:if>
							<c:if test="${map.HType ne 'success'}">error</c:if>
						</td>
						<td>
							${map.HSql}
						</td>
					</tr>
			 	</c:forEach>
			</table>
		</div>
		
        <div id = "dataResults" style="height:auto;"></div> 
		</div> 
    </div>
</div>
</body>
</html>