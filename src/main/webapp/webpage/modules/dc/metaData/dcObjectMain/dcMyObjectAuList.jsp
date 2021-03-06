<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/dc/css/icons.css" rel="stylesheet" />
	<script>
		$(document).ready(function() {
			$(document).on('ifChecked', '#contentTable thead tr th input.i-checks',function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		  	  $('#contentTable tbody tr td input.i-checks').iCheck('check');
		  	});
	
		  $(document).on('ifUnchecked','#contentTable thead tr th input.i-checks', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		  	  $('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
		  	});
		    
		});
	</script>
	<style>
		#frame {
		  position: relative;
		  width: 100%;
		  height: 100%;
		}
		#frame .frame {
		  position: relative;
		  overflow: hidden;
		}
		#frame .frame .inset .image {
		  cursor: pointer;
		  background-position: center;
		  background-size: cover;
		}
		#frame .frame .inset .info .title {
		  cursor: pointer;
		  display: inline-block;
		  font-weight: bold;
		}
		#frame .frame .inset .info .description {
		  display: block;
		  overflow: hidden;
		  text-overflow: ellipsis;
		  white-space: nowrap;
		}
		#frame .frame .inset .info [class*='icon-'] {
		  cursor: pointer;
		  margin-left: 10px;
		  display: inline-block;
		  font-weight: bold;
		}
		#frame .frame .inset .info [class*='icon-']:before {
		  margin-right: 5px;
		  font-weight: normal;
		}

		.grid {
		  display: flex;
		  flex-flow: row wrap;
		}
		.grid .frame {
		  min-width: 250px;
		  height: 100px;
		}
		.grid .frame .inset {
		  margin: 10px;
		}
		.grid .frame .inset .image {
			display: inline-block;
			vertical-align: top;
		}
		.grid .frame .inset >div:FIRST-CHILD {
		 display: inline-block;
		}
		.grid .frame .inset .info {
		 margin-left:10px;
		  overflow: hidden;
		  display: inline-block;
		}
		.grid .frame .inset .info .title {
		margin-bottom:5px;
		}
		.grid .frame .inset .info .shares {
			margin-top:5px;
		  display: block;
		  font-size: 12px;
		}
		.no-margin{
			margin: 0px!important;
		}
	</style>
</head>
<body>
<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	<!-- 查询条件 -->


	<form:form id="searchForm" modelAttribute="objectMain"  method="post" class="form-inline">
		<input id="fparent_id" name="parent_id" type="hidden" />
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="objCata" name="objCata" type="hidden" value="${objectMain.objCata}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>对象名称：</span><form:input path="objName" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
			<span>对象编码：</span><form:input path="objCode" htmlEscape="false" maxlength="64"  class="form-control input-sm"/>
			<span>对象类型：</span>
				<form:select path="objType" class="form-control">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictListLike('dc_dataobj_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				
				
				
				<button class="btn btn-success btn-rect  btn-sm " onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
			
				<button class="btn btn-success btn-rect  btn-sm " id="changeBtn" type="button"><i class="fa fa-exchange"></i>切换显示至我的收藏</button>
			
		 </div>	
	</form:form>
	<br/>

	
	
	<table id="contentTable"  class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" width="100%">
		<thead>
			<tr>
				
				<th class="objName">对象名称</th>
				<th class="objCode">对象编码</th>
				<th class="objType">对象类型</th>
				<th class="objDesc">对象描述</th>
				<th class="managerOrg">业务部门</th>
				<th class="managerPer">业务负责人</th>
				<th class="createDate" id="applyDate" >申请时间</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
	
			 
	<ol class='grid' id='frame' style="display: none">
	<!-- 
    <li class='frame'>
      <div class='inset' style="background-color:#E8E4DE;">
        <div style="background:url(${ctxStatic}/login/images/cysl_up.png) no-repeat center center; width:100px; height:100px;"></div>
        <div class='info'>
          <div class='title'>数据表: DC_SYSTEM</div>
          <div class='description'>测试数据表,业务系统信息,华量软件</div>
          <div class='shares'>
            <div class='icon-lik likes'>收藏</div>
            <div class='icon-pla preview'>预览</div>
            <div class='icon-dar download'>下载</div>
          </div>
        </div>
      </div>
    </li>
    <li class='frame'>
      <div class='inset'>
        <div class='image'></div>
        <div class='info'>
          <div class='title'>文件: DC_SYSTEM</div>
          <div class='description'>FILE _ BBBB, HAHAHA 华量软件</div>
          <div class='shares'>
            <div class='icon-lik likes'>收藏</div>
            <div class='icon-pla preview'>预览</div>
            <div class='icon-arc apply'>申请权限</div>
          </div>
        </div>
      </div>
    </li>
    <li class='frame'>
      <div class='inset'>
        <div class='image'></div>
        <div class='info'>
          <div class='title'>Lorem Ipsum</div>
          <div class='description'></div>
          <div class='shares'>
            <div class='icon-lik likes'></div>
            <div class='icon-ask comments'></div>
          </div>
        </div>
      </div>
    </li>
    <li class='frame'>
      <div class='inset'>
        <div class='image'></div>
        <div class='info'>
          <div class='title'>Lorem Ipsum</div>
          <div class='description'></div>
          <div class='shares'>
            <div class='icon-lik likes'></div>
            <div class='icon-ask comments'></div>
          </div>
        </div>
      </div>
    </li>
    <li class='frame'>
      <div class='inset'>
        <div class='image'></div>
        <div class='info'>
          <div class='title'>Lorem Ipsum</div>
          <div class='description'></div>
          <div class='shares'>
            <div class='icon-lik likes'></div>
            <div class='icon-ask comments'></div>
          </div>
        </div>
      </div>
    </li>
    <li class='frame'>
      <div class='inset'>
        <div class='image'></div>
        <div class='info'>
          <div class='title'>Lorem Ipsum</div>
          <div class='description'></div>
          <div class='shares'>
            <div class='icon-lik likes'></div>
            <div class='icon-ask comments'></div>
          </div>
        </div>
      </div>
    </li>
    <li class='frame'>
      <div class='inset'>
        <div class='image'></div>
        <div class='info'>
          <div class='title'>Lorem Ipsum</div>
          <div class='description'></div>
          <div class='shares'>
            <div class='icon-lik likes'></div>
            <div class='icon-ask comments'></div>
          </div>
        </div>
      </div>
    </li>
    <li class='frame'>
      <div class='inset'>
        <div class='image'></div>
        <div class='info'>
          <div class='title'>Lorem Ipsum</div>
          <div class='description'></div>
          <div class='shares'>
            <div class='icon-lik likes'></div>
            <div class='icon-ask comments'></div>
          </div>
        </div>
      </div>
    </li>
	-->
  </ol>

	<script>
	var table, list_flag = true;
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
				url : "${ctx}/dc/metadata/dcMyObject/ajaxlist1?objCataItem=null",
				"data" : function (d) {
					//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
					$.extend(d, getFormParamsObj('searchForm'));
				},
				"dataSrc" : function (json) {//定义返回数据对象
					//console.log(json);
					//刷新文件页面
					reloadFilePage(json);
					return JSON.parse(json.body.gson);
				}
			},
				"columns" : [
					 {
						"data" : "objName"
					}, {
						"data" : "objCode"
					}, {
						"data" : "objType"
					}, {
						"data" : "objDesc"
					}, {
						"data" : "managerOrg"
					}, {
						"data" : "managerPer"
					}, {
						"data" : "createDate"
					}, {
						"data" : null
					}
				],
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets :7,	//第7列
						render : function (a,b) {
							var html = '';
							html+= '<a href="#" onclick="deleteA(\'${ctx}/dc/metadata/dcMyObject/nopass?id='+a.id+'\',\'数据\') " class="btn btn-success btn-xs" title="删除数据"><i class="fa fa-trash"></i></a>&nbsp;';
							return html;
						}
					},{
						targets :6,
						render : function (a, b) {
							var d = new Date(a);
							var tf = function(i){return (i < 10 ? '0' : '') + i};
							var html = d.getFullYear() + '-' + tf((d.getMonth() + 1)) + '-' + tf(d.getDate()) + ' ' + tf(d.getHours()) + ':' + tf(d.getMinutes()) + ':' + tf(d.getSeconds());
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
		
		//按钮切换事件 重新执行查询
		$('#changeBtn').bind('click',function(){
			
			if('apply'==$('#objCata').val()){
				$('#objCata').val('collect');
				$('#applyDate').text('收藏时间');
				$('#set').text('收藏时间');
				$('#changeBtn').text('我的收藏');
				 
			}else{
				$('#objCata').val('apply');
				$('#applyDate').text('申请时间');
				$('#set').text('申请时间')
				$('#changeBtn').text('我的申请');
			}
			searchA();
		});
		
		/* $("#changeBtn").toggle(
		  function () {
			  $('#contentTable_wrapper').hide();
			  $('.grid').show();
			  list_flag = false;
			  if()
		  },
		  function () {
			  $('#contentTable_wrapper').show();
			  $('.grid').hide();
			  list_flag = true;
			  //$('#jqContextMenu').hide();
		  }
		); */ 
		
		/* $('.fancybox').contextMenu('myMenu1', {
			shadow:false,
			bindings : {
				'open' : function(t) {
					top.layer.alert('查看', {icon: 3, title:'系统提示'});
				},

				'delete' : function(t) {
					top.layer.alert('删除', {icon: 3, title:'系统提示'});
				}
			}

		}); */
		//补充内容
		$('.frame').each(function(){
			  $(this).find('.image')
				.css({
					'background': 'url(${ctxStatic}/login/images/cysl_up.png) no-repeat top center',
					'background-size': '100% auto'
				});
			  var like = 100,
			      likes = Math.floor(Math.random() * like) + 1;
			  $(this).find('.likes').text(likes);
			  var comment = 50,
			      comments = Math.floor(Math.random() * comment) + 1;
			  $(this).find('.comments').text(comments);
			});

		//	$('.description').text('dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
          
			
	});
	
	//列表查询事件
	function searchA(url){//查询，页码清零
		if(url!=undefined){
			table.ajax.url(url).load();
		}else{
			//刷新列表数据
			table.ajax.reload();
		}
		//console.dir(table);
	}
	
	//刷新文件列表 数据不分页  data.body.gson
	function reloadFilePage(data){
		// 列表(id='frame')动态添加内容
		$('#frame').empty();
		if(data && '-1'==data.errorCode ){
			var jsonArr = JSON.parse(data.body.gson), 
				li, insetDiv, iconDiv, infoDiv, titleDiv, descDiv, shareDiv;
			//检查数据对象
			if(jQuery.isArray(jsonArr) && jsonArr.length>0){
				//遍历数组, 生成文件列表
				$.each(jsonArr, function (index, obj) {
					console.log(obj);
					li = $("<li class='frame'></li>");
					insetDiv = $("<div class='inset'>");
					li.append(insetDiv);
					iconDiv = $("<div style='background:url(${ctxStatic}/login/images/cysl_up.png) no-repeat center center; width:67px; height:62px;' class='image'></div>");	//单个显示
				//	iconDiv = $("<div style='background:url(${ctxStatic}/login/images/cysl_up.png) no-repeat top center; background-size:100% auto'></div>");		//撑满显示
					infoDiv = $("<div class='info'></div>");
					insetDiv.append(iconDiv).append(infoDiv);
					titleDiv = $("<div class='title'></div>").append(obj.objName);
					descDiv = $("<div class='description'></div>").append(obj.objDesc);
					shareDiv = $("<div class='shares'><div class='icon-lik likes no-margin'>收藏</div><div class='icon-pla preview'>预览</div><div class='icon-dar download'>下载</div></div>");
					infoDiv.append(titleDiv).append(descDiv).append(shareDiv);
					
					//添加到列表
					$('#frame').append(li);
				});
				//事件
				  $('.shares div').on('click',function(){
					  if($(this).hasClass('icon-lik likes')){
						  top.layer.alert('收藏对象', {icon: 3, title:'系统提示'});
					  }else if($(this).hasClass('icon-pla preview')){
						  top.layer.alert('数据预览', {icon: 3, title:'系统提示'});
					  }else if($(this).hasClass('icon-dar download')){
						  top.layer.alert('数据下载', {icon: 3, title:'系统提示'});
					  }else if($(this).hasClass('icon-arc apply')){
						  top.layer.alert('申请权限', {icon: 3, title:'系统提示'});
					  }
				  });
			}
		}
	}
	
	/* function getId(id)
	   {
	       return document.getElementById(id);
	   }
	   getId("changeBtn").onclick=function()
	   {
	     getId("changeBtn1").style.display="none";
	     else{
	    	 
	     }
	       getId("changeBtn1").style.display="block";
	   }
	   getId("changeBtn").onclick=function()
	   {
		   getId("changeBtn").style.display="block";
		   getId("changeBtn1").style.display="none";
	      // getId("text1").style.display="none";
	       //getId("text2").style.display="block";
	   }*/
	</script>
	</div>
</body>
</html>