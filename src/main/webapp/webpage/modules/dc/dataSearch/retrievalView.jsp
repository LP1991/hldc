<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<%@ include file="/webpage/include/echarts.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <link rel="shortcut icon" href="${ctxStatic}/common/img/favicon.ico">
    <title>${fns:getConfig('system.productName')}</title>
    <script src="${ctxStatic}/dc/js/jquery-2.1.1.min.js"></script>
    <link href="${ctxStatic}/common/hlframe.css" type="text/css" rel="stylesheet" />
    <script src="${ctxStatic}/common/hlframe.js" type="text/javascript"></script>
    <script src="${ctxStatic}/layer-v2.3/layer/laydate/laydate.js"></script>
    
    <link href="${ctxStatic}/dc/css/dc.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/dc/css/jiansuo.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/dc/css/global.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/dc/js/dataTables/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/dc/css/dc.dataTables.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/dc/js/awesome/4.7/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/bootstrap/3.3.4/css_default/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script src="${ctxStatic}/jquery/jquery-2.1.1.min.js" type="text/javascript"></script>
	<script src="${ctxStatic}/common/hlframe.js" type="text/javascript"></script>
	<script src="${ctxStatic}/layer-v2.3/layer/layer.js"></script>
	<script type="text/javascript">
		function Dowload(){
			$("#fileorzipdowload").submit();
		}
	</script>
</head>
<body>
<%@ include file="retrievalTop.jsp"%>
<input type="hidden" id="accid-1" value="${accre}"/>
<input type="hidden" id="accid-2" value="${dcObjectMain.accre}"/>
<div class="dc_wrap dc_detail">
	<input type="hidden" id="objId" value="${dcObjectMain.jobId}"/>
    <div class="dt_left ">
        <div class="left_title blue_theme">
            数据表详情
        </div>
      <!--  <div class="func_jia ">
           <div class="read">
               <i class="fa fa-envelope-open"></i>
               <span>读取<br/><label>1037次</label></span>
           </div>
           <div class="sc">
               <i class="fa fa-heart"></i>
               <span>收藏<br/><label>1037次</label></span>
           </div>
           <div class="ll">
                   <i class="fa fa-eye"></i>
                    <span>浏览<br/><label>1037次</label></span>
           </div>
           <div class="jl">
               <i class="fa fa-newspaper-o"></i>
               <span>记录<br/><label>1037次</label></span>
           </div>
        </div>-->
		<hr/>
        <ul class="left_ul">
            <li>产出任务:${dcObjectMain.objName}<!--<a class="viewtask" href="#">查看任务</a>--></li>
            <li class="qing">所属应用:${dcObjectMain.objName}</li>
			<li>所属部门:${dcObjectMain.office.name}</li>
            <li class="qing">负责人:${dcObjectMain.user.name}</li>
            <li>创建时间:<fmt:formatDate value="${dcObjectMain.createDate}" type="both" dateStyle="full"/></li>
            <li class="qing">描述:${dcObjectMain.objDesc}</li>
            <li>存储量:单元测试</li>
            <li class="qing">备注:${dcObjectMain.remarks}</li>
			<c:choose>
			<c:when test="${dcObjectMain.objType eq '文件'}">
            <li>文件名称:${dcObjectMain.objDesc}</li>
			</c:when>

			</c:choose>

            <!-- 添加检索标签 add by peijd -->
            <li>标签: 
				<div class="btn_d">
					<c:forEach items="${objLabelList}" var="lab">
						<span class="label label-info">${lab.labelName}</span>
					</c:forEach>
					<c:if test="${fns:getUser().name != null}">
					  <span id='btn_addLabel'> <a onclick="addObjLabel()" class="btn btn-info btn-xs" title="新增标签"> + </a> </span>
					</c:if>
				</div>
			</li>
        </ul>
    </div>
    <div class="dt_right">
        <div class="right_title ">
            <span class="right_title_txt">${dcObjectMain.objName}</span> &nbsp; &nbsp; &nbsp;
			<c:if test="${fns:getUser().name != null}">
				<a id="favoriteBtn" onclick="addFavorite()" class="btn btn-default btn-sm" title="添加至个人收藏目录"><i class="fa fa-star"></i><span> 收藏</span></a> &nbsp; &nbsp;
				<c:choose>
					<c:when test="${dcObjectMain.accre!=1}">
						<a onclick="getAu('${ctx}/dc/dataSearch/retrieval/getAu?id=${dcObjectMain.id} ','数据库链接的操作')" class="btn btn-default btn-sm"><i class="fa fa-key"></i><span>权限申请</span></a>
					</c:when>
					<c:when test="${dcObjectMain.objType eq '接口'}">
						<a  class="btn btn-default btn-sm"><i class="fa fa-key"></i><span>数据接口</span></a>

					</c:when>
					<c:when test="${dcObjectMain.objType eq '文件'}">
							<a onclick="Dowload()" class="btn btn-default btn-sm" title="文件下载"><i class="fa fa-key"></i><span> 文件下载</span></a>
						</c:when>
						<c:when test="${dcObjectMain.objType eq '文件夹'}">
							<a onclick="Dowload()" class="btn btn-default btn-sm" title="目录打包"><i class="fa fa-key"></i><span> 目录打包</span></a>
						</c:when>
					
						
						<c:otherwise>
						<a onclick="Dowload()" class="btn btn-default btn-sm" title="文件下载"><i class="fa fa-key"></i><span> 文件下载</span></a>
						</c:otherwise>
					
					</c:choose>

			   </c:if>
						<form id="fileorzipdowload" style="display: none" method="post" target="" action="${ctx}/dc/dataSearch/retrieval/exportFileOrZip">
							<input type="hidden" name="objType" value="${dcObjectMain.objType}" />
							<input type="hidden" name="id" value="${dcObjectMain.id}" />
						</form>
					
		
        <!--    <span class="sma_item"> <i class="fa fa-star"></i><span class="right_small_txt">收藏</span></span>
            <span class="sma_item"> <i class="fa fa-edit"></i><span class="right_small_txt">求解释</span></span>
            <span class="sma_item"> <i class="fa fa-key"></i><span class="right_small_txt">权限申请</span></span>-->
        </div>
        <div>
            <div class="right_tab tab">
                <span class="active">明细信息</span>
                <span>血缘信息</span>
             <!--   <span>相关问答</span>
                <span>使用记录</span>
                <span>帮助手册</span>-->
            </div>
            <div class="tab_content">
                <div class=" active">
                    <ul class="down_tab setab">
						<c:choose>
						<c:when test="${dcObjectMain.objType eq '接口'}">
                       <li class="no">
                            <h2>字段信息</h2>
					   </li>
						</c:when>
						<c:when test="${dcObjectMain.objType eq '数据表'}">
                          <li calss="no">
                            <h2>数据预览</h2>
						  </li>
						</c:when>
							<c:when test="${dcObjectMain.objType eq '文件'}">
								<li  class="no">
									<h2>文件信息详情</h2>
								</li>
							</c:when>
						<c:when test="${dcObjectMain.objType eq '文件夹'}">
							<li  class="no">
								<h2>文件夹信息详情</h2>
							</li>
						</c:when>
						</c:choose>


                   <!--     <li >
                            <h2>产出信息</h2>
                        </li>
                        <li class="">
                            <h2>变更记录</h2>
                        </li>-->
                    </ul>

                    <div class="down_tab_content">
                        <div class=" active">
                             <table id="previewTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;width:800px;">
		   <thead>
			<tr>
				<c:forEach items="${dcObjectFeildList}" var="index" varStatus="status">
				<c:if test="${status.index=='0'}" >
				<c:forEach items="${index}" var="ina" >
					<th style="text-align:center; ">${ina.key}</th>
				</c:forEach>
				 </c:if>					
				</c:forEach>
			</tr> 
		  </thead>
         	<c:forEach items="${dcObjectFeildList}" var="index">
		    <tr>	
			   <c:forEach items="${index}" var="inx">
			   <td style="text-align:center">${inx.value}</td>
			    </c:forEach>
			</tr>
			 </c:forEach>			  
	   </table>
                        </div>
                        <div class="active">
                             <table id="previewTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;width:800px;">
								<c:choose>
								   <c:when test="${columnList==null || fn:length(columnList)==0}">
								   </c:when>
								   <c:otherwise>
									   <thead>
										<tr>
											<c:forEach items="${columnList}" var="index" varStatus="status">
											<c:if test="${status.index=='0'}" >
											<c:forEach items="${index}" var="ina" >
												<th style="text-align:center; ">${ina.key}</th>
											</c:forEach>
											 </c:if>
											</c:forEach>
										</tr>
										</thead>
										<c:forEach items="${columnList}" var="index">
										<tr>
										   <c:forEach items="${index}" var="inx">
										   <td style="text-align:center">${inx.value}</td>
											</c:forEach>
										</tr>
										 </c:forEach>
									</c:otherwise>
								</c:choose>
						   </table>
						</div>
                        <div class="active">
							<table id="previewTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;width:800px;">
							<textarea id="hdfsFile_content" title="文件内容" class="form-control span12" style="height: 680px;width:800px;" disabled="disabled">${hdfsFile.content }</textarea>
							</table>
						</div>
						<div class="active">
							<table id="previewTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;width:800px;">
						    <tr>
							<th>文件名</th>
							<th>文件大小</th>
							<th>用户</th>
							<th>部门</th>
							<th>权限</th>
							<th>创建日期</th>
						    </tr>
								<c:forEach items="${list}" var="dcHdfsFileLook">
								<tr>
									<td>${dcHdfsFileLook.folderName}</td>
									<td>${dcHdfsFileLook.size}</td>
									<td>${dcHdfsFileLook.owner}</td>
									<td>${dcHdfsFileLook.group}</td>
									<td>${dcHdfsFileLook.permissions}</td>
									<td>${dcHdfsFileLook.dateT}</td>
								</tr>
							</c:forEach>
							</table>
						</div>
						</div>
				</div>
                <div>
                <div>
                <br>
                <img src="${ctxStatic}/dc/bloodImg/tar.png" height="30px"/>
                <img src="${ctxStatic}/dc/bloodImg/source.png" height="30px"/>
                <img src="${ctxStatic}/dc/bloodImg/process.png" height="30px"/></div>
                <div id="container" style="background: #5C98D9;width: 750px;height: 600px;">
                </div>
                </div>
                <div class="">
                    2
                </div>
                <div class="">
                    3
                </div>
                <div class="">
                    4
                </div>
            </div>

        </div>
    </div>

	</div>
</div>

<script src="${ctxStatic}/dc/js/jquery-2.1.1.min.js"></script>
<script src="${ctxStatic}/dc/js/cs.js"></script>

<script src="${ctxStatic}/dc/js/detail.js"></script>
<script src="${ctxStatic}/dc/js/dataTables/jquery.dataTables.js"></script>



<script type="text/javascript">
var dom = document.getElementById("container");
var myChart = echarts.init(dom);
var app = {};
option = null;
option = {
    title: {
    },
    tooltip: {
    	formatter:'{c}'
    },
    animationDurationUpdate: 1500,
    animationEasingUpdate: 'quinticInOut',
    series : [
        {
            type: 'graph',
            layout: 'force',
            symbolSize: 40,
            roam: true,
            draggable:true,
            force: {
                repulsion:1500
            },
            label: {
                normal: {
                    show: true,
                    position:['0%',60],
                    textStyle:{
                    color:'#000000'
                    },
                },
            },
            edgeSymbol: ['circle', 'arrow'],
            edgeSymbolSize: [4, 10],
            edgeLabel: {
                normal: {
                    textStyle: {
                        fontSize: 20
                    }
                }
            },
        	${graphData},
            lineStyle: {
                normal: {
                    opacity: 0.9,
                    width :2,
                    curveness: 0
                }
            }
        }
    ]
};
if (option && typeof option === "object") {
    myChart.setOption(option, true);
}
myChart.on('dblclick', function (params) {
    // 控制台打印数据的名称
    if("process" == params.data.label){
    	openDialogView('转换过程', '${ctx}/dc/dataSearch/retrieval/getSQL?id='+params.data.id,'800px', '400px');
    }
});
//权限申请
function getAu(url,title,flag){
	confirmx('确认要申请该'+title+'的权限吗？', function(){
		submitData(url,{},function(data){
			var icon_number;
			if(!data.success){
				icon_number = 8;
			}else{
				icon_number = 1;
			}
			top.layer.alert(data.msg, {icon: icon_number, title:'提示'});
			// 刷新表格数据，分页信息不会重置
			if (typeof(table) != "undefined") { 
				table.ajax.reload( null, false ); 
			}
			if(flag){
				refreshAllTree();
			}
		});
	})
}

//添加收藏夹
function addFavorite(){
    $.ajax({ url: '${ctx}/dc/objCollect/dcObjCollect/ajaxSaveObjCollect', context: document.getElementById('addFavorite'),dataType:'json',
        data:{
            objId:$('#objId').val()
        },
        success: function(data){
            $('#favoriteBtn').addClass('disabled');
            console.log($(this).innerHTML);
            $('#favoriteBtn').children('span')[0].innerHTML = '已收藏';
        },error:function(data){
            layer.alert(data.msg, {icon: 8, title:'系统提示'});
        }
    });
}
	//添加对象标签  add by peijd
	function addObjLabel(){	
		layer.prompt({
            formType: 3,
            value: '',
            title: '添加标签'
        }, function(value, index, elem){
			if(value){
				//保存标签
				submitData('${ctx}/dc/dataSearch/dcSearchLabel/ajaxSaveLabelRef', {
					'objId': $('#objId').val(),
					'labelName':value
				}, function (data) {
					
					if(data.success){	//保存成功
						layer.close(index);
						$('#btn_addLabel').before('<span class="label label-info">'+value+'</span> ');				 
						//$('<span class="label label-info">'+value+'</span>').after($('#btn_addLabel'));	
					}else{
						layer.alert(data.msg, {icon: 8, title:'系统提示'});
						return false;
					}
				});
			}else{
				return false;
			}
        });
	}

$(function() {
    debugger
    $.ajax({ url: '${ctx}/dc/objCollect/dcObjCollect/ajaxIsFavorite', context: document.getElementById('addFavorite'),dataType:'json',
        data:{
            objId:$('#objId').val()
        },
        success: function(data){
            if(data.success == true){
                $('#favoriteBtn').children('span')[0].innerHTML = '已收藏';
                $('#favoriteBtn').addClass('disabled');
            }
        }
    });
});
       </script>
</body>
</html>