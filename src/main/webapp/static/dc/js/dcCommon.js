
//打开iframe model窗口 
function openFrameModel(title, url, width, height) {
	if(navigator.userAgent.match(/(iPone|iPod|Android|iso)/i)) { // 如果是移动端，就使用自适应大小弹窗
		width='auto';
		height='auto';
	} else { // 如果是PC端，根据用户设置的width和height显示
		if (width && $(top.window).width() < width.replace('px', '')) {
			width = ($(top.window).width() - 20) + 'px';
		}else{
			//width = (width.replace('px', '')/$(top.window).width())*100+'%';
		}
		if (height && $(top.window).height() < height.replace('px', '')) {
			height = ($(top.window).height() - 20) + 'px';
		}else{
			//height = (height.replace('px', '')/$(top.window).height())*100+'%';
		}
	}

	//打开目标窗口
	top.layer.open({
		type : 2,
		title : title,
		//title: '你好，layer。',
		shade: 0.6, //遮罩透明度
		maxmin: true, //允许全屏最小化
		anim: 1, //0-6的动画形式，-1不开启
		//shadeClose : true,
		//shade : false,
		//maxmin : true, //开启最大化最小化按钮
		area : [ width, height ],
		content : url,
		success : function(layero, index) {	//将index传递给目标窗口, 不然没法关闭, 目标页面需实现 function setPIndexId 设置隐藏字段'cur_indexId'
			
			top.layer.closeAll('loading');
			
			var iframeWin = layero.find('iframe')[0]; // 得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
			//debugger;
			iframeWin.contentWindow.layer.closeAll('loading');
			if (typeof(table) == "undefined") { 
				iframeWin.contentWindow.setPIndexId(index);
			}else{
				iframeWin.contentWindow.setPIndexId(index,table);
			}
		}
	});
	top.layer.load(1,{content:'<p class="loading_style">加载中，请稍后。</p>'});

}

/**
 * 判断数组中是否存在重复记录
 * @param arr
 * @returns {boolean}
 */
function existsInArr(arr){
    return /(\x0f[^\x0f]+)\x0f[\s\S]*\1/.test("\x0f"+arr.join("\x0f\x0f") +"\x0f");
}



//加密字符串, 并赋值给目标字段
function des(str, tarField) {
    console.log(str);
    if(!str){
        top.layer.alert("该字段内容不可为空!", {icon: 8, title:'系统提示'});
    }
    if(!tarField){
        top.layer.alert("加密目标字段不存在!", {icon: 8, title:'系统提示'});
    }
    $("[id='"+tarField+"']").val(strEnc(str));
    // $('#'+tarField).val(strEnc(str));
    console.log($("[id='"+tarField+"']").val());
}