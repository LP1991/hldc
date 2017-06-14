 $(document).ready(function(){
		 tick();
	 $(".search_result").hide();
		$("#searchbtn").click(function(){
		   var param = {'name':$("#name").val(),
				        pageSize:20,
		                pageNum:1
				   
		   };
		   submitData("${ctx}/dc/dataSearch/retrieval/findData",param,function(result){   
				 var html = '';
				 var data = result.body;
				 $(".result_con").empty();
				 $(".search_result_txt").empty();
			     $(".search_result_txt").append('共找到匹配记录'+data.searchList.length+'条' );
				 $("#pageSize").val(result.body.pageSize);
				 $("#pageNum").text(result.body.pageNum);
				 $(".pageNum").text(result.body.pageNum);
				 $("#pageNext").val(result.body.pageNum);
				 for(var i=0;i<data.searchList.length;i++){
					  html+= '<div class="result_item"><div class="item_txt"><a href="#" id="objName" onclick="dataName(\''+data.searchList[i].对象名称+'\')">'+data.searchList[i].对象名称
					  +'</a></div><div class="item_txt">描述：'+data.searchList[i].对象描述+
					  '</div><div class="item_txt">类型：Mysql'+'</div><div class="item_txt">所属应用：'+data.searchList[i].对象编码+'</div><div height="100"></div></div>';
				 }
				 $(".result_con").append(html);
				 $(".search_result").show();
				 $(".case_col").hide();
			});
		});
	});
 
	function dataName(objName){
	  debugger;
	    var param = {'name':objName};
		submitData("${ctx}/dc/dataSearch/retrieval/view",param,function(result){
			var data = result.body.dataSearch;
			var objName = data.objName;
			var objCode = data.objCode;
			var objDesc = data.objDesc;
			var ManagerPer = data.managerPer;
			   if(result.success == true){
				   location.href= "hldc/webapp/modules/dc/dataSearch/retrievalView.jsp?dataSearch.objName="+objName+"&dataSearch.objCode="+objCode+"&dataSearch.objDesc="+objDesc+"&dataSearch.managerPer="+managerPer;
			              }
		});
	}
	

	function showLocale(objD)
	{
	  var hh = objD.getHours();
	   if(hh<10) hh = '0' + hh;
	  var mm = objD.getMinutes();
	   if(mm<10) mm = '0' + mm;
	  var ss = objD.getSeconds();
	   if(ss<10) ss = '0' + ss;
		   return str =  hh + ":" + mm + ":" + ss ;     
	}
	function tick()
	{
	  var today = new Date();
	  document.getElementById("time").innerHTML = showLocale(today);
	  window.setTimeout("tick()", 1000);
	}