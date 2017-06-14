/*!
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 * 
 * 通用公共方法
 * @author hlframe
 * @version 2014-4-29
 */
$(document).ready(function() {
	try{
		// 链接去掉虚框
		$("a").bind("focus",function() {
			if(this.blur) {this.blur()};
		});
		//所有下拉框使用select2
		$("select").select2();
	}catch(e){
		// blank
	}
	/**全局设置效验
	 * @author fzg
	 * @time 2017-4-20 09:38:29
	 * @detail 所有form表单中的input设置空格校验，禁止填入空格
	 * @change 对应class类名验证input，.f_加上对应的类型
	 * 这样写显示会有问题，因为与validate插件冲突，如果页面有引用validate，应在该插件基础上增加自定义验证规则
	 * 已经写在函数中，没有调用
	*/
	function f_label(d){//判断input同级节点是否存在label
		return ($(d).siblings().map(function(item){
			if($(d).siblings().eq(item)[0].tagName=='LABEL'){
				//$(d).siblings().eq(item).show().text(txt);
				index = item;
				return true;
			}
		}))
	}
	function tipError(d,name,txt){
		var index;
		if( !$(d).hasClass(name)) {
			$(d).addClass(name);
		}

		if( $(d).siblings().length>0 && f_label(d).length>0){
//			$(d).siblings().show();
			$(d).siblings().eq(index).show().text(txt);
/*			if($(d).siblings()[0].tagName === 'LABEL'){
				$(d).siblings()[0].innerText = txt;
			}*/
		}else{
			$(d).parent().append('<label class="tipLabel" style="color:red;">'+txt+'</label>');
			$(d).focus();
		}	
	}
function key_b(){
	$('form input').on('keydown',function(){
		var index;
		var event = event||window.event;
		if($(event.target).siblings().length>0 && f_label(event.target).length>0){
			$(d).siblings().eq(index).hide();
		}
	})
	$('form input').on('blur',function(){
		var event = event||window.event;
		var inp_value = $(event.target).val();
		//判断是否存在类名
		var f_class = $(event.target).attr('class').toString();
		event.target.value=event.target.value.replace(/\s+/g,'');
		if(f_class.indexOf('f_length')!==-1){//字段长度验证
			
		}
		if(f_class.indexOf('f_password')!==-1){
			//判断是否是纯数字
			if(!/^[0-9a-zA-Z_#]{6,16}$/.test(inp_value)){
				tipError(event.target,'error','请输入6-16位密码');
				return;
			}
		}
		if(f_class.indexOf('f_number')!==-1){
			//判断是否是纯数字
			if(!isNaN(inp_value)){//inNaN,可以用来判断数字
				return;
			}
			tipError(event.target,'error','请输入数字')
		}
		if(f_class.indexOf('f_tel')!==-1){
			if((/^1[34578]\d{9}$/.test(inp_value)) || /^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$/.test(inp_value)){
				return;
			}
			if(!(/^1[34578]\d{9}$/.test(inp_value))){   
		        tipError(event.target,'error','请输入格式正确的号码');
		        return; 
		    } 
			if(!/^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$/.test(inp_value)){
				tipError(event.target,'error','请输入格式正确的号码');
				return;
			}
		}
		if(f_class.indexOf('f_Chinese')!==-1){
			if(!/^[u4e00-u9fa5],{0,}$/.test(inp_value)){
				tipError(event.target,'error','请输入中文');
				return;
			}
		}
		if(f_class.indexOf('f_English')!==-1){
			if(!/^[A-Za-z]+$,{0,}$/.test(inp_value)){
				tipError(event.target,'error','请输入英文');
				return;
			}
		}
		if(f_class.indexOf('f_maxLength')!==-1){
			if(!(/^[\u4e00-\u9fa5]{1,7}$|^[\dA-Za-z_]{1,14}$/.test(inp_value))){
				tipError(event.target,'error','最长不得超过7个汉字，或14个字节(数字，字母和下划线)');
				return;
			}
		}
	});	
}	

});

// 引入js和css文件
function include(id, path, file){
	if (document.getElementById(id)==null){
        var files = typeof file == "string" ? [file] : file;
        for (var i = 0; i < files.length; i++){
            var name = files[i].replace(/^\s|\s$/g, "");
            var att = name.split('.');
            var ext = att[att.length - 1].toLowerCase();
            var isCSS = ext == "css";
            var tag = isCSS ? "link" : "script";
            var attr = isCSS ? " type='text/css' rel='stylesheet' " : " type='text/javascript' ";
            var link = (isCSS ? "href" : "src") + "='" + path + name + "'";
            document.write("<" + tag + (i==0?" id="+id:"") + attr + link + "></" + tag + ">");
        }
	}
}

// 获取URL地址参数
function getQueryString(name, url) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    if (!url || url == ""){
	    url = window.location.search;
    }else{	
    	url = url.substring(url.indexOf("?"));
    }
    r = url.substr(1).match(reg)
    if (r != null) return unescape(r[2]); return null;
}

//获取字典标签
function getDictLabel(data, value, defaultValue){
	for (var i=0; i<data.length; i++){
		var row = data[i];
		if (row.value == value){
			return row.label;
		}
	}
	return defaultValue;
}

// 打开一个窗体   -- peijd 设置窗口默认宽高
function windowOpen(url, name, width, height){
	width = width?width:800;
	height = height?height:500;
	var top=parseInt((window.screen.height-height)/2,10),left=parseInt((window.screen.width-width)/2,10),
		options="location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,"+
		"resizable=yes,scrollbars=yes,"+"width="+width+",height="+height+",top="+top+",left="+left;
	window.open(url ,name , options);
}

// 恢复提示框显示
function resetTip(){
	top.$.jBox.tip.mess = null;
}

// 关闭提示框
function closeTip(){
	top.$.jBox.closeTip();
}

//显示提示框
function showTip(mess, type, timeout, lazytime){
	resetTip();
	setTimeout(function(){
		top.$.jBox.tip(mess, (type == undefined || type == '' ? 'info' : type), {opacity:0, 
			timeout:  timeout == undefined ? 2000 : timeout});
	}, lazytime == undefined ? 500 : lazytime);
}

// 显示加载框
function loading(mess){
	if (mess == undefined || mess == ""){
		mess = "正在提交，请稍等...";
	}
	resetTip();
	top.$.jBox.tip(mess,'loading',{opacity:0});
}

// 警告对话框
function alertx(mess, closed){
	top.$.jBox.info(mess, '提示', {closed:function(){
		if (typeof closed == 'function') {
			closed();
		}
	}});
	top.$('.jbox-body .jbox-icon').css('top','55px');
}

// 确认对话框
function confirmx(mess, href, closed){
	top.layer.confirm(mess, {icon: 3, title:'系统提示'}, function(index){
		if (typeof href == 'function') {
			href();
		}else{
			resetTip(); //loading();
			location = href;
		}
	    top.layer.close(index);
	});
	
//	top.$.jBox.confirm(mess,'系统提示',function(v,h,f){
//		if(v=='ok'){
//			if (typeof href == 'function') {
//				href();
//			}else{
//				resetTip(); //loading();
//				location = href;
//			}
//		}
//	},{buttonsFocus:1, closed:function(){
//		if (typeof closed == 'function') {
//			closed();
//		}
//	}});
//	top.$('.jbox-body .jbox-icon').css('top','55px');
	return false;
}

// 提示输入对话框
/**
function promptx(title, lable, href, closed){
	top.$.jBox("<div class='form-search' style='padding:20px;text-align:center;'>" + lable + "：<input type='text' id='txt' name='txt'/></div>", {
			title: title, submit: function (v, h, f){
	    if (f.txt == '') {
	        top.$.jBox.tip("请输入" + lable + "。", 'error');
	        return false;
	    }
		if (typeof href == 'function') {
			href();
		}else{
			resetTip(); //loading();
			location = href + encodeURIComponent(f.txt);
		}
	},closed:function(){
		if (typeof closed == 'function') {
			closed();
		}
	}});
	return false;
}**/
function promptx(title,  href){
	 var index = top.layer.prompt({title: title, formType: 2}, function(text){
		 if (typeof href == 'function') {
				href();
			}else{
				resetTip(); //loading();
				location = href + encodeURIComponent(text);
			}
		 
		 top.layer.close(index);
		  });
	return false;
}

/**
 * alert("提示的内容，可以是html片段", "我是标题", function() {
 *     // TODO
 * });
 */
// 设定window.baseAlert为原始的alert
window.baseAlert = window.alert;
/**
 * 重写alert
 * @param	{String}	消息内容
 * @param	{Function}	确定按钮回调函数
 */
window.alert = function(content, callback) {
	alertx(content, callback);
};

// 添加TAB页面
function addTabPage(title, url, closeable, $this, refresh){
	top.$.fn.jerichoTab.addTab({
        tabFirer: $this,
        title: title,
        closeable: closeable == undefined,
        data: {
            dataType: 'iframe',
            dataLink: url
        }
    }).loadData(refresh != undefined);
}

// cookie操作
function cookie(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        var path = options.path ? '; path=' + options.path : '';
        var domain = options.domain ? '; domain=' + options.domain : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
}

// 数值前补零
function pad(num, n) {
    var len = num.toString().length;
    while(len < n) {
        num = "0" + num;
        len++;
    }
    return num;
}

// 转换为日期
function strToDate(date){
	return new Date(date.replace(/-/g,"/"));
}

// 日期加减
function addDate(date, dadd){  
	date = date.valueOf();
	date = date + dadd * 24 * 60 * 60 * 1000;
	return new Date(date);  
}

//截取字符串，区别汉字和英文
function abbr(name, maxLength){  
 if(!maxLength){  
     maxLength = 20;  
 }  
 if(name==null||name.length<1){  
     return "";  
 }  
 var w = 0;//字符串长度，一个汉字长度为2   
 var s = 0;//汉字个数   
 var p = false;//判断字符串当前循环的前一个字符是否为汉字   
 var b = false;//判断字符串当前循环的字符是否为汉字   
 var nameSub;  
 for (var i=0; i<name.length; i++) {  
    if(i>1 && b==false){  
         p = false;  
    }  
    if(i>1 && b==true){  
         p = true;  
    }  
    var c = name.charCodeAt(i);  
    //单字节加1   
    if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {  
         w++;  
         b = false;  
    }else {  
         w+=2;  
         s++;  
         b = true;  
    }  
    if(w>maxLength && i<=name.length-1){  
         if(b==true && p==true){  
             nameSub = name.substring(0,i-2)+"...";  
         }  
         if(b==false && p==false){  
             nameSub = name.substring(0,i-3)+"...";  
         }  
         if(b==true && p==false){  
             nameSub = name.substring(0,i-2)+"...";  
         }  
         if(p==true){  
             nameSub = name.substring(0,i-2)+"...";  
         }  
         break;  
    }  
 }  
 if(w<=maxLength){  
     return name;  
 }  
 return nameSub;  
}


//打开对话框(添加修改)
function openDialog(title,url,width,height,target,o){
	if(navigator.userAgent.match(/(iPone|iPod|Android|iso)/i)) { // 如果是移动端，就使用自适应大小弹窗
		width='auto';
		height='auto';
	} else { // 如果是PC端，根据用户设置的width和height显示
		if (width && $(top.window).width() < width.replace('px', '')) {
			width = ($(top.window).width() - 20) + 'px';
		}
		if (height && $(top.window).height() < height.replace('px', '')) {
			height = ($(top.window).height() - 20) + 'px';
		}
	}
	var option ={
			type : 2,
			area : [ width, height ],
			title : title,
			maxmin : true, // 开启最大化最小化按钮
			content : url,
			btn : ['确定','关闭'],
			yes : function(index, layero) {
				var body = top.layer.getChildFrame('body', index);
				var iframeWin = layero.find('iframe')[0]; // 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
				var inputForm = body.find('#inputForm');
				var top_iframe;
				if (target) {
					top_iframe = target;// 如果指定了iframe，则在改frame中跳转
				} else {
					top_iframe = top.getActiveTab().attr("name");// 获取当前active的tab的iframe
				}
				inputForm.attr("target", top_iframe);// 表单提交成功后，从服务器返回的url在当前tab中展示
				
				var method={};
				if (typeof(refreshTree) != "undefined") { 
					method.refreshTree=refreshTree;
				}
				if (typeof(refreshAllTree) != "undefined") { 
					method.refreshAllTree=refreshAllTree;
				}
				/*if( typeof window.parent.refreshTree === 'function' ){
					window.parent.refreshTree();
				}*/
				if (typeof(table) == "undefined") { 					
					if (iframeWin.contentWindow.doSubmit(index,method)){
						//刷新树1						
						console.log('dosubmit执行完毕');
						if( typeof window.parent.refreshTree === 'function'){
							window.parent.refreshTree();
						}
						setTimeout(function() {
							//新版改造  放入form中关闭
							console.log('开始关闭弹出框');
							top.layer.close(index);
						}, 100);// 延时0.1秒，对应360 7.1版本bug
					}
				} else{
					//top.layer.closeAll('loading');
					//调用子页面的方法
					if(typeof(iframeWin.contentWindow.getDataFromCatalog) == 'function'){
						if(iframeWin.contentWindow.getDataFromCatalog(index,table)){
							if( typeof window.parent.refreshTree === 'function' ){
								window.parent.refreshTree();
							}
							setTimeout(function() {
								//新版改造  放入form中关闭
								top.layer.close(index)
							}, 100);// 延时0.1秒，对应360 7.1版本bug
						}else{
							//return;
						}
					}
					
					if ($('#fparent_id').size()>0) { //为iframe服务
						if(iframeWin.contentWindow.setPId&&typeof(iframeWin.contentWindow.setPId)=="function")
						iframeWin.contentWindow.setPId($('#fparent_id').val());
					}
					
					if(iframeWin.contentWindow.doSubmit&&typeof(iframeWin.contentWindow.doSubmit)=="function"){
						if (iframeWin.contentWindow.doSubmit(index,table,method)){
							if( typeof window.parent.refreshTree === 'function' ){
								window.parent.refreshTree();
							}
							setTimeout(function() {
								//新版改造  放入form中关闭	
								table.ajax.reload();
								top.layer.close(index)
							}, 100);// 延时0.1秒，对应360 7.1版本bug
						}
					}
					//top.layer.close(index);
				} 
				
			},
			success: function(layero, index){//有些地方的success失效
				//console.log('success执行');
				top.layer.closeAll('loading');
			},
			cancel : function(index) {
				
			}			
		};
	option = $.extend({}, option, o);
	top.layer.open(option);
	/*
	 * 由于此处无法触发success回调，故设置自动关闭
	 * */
	setTimeout(function(){
		if(title=='处理过程'){//
			$('.layui-layer-btn0',parent.document).hide()
		}else{
			//$('.layui-layer-btn0').show();
		}
	})

	top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>',time:2*800});

}

// 打开对话框(查看)
function openDialogView(title,url,width,height,o){
	if(navigator.userAgent.match(/(iPone|iPod|Android|iso)/i)) { // 如果是移动端，就使用自适应大小弹窗
		width='auto';
		height='auto';
	} else { // 如果是PC端，根据用户设置的width和height显示
		if (width && $(top.window).width() < width.replace('px', '')) {
			width = ($(top.window).width() - 20) + 'px';
		}
		if (height && $(top.window).height() < height.replace('px', '')) {
			height = ($(top.window).height() - 20) + 'px';
		}
	}
	
	var option={
		type : 2,
		area : [ width, height ],
		title : title,
		maxmin : true, // 开启最大化最小化按钮
		content : url,
		btn : [ '关闭' ],
		success: function(layero, index){
			top.layer.closeAll('loading');
		},
		cancel : function(index) {
			
		}
	};

	option = $.extend({}, option, o);
	
	top.layer.open(option);
	/*增加一个加载层
	 * 由于此处无法触发success回调，故设置自动关闭
	 * */
	top.layer.load(1,{content:'<p class="loading_style">加载中，请稍候。</p>',time: 2*800});
}

function search(){//查询，页码清零
	$("#pageNo").val(0);
	$("#searchForm").submit();
		return false;
}

function searchA(url){//查询，页码清零
	if(url!=undefined){
		table.ajax.url(url).load();
	}else{
		table.ajax.reload();//null, false
	}
}

function deleteA(url,title,flag){//查询，页码清零
	confirmx('确认要删除该'+title+'吗？', function(){
        top.layer.load(1,{content:'<p class="loading_style">删除中，请等待。</p>'});
		submitData(url,{},function(data){
            top.layer.closeAll('loading');
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
			if(flag){
				refreshAllTree();
			}
		});
	})
}
function refreshAll(){
	// 刷新表格数据，分页信息不会重置
	if (typeof(table) != "undefined") { 
		table.ajax.reload( null, false ); 
	}
	//刷新树
	refreshAllTree();
}
function refreshAllTree(){
	//刷新树
	if( typeof window.parent.refreshTree === 'function' ){
		window.parent.refreshTree();
	}else if(typeof refreshTree === 'function'){
		refreshTree();
	}
}
function reset(){//重置，页码清零
	$("#pageNo").val(0);
	$("#searchForm div.form-group input").val("");
	$("#searchForm div.form-group select").val("");
	$("#searchForm").submit();
		return false;
	 }
function sortOrRefresh(){//刷新或者排序，页码不清零
	
	$("#searchForm").submit();
		return false;
}
function page(n,s){//翻页
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").submit();
	$("span.page-size").text(s);
	return false;
}

//提交ajax请求到服务端
function submitData(url,param,successFunc,errorFunc,type,dataType,async){
	type = isBlank(type) ? 'post' : type;
	dataType = isBlank(dataType) ? 'json' : dataType;
	param = isBlank(param) ? '' : param;
	async = async == false?false:true;
	$.ajax({
		async:async,//默认为true，即为异步请求
		type:type,//post or get
		url:url,//***.action/method=**
		dataType:dataType,
		data:param,
		success:function(data){
			if(!isBlank(successFunc) && typeof successFunc == 'function'){
				successFunc.call(this,data);
			}
		},
		error:function(data){
			if(!isBlank(errorFunc) && typeof errorFunc == 'function'){
				errorFunc.call(this,data);
			}
		}
	});
}

//获取ajax请求数据,同步获取即时数据  peijd
function getDataFromAjax(url, param, dataType){
	var result;
	dataType = dataType || 'json';
	param = '' ||  param;
//	async = async == false?false:true;
	$.ajax({
		async:false,//默认为true，即为异步请求
		type:'post',//post or get
		url:url,//***.action/method=**
		dataType:dataType,
		data:param,
		success:function(data){
			result = data;
		},
		error:function(data){
			result = data.responseText;
		}
	});
	
	return result;
}

//判断数据是否为空
function isBlank(value){
	return undefined == value || null == value || "" == value;
}

//查询数据arr中是否存在str
function chachong(arr,str){
	var flag=false;
	if($.trim(str)==''){
		return true;
	}
	for(idx in arr){
		if(arr[idx].name==str){
			flag=true;
			break;
		}
	}
	return flag;
}
/*获取表单中需要提交的内容*/
function  getFormParams(fm,fix){
	//不存在表单返回空对象
	if($('#'+fm).length==0){
		return {};
	}
	var params = $("#"+fm+" input[type!='radio'][type!='checkbox'],#"+fm+" textarea,#"+fm+" select,#"+fm+" input[type='radio']:checked");
	//不存在提交元素返回空对象
	if(params.length==0){
		return {};
	}
	var jsonParamStr = "{";
	params.each(function(i){
		jsonParamStr+='"'+this.name+'":"'+this.value+'",';
	});
	//,#"+fm+" input[type='checkbox']:checked  特殊处理checked
	var obj={};
	$("#"+fm+" input[type='checkbox']:checked").each(function(i){
		//jsonParamStr+='"'+this.name+'":"'+this.value+'",';
		//var a=chachong(checks,this.name);
		if(obj[this.name]!=undefined){//存在
			obj[this.name]+=','+this.value;
		}else{
			obj[this.name]=[this.value];
		}
	});
	//var str='';
	for(idx in obj){
		jsonParamStr+='"'+idx+'":"'+obj[idx]+'",';
	}
	var a=$('input[type=checkbox]:checked').map(function(){return this.value}).get().join(',');
	jsonParamStr = jsonParamStr.substring(0, jsonParamStr.length-1)+"}";
	return $.parseJSON(jsonParamStr);
}
function  getFormParamsSim(fm){
	var params = $("#"+fm+" input[type!='radio'][type!='checkbox'],#"+fm+" textarea,#"+fm+" select,#"+fm+" input[type='radio']:checked");
	return params.serialize();
}
function  getFormParamsObj(fm,fix){
	var params = $("#"+fm+" input");
	var obj= new Object;
	var jsonParamStr = "{";
	params.each(function(i){
		
		obj[this.name]=this.value;
		
	});
	return obj;
}

/*常量*/
var CONSTANT = {
	DATA_TABLES : {
		DEFAULT_OPTION : { //DataTables初始化选项
			language : {
				"sProcessing" : "处理中...",
				"sLengthMenu" : "每页 _MENU_ 项",
				"sZeroRecords" : "没有匹配结果",
				"sInfo" : "当前显示第 _START_ 至 _END_ 项，共 _TOTAL_ 项。",
				"sInfoEmpty" : "当前显示第 0 至 0 项，共 0 项",
				"sInfoFiltered" : "(由 _MAX_ 项结果过滤)",
				"sInfoPostFix" : "",
				"sSearch" : "搜索:",
				"sUrl" : "",
				"sEmptyTable" : "表中数据为空",
				"sLoadingRecords" : "载入中...",
				"sInfoThousands" : ",",
				"oPaginate" : {
					"sFirst" : "首页",
					"sPrevious" : "上页",
					"sNext" : "下页",
					"sLast" : "末页",
					"sJump" : "跳转"
				},
				"oAria" : {
					"sSortAscending" : ": 以升序排列此列",
					"sSortDescending" : ": 以降序排列此列"
				}
			},
			autoWidth : false, //禁用自动调整列宽
			stripeClasses : ["odd", "even"], //为奇偶行加上样式，兼容不支持CSS伪类的场合
			order : [], //取消默认排序查询,否则复选框一列会出现小箭头
			processing : false, //隐藏加载提示,自行处理
			serverSide : true, //启用服务器端分页
			searching : false //禁用原生搜索
		},
		COLUMN : {
			CHECKBOX : { //复选框单元格
				className : "td-checkbox",
				orderable : false,
				width : "30px",
				data : null,
				render : function (data, type, row, meta) {
					return '<input type="checkbox" class="i-checks" id="'+row.id+'">';
				}
			}
		},
		RENDER : { //常用render可以抽取出来，如日期时间、头像等
			ELLIPSIS : function (data, type, row, meta) {
				data = data || "";
				return '<span title="' + data + '">' + data + '</span>';
			}
		}
	}
};


function nofind(src){ 
	var img=event.srcElement; 
	img.src=src; 
	img.onerror=null; //控制不要一直跳动 
}

/**
 * 加载提示信息框
 * @param msg 提示信息
 * add by peijd 2017-5-8
 */
function loadMsg(msg) {
    if (msg == undefined || msg == ""){
        msg = "正在提交，请稍等...";
    }
    top.layer.load(1,{content:'<p class="loading_style">'+msg+'</p>'});
}

/**
 * 关闭提示信息框
 * add by peijd 2017-5-8
 */
function closeLoadMsg() {
    top.layer.closeAll('loading');
}