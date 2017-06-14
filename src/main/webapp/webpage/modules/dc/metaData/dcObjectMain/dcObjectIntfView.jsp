<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
<title>接口数据查看</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/jquery-validation/1.14.0/validate.methods.js"></script>
<style type="text/css">
	li{
		list-style:none;
	}
	.btn_d{
		display:inline;
		float:left;
	}
</style>
</head>
<body>
	<form:form id="inputForm" modelAttribute="objectIntf" action="#" autocomplete="off" method="post" class="form-horizontal">
		<form:hidden path="objId" />
		<sys:message content="${message}" />
		<table
			class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
			<tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right">对象名称:</label></td>
					<td class="width-35">${objectIntf.objName}</td>
					<td class="width-15 active"><label class="pull-right">对象编码:</label></td>
					<td class="width-35">${objectIntf.objCode}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">对象描述:</label></td>
					<td class="width-35">${objectIntf.objCode}</td>
					<td class="width-15 active"><label class="pull-right">业务部门:</label></td>
					<td class="width-35">${objectIntf.office.name}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">接口类别:</label></td>
					<td class="width-35">${objectIntf.intfcType}</td>
					<td class="width-15 active"><label class="pull-right">业务负责人:</label></td>
					<td class="width-35">${objectIntf.user.name}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">接口地址:</label></td>
					<td class="width-35" colspan="3">${objectIntf.intfcUrl}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">调用方式:</label></td>
					<td class="width-35">${objectIntf.intfcCalltype}</td>
					<td class="width-15 active"><label class="pull-right">传参方式:</label></td>
					<td class="width-35">${objectIntf.intfcContype}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">接口字段:</label></td>
					<td class="width-35" colspan="3">${objectIntf.intfcFields}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">限制条件:</label></td>
					<td class="width-35" colspan="3">${objectIntf.intfcParams}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">默认排序:</label></td>
					<td class="width-35" colspan="3">${objectIntf.orderFields}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">调用示例:</label></td>
					<td class="width-35" height="150px" colspan="3">${objectIntf.remarks}</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">标签:</label></td>
					<td class="width-35" colspan="3">
						<c:forEach items="${objLabelList}" var="lab">
							<span class="label label-info">${lab.labelName}</span>
						</c:forEach>
					</td>
				</tr>
				<c:if test="${objectIntf.accre == 9}">
					<tr>
						<td class="width-15 active"><label class="pull-right">访问状态:</label></td>
						<td id="visitStatus" class="width-35" colspan="3"></td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</form:form>

	<script type="text/javascript">
        $(document).ready(function () {
            if('${objectIntf.accre}'=='9'){
                updateVisitStatus();
			}
        });

        //更新申请状态
        function updateVisitStatus() {
            var visitStatus;
            //获取数据访问状态
            submitData('${ctx}/dc/intfVisit/apply/getVisitStatus?objId=${objectIntf.objId}',{},function(data){
                if(data.success){
                    //0:申请中; 1:已申请; 9:已撤销; -1:禁止访问; null: 无记录
                    if(data.msg=='0'){
                        visitStatus = '申请中';
                    }else if(data.msg=='1'){
                        visitStatus = '已申请';
                    }else if(data.msg=='9'){
                        visitStatus = '已撤销 &nbsp;<a href="#" onclick="visitApply(\'${objectIntf.objId}\')" class="btn btn-success btn-xs" title="重新申请">重新申请</a>';
                    }else if(data.msg=='-1'){
                        visitStatus = '禁止访问';
                    }else{
                        visitStatus = '<a href="#" onclick="visitApply(\'${objectIntf.objId}\')" class="btn btn-success btn-xs" title="申请访问">申请访问</a>';
                    }
                }else{
                    visitStatus = '<span class="label label-danger">接口状态异常</span>';
                }
                $('#visitStatus').html(visitStatus)
            });
        }


        //申请接口访问权限
        function visitApply(objId) {
            if(!objId){
                top.layer.alert("接口ID不可为空!", {icon: 1, title:'提示'});
                return false;
            }

            top.layer.prompt({
                formType: 2,
                value: '',
                title: '请填写申请原因',
                area: ['340px', '225px'] //自定义文本域宽高
            }, function(value, index, elem){
                if(!value){
                    top.layer.alert('请填写申请原因!', {icon: 8, title:'提示'});
                    return false;
				}
                submitData('${ctx}/dc/intfVisit/apply/applyVisit',{
                    'objId':objId,
					'remarks':value
				},function(data){
                    var icon_number;
                    if(!data.success){
                        icon_number = 8;
                    }else{
                        icon_number = 1;
                    }
                    top.layer.alert(data.msg, {icon: icon_number, title:'提示'});
                    updateVisitStatus();
                    top.layer.close(index);
                });
            })

            /*confirmx('确认要申请该接口的访问权限吗？', function(){
                submitData('${ctx}/dc/intfVisit/apply/applyVisit?objId='+objId,{},function(data){
                    var icon_number;
                    if(!data.success){
                        icon_number = 8;
                    }else{
                        icon_number = 1;
                    }
                    top.layer.alert(data.msg, {icon: icon_number, title:'提示'});
                    // 刷新表格数据，分页信息不会重置
                    if (typeof(table) != "undefined") {
                        table.ajax.reload(null, false );
                    }
                });
            })*/
        }

	</script>
</body>

</html>