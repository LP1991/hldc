
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
//判断数据是否为空
function isBlank(value){
	return undefined == value || null == value || "" == value;
}