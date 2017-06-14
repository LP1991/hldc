<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxStatic" value="${pageContext.request.contextPath}/static"/>
<html>
<head>
	<meta charset="utf-8">
	<meta name="description" content="数据采集，处理，探索，建仓，导出"> 
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<title>首页</title>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/dc/homePage/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/dc/homePage/css/index.css">
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	function test_btn(str,t){
		//console.log('');
		//$('#content-main', parent.document);
		//location.href = str;
		$('.page-tabs .page-tabs-content', parent.document).find('a').removeClass('active');
		if($('.page-tabs .page-tabs-content', parent.document).find('a').length>1){
			var str_check = [];
			for(var k=0;k<$('.page-tabs .page-tabs-content', parent.document).find('a').length;k++){
				str_check.push($('.page-tabs .page-tabs-content', parent.document).find('a').eq(k).text());
			}
			if(str_check.indexOf(t)!==-1){
				var a_length = $('.page-tabs .page-tabs-content', parent.document).find('a').length;
				var ifr_length = $('#content-main', parent.document).find('.J_iframe').length;
				for(var i=0;i<a_length;i++){					
					if($('.page-tabs .page-tabs-content', parent.document).find('a').eq(i)[0].dataset.id === str){
						$('.page-tabs .page-tabs-content', parent.document).find('a').eq(i).addClass('active').siblings().removeClass('active');
						for(var j=0;j<ifr_length;j++){
							if($('#content-main', parent.document).find('.J_iframe').eq(j)[0].dataset.id === str){
								$('#content-main', parent.document).find('.J_iframe').eq(j).css({"display":"inline"}).siblings().css({"display":"none"});
							}
						}
					}
				}
			}else{
				$('.page-tabs .page-tabs-content', parent.document).append('<a href="javascript:;" class="J_menuTab active" data-id='+str+'>'+ t +'<i class="fa fa-times-circle"></i></a>');
				$('#content-main', parent.document).find('.J_iframe').css({"display":"none"});
				
				$('#content-main', parent.document).append('<iframe class="J_iframe" name="iframeindex" width="100%" height="100%" src='+str+' frameborder="0" data-id='+str+' seamless="" style="display: inline;"></iframe>')
			
			
			}
			
				
		}else{
			$('.page-tabs .page-tabs-content', parent.document).append('<a href="javascript:;" class="J_menuTab active" data-id='+str+'>'+ t +'<i class="fa fa-times-circle"></i></a>');
			$('#content-main', parent.document).find('.J_iframe').css({"display":"none"});
			
			$('#content-main', parent.document).append('<iframe class="J_iframe" name="iframeindex" width="100%" height="100%" src='+str+' frameborder="0" data-id='+str+' seamless="" style="display: inline;"></iframe>')
		
		}
	
	
		
		}
			
		
	</script>
	<style type="text/css">
		ul{margin:0;padding:0;}
		ul li{list-style:none;}
		.fsize{
			white-space: nowrap;
		}
		/* 设置媒体查询 
		*  由于左侧菜单影响，比调试要减去200px
		*/
		@media screen and (max-width: 700px) {
			.Rarrow:nth-last-of-type(4){
				height:132px;
			}
		}
		@media screen and (max-width: 1014px) {
			.Rarrow:nth-last-of-type(2){
				margin-bottom:15%;
			}
			.col-md-1, .col-md-10, .col-md-11, .col-md-12, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8, .col-md-9{
				float:left;
			}
			.col-md-3{
				width:44%;
			}
			.col-md-6{
				width:100%;
			}
			.col-md-6 .row{
				width:100%;
			}
			.col-md-8{
				width:46%;
			}
			.f_line{
				width:10%;
				margin-top:20px !important;
			}
			.f_detail{
				margin-top:40px !important;
			}
			.col-10{
				width:71%;
			}
			.col-md-12{
				width:100%;
			}
		}
	</style>
</head>
<body>
<div id="container" class="container-fluid">
	<div class="row"  style="margin-top: 10px;">
		<div class="col-md-6">
			<div class="panel panel-default">
	  			<div class="panel-body">
					<div class="row" style="position: relative;">
						<div class="col-md-3 l_area no_pad" >
						    <h4>总数据量值</h4>
						    <h3>${metaData_totle} 项</h1>
						    <img src="${ctxStatic}/dc/homePage/images/002.png" alt="" style="width: 100%;height: 100%;">
					    </div>
					    <div class="col-md-1 f_line" style="text-align: center;margin-top: 10px;margin-left: -15px;">
					    	<img src="${ctxStatic}/dc/homePage/images/107.png" alt="pic">
					    </div>
					    <div class="col-md-8 f_detail" style="margin-top: 25px;">
					    	<div class="row">
  								<div class="col-md-1 no_pad col-1" >
  									<p class="fsize">数据表</p>
  								</div>
  								<div class="col-md-10 col-10" >
							    	<div class="progress">
									  <div class="progress-bar" role="progressbar" aria-valuenow="${rate_table}" aria-valuemin="0" aria-valuemax="100" style="width: ${rate_table}%;background: linear-gradient(to right, #bbfbfb 35%,#68aff1 68%)">
									    <span class="sr-only">${rate_table}% Complete</span>
									  </div>
									</div>
								</div>
								<div class="col-md-1 no_pad" style="width:13%;">
									<p>${metaData_table}</p>
								</div>
							</div>
							<div class="row">
  								<div class="col-md-1 no_pad col-1" >
  									<p>文件</p>
  								</div>
  								<div class="col-md-10 col-10" >
							    	<div class="progress">
									  <div class="progress-bar" role="progressbar" aria-valuenow="${rate_file}" aria-valuemin="0" aria-valuemax="100" style="width: ${rate_file}%;background: linear-gradient(to right, #bbfbfb 35%,#68aff1 68%)">
									    <span class="sr-only">${rate_file}% Complete</span>
									  </div>
									</div>
								</div>
								<div class="col-md-1 no_pad" style="width:13%;">
									<p>${metaData_file}</p>
								</div>
							</div>
							<div class="row">
  								<div class="col-md-1 no_pad col-1" >
  									<p>接口</p>
  								</div>
  								<div class="col-md-10 col-10" >
							    	<div class="progress">
									  <div class="progress-bar" role="progressbar" aria-valuenow="${rate_intfc}" aria-valuemin="0" aria-valuemax="100" style="width: ${rate_intfc}%;background: linear-gradient(to right, #bbfbfb 35%,#68aff1 68%)">
									    <span class="sr-only">${rate_intfc}% Complete</span>
									  </div>
									</div>
								</div>
								<div class="col-md-1 no_pad" style="width:13%;">
									<p>${metaData_intfc}</p>
								</div>
							</div>
						</div>
					<a class="J_menuTab"  onclick="test_btn('${ctx}/dc/datasearch/dataMap/index','数据地图')" href="javascript:;" ><i class="onei"></i></a>
					</div>
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="panel panel-default">
	  			<div class="panel-body">
					<div class="row" style="position: relative;">
						<div class="col-md-3 l_area no_pad">
						    <h4>总任务数</h4>
						    <h3>${task_totle} 个</h1>
						    <img src="${ctxStatic}/dc/homePage/images/001.png" alt="" style="width: 100%;height: 100%;">
					    </div>
					    <div class="col-md-1 f_line" style="text-align: center;margin-top: 10px;margin-left: -15px;">
					    	<img src="${ctxStatic}/dc/homePage/images/107.png" alt="pic">
					    </div>
					    <div class="col-md-8 f_detail" style="margin-top: 25px;">
					    	
  							<div class="row">
  								<div class="col-md-1 no_pad col-1" >
  									<p class="fsize">数据采集</p>
  								</div>
  								<div class="col-md-10 col-10" >
							    	<div class="progress">
									  <div class="progress-bar" role="progressbar" aria-valuenow="${rate_extract}" aria-valuemin="0" aria-valuemax="100" style="width: ${rate_extract}%;background: linear-gradient(to right, #8ff6c9 35%,#5ae7bc 68%)">
									    <span class="sr-only">${rate_extract}% Complete</span>
									  </div>
									</div>
								</div>
								<div class="col-md-1 no_pad" style="width:13%;">
									<p>${task_extract}</p>
								</div>
							</div>
							<div class="row">
  								<div class="col-md-1 no_pad col-1" >
  									<p class="fsize">数据转换</p>
  								</div>
  								<div class="col-md-10 col-10" >
							    	<div class="progress">
									  <div class="progress-bar" role="progressbar" aria-valuenow="${rate_translate}" aria-valuemin="0" aria-valuemax="100" style="width: ${rate_translate}%;background: linear-gradient(to right, #8ff6c9 35%,#5ae7bc 68%)">
									    <span class="sr-only">${rate_translate}% Complete</span>
									  </div>
									</div>
								</div>
								<div class="col-md-1 no_pad" style="width:13%;">
									<p>${task_translate}</p>
								</div>
							</div>
							<div class="row">
  								<div class="col-md-1 no_pad col-1" >
  									<p class="fsize">数据导出</p>
  								</div>
  								<div class="col-md-10 col-10" >
							    	<div class="progress">
									  <div class="progress-bar" role="progressbar" aria-valuenow="${rate_load}" aria-valuemin="0" aria-valuemax="100" style="width: ${rate_load}%;background: linear-gradient(to right, #8ff6c9 35%,#5ae7bc 68%)">
									    <span class="sr-only">${rate_load}% Complete</span>
									  </div>
									</div>
								</div>
								<div class="col-md-1 no_pad" style="width:13%;">
									<p>${task_load}</p>
								</div>
							</div>
						</div>
					<a class="J_menuTab"  onclick="test_btn('${ctx}/dc/schedule/dcTaskTime/index','调度任务管理')" href="javascript:;" ><i class="onei"></i></a>
					</div>
				</div>
			</div>
		</div>			
	</div>
	<div class="row" >
		<div class="col-md-6" style="position: relative;">
			<div class="panel panel-default">
	  			<div class="panel-body" >
					<div id="data1" style="width: 100%;height: 300px;"></div>
				<a class="J_menuTab"   href="javascript:;" ><i class="twoi"></i></a>
				</div>
			</div>
			
		</div>
		<div class="col-md-6">
			<div class="panel panel-default">
	  			<div class="panel-body">
					<div id="task1"  style="width: 100%;height: 300px;"></div>
			<a class="J_menuTab"   href="javascript:;" ><i class="twoi"></i></a>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<div class="panel panel-default">
	  			<div class="panel-body l_area">
	  				<h3 style="font-family: '微软雅黑';font-weight: 600;">数据运转流程示意</h3>
	  				<div class="Dimg">
	  					
						<div class="fl dataimg">
						<ul>
							<li><a class="J_menuTab"  onclick="test_btn('${ctx}/dc/dataProcess/transJob','DB数据采集')" href="javascript:;" ><img src="${ctxStatic}/dc/homePage/images/collect.png" alt="数据采集"></a></li>
								<li><span class="st">采集</span></li>
								<li><span>关系型数据库采集</span></li>
								<li><span>FTP文件采集</span></li>
								<li><span>HDFS文件采集</span></li>
						</ul>							
						</div>
						<div class="fl Rarrow ">
							<img src="${ctxStatic}/dc/homePage/images/Rarrow.png" alt="右箭头">
						</div>
						<div class="fl dataimg">
						<ul>
							<li><a class="J_menuTab"  onclick="test_btn('${ctx}/dc/dataProcess/process/list','转换过程设计')" href="javascript:;"><img src="${ctxStatic}/dc/homePage/images/deal.png" alt="数据处理"></a></li>
							
								<li><span class="st">转换</span></li>
								<li><span>数据校验</span></li>
								<li><span>数据清洗</span></li>
								<li><span>数据转换</span></li>
						</ul>
						</div>
						<div class="fl Rarrow ">
							<img src="${ctxStatic}/dc/homePage/images/Rarrow.png" alt="右箭头">
						</div>
						<div class="fl dataimg">
						<ul>
							<li><a class="J_menuTab"  onclick="test_btn('${ctx}/dc/datasearch/dataMap/index','数据地图')" href="javascript:;"><img src="${ctxStatic}/dc/homePage/images/explore.png" alt="数据探索"></a></li>
							
								<li><span class="st">编目</span></li>
								<li><span>数据检索</span></li>
								<li><span>数据地图</span></li>
								<li><span>数据链路</span></li>
						</ul>
						</div>
						<div class="fl Rarrow ">
							<img src="${ctxStatic}/dc/homePage/images/Rarrow.png" alt="右箭头">
						</div>
						<div class="fl dataimg">
						<ul>
							<li><a class="J_menuTab"  onclick="test_btn('${ctx}/dc/dataProcess/queryHive/list','QueryHive')" href="javascript:;"><img src="${ctxStatic}/dc/homePage/images/newdoc.png" alt="数据建仓"></a></li>
							
								<li><span class="st">建仓</span></li>
								<li><span>仓库主题</span></li>
								<li><span>仓库管理</span></li>
								<li><span>数据加载</span></li>
						</ul>	
						</div>
						<div class="fl Rarrow">
							<img src="${ctxStatic}/dc/homePage/images/Rarrow.png" alt="右箭头">
						</div>
						<div class="fl dataimg last">
						<ul>
							<li><a class="J_menuTab"  onclick="test_btn('${ctx}/dc/dataExport/job/list','数据导出')" href="javascript:;"><img src="${ctxStatic}/dc/homePage/images/export.png" alt="数据导出"></a></li>
							
								<li><span class="st">导出</span></li>
								<li><span>导出至关系型数据库</span></li>
								<li><span>导出过程配置</span></li>
								<li><span>导出任务监控</span></li>
						</ul>	
						</div>

					</div>
					</div>
<!-- 					<div class="col-md-12">
					</div> -->
	  			</div>
		</div>
	</div>
</div>

<script src="${ctxStatic}/dc/homePage/js/jquery-3.2.0.min.js"></script>
<script src="${ctxStatic}/dc/homePage/js/bootstrap.min.js"></script>
<script src="${ctxStatic}/dc/homePage/js/echarts.js"></script>
<script type="text/javascript">
	var myLine=echarts.init(document.getElementById('data1'));
		var line_option={
		    title: {
		        text: '数据增长情况',
		        left: 'left'
		    },
		    tooltip: {		        
		    },
		    legend: {
		        left: 'left',		   
		    },
		    xAxis: {
		    	name: '日期',//坐标轴名称 
		        type: 'category',
				splitLine:{show: false},
				boundaryGap : false,
		        data: "${metaData_trend_date}".split(',')
		        // data: [3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,3.10,3.11,3.12,3.13]
		    },
		    grid: {		        
		    },
		    boundaryGap:[
		    	false
		    ],
		    yAxis: {
		    	name: '增长幅度',//坐标轴名称 
		    },
		    color:[
		    '#5CBCE7'
		    ],
		    series: [
		        {
		            name: '数据增长',
		            type: 'line',
					itemStyle: {
						normal: {
							areaStyle: {type: 'default'},
							lineStyle: {            // 系列级个性化折线样式，横向渐变描边
								width: 3
							}
						}
					},
		            data: "${metaData_trend_num}".split(',')
		         //   data: [100,150,200,200,250,400,400,425,475,525,570,600,645]
		            
		        }
		    ]
		};
		myLine.setOption(line_option);
		/*$.get('json/data.json').done(function(data){
			myChart.setOption({
				xAxis:{
					data:data.categories
				},
				series:[{
					name:'数据增长',
					data:data.data
				}]
			});
		})*/
		/*不需要ajax异步加载*/
		
	
</script>

<script type="text/javascript">
	var myBar=echarts.init(document.getElementById('task1'));
/* 	var myDate = new Date();
	var y = myDate.getFullYear();
	var m = myDate.getMonth()+1;
	var d = myDate.getDate();	 */
	
	var title_left;//设置一个left值 
	if(top.innerWidth<1485){//页面加载时进行判断 
		title_left = '36%';
		console.dir(bar_option);
	}else{
		title_left = 'center';
	}
	var taskData = "${task_chart_hour}".split(',');
	var bar_option={
		    title: {
		        text: '当日任务运行情况',
		        left: 'left'
		    },
		    tooltip: {
		        
		    },
		    legend: {
		        left: title_left,
		        data: ['数据采集', '数据转换','数据导出']
		    },
		    xAxis: {
		    	name: '时间',//坐标轴名称 
		        type: 'category',
		    //    data: [0,1,2,3,4,5,6,7,8,9,10,11,12]
		        //data: "${task_chart_hour}".split(','),
		        data:taskData.map(function(item){
		        	return item+':00'
		        }),
		        axisLabel: {
		        	interval:0//强制显示所有标签 
	            }
		    },
		    grid: {
		        
		    },
		    yAxis: {
		        name:'数量 '
		    },
		    color:[
				'#516b91','#59c4e6','#93b7e3'
		 //   '#5CBCE7','#82F3C6','#425A94'
		    ],
		    series: [
		    	{
		            name: '数据采集',
		            type: 'bar',
		            stack:'one',
		      	//  data: [40,50,58,70,55,62,45,36,30,34,24,18,13]
		            data: "${task_chart_extract}".split(',')
		        },
		        {
		            name: '数据转换',
		            type: 'bar',
		            stack:'one',
		        //  data: [60,85,100,90,73,75,75,80,90,60,40,30,25]
		            data: "${task_chart_translate}".split(',')
		        },
		        {
		            name: '数据导出',
		            type: 'bar',
		            stack:'one',
		        //  data: [8,22,15,25,30,25,15,20,10,15,26,14,10]
		            data: "${task_chart_load}".split(',')
		        }
		        
		        
		    ]
		};

		myBar.setOption(bar_option);
		window.onresize = function(){
			console.log(top.innerWidth)
			if(top.innerWidth<1485){
				bar_option.legend.left = '36%';
				console.dir(bar_option);
				myBar.setOption(bar_option);
			}else{
				bar_option.legend.left = 'center';
				myBar.setOption(bar_option);
			}
			myLine.resize();
			myBar.resize();
		}

	/*$.get('json/bar.json',function(data){
		myBar.setOption({
			xAxis:{
				data:data.category
			},
			series:[
			{
				name:'数据采集',
				data:data.collect

			},
			{
				name:'数据转换',
				data:data.transform

			},
			{
				name:'数据导出',
				data:data.export

			}
			]
		})
	})*/
</script>
</body>
</html>