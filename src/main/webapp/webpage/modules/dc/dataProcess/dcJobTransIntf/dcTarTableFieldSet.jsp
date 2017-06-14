<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>初始化目标表</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
	<script type="text/javascript">
        //回调函数，在编辑和保存动作时，供openDialog调用提交表单。
        function doSubmit(index,table){
            var tbData =  $('#fieldList').DataTable({
                "bPaginate" : false,// 分页按钮
                "searching" : false, //禁用搜索
                "ordering": false, //禁用排序
                "dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
                "autoWidth" : false, //自动宽度
                "bFilter" : false, //列筛序功能
                "info" : false //隐藏表格左下角的信息
            });
            var data = tbData.$('input, select').serialize();
            var list = new Array(),
                fieldList = new Array(),
                idx=0,
                selectList = new Array();	//关联接口字段列表
            if(!data){
                top.layer.alert('字段列表为空!');
                return false;
            }
            fieldList = data.split("&");//将表格中的字段取出来后分割
            debugger
            for(var i=1;i<fieldList.length+1;i++){
                if(i%8==0){
                    list[idx]={
                        fieldName:fieldList[i-8].split("=")[1],
                        fieldType:fieldList[i-7].split("=")[1],
                        fieldLeng:fieldList[i-6].split("=")[1],
                        fieldDesc:fieldList[i-5].split("=")[1],
                        isKey:fieldList[i-4].split("=")[1],
                        isNull:fieldList[i-3].split("=")[1],
                        defaultVal:fieldList[i-2].split("=")[1],
                        remarks:fieldList[i-1].split("=")[1]
                    };	//把得到的数据组成list格式
                    //保存已关联的接口字段, 验证重复
                    if(fieldList[i-1].split("=")[1]){
                        selectList.push(fieldList[i-1].split("=")[1])
                    }
                    idx++;
                }
            }
            if(existsInArr(selectList)){
                top.layer.alert('存在重复关联接口字段, 请检查!');
                return false;
            }
//            console.log(list);
//            'remarks':encodeURI(JSON.stringify(list),"utf-8"),
            submitData( '${ctx}/dc/dataProcess/transIntf/ajaxSaveTarTable',{
                'remarks':JSON.stringify(list),
                'id':'${formData.id}',
                'jobDesc':$(objDesc).val(),
                'createFlag':${formData.remarks eq 'true'}
            },function(result){
                top.layer.alert(result.msg, {icon: 3, title:'系统提示'});
                if(result.success!=true){
                    return false;
                }else{
                    //刷新表格
                    table.ajax.reload();
                    //关闭form面板
                    top.layer.close(index)
                    return true;
                }
            });
        }

        /**
         * 判断数组中是否存在重复记录
         * @param arr
         * @returns {boolean}
         */
        function existsInArr(arr){
            return /(\x0f[^\x0f]+\x0f)[\s\S]*\1/.test("\x0f"+arr.join("\x0f\x0f") +"\x0f");
        }

        /**
         * 更新数据表字段  peijd
         */
        function updateTableField() {
//            dataTables  无法加载动态动态下拉列表, 所以这里用整页刷新
            top.layer.confirm('刷新源数据字段可能会丢失部分配置信息, 您确定要进行刷新？', {
                btn: ['确认','取消'] //按钮
            }, function(index){
				//提交表单刷新
                $("#inputForm").submit();
                top.layer.close(index);
                return false;
            }, function(){

            });
        }

	</script>
</head>
<body class="hideScroll">

<form:form id="inputForm" modelAttribute="formData" autocomplete="off" action="${ctx}/dc/dataProcess/transIntf/initTarTable" method="post" class="form-horizontal" >
	<form:hidden path="id"/>
	<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
		<tr>
			<td class="width-15 active"><label class="pull-right">连接Schema：</label></td>
			<td class="width-35">${formData.dbDataBase}</td>
			<td  class="width-15 active" class="active"><label class="pull-right">是否创建数据表：</label></td>
			<td class="width-35">
				<c:choose>
					<c:when test="${formData.remarks eq 'true'}">√</c:when>
					<c:otherwise>×</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<td  class="width-15 active" class="active"><label class="pull-right">数据表名称：</label></td>
			<td class="width-35">${formData.tableName}</td>
			<td  class="width-15 active" class="active"><label class="pull-right">数据表描述：</label></td>
			<td class="width-35">
				<c:choose>
					<c:when test="${formData.remarks eq 'true'}">
						<form:input path="objDesc" htmlEscape="false" maxlength="100" class="form-control"/>
					</c:when>
					<c:otherwise>
						<input type="hidden" id="objDesc" value="${formData.objDesc}"/>${formData.objDesc}
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		</tbody>
	</table>
</form:form>
<br/>

<sys:message content="${message}"/>
<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<button class="btn btn-success btn-rect  btn-sm " onclick="updateTableField()" type="button"><i class="fa fa-search"></i> 更新数据表字段</button>
		</div>
	</div>
</div>
<table id="fieldList" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable display" cellspacing="0" style="overflow: scroll;">
	<thead>
	<tr>
		<th style="text-align:center; width:4%;">序号</th>
		<td style="text-align:center; width:12%;" >字段名称</td>
		<td style="text-align:center; width:10%;" >字段类型</td>
		<td style="text-align:center; width:8%;">字段长度</td>
		<td style="text-align:center; ">字段描述</td>
		<td style="text-align:center; width:8%;" >是否主键</td>
		<td style="text-align:center; width:8%;" >允许空值</td>
		<td style="text-align:center; width:10%;" >默认值</td>
		<td style="text-align:center; width:20%;" >关联接口字段</td>
	</tr>
	</thead>
	<tbody>	<!-- 不加tbody 则无法获取表格数据 -->
	<c:forEach items="${fieldList}" var="index" varStatus="vs">
		<tr>
			<td style="text-align:center" >${vs.index+1}</td>
			<td style="text-align:center" ><input type="hidden" id="fieldName" name="fieldName" value="${index.fieldName}"/>${index.fieldName} </td>
			<td style="text-align:center" ><input type="hidden" id="fieldType" name="fieldType" value="${index.fieldType}"/>${index.fieldType} </td>
			<td style="text-align:center" ><input type="hidden" id="fieldLeng" name="fieldLeng" value="${index.fieldLeng}"/>
				<c:choose>
					<c:when test="${index.fieldLeng eq '0'}">-</c:when>
					<c:otherwise>${index.fieldLeng}</c:otherwise>
				</c:choose>
			</td>
			<td style="text-align:center" ><input type="hidden" id="fieldDesc" name="fieldDesc" value="${index.fieldDesc}"/>${index.fieldDesc} </td>
			<td style="text-align:center" ><input type="hidden" id="isKey" name="isKey" value="${index.isKey}"/><c:if test="${index.isKey eq '1' }">√</c:if> </td>
			<td style="text-align:center" ><input type="hidden" id="isNull" name="isNull" value="${index.isNull}"/><c:if test="${index.isNull eq 'Y' }">√</c:if> </td>
			<td style="text-align:center" ><input type="hidden" id="defaultVal" name="defaultVal" value="${index.defaultVal}"/>
				<c:choose>
					<c:when test="${empty index.defaultVal}">NULL</c:when>
					<c:otherwise>${index.defaultVal}</c:otherwise>
				</c:choose>
			</td>
			<td style="text-align:center">
				<c:choose>
					<c:when test="${index.fieldName eq 'ID_ROW_SEQ_NO'}">
						<input type="hidden" id="remarks" name="remarks" value=""/>-
					</c:when>
					<c:otherwise>
						<select id="remarks" name="remarks" value="${index.remarks}">
							<option value=""> 无</option>
							<c:forEach var="f1" items="${f_remarks}">
								<option value="${f1}"
										<c:if test="${index.remarks==f1}">selected</c:if>>${f1}
								</option>
							</c:forEach>
						</select>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</c:forEach>
	</tbody>
</table>
</body>
</html>