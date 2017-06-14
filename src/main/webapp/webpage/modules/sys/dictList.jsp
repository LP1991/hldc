<%@ page contentType="text/html;charset=UTF-8" %>

	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
	    	return false;
	    }
	
		var option = {
			success : function(layero, index) {
				var body = layer.getChildFrame('body', index);
				var iframeWin = window[layero.find('iframe')[0]['name']]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
				var zbody = top.layer.getChildFrame('body', index);
				var inputForm = zbody.find('#type');
				inputForm.val($(body.context).find('#type_name').val());
				zbody.find('#parent_id').val($(body.context).find('#parent_id1').val());
				zbody.find('#type').val($(body.context).find('#type').val());
				zbody.find('#flag').val('add');
			}
		};
		$(document).ready(function() {
			$(document).on('ifChecked', '#contentTable thead tr th input.i-checks',function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		  	  $('#contentTable tbody tr td input.i-checks').iCheck('check');
		  	});
	
		  $(document).on('ifUnchecked','#contentTable thead tr th input.i-checks', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		  	  $('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
		  	});
		    
		});
	</script>
<div class="wrapper wrapper-content">
	<sys:message content="${message}"/>
	
	<!-- 查询条件 -->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="dict" action="${ctx}/sys/dict/" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		
		<input id="parent_id1" name="parent.id" type="hidden" />
		<input id="type_name" name="type_name" type="hidden" />
		<input id="type_label" name="type_label" type="hidden" />
		<input id="type" name="dict_type" type="hidden" />
		
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			 <span>标签 ：</span>
				<form:input path="label" htmlEscape="false" maxlength="50" class="form-control"/>
			<button class="btn btn-success btn-rect  btn-sm" onclick="searchA()" type="button"><i class="fa fa-search"></i> 查询</button>
		 </div>	
	</form:form>
	<br/>
	</div>
	</div>
	
		<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="sys:dict:add">
				<button class="btn btn-success btn-rect btn-sm" data-toggle="tooltip" data-placement="left"  dataFlag="add"  title="添加"><i class="fa fa-plus"></i> 添加</button>
				<%-- 使用方法： 1.将本tag写在查询的form之前；2.传入table的id和controller的url --%>
				<script type="text/javascript">
					function add(url){
						openDialog("新增字典",url,"800px", "500px",null,typeof(option) == "undefined"?{}:option);
					}
				</script>
			</shiro:hasPermission>
			<shiro:hasPermission name="sys:dict:del">
				<table:delRowByAjax url="${ctx}/sys/dict/deleteAllByA" id="contentTable"></table:delRowByAjax><!-- 删除按钮 -->
			</shiro:hasPermission>
		</div>
	</div>
	</div>
	
	<table id="contentTable" class="table table-striped table-bordered  table-hover table-condensed  dataTables-example dataTable no-footer">
		<thead>
			<tr>
				<th> <input type="checkbox" class="i-checks"></th>
				<th class="value">键值</th>
				<th >标签</th>
				<!-- <th class="type">类型</th> -->
				<th class="sort">排序</th>
				<th>操作</th>
			</tr>
		</thead>
	</table>
</div>
<script>
	var table;
	var parentId='';
	$(document).ready(function () {
		$('[dataFlag="add"]').on('click',function(e){
			if($('#type_name').val()==''){
				top.layer.alert('请先选择类型', { title:'系统提示'});
				return false;
			}else{
				if(parentId!=''){
					add("${ctx}/sys/dict/form?parent.id="+parentId);
				}else{
					add("${ctx}/sys/dict/form");
				}
				
			}
		});
		table = $('#contentTable').DataTable({
				"processing": true,
				"serverSide" : true,
				searching : false, //禁用搜索
				"ordering": false, //禁用排序
				
				"dom" : 'tr<"bottom"><"pull-left"i><"pull-left margins"l>p<"clear">',
				"autoWidth" : true, //自动宽度
				"bFilter" : false, //列筛序功能
				"ajax" : {
					url : "${ctx}/sys/dict/ajaxlist?parent.id=null",
					"data" : function (d) {
						//d 是原始的发送给服务器的数据，默认很长。 添加搜索条件
						$.extend(d, getFormParamsObj('searchForm'));
					},
					"dataSrc" : function (json) {//定义返回数据对象
						return JSON.parse(json.body.gson);
					}
				},
				"columns" : [
					CONSTANT.DATA_TABLES.COLUMN.CHECKBOX, {
						"data" : "value"
					}, {
						"data" : "label"
					}/* , {
						"data" : "type"
					} */, {
						"data" : "sort"
					}, {
						"data" : null
					}
				],
				//定义列的初始属性
				columnDefs : [{	                          
                    "defaultContent": "",
                    "targets": "_all"
                  },{
						targets : 4,
						render : function (a, b) {
							//判断权限
							var html ='';
							html += '<a href="#" onclick="openDialogView(\'查看字典\', \'${ctx}/sys/dict/dictView?id='+a.id+'\',\'800px\', \'680px\')" class="btn btn-success btn-xs"><i class="fa fa-search-plus"></i></a>&nbsp;';
							html+= '<a href="#" onclick="openDialog(\'修改字典\', \'${ctx}/sys/dict/form?id='+a.id+'\',\'800px\', \'700px\', \'officeContent\')" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>&nbsp;';
							html+= '<a  onclick="deleteA(\'${ctx}/sys/dict/deleteA?id='+a.id+'\',\'字典\') " class="btn btn-success btn-xs"><i class="fa fa-trash"></i></a>';
							return html;
						}
					}
				],
				//初始化完成回调
				"initComplete": function(settings, json) {
				},
				//重绘回调
				"drawCallback": function( settings ) {
					//初始化check
					 $('.i-checks').iCheck({
			                checkboxClass: 'icheckbox_square-green',
			                radioClass: 'iradio_square-green',
			            });
					 //去除表头选中状态
					 $('.dataTable thead .i-checks').iCheck('uncheck');
			    }
			});
	});

	

	</script>