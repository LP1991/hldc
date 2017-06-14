<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>数据转换设计</title>
	<meta name="decorator" content="default"/>
	<!--引入angular-->

<script type="text/javascript" src="${ctxStatic}/underscore/underscore.js"></script>
	
<script type="text/javascript" src="${ctxStatic}/angular/angular.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/angular-sanitize/angular-sanitize.js"></script>
<script type="text/javascript" src="${ctxStatic}/angular-ui-select/dist/select.min.js"></script>
<!--自定义文件-->


<link href="${ctxStatic}/bootstrap/dist/css/bootstrap.css" rel="stylesheet" />


<!-- 引入d3-->
<script type="text/javascript" src="${ctxStatic}/d3/d3.min.js"></script>
<script src="${ctxStatic}/angular-drag/angular-drag.js" type="text/javascript"></script>
<link href="${ctxStatic}/angular-ui-select/dist/select.min.css" type="text/css" rel="stylesheet" />
<link href="${ctxStatic}/common/pipelineGraph/css/pipelineGraph.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="${ctxStatic}/common/pipelineGraph/js/pipelineGraph.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/pipelineGraph/js/splitterDirectives.js"></script>
<!-- hlframe -->
<link href="${ctxStatic}/common/hlframe.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/common/hlframe.js" type="text/javascript"></script>
	<script type="text/javascript">
		var table;

		var ctx = '${ctx}';
		//设置当前页 IndexId
		function setPIndexId(val,t){//添加edit判断是否有值传入
			table=t;
			$('#cur_indexId').val(val);		
		}
		//关闭当前层
		function close_layer(){
	         var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
	         parent.layer.close(index);
		}
		
		//页面接收数据 
		var get_obj = "${design.designJson}".replace(/&quot;/g,'"');//将&quot转换为引号
		var get_name = "${design.designName}".replace(/&quot;/g,'"');
		var get_desc = "${design.designDesc}".replace(/&quot;/g,'"');
		
 		function common_found(n){//bootstrap自带的tab切换无法使用，手动添加切换tab页代码
			$('.tab-pane').eq(n).show().siblings().hide();
			$('#myTab li').eq(n).addClass("active").siblings().removeClass("active");
			$('.tab-pane').eq(n).addClass('active');
			$('.tab-pane').eq(n).siblings().removeClass('active');
			var ab = $('.ui-select-container');
			 for(var i=0;i<ab.length;i++){
			 	ab.eq(i).width(ab.eq(i).parent().width());
			 }
		 }
		 $(function(){
			 /* 窗口改变iframe自适应  */
			 var oId = window.frameElement && window.frameElement.id;
		    top.onresize = function(){			
			   if(oId){
		    		$('.layui-layer-content',window.parent.document).css({"height":'92%'});
		    		$('#'+oId,window.parent.document).css({"height":'100%'});
		    		$('.layui-layer-iframe',window.parent.document).css({"width":top.innerWidth*0.80+'px'});
		    		$('.layui-layer-iframe',window.parent.document).css({"height":top.innerHeight*0.80+'px'});
		    	}
		    }	
			 /* 点击折叠表格 */
				 $('.dataintable tbody tr').eq(0).on('click','.hideTable',function(){
					 $(this).parent().parent().parent().toggleClass('hideClass');
				 });
			})
			 //判断当前页面iframe的url 
			 var oId = window.frameElement && window.frameElement.id;
				if($('#'+oId,parent.document).parent().siblings().text().indexOf('查看')!==-1){
					$('.add,.delete,.add_source,.add_map,.add_target,.save_pipeline').hide();
				}
	</script>
	<style type="text/css">
	html,body{
		overflow:hidden !important;
	}
		.form-horizontal{
			height:100%;
			overflow-y: hidden !important;
		}
	    .tab-content{
	    	overflow-y: scroll !important;
	    	overflow-x: hidden;
    		height: 83%;
	    }		    
		.total_app{
			height:100%;
			width:auto;
		}
		.pipeline_btn{
			height:4%;
			min-height:40px;
		}
		.my-info{
			height:100%;
/* 			min-height:300px; */
		}
		.container_box{
			height:52%;
		}
		.tab_parent{
			height:42%;
		}
		/* tab切换标签 */
		.tab_parent .nav-tabs{
/* 			min-height:30px;
			height:15%;
			margin-bottom: 0 !important; */
		}
		.tab_parent .tab_content{
			height: auto;
		    overflow: hidden;
		    width: 100%;
		}
		/* 自定义拖拽 */
		.split-handler{
			position: absolute;
		    left: 0;
		    height: 4px;
		    background: transparent;
		    width: 100%;
		    cursor: row-resize;		
		}
		.cross_field{
			width: auto;
		    max-width: 4%;
		    float: left;
		    position: fixed;
		    top: 74%;
		    left: 38%;
		}
		.ui-select-choices{
			top:34px !important;
			bottom:-200px !important;
		}
		@media screen and (max-width:960px){
			   .tab_parent ul{
			   		height:18%;
			   }
			  .tab_parent ul>li>a{
			  		padding: 7px 6px;
			  }
		}
		#map_filter .dataintable{
			/* margin-top:1% !important; */
			margin-top:10px !important;
			/* margin-left:2%; */
			float:left;
		}
		
		.filter,.map_filter{
			width:40% !important;
			margin-bottom:20px;		
		}
		.filter tbody tr:nth-child(1) th:nth-child(1),.map_filter tbody tr:nth-child(1) th:nth-child(1){
			width:32%;
		}
		.filter tbody tr:nth-child(1) th:nth-child(2),.map_filter tbody tr:nth-child(1) th:nth-child(2){
			width:40%;
		}

		#map_filter .btn-group{
			float: left;
		    margin-top: 2%;
		    margin-left: 2%;
		}
		.map_table{
			width: 30%;float: left;margin-left: 2%;margin-top: 2%;
		}
		#profile .map_table{
			margin-top:1%;
		}
		#profile .dataintable{
			/* margin-top:0 !important; */
		}
		#profile .filter{
			margin-top:10px !important;
		}
		.set_express span{
			display:block;
			text-align:center;
			font-size:1.6em;
			line-height:100%;
		}
		#cognate .dataintable:nth-child(1){
			width: 45%;clear:none;
			margin-top:0 !important;
		}
		#cognate .dataintable:nth-child(2){
			width: 40%;clear:none;
			margin-top:0 !important;
		}

		#map_filter .btn-group button{
			margin-bottom:4px;
		}
		.cognate_field_btn{
			float: left;
    		margin-left: 2%;
    		margin-top:2%;
		}
		.cognate_field_btn .btn{
			display:block;
			float:none;
			margin-bottom:4px;
		}
		#inputForm #cognate .dataintable {
			width:40%;
			margin-bottom:20px !important;
		}
		.ui-select-choices{
			min-width:0 !important;
		}
		
		.cognate_add,.map_filter_add,.xy_filter_add{
			display:block;
			float:none;
			/* margin: 0.3% 0 0 2%; */
			/* margin-bottom:5px; */
		}
		#profile .target_div .dataintable{
			margin-top:20px;
		}
		.total_app .tab-content .map_filed_table2 .dataintable{
			margin-top:0 !important;
		}
		.change_btn{
			
		}
		.result_btn{
			width:100%;
		}
		.result_btn button{
			width:100%;
		}
		/* 表达式 */
		.map_filed_table2 table{
			
		}
		/* 进度条 */
		.write_loading{
			width:140px;
			height:38px;
			border-radius:4%;
			background-size:100% 100%;
			background-image:url('${ctxStatic}/common/img/loading.gif');
			background-repeat:no-repeat;
			position:fixed;
			top:32%;
			left:42%;	
			z-index:1000;
			display:none;
		}
		.write_wrap{
			position:fixed;
			left:0;
			top:0;
			width:100%;
			height:100%;
			z-index:900;
			opacity: 0.01;
    		background: rgba(0, 0, 0, 0.5);
			display:none;
		}
		/* 设置省略号 */
		.f_eclipse{
			overflow: hidden;
		    text-overflow: ellipsis;
		    white-space: nowrap;
		}
	</style>
</head>
<body>
<input type="hidden" id="cur_indexId"/>
<input type="hidden" id="design_id" value="${design.id}"/>
<form:form id="inputForm" modelAttribute="design" action="#"  autocomplete="off" method="post" class="form-horizontal" >

		<sys:message content="${message}"/>
	<!--	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
				<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>转换名称:</label></td>
					<td  class="width-35" ><form:input path="designName" htmlEscape="false" maxlength="200" class="form-control required"/></td>
				</tr>
				<tr>
					<td  class="width-15 active"  class="active"><label class="pull-right"><font color="red">*</font>转换描述:</label></td>
					<td  class="width-35" ><form:input path="designDesc" htmlEscape="false" maxlength="200" class="form-control"/></td>
				</tr>
			</tbody>
		</table>
		-->

<div ng-keydown="common.bodyKeyEvent($event)" class="total_app" ng-app="MyApp" ng-controller="MyController as ctrl" >
		<div class="write_wrap">
			
		</div>
		<div class="write_loading"></div>
<div class="pipeline_btn">

	<div class="btn-group add_source" >
	    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" >增加源数据
	        <span class="caret"></span>
	    </button>
	    <ul class="dropdown-menu" role="menu">
	        <li ng-repeat="t in table_nameData track by $index">
	            <a href="#" ng-click="addSourceNode('SOURCE',t)">{{t}}</a>
	        </li>
	    </ul>
	</div>
	<div class="btn-group add_map">
		<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" ng-click="addSourceNode('PROCESSOR','change_rules')">转换规则</button>
	</div>
	<div class="btn-group add_map">
		<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" ng-click="addSourceNode('PROCESSOR')">增加映射 </button>
	</div>
	<div class="btn-group add_target">
		<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">输出 
	        <span class="caret"></span>
		</button>
	    <ul class="dropdown-menu" role="menu">
	        <li ng-repeat="t in out_table_nameData track by $index">
	            <a href="#" ng-click="addSourceNode('TARGET',t)">{{t}}</a>
	        </li>
	    </ul>
	</div>
	<div class="btn-group delete" >
		<button type="button" class="btn btn-default" ng-click="delete_selected()" name="">删除</button>
	</div>
	<div class="btn-group">
		<button class="btn btn-success btn-rect  btn-sm save_pipeline" ng-click="save_pipeline_data($event)" type="button"><i class="fa fa-search"></i> 保存</button>
	</div>
	<div class="btn-group">
	<button type="button" onclick="close_layer()" class="btn btn-default">关闭</button>
	</div>	
<!-- 	<div class="btn-group">
	<button type="button" ng-click="change_svg(change_flag)" ng-model="change_flag" class="btn btn-default">全屏</button>
	</div> -->
</div>
<div class="container_box">
<!--svg画布-->
<div class="my-info">
<pipeline-graph>
	<svg></svg>
</pipeline-graph>
</div>
</div>
<!-- 增加拖拽自定义大小 -->
<bg-splitter></bg-splitter>


<!--信息数据转换-->
<div class="tab_parent">
<ul class="nav nav-tabs" id="myTab">
  <li class="active">
  	<a href="" onclick="common_found(0)">通用</a>
  </li>
  <li>
	  <a href="" onclick="common_found(1)" >
	    <span ng-show="ctrl.change_cotrollSelect">过滤</span>
	 	<span ng-hide="ctrl.change_cotrollSelect">字段映射</span> 
	<!--  	<span ng-show="!ctrl.hideTable&&ctrl.cotrollSelect">选择表</span> -->
	  </a>
  </li>
  <li>
	  <a href="" onclick="common_found(2)" ng-if="!ctrl.change_cotrollSelect && !ctrl.cotrollSelect && !target_data">
	  	<span>关联</span>
	  </a>
  </li>
  <li>
	  <a href="" onclick="common_found(3)" ng-if="!ctrl.change_cotrollSelect && !ctrl.cotrollSelect && !target_data">
	  	<span>映射过滤</span>
	  </a>
  </li>
</ul>

<div class="tab-content">
  <div class="tab-pane active" id="home">
	    <!--基本信息-->
	<form class="form-horizontal" ng-if="down_found" role="form">
	<fieldset>
	    <legend>基本信息</legend>
	    
	    
	   <div class="form-group" ng-if="options.uiInfo.stageType!=='SOURCE' && options.uiInfo.stageType!=='TARGET'">
	      <label class="col-sm-2 control-label" for="proce_ds_host">步骤名称</label>
	      <div class="col-sm-4">
	         <input class="form-control" id="proce_ds_host" type="text" ng-change="change_step_name(options.uiInfo.label)" ng-model="options.uiInfo.label" value={{options.uiInfo.label}}>
	      </div>                         
	   </div>
	     <div class="form-group" ng-if="options.uiInfo.stageType=='SOURCE'">
	      <label class="col-sm-2 control-label" for="source_ds_host">步骤名称</label>
	      <div class="col-sm-4">
	         <input class="form-control" id="source_ds_host" type="text" readonly ng-if="options.tableName" ng-model="options.tableName" value={{options.tableName}}>
	          <input class="form-control" id="source_ds_host" type="text" readonly ng-if="!options.tableName" ng-model="options.uiInfo.label" value={{options.uiInfo.label}}>
	      </div>                         
	   </div>
	   <div class="form-group" ng-if="options.uiInfo.stageType=='TARGET'">
	      <label class="col-sm-2 control-label" for="target_ds_host">步骤名称</label>
	      <div class="col-sm-4">
	         <input class="form-control" id="target_ds_host" type="text" ng-model="options.targetName" value={{options.targetName}}>
	      </div>                         
	   </div>
	    
	    
	   <div class="form-group">
	      <label class="col-sm-2 control-label" for="ds_host_name">名字</label>
	      <div class="col-sm-4">
	         <input class="form-control" id="ds_host_name" type="text" readonly value={{options.instanceName}}>
	      </div>                         
	   </div>
	   <div class="form-group">
	      <label class="col-sm-2 control-label" for="ds_username">类型</label>
	      <div class="col-sm-4">
	         <input class="form-control" id="ds_username" type="text" readonly value={{options.uiInfo.name}} >
	      </div>                         
	   </div>
	</fieldset>
	   <fieldset>
	     <legend>转换信息</legend>
<!-- 	  <div class="form-group">
	
	       <label for="disabledSelect"  class="col-sm-2 control-label">表</label>
	     <div class="col-sm-10">
       		<span ng-if="options.hiveName" class="form-control" style="width: 100px;border:none;">
       			{{options.hiveName}}                           		
       		</span>
       		<p class="form-control" ng-if="!options.hiveName" style="width: 100px;border:none;">尚未选择</p>				
		</div>   
	</div> -->
	<div class="form-group">
		<label for="disabledSelect"  class="col-sm-2 control-label">设计转换任务名称</label>
	      <div class="col-sm-10">       		
			<input type="text" class="form-control" name="design_name" ng-model="designName" required ng-change="pipeline_name_change(designName)" value={{designName}}>
		</div>
	</div>
	<div class="form-group">
		<label for="disabledSelect"  class="col-sm-2 control-label">设计转换任务描述</label>
	      <div class="col-sm-10">
			<input type="text" class="form-control" name="design_desc" ng-model="designDetail" required ng-change="pipeline_detail_change(designDetail)" value={{designDetail}}>
		</div>   
	</div>
</div>

  <div class="tab-pane" id="profile" ng-cloak>
  	<!--angular-select-ui-->
<p ng-if="ctrl.cotrollSelect && !ctrl.change_cotrollSelect" style="margin-left:4%;">请选择hive表</p>
<!-- <p>{{ctrl.selectedData.hiveName}}</p> -->
<div class="choice_hive">
  <ui-select ng-model="ctrl.selectedData" ng-if="ctrl.cotrollSelect && !ctrl.change_cotrollSelect" style="width:400px;margin-left:4%;" on-select="crossSelected(ctrl.selectedData)">
    <ui-select-match class="ui-select-match" style="width:400px !important;">
    	{{$select.selected.hiveName}}
    </ui-select-match>
    <ui-select-choices group-by="'tableSpace'"  style="width:400px !important;" class="ui-select-choices" repeat="x in arrData | filter: {tableName: $select.search}" title="{{x.tableName}}">
      <div ng-bind-html="x.tableName | highlight: $select.search"></div>      
    </ui-select-choices>
  </ui-select>
  </div>
  <!-- 搜索字段 -->
 <table class="dataintable" style="width:50%;margin-left:4%;margin-top:12px;"  ng-if="ctrl.cotrollSelect && !ctrl.change_cotrollSelect">
        <tr>
          <!-- tr列，td行 -->
          <th>字段名</th>
          <th>类型</th>     
          <th>描述</th>
        </tr>
        <!--<p>{{ctrl.selectedData}}</p>-->
        <tr ng-repeat="a in fieldArr track by $index">
		  <td>{{a.fieldName}}</td>
          <td>{{a.fieldType}}</td>
          <td>{{a.fielDesc}}</td>
        </tr>
 </table>

<!-- 校验过滤 -->

 <!-- 过滤条件 -->
  <div ng-if="!ctrl.hideTable&&ctrl.change_cotrollSelect" style="margin: 10px 0 0 1%;">
<!--   <h3>过滤</h3> -->

	  <button type="button" class="btn btn-default xy_filter_add" ng-click="add_filter()">add</button>

  	  <table class="dataintable filter table table-striped table-bordered table-hover table-condensed dataTables-exampledataTable "  style="width:36%;margin-right:3%;" >
        <tr>
          <!-- tr行，td列 -->
          <th style="width:35%;">源表字段</th>
          <th style="width:40%;">操作符</th>
          <th style="width:25%;">参数值</th>
        </tr>            	
        <tr class="have_ui_select"  ng-repeat="w in add_filter_table track by $index">
        <!-- 源表字段 -->
          <td>
			 <ui-select ng-model="ctrl.filter_field[$index]">
				    <ui-select-match class="ui-select-match">
				    	{{$select.selected.fieldName}}	    	
				    </ui-select-match>
				    <ui-select-choices group-by="'instanceName'" class="ui-select-choices" repeat="j in filter_data | filter: {fieldName: $select.search}" >
				      <div ng-bind-html="j.fieldName | highlight: $select.search"  ng-init="active_x = x.tableName"></div>      
				    </ui-select-choices>
			</ui-select>
		  </td>
		  <!-- 操作符 -->
          <td class="have_ui_select">
			<ui-select ng-model="ctrl.filter_operate[$index]" style="width:auto;">
				    <ui-select-match class="ui-select-match" style="width:100%;">
				    	{{$select.selected.label}}
				    	<!-- {{$select.selected.label}} -->				    	
				    </ui-select-match>
				    <ui-select-choices group-by="'tableSpace'" style="width:100%;" class="ui-select-choices" repeat="t in filter_operate | filter: { label : $select.search}" >
				      <div ng-bind-html="t.label | highlight: $select.search"></div>      
				    </ui-select-choices>
			</ui-select>
		  </td>     
          <!-- 用户输入 -->
          <td>
          	<input type="text" class="from-controll" style="width:100%;" ng-model="ctrl.user_write[$index]" value={{ctrl.user_write[$index]}}>
<!--      		<div class="btn-group">
     			<button type="button" class="btn btn-default" style="display:block;float:none;" ng-click="filter_message(ctrl.filter_field[$index],ctrl.filter_operate[$index],ctrl.user_write[$index],$index)">添加</button>
     		</div>   -->   		
          </td>     
        </tr>
     </table>
     
  	<div class="btn-group change_btn" style="float:left;margin-top:2%;">

     	<button type="button" class="btn btn-default" style="display:block;float:none;" ng-click="filter_message(ctrl.filter_field,ctrl.filter_operate,ctrl.user_write)"><i class="fa fa-forward" aria-hidden="true"></i></button>

		
		<button type="button" class="btn btn-default" style="display:block;float:none;" ng-click="delete_xy_filter()"><i class="fa fa-backward" aria-hidden="true"></i></button>
	</div>


     <table class="dataintable filter table table-striped table-bordered table-hover table-condensed dataTables-exampledataTable " style="width:30%;clear:none;margin-left:2%;" >
	<tr>
		<th style="width:30%;">源字段</th>
		<th style="width:40%;">操作符</th>
		<th style="width:15%;">参数值</th>	
		<th style="width:15%;">操作</th>		
	</tr>
	<tr ng-repeat="fa in xy_filter_all_data track by $index">
		<td>{{fa.field.fieldName}}</td>
		<td>{{fa.operate.remarks}}</td>
		<td>{{fa.value}}</td>
		<td>
			<div class="btn-group result_btn">	
				<button type="button" class=""  ng-click="delete_filter_message($index,xy_filter_all_data,'xy')">删除</button>	
			</div>
		</td>
	</tr>
</table>   
  </div>
<div class="map-wrap box-3"  style="background:#efefef;width:100%;height:100%;position:relative;">
  <div class="map_table"> 
  <!--映射左边字段-->
<!-- 新加全选单选按钮 -->

<!-- 没有数据时的显示 -->		
	<table ng-if="d_data.length<1 && ctrl.hideTable && !ctrl.change_cotrollSelect" class="dataintable field_table table table-striped table-bordered table-hover table-condensed dataTables-exampledataTable " style="width:100%;">
        <tr>
          <!-- tr列，td行 -->
          <th style="width:8%;">
			<label>
                  <input type="checkbox" ng-model="master[table_index]" ng-disabled = "y.ago_checked" ng-click="all(master[table_index],y,$index)">
            </label>
		  </th>
          <th style="width:40%;">字段名</th>
          <th style="width:40%;">类型</th> 
          <th style="width:12%;" class="hideTable" ng-click="hideTable=!hideTable"><span ng-show="hideTable">收起</span><span ng-show="!hideTable">展开</span></th>
        </tr>
      </table>
<!-- 存在数据字段 -->		
      <table  ng-if="d_data.length>0 && ctrl.hideTable && !ctrl.change_cotrollSelect"  class="dataintable field_table table table-striped table-bordered table-hover table-condensed dataTables-exampledataTable " style="width:100%;" ng-repeat="y in d_data track by $index" ng-init="table_index=[$index]">
        <tr>
          <!-- tr列，td行 -->
          <th style="width:8%;">
			<label>
                  <input type="checkbox" ng-model="master[table_index]" ng-disabled = "y.ago_checked" ng-click="all(master[table_index],y,$index)">
            </label>
		  </th>
          <th style="width:40%;">字段名</th>
          <th style="width:40%;">类型</th> 
          <th style="width:12%;" class="hideTable" ng-click="hideTable=!hideTable"><span ng-show="hideTable">收起</span><span ng-show="!hideTable">展开</span></th>
        </tr>
        <tr ng-if="ctrl.hideTable && !ctrl.change_cotrollSelect" ng-show="hideTable" ng-repeat="item in y.fieldArr track by $index"class="draglist" ng-drag-data="item" ng-init="item.instanceName=y.instanceName" ng-drag="!item.ago_checked[item.instanceName]" >
          <td> 
              <label>
              
              <!-- 单选 -->
              	  <input type="checkbox" name="selected_true" ng-if="item[y.now_ins]" ng-checked="true" disabled="disabled">

                  <input type="checkbox" name="selected_false" ng-if="!item[y.now_ins]" ng-model="item.m" ng-checked="master[table_index]" ng-click="chk(item,item.m,$index,y)">
              </label>
       
          </td>  
          <td ng-if="item[y.now_ins]" style="background:#bebebe">{{item.fieldName}}</td>
          <td ng-if="item[y.now_ins]" style="background:#bebebe">{{item.fieldType}}</td>
          
          <td ng-if="!item[y.now_ins]">{{item.fieldName}}</td>
          <td ng-if="!item[y.now_ins]">{{item.fieldType}}</td>
        </tr>
      </table>
  </div>
  <!-- 中间按钮 -->
  		<div ng-if="ctrl.hideTable && !ctrl.change_cotrollSelect" class="cross_field change_btn">
			<button type="button" class="btn btn-default" ng-click="checkbox_cross()" name="" style="margin-bottom:4%;"><i class="fa fa-forward" aria-hidden="true"></i></button>
			<button type="button" class="btn btn-default" ng-click="delete_all()" name=""><i class="fa fa-backward" aria-hidden="true"></i></button>
		</div>
      <!-- 表达式表格  -->
  
  <div ng-if="ctrl.hideTable && !ctrl.change_cotrollSelect" class="map_filed_table2" style="float:right;width:49%;margin-right: 5%;margin-top: 1%;">
      <table ng-cloak class="dataintable table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" ui-sortable="sortableOptions" style="width:100%;"  ng-drop="true" ng-drop-success="dropComplete($index,$data,$event)"  >

		<tr>
          <!-- tr列，td行 -->
          <th style="width: 25%;">来源表</th>
          <th style="width: 15%;">字段名</th>
          <th style="width: 25%;">转换函数</th>
          <th style="width: 10%;">参数</th>
          <th style="width: 15%;">输出</th>
          <th style="width: 10%;">操作</th>
        </tr>
        <tr ng-repeat="item in dropData_k track by $index" ng-if="items" >
            <td>
            	<!--表达式-->
			<span>
				<input type="text" name="" id="" style="width:100%;" ng-change="found_origin(item,itemK,dropData_k,$index)" ng-init="itemK = item.itemK" ng-blur="clear_color(item,itemK,dropData_k,$index)" ng-model="itemK" value={{item.itemK}} title={{item.itemK}} class="f_eclipse">
			</span>
		</td>
		<td>
			<!--输出字段名-->
			<input type="text" name="" id="" style="width:100%;" readonly  value={{item.fieldName}}>
		</td>
		<!-- 转换函数 -->
		<td class="have_ui_select">
			<ui-select ng-model="item.transform_func" style="width:100%;" on-select="transform_selected()">
			    <ui-select-match class="ui-select-match">
			    	{{$select.selected.label}}
			    </ui-select-match>
			    <ui-select-choices group-by="" class="ui-select-choices" repeat="x in tranform_funcList | filter: {value: $select.search}" >
			      <div ng-bind-html="x.label | highlight: $select.search"></div>      
			    </ui-select-choices>
			</ui-select>
		</td>

		<!-- 用户输入参数 -->
		<td>
			<input type="text" class="form-control" ng-model="item.transform_value" ng-change="" ng-blur="appear=true" ng-focus="appear=false" value={{item.transform_value}}>	
		</td>
		<!-- 输出 -->
		<td>
			<input type="text"  class="form-control"  ng-model="item.edit_input" value={{item.edit_input}}>
		</td>
		<!-- 删除 -->
		<td class="result_btn">
			<input type="button"  class=""  name="delete_field" ng-click="delete_field($index,dropData_k)" style="width:100%;" value="删除">
		</td>
        </tr>
      </table>
    </div>  
      <!--target-->
    <div ng-if="target_data && !ctrl.change_cotrollSelect" class="target_div">
<!--   {{options}} -->
<div style="width:100%;">
	<input type="text" style="width:400px !important;margin-left:2%;" class="form-control" id="new_table_name" required name="target_name" ng-model="options.targetName" ng-change="dropName(options.targetName)" value={{options.targetName}}>
</div>
        <p ng-show="warning">输入表名重复</p>		 
       <table class="dataintable" style="width:50%;float:left;margin-left:2%;" >
        <tr>
          <!-- tr列，td行 -->
          <th>字段名</th>
          <th>类型</th>
        </tr>            	
        <tr ng-repeat="item in dropData_L track by $index">          
          <td>{{item.itemK}}</td>
          <td>{{item.fieldType}}</td>        
        </tr>
      </table>  		
   </div>
      
   </div>

  </div>
  
  
 
<!-------- 第三个tab  关联关系 -------------------------------------------------->
  <div class="tab-pane" id="cognate">

  <!-- 关联关系 -->
  	
   <div ng-if="ctrl.hideTable" style="height:auto;margin: 10px 0 0 1%;">
   	  <button type="button"  ng-if="ctrl.hideTable" class="btn btn-default cognate_add" ng-click="add_cognate()" name="" style="margin-bottom:0;">增加</button>
	<!-- 设置字段间的关联 -->
<table class="dataintable table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" style="height:auto;    margin-top: 10px !important;" >
	<tr>
		<th style="width:40%;">
			<span>A字段</span>
		</th>
		<th style="width:20%;">
			<span>关联关系</span>
		</th>
		<th style="width:40%;">
			<span>B字段</span>
		</th>
<!--  		<th class="hideTable" ng-click="hideTable=!hideTable"><span ng-show="hideTable">-</span><span ng-show="!hideTable">+</span></th>
	 --></tr>
	<tr class="choice_field" ng-repeat="k in copyhtml track by $index">
		<td class="have_ui_select">
		<!-- 关联A字段 -->
			<ui-select ng-model="ctrl.cognate_A[$index]" style="width:100%;" on-select="change_km()">
			    <ui-select-match class="ui-select-match">
			    	{{$select.selected.fieldName}}			    	
			    </ui-select-match>
			    <ui-select-choices group-by="'instanceName'" class="ui-select-choices" repeat="x in choice_field_arr | filter: {fieldName: $select.search} | Filter_ago:'ago_cognated':false" >
			      <div ng-bind-html="x.fieldName | highlight: $select.search"  ng-if="!x.ago_cognated"></div>      
			    </ui-select-choices>
			 </ui-select>
		</td>
		<td>
			<!-- 关联关系 -->
			<div class="set_express">
				<span ng-model="express_value">{{express_value}}</span>		
			</div>
		</td>
		<td class="have_ui_select">
		<!-- 关联B字段 -->
			 <ui-select ng-model="ctrl.cognate_B[$index]" style="width:100%;" ng-if="ctrl.cognate_A[$index]">
			    <ui-select-match class="ui-select-match" style="width:100%;">
			    	{{$select.selected.fieldName}}	    	
			    </ui-select-match>
			    <ui-select-choices group-by="'instanceName'"  style="width:100%;" class="ui-select-choices" repeat="x in choice_field_arr | filter: {fieldName: $select.search} | myFilter:'instanceName':ctrl.cognate_A[$index].instanceName | Filter_ago:'ago_cognated':false"">
			      <div ng-bind-html="x.fieldName | highlight: $select.search" ng-if="!x.ago_cognated"></div>     
			    </ui-select-choices>
			  </ui-select>
		</td>		
	</tr>

</table>
<!-- 关联增加中间的按钮操作 -->
  		<div class="cognate_field_btn change_btn">
			<button type="button" class="btn btn-default" ng-click="click_cognate(ctrl.cognate_A,ctrl.cognate_B)" name="" ><i class="fa fa-forward" aria-hidden="true"></i></button>

			<button type="button" class="btn btn-default" ng-click="delete_all_cognate()"><i class="fa fa-backward" aria-hidden="true"></i></button>	
		</div>


 <table class="dataintable" style="width:30%;clear:none;margin-left:2%;margin-top:10px;" >
	<tr>
		<th style="width:35%;">A字段</th>
		<th style="width:15%;">关系</th>
		<th style="width:35%;">B字段</th>
			
		<th	style="width:15%;">操作</th>		
	</tr>
	<tr ng-repeat="m in cognate_all_data track by $index">
		<td>{{m.fieldName_a}}</td>
		<td>{{m.join}}</td>
		<td>{{m.fieldName_b}}</td>
		
		<td>
			<div class="btn-group result_btn">	
				<button type="button" class=""  ng-click="delete_cognate($index)">删除</button>	
			</div>
		</td>
	</tr>
</table>

   </div>	
 </div>  
 <!-- -----------------------关联结束 -->
 <!-- -------------映射过滤 -->
 <div id="map_filter" class="tab-pane">
 	 <!-- 过滤条件 -->
  <div ng-if="ctrl.hideTable" style="margin: 10px 0 0 1%;">

	<button type="button" class="btn btn-default map_filter_add" ng-click="add_map_filter()">增加</button>

  	  <table class="dataintable map_filter table table-striped table-bordered table-hover table-condensed dataTables-example" style="table-layout:fixed;">
        <tr>
          <!-- tr行，td列 -->
          <th style="width:33%;">源表字段</th>
          <th style="width:33%;">操作符</th>
          <th style="width:33%;">参数值</th>
        </tr>            	
        <tr ng-repeat="w in add_map_filter_table track by $index">
        <!-- 源表字段 -->  
          <td class="have_ui_select">
			 <ui-select ng-model="ctrl.map_filter_field[$index]" style="width:auto;">
				    <ui-select-match class="ui-select-match" style="width:100%;">
				    	{{$select.selected.fieldName}}	    	
				    </ui-select-match>
				    <ui-select-choices group-by="'instanceName'"  class="ui-select-choices" repeat="x in choice_field_arr | filter: {fieldName: $select.search} | Filter_ago:'ago_map_filter':false" >
				      <div ng-bind-html="x.fieldName | highlight: $select.search"></div>      
				    </ui-select-choices>
			</ui-select>
		  </td>
		  <!-- 操作符 -->
          <td class="have_ui_select">
			<ui-select ng-model="ctrl.map_filter_operate[$index]" style="width:auto;">
				    <ui-select-match class="ui-select-match" style="width:100%;">
				    	<!-- {{$select.selected.label}} -->	
				    	{{$select.selected.label}}				    	
				    </ui-select-match>
				    <ui-select-choices group-by="'tableSpace'" class="ui-select-choices" repeat="x in filter_operate | filter: { label : $select.search}" >
				      <div ng-bind-html="x.label | highlight: $select.search"></div>    
				    </ui-select-choices>
			</ui-select>
		  </td>     
          <!-- 用户输入 -->
          <td>
          	<input type="text" class="from-controll" style="width:100%;" ng-model="ctrl.map_user_write[$index]" value={{ctrl.map_user_write[$index]}}>
<!--           	<div class="btn-group">
     			<button type="button" class="btn btn-default" ng-click="filter_message(ctrl.map_filter_field[$index],ctrl.map_filter_operate[$index],ctrl.map_user_write[$index],$index)">添加</button>
     		</div> -->
          </td>     
        </tr>
     </table>
   <!-- 条件 -->
    <div class="btn-group change_btn" style="float:left">
		<!-- <button type="button" class="btn btn-default" ng-click="add_map_filter()">增加</button> -->
		
		<button type="button" class="btn btn-default" style="display:block;float:none;" ng-click="filter_message(ctrl.map_filter_field,ctrl.map_filter_operate,ctrl.map_user_write)"><i class="fa fa-forward" aria-hidden="true"></i></button>

	
		<button type="button" class="btn btn-default" style="display:block;float:none;" ng-click="delete_map_filter()"><i class="fa fa-backward" aria-hidden="true"></i></button>
	</div>
     
<table class="dataintable table table-striped table-bordered table-hover table-condensed dataTables-example dataTable" style="width:30%;clear:none;margin-left:2%;" >
	<tr>
		<th style="width:25%;">源字段</th>
		<th style="width:25%;">操作符</th>
		<th style="width:25%;">参数值</th>
		<th style="width:25%;">操作</th>		
	</tr>
	<tr ng-repeat="fa in map_filter_all_data track by $index">
		<td>{{fa.field.fieldName}}</td>
		<td style="white-space: nowrap;">{{fa.operate.remarks}}</td>
		<td>{{fa.value}}</td>
		<td>
			<div class="btn-group result_btn">	
				<button type="button" class=""  ng-click="delete_filter_message($index,map_filter_all_data,'map')">删除</button>	
			</div>
		</td>
	</tr>
</table>
  </div>
 
</div>
</div>
</div>   
</div>
</div>
	

</form:form>	
</body>
</html>