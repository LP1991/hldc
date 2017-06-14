<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="shortcut icon" href="${ctxStatic}/common/img/favicon.ico">
	<title>${fns:getConfig('system.productName')}</title>

	<link href="${ctxStatic}/dc/css/global.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/dc/css/dc.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/awesome/4.4/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<script src="${ctxStatic}/dc/js/jquery-2.1.1.min.js"></script>
</head>
<body style="overflow-x:hidden;">
<%@ include file="retrievalTop.jsp"%>
<div class="search_wrap">
	<div class="search clear">
		<div id="expend_search">
			<input class="text" type="text" value="${search.name}"  placeholder="请输入关键词搜索数据..." id="name" name="name">
		</div>
		<span id="searchbtn" style="font-weight: 900;">全站搜索</span>
		<em  class="fa-hover filterBtn"  ><i class="fa fa-angle-double-down"></i>筛选 </em>
	</div>
</div>
<input  type="hidden" value="" id="searchTypeFirst"/>
<div class="main_visual">
	<div id="dataClass">
		<h2>数据领域</h2>
		<h4 style="width:auto;">您可以点击下方链接进入相应的分类</h4>
		<ul class="clear sort_ul" style="width:auto;height:auto;">
			<li><a href="javascript:void()" onclick='searchyy("f2e2df5e9c724d1ca89e33b20e57ea11")' class="links01"><strong>经济建设</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("324d878497d34baf9b782485567c34c1")' class="links02"><strong>旅游住宿</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("823aaac107fa40579778c76d005a2253")' class="links03"><strong>房屋住宅</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("c3379a837fd4465491a111584ddce3e3")' class="links04"><strong>餐饮美食</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("c9dd2a6612c54c8eba95d3666723fedc")' class="links05"><strong>医疗健康</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("23430204462849d8a2f57a6ac073703e")' class="links06"><strong>文化娱乐</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("de86705a1898424382a49302c5f1a7e8")' class="links07"><strong>消费购物</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("5554befa92134873b62ba79efb6e9fea")' class="links08"><strong>生活安全</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("ecb4b09dee824621a1340119b050d78c")' class="links09"><strong>宗教信仰</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("3fec961a5321402c96cb5d048ca5870c")' class="links010"><strong>教育科研</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("8c6a96a2c2b64696b3ab041cec294b98")' class="links011"><strong>社会保障</strong></a></li>
			<li><a href="javascript:void()" onclick='searchyy("a51503864a2b45668395bdc7cf0746ff")' class="links012"><strong>环境保护</strong></a></li>
		</ul>
	</div>
	<div id="latest">
		<h2>华量软件</h2>
		<div class="lcon clear">
			<dl class="dataProducts" id="newDataProduct"><dt>数据产品</dt><dd>·<a href="#" title=""></a></dd></dl>
			<dl class="dataApplication" id="newDataApplication"><dt>数据应用</dt><dd>·<a href="#" title=""></a></dd></dl>
			<dl class="interface" id="newInterface"><dt>接口</dt><dd>·<a href="#" title=""></a></dd></dl>
			<dl class="mobileApplication" id="newDataSpeTopic"><dt>移动应用</dt><dd>·<a href="#" title=""></a></dd></dl>
		</div>
	</div>
</div>

<div class="con_container clear">
	<div id="side" >
		<div class="borders">
			<dl class="sidebar_option">

			</dl>
		</div>
	</div>
	<div id="content">
		<div class="search_result" >
			<div class="search_result_txt"></div>
			<div class="search_result_option" style="display:none"></div>
			<dl class="result_con active">	</dl>

			<div class="page">
						<span >
							<ul>
							<li class="page_btn"><a href="#" class="disabled">&lt;上一页</a>&nbsp;&nbsp;</li>
								<li class="page_btn"><a href="#" class="active" id="pageNum">1</a></li>
								<li class="page_btn"> <a href="#" class="disabled">下一页&gt;</a>&nbsp;&nbsp;</li>
								<li class="info"> 共<a id="pageNum">1</a>页， 到第  <input  style="width: 20px;background-color: #ffffff;" id="pageNext" name="pageNext" onkeyup="this.value=this.value.replace(/[^\d]/g,'')"/> 页，
									 每页  <input  style="width: 20px;background-color: #ffffff;" id="pageSize"/>条
									<a href="#" class="sure"> 确定  </a>
								</li>
							</ul>
						</span>
			</div>
		</div>
	</div>
</div>

<div id="footer">
	<p class="fNav">
	<p>(建议使用IE7、8、9、10,1024*768以上分辨率浏览本站)</p>
</div>

<!-- end of html -------------------------------------------------------------------------- -->

<script type="text/javascript" src="${ctxStatic}/dc/js/util.js"></script>
<script src="${ctxStatic}/dc/js/cs.js"></script>
<script src="${ctxStatic}/dc/js/icheck-1.0.2/icheck.min.js"></script>
<link href="${ctxStatic}/dc/js/icheck-1.0.2/custom.css" rel="stylesheet">
<link href="${ctxStatic}/dc/js/icheck-1.0.2/skins/all.css" rel="stylesheet">
<script>
    //改变遍历顺序 ,使用for(i=0;)遍历
    function sortObj(obj) {
        var arr = [];
        for (var i in obj) {
            arr.push([obj[i],i]);
        };
        arr.reverse();
        var len = arr.length;
        var obj = {};
        for (var i = 0; i < len; i++) {
            obj[arr[i][1]] = arr[i][0];
        }
        return obj;
    }

    $(document).ready(function(){
        current_page =1;
        firstFlag = true;
        // var objType = "table";
        searchName = "*";
        searchTime="", searchLabel="", searchType="",searchCat="";
        $(".search_result").hide();

        //如果搜索类型是首页，就是全站搜索，否则搜索，默认全站搜索


        $("#searchbtn").click(function(){
            debugger;
            objType = $(".dc_search_ul .on").attr('value');
            searchName = $("#name").val();
            searchTime="";
            searchType=$("#searchTypeFirst").attr('value');
            var pageSize=10,pageNo=1;
            var sId='';
            searchCat = 's_cata';
            //时间周期
            if(firstFlag) {
                $(document).on('click', '.option_item_con_k label', function () {//选择最近一年时间周期
                    //标签选择唯一的黑体字
                    $(this).css('font-weight', 'bolder').parent().parent().siblings().find('.option_item_con').find('label').css('font-weight', 'normal');
                    $(this).css('font-weight', 'bolder').parent().siblings().find('label').css('font-weight', 'normal');
                    searchTime = $(this).attr("id");
                    $(this).attr("id");
//                    searchType = '';
                    objType = $(".dc_search_ul .on").attr('value');
                    findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, pageNo);
                });
                //时间周期侧边栏
                $(document).on('click', '#side label', function () {//选择最近一年时间周期
                    //标签选择唯一的黑体字
                    $(this).css('font-weight', 'bolder').siblings().find('label').css('font-weight', 'normal');
                    $(this).parent().siblings().find('label').css('font-weight', 'normal');
                    var o = $(this);
                    if (o.attr("id")=="oneYear" || o.attr("id")=="halfYear" || o.attr("id")=="threeMonths" || o.attr("id")=="oneMonth" || o.attr("id")=="oneWeek" ||o.attr("id")=="today") {
                        //日志信息
                        searchTime = o.attr("id");
//                        searchType = null;
                    } else {
//                        searchTime = null;
                        searchType = '';
                        $(this).parent().parent().siblings().find('label').each(function(index) {
//                            console.log("id :"+ $(this)[0].innerHTML+",index:"+index+",font-weight:"+$(this).css('font-weight'));
                            if($(this).css('font-weight') == 'bold'){
                                //时间条件和其他条件区
                                var oid = $(this).attr('id');
                                if (oid!="oneYear" && oid!="halfYear" && oid!="threeMonths" && oid!="oneMonth" && oid!="oneWeek" && oid!="today") {
                                    searchType += oid+",";
                                }
                            }
                        });//定位查找所有黑体的 选项

                        searchType += o.attr('id');
//                        console.log("searchType :"+searchType);
                    }
                    objType = $(".dc_search_ul .on").attr('value');
                    findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, pageNo);
                });

//            $(document).on('click','.sId',function(){//选择业务分类第二层
//                searchType = $(this).attr('id');
//                searchCat = 's_cata';
//				console.log(searchType)
//                findData(null,searchName,objType,null,searchType,searchCat,pageSize,pageNo);
//            });
//隐藏标签的click方法
                $(document).on('click', '.option_searchType div', function () {//problem
//                    console.log($(this).find('label').parent().parent().parent().parent().siblings().find('label'));
//                    $(this).find('label').parent().parent().parent().parent().siblings().find('label').css('font-weight', 'normal');
                    $(this).find('label').css('font-weight', 'bolder').parent().siblings().find('label').css('font-weight', 'normal');

                    var o = $(this);

//					searchTime = null;
                    searchType = '';
                    o.parent().parent().parent().siblings().find('label').each(function(index) {
//						console.log("id :"+ $(this)[0].innerHTML+",index:"+index+",font-weight:"+$(this).css('font-weight'));
                        if($(this).css('font-weight') == 'bold'){
                            //时间条件和其他条件区
                            var oid = $(this).attr('id');
                            if (oid!="oneYear" && oid!="halfYear" && oid!="threeMonths" && oid!="oneMonth" && oid!="oneWeek" && oid!="today") {
                                searchType += oid+",";
                            }
                        }
                    });//定位查找所有黑体的 选项

                    searchType += o.find('label').attr('id');
//                        console.log("searchType :"+searchType);
                    objType = $(".dc_search_ul .on").attr('value');

                    findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, pageNo);
                });

                $(document).on('click', '.hide_data label', function () {
                    $(this).parents().parents().find('.search_result_option').find('label').css('font-weight', 'normal');
                    $(this).css('font-weight', 'bolder');
                })

//                $(document).on('click', '.ssId', function () {//选择业务分类第三层
//                    searchType = $(this).attr('id');
//                    searchCat = 'sss_cata';
//                    findData(null, searchName, objType, null, searchType, searchCat, pageSize, pageNo);
//                });

                $(document).on('click', '.pageNum', function () {//选择分页
                    findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, $(this).attr('id'));
                });

                $(document).on('click', '.pageBefore', function () {//选择上一页
                    var lastPage = parseInt($('.current_page').attr('id')) - 1;
                    findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, lastPage);
                });
                $(document).on('click', '.pageAfter', function () {//选择下一页
                    var current_page = $('.current_page').attr('id');
                    var pageNext = ($('.current_page').attr('id') != null) ? (parseInt(current_page) + 1) : (pageNo + 1);
                    findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, pageNext);
                });
                $(document).on('click', '.sure', function () {//选择分页
                    findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, $('#pageNext').val());
                });
                firstFlag = false;
            }
            var param = {
                pageSize:pageSize,
                pageNo:pageNo,
                'searchName': searchName,		//检索名称
                'objType': objType,				//对象类型(表/字段/接口...)
                'searchType':searchType,		//业务分类
                'searchLabel':searchLabel,		//检索标签
                'searchTime':searchTime	,		//检索时间
                'searchCat':searchCat           //业务分类层次
            };
            submitData("${ctx}/dc/dataSearch/retrieval/findData",param,function(result){
//                console.log(result);
                var dateRange = result.body.searchMap.dateRange;//时间周期的数据
                var firstClass=result.body.searchMap.catalog;//业务分类第一层
                var secondClass=result.body.searchMap.catalog;//业务分类第二层
                var thirdClass=result.body.searchMap.catalog;//业务分类第三层
                var source = result.body.searchMap.source;//数据
                var categoryData = result.body.categoryTree;//业务分类元数据
                var pageNum = result.body.pageNum;
                <!--此部分显示根据条件查到的数据 -->
                $(".search_result_txt").empty();
                $(".search_result_txt").append('共找到匹配记录'+result.body.count+'条' ); //显示所搜索的数据有多少条

                <!-- 时间周期中间检索条件-->
                $(".search_result_option").empty();
                var html ='';
                html+=' <div class="option_item"><div class="option_item_name">时间周期</div><div class="option_item_con">';
                html +='<div class="option_item_con_k twoline">';//显示时间周期部分
                dateRange = sortObj(dateRange);
                for(key in dateRange){
                    if(key=='oneYear'){//最近一年的统计数据
                        html +='<div><input type="checkbox" name="searchTime" value="oneYear"><label id="oneYear" >最近一年('+dateRange[key]+')</label></input></div>';
                    }if(key =='halfYear'){//最近半年的统计数据
                        html +='<div><input type="checkbox" name="searchTime" value="halfYear"><label id="halfYear">最近半年('+dateRange[key]+')</label></input></div>';
                    }if(key =='threeMonths'){//最近三个月的统计数据
                        html+='<div><input type="checkbox" name="searchTime" value="threeMonths"><label id="threeMonths">最近三个月('+dateRange[key]+')</label></input></div>';
                    }if(key =='oneMonth'){//最近一个月的统计数据
                        html+='<div><input type="checkbox" name="searchTime" value="oneMonth"><label id="oneMonth">最近一个月('+dateRange[key]+')</label></input></div>';
                    }if(key =='oneWeek'){//最近一周的统计数据
                        html +='<div><input type="checkbox" name="searchTime" value="oneWeek"><label id="oneWeek">最近一周('+dateRange[key]+')</label></input></div>';
                    }if(key =='today'){//今天的统计数据
                        html +='<div><input type="checkbox" name="searchTime" value="today"><label id="today">今天('+dateRange[key]+')</label></input></div>';
                    }
                }
                html +='</div></div>';
                html +='<div class="option_item_op "><span class="more_C gray_btn">多选</span><span  class="more_dt btn">更多<span class="down"></span></span> </div><div class="clear"></div>';
                html +='</div>';
                <!-- 时间周期侧边栏检索条件-->
                $(".sidebar_option").empty();
                var sidehtml ='';
                sidehtml+=' <div><dt>时间周期:</dt>';
                for(key in dateRange){
                    if(key=='oneYear'){//最近一年的统计数据
                        sidehtml +='<dd><input type="checkbox" name="searchTime" value="oneYear"><label id="oneYear">最近一年('+dateRange[key]+')</label></input></dd>';
                    }if(key =='halfYear'){//最近半年的统计数据
                        sidehtml +='<dd><input type="checkbox" name="searchTime" value="halfYear"><label id="halfYear">最近半年('+dateRange[key]+')</label></input></dd>';
                    }if(key =='threeMonths'){//最近三个月的统计数据
                        sidehtml+='<dd><input type="checkbox" name="searchTime" value="threeMonths"><label id="threeMonths">最近三个月('+dateRange[key]+')</label></input></dd>';
                    }if(key =='oneMonth'){//最近一个月的统计数据
                        sidehtml+='<dd><input type="checkbox" name="searchTime" value="oneMonth"><label id="oneMonth">最近一个月('+dateRange[key]+')</label></input></dd>';
                    }if(key =='oneWeek'){//最近一周的统计数据
                        sidehtml +='<dd><input type="checkbox" name="searchTime" value="oneWeek"><label id="oneWeek">最近一周('+dateRange[key]+')</label></input></dd>';
                    }if(key =='today'){//今天的统计数据
                        sidehtml +='<dd><input type="checkbox" name="searchTime" value="today"><label id="today">今天('+dateRange[key]+')</label></input></dd></div>';
                    }
                }

                <!-- 自定义分类数据的显示部分-->
                var  categoryHtml = '';
                for(var i=0;i<categoryData.length;i++){
                    categoryHtml +='<div class="option_item_'+i+'">';
                    var hide_data = '';
                    for(key in categoryData[i] ){//构建业务分类树
                        if(key =='item_name'){
                            categoryHtml +='<div class="option_item_name">'+categoryData[i][key]+' </div>';//业务分类名
                            categoryHtml += '<div class="option_item_con"><div class="option_searchType">';
                            for(var j=0;j<categoryData[i]['children'].length;j++) {//这一部分为构建 隐私数据(0)未分类对象(1)公开数据(1)
                                categoryHtml +='<div><input type="checkbox" name="searchType" value="itemName" >';
                                var  catName = categoryData[i]['children'][j]['cata_name'];
                                var catCount = (firstClass[categoryData[i]['children'][j]['id']]!=null) ? firstClass[categoryData[i]['children'][j]['id']] :0;
                                categoryHtml += '<label class="sId" id="'+categoryData[i]['children'][j]['id']+'">'+catName+'('+ catCount+')'+'</label>';
                                var ssChildren = categoryData[i]['children'][j]['children'] != null ? categoryData[i]['children'][j]['children']:null ;
                                if(ssChildren !=null){
                                    for(var k=0;k<ssChildren.length;k++) {//此部分构建业务分类的第三层
                                        var  scatName = ssChildren[k]['cata_name'];
                                        var scatCount = (secondClass[ssChildren[k]['id']]!=null) ? secondClass[ssChildren[k]['id']] :0;
                                        //console.log(scatCount)
                                        hide_data +='<label class = "ssId" id="'+ssChildren[k]['id']+'">'+scatName+'('+ scatCount+')'+'</label>';
                                    }
                                    var hide_data = '<div class="hide_data" style="display:none;">'+hide_data+'</div>'
                                }
                                categoryHtml +='</input></div>';
                            }
                            categoryHtml+='</div></div>';
                            categoryHtml+=' <div class="option_item_op "> <span  class="more_dt btn">更多<span class="down">';
                            categoryHtml +='</span></span></div>';
                            categoryHtml +='<div class="clear"></div></div></div>';
                        }
                    }
                    $('.option_item_1').append(hide_data);
                }
                <!-- 自定义分类数据的侧边栏显示部分-->
                var  catSideHtml = '';
                for(var i=0;i<categoryData.length;i++){
                    catSideHtml +='<div class="option_item_'+i+'">';
                    var hide_data = '';
                    for(key in categoryData[i] ){//构建业务分类树
                        if(key =='item_name'){
                            catSideHtml +='<dt>'+categoryData[i][key]+':</dt>';//自定义分类名
                            for(var j=0;j<categoryData[i]['children'].length;j++) {//这一部分为构建子分类  如隐私数据(0)未分类对象(1)公开数据(1)
                                catSideHtml +='<dd><input type="checkbox" name="searchType" value="itemName" >';
                                var  catName = categoryData[i]['children'][j]['cata_name'];
                                var catCount = (firstClass[categoryData[i]['children'][j]['id']]!=null) ? firstClass[categoryData[i]['children'][j]['id']] :0;
                                catSideHtml += '<label class="sId" id="'+categoryData[i]['children'][j]['id']+'">'+catName+'('+ catCount+')'+'</label>';
                                var ssChildren = categoryData[i]['children'][j]['children'] != null ? categoryData[i]['children'][j]['children']:null ;
                                if(ssChildren !=null){
                                    for(var k=0;k<ssChildren.length;k++) {//此部分构建业务分类的第三层
                                        var  scatName = ssChildren[k]['cata_name'];
                                        var scatCount = (secondClass[ssChildren[k]['id']]!=null) ? secondClass[ssChildren[k]['id']] :0;
                                        //console.log(scatCount)
                                        hide_data +='<label class = "ssId" id="'+ssChildren[k]['id']+'">'+scatName+'('+ scatCount+')'+'</label>';
                                    }
                                    var hide_data = '<dd class="hide_data" style="display:none;">'+hide_data+'</dd>'
                                }
                                catSideHtml +='</input></dd>';
                            }
                            catSideHtml+='</div>';

                        }
                    }
                    $('.option_item_1').append(hide_data);
                }
                $(".search_result_option").append(html+categoryHtml);
                $(".sidebar_option").append(sidehtml+catSideHtml);

                //中间显示数据部分，只显示表名，描述，类型，更新时间
                $(".result_con").empty();
                var datahtml = '';
                for(var i=0;i<source.length;i++){
                    var resultList = '';
                    var objDesc = (source[i]['objDesc']) !=null ? source[i]['objDesc'] :"";
                    resultList += '<dt class="result_item"><a target="_blank" href="${ctx}/dc/dataSearch/retrieval/view?id='+source[i]['id']+'">'+objDesc+'</a>&nbsp;&nbsp;&nbsp;&nbsp;</dt>';
                    resultList += '<dd><p>对象名称：'+source[i]['objName']+'&nbsp;&nbsp;&nbsp;&nbsp;</p>';
                    if(source[i]['updateDate']){
                        resultList += '<span>更新时间:'+source[i]['updateDate'].replace(/T/,' ').replace('.000Z','')+'</span></dd>';
                    }else{
                        resultList += '<span>更新时间: </span></dd>';
                    }
                    datahtml+= ''+resultList+'';
                }
                $(".result_con").append(datahtml);

                $(".page").empty();//分页
                var pageHtml ='<span ><ul>';
                if(pageNo==pageNum){
                    pageHtml+='<li class="page_btn"><a href="#" class="pageBefore active" id="pageNum" value="'+i+'">&lt;上一页</a>&nbsp;&nbsp;</li>';
                }else{
                    pageHtml+='<li class="page_btn"><a href="#" class="pageBefore disabled" id="1" >&lt;上一页</a>&nbsp;&nbsp;</li>';
                }
                for(var i=0;i<pageNum;i++){
                    if(i==0){
                        pageHtml +='<li class="page_btn"><a href="#" class="pageNum active" id="'+(i+1)+'" >'+(i+1)+'</a></li>';
                    }else if(i<=4){
                        //  pageHtml +='<li class="page_btn"><a href="#" class="pageNum" id="'+(i+1)+'" >'+(i+1)+'</a></li>';
                        //加入判断只显示5个可点按钮
                        console.log(i);
                        pageHtml +='<li class="page_btn"><a href="#" class="pageNum" id="'+(i+1)+'" >'+(i+1)+'</a></li>';

                    }

                }
                if(pageNum=='1'){
                    pageHtml+='<li class="page_btn"> <a href="#" class="pageAfter disabled" id="'+(i+2)+'">下一页&gt;</a>&nbsp;&nbsp;</li>';
                }else{
                    pageHtml+='<li class="page_btn"> <a href="#" class="pageAfter active" id="'+(i+2)+'" >下一页&gt;</a>&nbsp;&nbsp;</li>';
                }
                pageHtml +='<li class="info"> 共<a>'+pageNum+'</a>页， 到第  <input  style="width: 20px;background-color: #ffffff;" id="pageNext" name="pageNext" onkeyup="this.value=this.value.replace(/[^\\d]/g,\'\')" /> 页，';
                pageHtml +='  每页'+pageSize+'条<a href="#" class="sure" id="forSure"> 确定</a></li>';
                if(pageNo>pageNum){console.log('数字太大');}
                pageHtml +='</ul></span>';
                console.log(pageHtml);
                $(".page").append(pageHtml);

                $(".search_result").show();
                $(".main_visual").hide();
                $('.filterBtn').show();
                $(".case_col").hide();
            });
        });

    });

    //通过类型查询类型
    function searchTo(objType){
        //替换全站搜索为搜索
        document.getElementById("searchbtn").innerHTML="搜索";
        // objType = $(".dc_search_ul .active").attr('value');
        searchName = $("#name").val();
        searchTime="";
        searchType="";
        var pageSize=10,pageNo=1;
        var sId='';
        searchCat = 's_cata';
        //时间周期
        if(firstFlag) {
            $(document).on('click', '.option_item_con_k label', function () {//选择最近一年时间周期
                //标签选择唯一的黑体字
                $(this).css('font-weight', 'bolder').parent().parent().siblings().find('.option_item_con').find('label').css('font-weight', 'normal');
                $(this).css('font-weight', 'bolder').parent().siblings().find('label').css('font-weight', 'normal');
                searchTime = $(this).attr("id");
                $(this).attr("id");
//                    searchType = '';
                objType = $(".dc_search_ul .on").attr('value');
                findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, pageNo);
            });
            //时间周期侧边栏
            $(document).on('click', '#side label', function () {//选择最近一年时间周期
                //标签选择唯一的黑体字
                $(this).css('font-weight', 'bolder').siblings().find('label').css('font-weight', 'normal');
                $(this).parent().siblings().find('label').css('font-weight', 'normal');
                var o = $(this);
                if (o.attr("id") == "oneYear" || o.attr("id") == "halfYear" || o.attr("id") == "threeMonths" || o.attr("id") == "oneMonth" || o.attr("id") == "oneWeek" || o.attr("id") == "today") {
                    //日志信息
                    searchTime = o.attr("id");
//                        searchType = null;
                } else {
//                        searchTime = null;
                    searchType = '';
                    $(this).parent().parent().siblings().find('label').each(function (index) {
//                            console.log("id :"+ $(this)[0].innerHTML+",index:"+index+",font-weight:"+$(this).css('font-weight'));
                        if ($(this).css('font-weight') == 'bold') {
                            //时间条件和其他条件区
                            var oid = $(this).attr('id');
                            if (oid != "oneYear" && oid != "halfYear" && oid != "threeMonths" && oid != "oneMonth" && oid != "oneWeek" && oid != "today") {
                                searchType += oid + ",";
                            }
                        }
                    });//定位查找所有黑体的 选项

                    searchType += o.attr('id');
//                        console.log("searchType :"+searchType);
                }
                objType = $(".dc_search_ul .on").attr('value');
                findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, pageNo);
            });

//            $(document).on('click','.sId',function(){//选择业务分类第二层
//                searchType = $(this).attr('id');
//                searchCat = 's_cata';
//				console.log(searchType)
//                findData(null,searchName,objType,null,searchType,searchCat,pageSize,pageNo);
//            });
//隐藏标签的click方法
            $(document).on('click', '.option_searchType div', function () {//problem
//                    console.log($(this).find('label').parent().parent().parent().parent().siblings().find('label'));
//                    $(this).find('label').parent().parent().parent().parent().siblings().find('label').css('font-weight', 'normal');
                $(this).find('label').css('font-weight', 'bolder').parent().siblings().find('label').css('font-weight', 'normal');

                var o = $(this);

//					searchTime = null;
                searchType = '';
                o.parent().parent().parent().siblings().find('label').each(function (index) {
//						console.log("id :"+ $(this)[0].innerHTML+",index:"+index+",font-weight:"+$(this).css('font-weight'));
                    if ($(this).css('font-weight') == 'bold') {
                        //时间条件和其他条件区
                        var oid = $(this).attr('id');
                        if (oid != "oneYear" && oid != "halfYear" && oid != "threeMonths" && oid != "oneMonth" && oid != "oneWeek" && oid != "today") {
                            searchType += oid + ",";
                        }
                    }
                });//定位查找所有黑体的 选项

                searchType += o.find('label').attr('id');
//                        console.log("searchType :"+searchType);
                objType = $(".dc_search_ul .on").attr('value');
                findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, pageNo);
            });

            $(document).on('click', '.hide_data label', function () {
                $(this).parents().parents().find('.search_result_option').find('label').css('font-weight', 'normal');
                $(this).css('font-weight', 'bolder');
            })

//                $(document).on('click', '.ssId', function () {//选择业务分类第三层
//                    searchType = $(this).attr('id');
//                    searchCat = 'sss_cata';
//                    findData(null, searchName, objType, null, searchType, searchCat, pageSize, pageNo);
//                });

            $(document).on('click', '.pageNum', function () {//选择分页
                objType = $(".dc_search_ul .on").attr('value');
                findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, $(this).attr('id'));
            });

            $(document).on('click', '.pageBefore', function () {//选择上一页
                objType = $(".dc_search_ul .on").attr('value');
                var lastPage = parseInt($('.current_page').attr('id')) - 1;
                findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, lastPage);
            });
            $(document).on('click', '.pageAfter', function () {//选择下一页
                objType = $(".dc_search_ul .on").attr('value');
                var current_page = $('.current_page').attr('id');
                var pageNext = ($('.current_page').attr('id') != null) ? (parseInt(current_page) + 1) : (pageNo + 1);
                findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, pageNext);
            });
            $(document).on('click', '.sure', function () {//选择分页
                objType = $(".dc_search_ul .on").attr('value');
                findData(searchTime, searchName, objType, null, searchType, searchCat, pageSize, $('#pageNext').val());
            });
            firstFlag = false;
        }
        var param = {
            pageSize:pageSize,
            pageNo:pageNo,
            //'searchName': searchName,		//检索名称
            'objType': objType,				//对象类型(表/字段/接口...)
            'searchType':searchType,		//业务分类
            'searchLabel':searchLabel,		//检索标签
            'searchTime':searchTime	,		//检索时间
            'searchCat':searchCat           //业务分类层次
        };
        submitData("${ctx}/dc/dataSearch/retrieval/findData",param,function(result){
//                console.log(result);




            var dateRange = result.body.searchMap.dateRange;//时间周期的数据
            var firstClass=result.body.searchMap.catalog;//业务分类第一层
            var secondClass=result.body.searchMap.catalog;//业务分类第二层
            var thirdClass=result.body.searchMap.catalog;//业务分类第三层
            var source = result.body.searchMap.source;//数据
            var categoryData = result.body.categoryTree;//业务分类元数据
            var pageNum = result.body.pageNum;
            <!--此部分显示根据条件查到的数据 -->
            $(".search_result_txt").empty();
            $(".search_result_txt").append('共找到匹配记录'+result.body.count+'条' ); //显示所搜索的数据有多少条

            <!-- 时间周期中间检索条件-->
            $(".search_result_option").empty();
            var html ='';
            html+=' <div class="option_item"><div class="option_item_name">时间周期</div><div class="option_item_con">';
            html +='<div class="option_item_con_k twoline">';//显示时间周期部分
            dateRange = sortObj(dateRange);
            for(key in dateRange){
                if(key=='oneYear'){//最近一年的统计数据
                    html +='<div><input type="checkbox" name="searchTime" value="oneYear"><label id="oneYear" >最近一年('+dateRange[key]+')</label></input></div>';
                }if(key =='halfYear'){//最近半年的统计数据
                    html +='<div><input type="checkbox" name="searchTime" value="halfYear"><label id="halfYear">最近半年('+dateRange[key]+')</label></input></div>';
                }if(key =='threeMonths'){//最近三个月的统计数据
                    html+='<div><input type="checkbox" name="searchTime" value="threeMonths"><label id="threeMonths">最近三个月('+dateRange[key]+')</label></input></div>';
                }if(key =='oneMonth'){//最近一个月的统计数据
                    html+='<div><input type="checkbox" name="searchTime" value="oneMonth"><label id="oneMonth">最近一个月('+dateRange[key]+')</label></input></div>';
                }if(key =='oneWeek'){//最近一周的统计数据
                    html +='<div><input type="checkbox" name="searchTime" value="oneWeek"><label id="oneWeek">最近一周('+dateRange[key]+')</label></input></div>';
                }if(key =='today'){//今天的统计数据
                    html +='<div><input type="checkbox" name="searchTime" value="today"><label id="today">今天('+dateRange[key]+')</label></input></div>';
                }
            }
            html +='</div></div>';
            html +='<div class="option_item_op "><span class="more_C gray_btn">多选</span><span  class="more_dt btn">更多<span class="down"></span></span> </div><div class="clear"></div>';
            html +='</div>';
            <!-- 时间周期侧边栏检索条件-->
            $(".sidebar_option").empty();
            var sidehtml ='';
            sidehtml+=' <div><dt>时间周期:</dt>';
            for(key in dateRange){
                if(key=='oneYear'){//最近一年的统计数据
                    sidehtml +='<dd><input type="checkbox" name="searchTime" value="oneYear"><label id="oneYear">最近一年('+dateRange[key]+')</label></input></dd>';
                }if(key =='halfYear'){//最近半年的统计数据
                    sidehtml +='<dd><input type="checkbox" name="searchTime" value="halfYear"><label id="halfYear">最近半年('+dateRange[key]+')</label></input></dd>';
                }if(key =='threeMonths'){//最近三个月的统计数据
                    sidehtml+='<dd><input type="checkbox" name="searchTime" value="threeMonths"><label id="threeMonths">最近三个月('+dateRange[key]+')</label></input></dd>';
                }if(key =='oneMonth'){//最近一个月的统计数据
                    sidehtml+='<dd><input type="checkbox" name="searchTime" value="oneMonth"><label id="oneMonth">最近一个月('+dateRange[key]+')</label></input></dd>';
                }if(key =='oneWeek'){//最近一周的统计数据
                    sidehtml +='<dd><input type="checkbox" name="searchTime" value="oneWeek"><label id="oneWeek">最近一周('+dateRange[key]+')</label></input></dd>';
                }if(key =='today'){//今天的统计数据
                    sidehtml +='<dd><input type="checkbox" name="searchTime" value="today"><label id="today">今天('+dateRange[key]+')</label></input></dd></div>';
                }
            }

            <!-- 自定义分类数据的显示部分-->
            var  categoryHtml = '';
            for(var i=0;i<categoryData.length;i++){
                categoryHtml +='<div class="option_item_'+i+'">';
                var hide_data = '';
                for(key in categoryData[i] ){//构建业务分类树
                    if(key =='item_name'){
                        categoryHtml +='<div class="option_item_name">'+categoryData[i][key]+' </div>';//业务分类名
                        categoryHtml += '<div class="option_item_con"><div class="option_searchType">';
                        for(var j=0;j<categoryData[i]['children'].length;j++) {//这一部分为构建 隐私数据(0)未分类对象(1)公开数据(1)
                            categoryHtml +='<div><input type="checkbox" name="searchType" value="itemName" >';
                            var  catName = categoryData[i]['children'][j]['cata_name'];
                            var catCount = (firstClass[categoryData[i]['children'][j]['id']]!=null) ? firstClass[categoryData[i]['children'][j]['id']] :0;
                            categoryHtml += '<label class="sId" id="'+categoryData[i]['children'][j]['id']+'">'+catName+'('+ catCount+')'+'</label>';
                            var ssChildren = categoryData[i]['children'][j]['children'] != null ? categoryData[i]['children'][j]['children']:null ;
                            if(ssChildren !=null){
                                for(var k=0;k<ssChildren.length;k++) {//此部分构建业务分类的第三层
                                    var  scatName = ssChildren[k]['cata_name'];
                                    var scatCount = (secondClass[ssChildren[k]['id']]!=null) ? secondClass[ssChildren[k]['id']] :0;
                                    //console.log(scatCount)
                                    hide_data +='<label class = "ssId" id="'+ssChildren[k]['id']+'">'+scatName+'('+ scatCount+')'+'</label>';
                                }
                                var hide_data = '<div class="hide_data" style="display:none;">'+hide_data+'</div>'
                            }
                            categoryHtml +='</input></div>';
                        }
                        categoryHtml+='</div></div>';
                        categoryHtml+=' <div class="option_item_op "> <span  class="more_dt btn">更多<span class="down">';
                        categoryHtml +='</span></span></div>';
                        categoryHtml +='<div class="clear"></div></div></div>';
                    }
                }
                $('.option_item_1').append(hide_data);
            }
            <!-- 自定义分类数据的侧边栏显示部分-->
            var  catSideHtml = '';
            for(var i=0;i<categoryData.length;i++){
                catSideHtml +='<div class="option_item_'+i+'">';
                var hide_data = '';
                for(key in categoryData[i] ){//构建业务分类树
                    if(key =='item_name'){
                        catSideHtml +='<dt>'+categoryData[i][key]+':</dt>';//自定义分类名
                        for(var j=0;j<categoryData[i]['children'].length;j++) {//这一部分为构建子分类  如隐私数据(0)未分类对象(1)公开数据(1)
                            catSideHtml +='<dd><input type="checkbox" name="searchType" value="itemName" >';
                            var  catName = categoryData[i]['children'][j]['cata_name'];
                            var catCount = (firstClass[categoryData[i]['children'][j]['id']]!=null) ? firstClass[categoryData[i]['children'][j]['id']] :0;
                            catSideHtml += '<label class="sId" id="'+categoryData[i]['children'][j]['id']+'">'+catName+'('+ catCount+')'+'</label>';
                            var ssChildren = categoryData[i]['children'][j]['children'] != null ? categoryData[i]['children'][j]['children']:null ;
                            if(ssChildren !=null){
                                for(var k=0;k<ssChildren.length;k++) {//此部分构建业务分类的第三层
                                    var  scatName = ssChildren[k]['cata_name'];
                                    var scatCount = (secondClass[ssChildren[k]['id']]!=null) ? secondClass[ssChildren[k]['id']] :0;
                                    //console.log(scatCount)
                                    hide_data +='<label class = "ssId" id="'+ssChildren[k]['id']+'">'+scatName+'('+ scatCount+')'+'</label>';
                                }
                                var hide_data = '<dd class="hide_data" style="display:none;">'+hide_data+'</dd>'
                            }
                            catSideHtml +='</input></dd>';
                        }
                        catSideHtml+='</div>';

                    }
                }
                $('.option_item_1').append(hide_data);
            }
            $(".search_result_option").append(html+categoryHtml);
            $(".sidebar_option").append(sidehtml+catSideHtml);

            //中间显示数据部分，只显示表名，描述，类型，更新时间
            $(".result_con").empty();
            var datahtml = '';
            for(var i=0;i<source.length;i++){
                var resultList = '';
                var objDesc = (source[i]['objDesc']) !=null ? source[i]['objDesc'] :"";
                resultList += '<dt class="result_item"><a target="_blank" href="${ctx}/dc/dataSearch/retrieval/view?id='+source[i]['id']+'">'+objDesc+'</a>&nbsp;&nbsp;&nbsp;&nbsp;</dt>';
                resultList += '<dd><p>对象名称：'+source[i]['objName']+'&nbsp;&nbsp;&nbsp;&nbsp;</p>';
                if(source[i]['updateDate']){
                    resultList += '<span>更新时间:'+source[i]['updateDate'].replace(/T/,' ').replace('.000Z','')+'</span></dd>';
                }else{
                    resultList += '<span>更新时间: </span></dd>';
                }
                datahtml+= ''+resultList+'';
            }
            $(".result_con").append(datahtml);

            $(".page").empty();//分页
            var pageHtml ='<span ><ul>';
            if(pageNo==pageNum){
                pageHtml+='<li class="page_btn"><a href="#" class="pageBefore active" id="pageNum" value="'+i+'">&lt;上一页</a>&nbsp;&nbsp;</li>';
            }else{
                pageHtml+='<li class="page_btn"><a href="#" class="pageBefore disabled" id="1" >&lt;上一页</a>&nbsp;&nbsp;</li>';
            }
            for(var i=0;i<pageNum;i++){
                if(i==0){
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum active" id="'+(i+1)+'" >'+(i+1)+'</a></li>';
                }else if(i<=4){
                    //  pageHtml +='<li class="page_btn"><a href="#" class="pageNum" id="'+(i+1)+'" >'+(i+1)+'</a></li>';
                    //加入判断只显示5个可点按钮
                    console.log(i);
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum" id="'+(i+1)+'" >'+(i+1)+'</a></li>';

                }

            }
            if(pageNum=='1'){
                pageHtml+='<li class="page_btn"> <a href="#" class="pageAfter disabled" id="'+(i+2)+'">下一页&gt;</a>&nbsp;&nbsp;</li>';
            }else{
                pageHtml+='<li class="page_btn"> <a href="#" class="pageAfter active" id="'+(i+2)+'" >下一页&gt;</a>&nbsp;&nbsp;</li>';
            }
            pageHtml +='<li class="info"> 共<a>'+pageNum+'</a>页， 到第  <input  style="width: 20px;background-color: #ffffff;" id="pageNext" name="pageNext" onkeyup="this.value=this.value.replace(/[^\\d]/g,\'\')" /> 页，';
            pageHtml +='  每页'+pageSize+'条<a href="#" class="sure" id="forSure"> 确定</a></li>';
            if(pageNo>pageNum){console.log('数字太大');}
            pageHtml +='</ul></span>';
            console.log(pageHtml);
            $(".page").append(pageHtml);

            $(".search_result").show();
            $(".main_visual").hide();
            $('.filterBtn').show();
            $(".case_col").hide();
        });
    }

    function dataName(objName,id){//跳转到查看页面
        var param = {'id':id};
        submitData("${ctx}/dc/dataSearch/retrieval/view",param,function(result){
        });
    }

    function  findData(searchTime,searchName,objType,searchLabel,searchType,searchCat,pageSize,pageNo){
        var param = {
            pageSize:pageSize,
            pageNo:pageNo,
            'searchName': searchName,		//检索名称
            'objType': objType,				//对象类型(表/字段/接口...)
            'searchType':searchType,		//业务分类
            'searchLabel':searchLabel,		//检索标签
            'searchTime':searchTime,			//检索时间
            'searchCat':searchCat           //业务分类层次
        };
        console.log(param);
        submitData("${ctx}/dc/dataSearch/retrieval/findData",param,function(result){
            var html = '';
            var data = result.body.searchMap.source;
            var pageNum = result.body.pageNum;

            if(pageNo <= 0){
                return false;
                console.log('出错了');
            }

            $(".result_con").empty();

            $(".search_result_txt").empty();
            $(".search_result_txt").append('共找到匹配记录'+result.body.count+'条' );

            $(".page").empty();
            var pageHtml ='<span ><ul>';
            if(pageNo == 1){
                pageHtml+='<li class="page_btn"><a href="#" class="pageBefore disabled" id="1" >&lt;上一页</a>&nbsp;&nbsp;</li>';
            }else{
                pageHtml+='<li class="page_btn"><a href="#" class="pageBefore active" id="'+i+'">&lt;上一页</a>&nbsp;&nbsp;</li>';

            }

            for(var i=0;i<pageNum;i++){
                var flag=true
                if((pageNo==1 && i==1)){
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum active" id="'+(i)+'" >'+(i)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+1)+'" >'+(i+1)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+2)+'" >'+(i+2)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+3)+'" >'+(i+3)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+4)+'" >'+(i+4)+'</a></li>';

                }else if((pageNo==2 && i==2)){
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-1)+'" >'+(i-1)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum active" id="'+(i)+'" >'+(i)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+1)+'" >'+(i+1)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+2)+'" >'+(i+2)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+3)+'" >'+(i+3)+'</a></li>';
                }else if((pageNo==3 && i==3)){
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-2)+'" >'+(i-2)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-1)+'" >'+(i-1)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum active" id="'+(i)+'" >'+(i)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+1)+'" >'+(i+1)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+2)+'" >'+(i+2)+'</a></li>';
                }else if((i) == pageNo && 3<pageNo && pageNo<(pageNum-1)){
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-2)+'" >'+(i-2)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-1)+'" >'+(i-1)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum active" id="'+(i)+'" >'+(i)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+1)+'" >'+(i+1)+'</a></li>';
                    pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i+2)+'" >'+(i+2)+'</a></li>';
                }
            }
            if(pageNo==(pageNum-1)){
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-4)+'" >'+(i-4)+'</a></li>';
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-3)+'" >'+(i-3)+'</a></li>';
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-2)+'" >'+(i-2)+'</a></li>';
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum active" id="'+(i-1)+'" >'+(i-1)+'</a></li>';
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i)+'" >'+(i)+'</a></li>';

            }
            if(pageNo==(pageNum) && pageNo>1){
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-4)+'" >'+(i-4)+'</a></li>';
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-3)+'" >'+(i-3)+'</a></li>';
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-2)+'" >'+(i-2)+'</a></li>';
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum " id="'+(i-1)+'" >'+(i-1)+'</a></li>';
                pageHtml +='<li class="page_btn"><a href="#" class="pageNum active" id="'+(i)+'" >'+(i)+'</a></li>';
            }
            if(pageNo==(pageNum+2)){
                pageHtml+='<li class="page_btn"> <a href="#" class="pageAfter disabled" id="'+(i+2)+'">下一页&gt;</a>&nbsp;&nbsp;</li>';
            }else{
                pageHtml+='<li class="page_btn"> <a href="#" class="pageAfter active" id="'+(i+2)+'" >下一页&gt;</a>&nbsp;&nbsp;</li>';
            }
            pageHtml +='<input type="hidden" class="current_page" id="'+pageNo+'"/>';
            pageHtml +='<li class="info"> 共<a>'+pageNum+'</a>页， 到第  <input  style="width: 20px;background-color: #ffffff;" id="pageNext" name="pageNext" /> 页，';
            pageHtml +='  每页'+pageSize+'条<a href="#" class="sure" id="forSure"> 确定</a></li>';

            pageHtml +='</ul></span>';

            $(".page").append(pageHtml);

            for(var i=0;i<data.length;i++){//与上面中间数据的显示一致
                var resultList = '';
                var objDesc = (data[i]['objDesc']) !=null ? data[i]['objDesc'] :"";
                resultList += '<dt class="result_item"><a target="_blank" href="${ctx}/dc/dataSearch/retrieval/view?id='+data[i]['id']+'">'+objDesc+'</a>&nbsp;&nbsp;&nbsp;&nbsp;</dt>';
                resultList += '<dd><p>对象名称：'+data[i]['objName']+'&nbsp;&nbsp;&nbsp;&nbsp;</p>';
                if(data[i]['updateDate']){
                    resultList += '<span>更新时间:'+data[i]['updateDate'].replace(/T/,' ').replace('.000Z','')+'</span></dd>';
                }else {
                    resultList += '<span>更新时间: </span></dd>';
                }
                html+= ''+resultList+'';
            }
            $(".result_con").append(html);
            $(".search_result").show();
            $(".case_col").hide();
        });
    }

    $(document).keydown(function(e){
        if(e.keyCode == 13) {//enter键等于搜索的按钮，触发搜索功能
            $("#searchbtn").click();
        }
    });

    function searchyy(id){//跳转到查看页面
        $("#searchTypeFirst").attr('value',id);
        $("#searchbtn").click();
    }

    //回车登录
</script>

</body>
</html>