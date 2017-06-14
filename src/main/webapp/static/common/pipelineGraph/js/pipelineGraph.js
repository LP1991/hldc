
/**
 * Module definition for Pipeline Graph Directive.
 */
 angular.module('myApp.constant',[]);
angular.module('myApp.constant')
  .constant('pipelineConstant', {
    SOURCE_STAGE_TYPE : 'SOURCE',
    PROCESSOR_STAGE_TYPE : 'PROCESSOR',
    SELECTOR_STAGE_TYPE : 'SELECTOR',
    EXECUTOR_STAGE_TYPE : 'EXECUTOR',
    TARGET_STAGE_TYPE : 'TARGET',
    STAGE_INSTANCE: 'STAGE_INSTANCE',
    LINK: 'LINK',
    PIPELINE: 'PIPELINE'
  });

var app = angular.module('MyApp', ['myApp.constant','ui.select','ngDraggable','ngSanitize','splitterDirectives']);
app.controller('MyController', function($scope,$http, $rootScope,$timeout, $element,$filter, $location,pipelineConstant,$interval){ 
var _this = this;
$scope.all_d_data_obj = {};//建立一个对象，缓存数据，监控对象中属性的变化
$scope.hideTable=true;//映射关系
$scope.ctx = ctx;//项目路径
var str = $location.absUrl();//获取当前url
var adress_url = str.toString().split('page')[0];
var dataType,stages;
var newOneArr=[];
$scope.index_arr=[];
//发起http请求
$http({//获取queryHiveTableList数据
method:'POST',
url:""+adress_url+"rest/translate/queryHiveTableList",
data:{"tableSpace":"default"},
headers:{
 'Content-Type':'application/x-www-form-urlencoded',
} 
}).success(function(data,header,config,status){
	$scope.items=[];
	$scope.arrData= data.rst_std_msg;
	$scope.selectedData={};
}).error(function(data,header,config,status){
    console.log('queryHiveTableList获取节点类型失败');
});
$http({//获取getHiveFuncList函数表达式
	method:'GET',
	url:""+adress_url+"rest/translate/getHiveFuncList",
	}).success(function(data,header,config,status){
		$scope.tranform_funcList = data.funcList;		
	}).error(function(data,header,config,status){
	   console.log('getHiveFuncList获取节点类型失败');
	});

$http({//获取getFilterExpList过滤表达式
	method:'GET',
	url:""+adress_url+"/rest/translate/getFilterExpList",
	}).success(function(data,header,config,status){
		$scope.filter_operate = data.expList;
	}).error(function(data,header,config,status){
	   console.log('getFilterExpList获取节点类型失败');
	});
//页面 json
$scope.table_nameData=["HIVE_input","HDFS_input"];
$scope.out_table_nameData=["HIVE_output","HDFS_output"];
$scope.filter_data = [];//过滤条件的字段集合
$scope.add_filter_table=['1'];
$scope.add_map_filter_table = ['1'];
/**
 * 增加过滤条件
 * */
$scope.add_filter=function(){
	var selected_node = $scope.state.selectedNode || null;
	if(selected_node!== null && selected_node.one.length>0 && $scope.filter_data.length>0){
		$scope.add_filter_table.push('1');
		setTimeout(function(){
			var ab = $('.filter').find('.ui-select-container');
			 for(var i=0;i<ab.length;i++){
			 	ab.eq(i).width(ab.eq(i).parent().width());
			 }
			 $scope.title_tip();
		})
	}
}
//一个方法将arr的值传入brr，同时清空arr
$scope.change_cross=function(arr,brr){
	var return_arr = $scope.cloneObj($scope.arr);
	$scope.a = [];
	$scope.state.selectedNode.filter = [];
	for(var i=0;i<return_arr.length;i++){
		_this.filter_field[i] = return_arr[i].field;
		_this.filter_operate[i] = return_arr[i].operate;
		_this.user_write[i] = return_arr[i].value;
	}
}
//清空校验数据，数据效验
$scope.delete_xy_filter = function(){
	//需要重新定义数组
	if($scope.xy_filter_all_data.length && $scope.xy_filter_all_data.length>0){
		_this.filter_field = [];
		_this.filter_operate = []
		_this.user_write = [];
		$scope.add_filter_table.length = $scope.xy_filter_all_data.length;
		var return_arr = $scope.cloneObj($scope.xy_filter_all_data);
		$scope.xy_filter_all_data = [];
		$scope.state.selectedNode.filter = [];
		for(var i=0;i<return_arr.length;i++){
			_this.filter_field[i] = return_arr[i].field;
			_this.filter_operate[i] = return_arr[i].operate;
			_this.user_write[i] = return_arr[i].value;
		}
		$scope.update_all_attributes = true;
		graph.updateGraph();		
	}
}
//增加映射过滤
$scope.add_map_filter=function(){
	var selected_node = $scope.state.selectedNode || null;
	if(selected_node!== null && selected_node.one.length>0 && $scope.choice_field_arr.length>0){
		$scope.add_map_filter_table.push('1');
		setTimeout(function(){
			var ab = $('#map_filter').find('.ui-select-container');
			 for(var i=0;i<ab.length;i++){
			 	ab.eq(i).width(ab.eq(i).parent().width());
			 }
			 $scope.title_tip();
		})
	}
}
//清空所有映射过滤
$scope.delete_map_filter=function(){
	if($scope.map_filter_all_data.length&&$scope.map_filter_all_data.length>0){
		$scope.add_map_filter_table = ['1'];//清空所有表格--同时清空所有添加的数据
		_this.map_filter_field = [];//清空原有数组，避免重复传值
		_this.map_filter_operate = [];
		_this.map_user_write = [];
		$scope.add_map_filter_table.length = $scope.map_filter_all_data.length;
		for(var i=0;i<$scope.choice_field_arr.length;i++){
			$scope.choice_field_arr[i].ago_map_filter = false;
		}
		var return_arr = $scope.cloneObj($scope.map_filter_all_data);
		$scope.map_filter_all_data = [];
		$scope.state.selectedNode.map_filter = [];
		for(var i=0;i<return_arr.length;i++){
			_this.map_filter_field[i] = return_arr[i].field;
			_this.map_filter_operate[i] = return_arr[i].operate;
			_this.map_user_write[i] = return_arr[i].value;
		}
		$scope.update_all_attributes = true;
		graph.updateGraph();
	}
}
//置空关联数组A、B
_this.cognate_A = [];
_this.cognate_B = [];
//清空所有关联，并将对应的字段放到左侧table
$scope.delete_all_cognate = function(){
	var d_now_ins = $scope.state.selectedNode || null;
		if($scope.cognate_all_data.length&&$scope.cognate_all_data.length>0){	
			$scope.copyhtml = ["1"]; 
			_this.cognate_A = [];
			_this.cognate_B = [];
			
			$scope.copyhtml.length = $scope.cognate_all_data.length;
			var return_arr = $scope.cloneObj($scope.cognate_all_data);
			$scope.cognate_all_data = [];
			$scope.state.selectedNode.cognate = [];
			for(var i=0;i<return_arr.length;i++){
				var obj_A = {},
					obj_B = {};
				obj_A.fieldName = return_arr[i].fieldName_a;
				obj_A.hiveName = return_arr[i].tableName_a;
				obj_A.instanceName = return_arr[i].instanceName_a;
				
				obj_B.fieldName = return_arr[i].fieldName_b;
				obj_B.hiveName = return_arr[i].tableName_b;
				obj_B.instanceName = return_arr[i].instanceName_b;
			
				var k_arr = $scope.all_d_data_obj[d_now_ins.instanceName][obj_A.instanceName].fieldArr;
				for(var k=0;k<k_arr.length;k++){
					if(k_arr[k].fieldName == return_arr[i].fieldName_a){
						$scope.all_d_data_obj[d_now_ins.instanceName][obj_A.instanceName].fieldArr[k].ago_cognated = false
					}
				}
				var b_brr = $scope.all_d_data_obj[d_now_ins.instanceName][obj_B.instanceName].fieldArr;
				for(var b=0;b<b_brr.length;b++){
					if(b_brr[b].fieldName == return_arr[i].fieldName_b){
						$scope.all_d_data_obj[d_now_ins.instanceName][obj_B.instanceName].fieldArr[b].ago_cognated = false
					}
				}
				_this.cognate_A[i] = obj_A;
				_this.cognate_B[i] = obj_B;
			}
			$scope.update_all_attributes = true;
			graph.updateGraph();
		}
		
		
		$scope.update_all_attributes = true;
		graph.updateGraph();	
}
//给页面所有ui-select下拉选择框增加title属性
$scope.title_tip=function(){
	 $('.have_ui_select').on('click',$('.ui-select-choices-row-inner'),function(){
		 for(var i=0;i<$(this).find('.ui-select-choices-row-inner').length;i++){
			 $(this).find('.ui-select-choices-row-inner').eq(i).attr('title',$(this).find('.ui-select-choices-row-inner').eq(i).find('div').text());
		 }
	})
};
setTimeout(function(){$scope.title_tip();})


var save_pipeline=[];

//$scope扩展对象--有一些用不到
	  angular.extend($scope, {
      state: {
        selectedNode: null,
        selectedEdge: null,
        mouseDownNode: null,
        mouseDownNodeLane: null,
        mouseDownNodeEventLane: null,
        mouseDownLink: null,
        justDragged: false,
        justScaleTransGraph: false,
        lastKeyDown: -1,
        shiftNodeDrag: false,
        selectedText: null,
        currentScale: 1,
        copiedStage: undefined,
        showBadRecords: false,
        showConfiguration: false
      },

      panUp: function($event) {
        graph.panUp();
        $event.preventDefault();
      },

      panDown: function($event) {
        graph.panDown();
        $event.preventDefault();
      },

      panLeft: function($event) {
        graph.panLeft();
        $event.preventDefault();
      },

      panRight: function($event) {
        graph.panRight();
        $event.preventDefault();
      },

      panHome: function($event) {
        graph.panHome();
        $event.preventDefault();
      },

      zoomIn: function($event) {
        graph.zoomIn();
        $event.preventDefault();
      },

      zoomOut: function($event) {
        graph.zoomOut();
        $event.preventDefault();
      },

      /**
       * Callback function on warning icon sign--警报图标上的回调函数
       * @param $event--返回事件
       */
      onWarningClick: function($event) {
        if ($scope.state.selectedNode) {
          graph.removeSelectFromNode();
        } else if ($scope.state.selectedEdge) {
          graph.removeSelectFromEdge();
        }

        var options = {
          selectedObject: undefined,
          type: pipelineConstant.PIPELINE
        }, firstConfigIssue;

        if (graph.issues && graph.issues.pipelineIssues) {
          angular.forEach(graph.issues.pipelineIssues, function(issue) {
            if (issue.configName && !firstConfigIssue) {
              firstConfigIssue = issue;
            }
          });

          if (!firstConfigIssue && graph.errorStage && graph.errorStage.instanceName &&
            graph.issues.stageIssues[graph.errorStage.instanceName]) {
            angular.forEach(graph.issues.stageIssues[graph.errorStage.instanceName], function(issue) {
              if (issue.configName && !firstConfigIssue) {
                firstConfigIssue = issue;
                options.errorStage = true;
              }
            });
          }
          if (firstConfigIssue) {
            options.detailTabName = 'configuration';
            options.configGroup = firstConfigIssue.configGroup;
            options.configName =  firstConfigIssue.configName;
          }
        }
        $scope.$emit('onRemoveNodeSelection', options);
      },
      /**
       * Callback function to delete stage/stream--回调函数删除阶段/流
       */
      deleteSelected: function() {//删除选中
      	
        var state = $scope.state,
          selectedNode = state.selectedNode,
          selectedEdge = state.selectedEdge;
        if (graph.isReadOnly) {
          //Graph is read only
          return;
        }
        if (selectedNode) {
/*          if (selectedNode.uiInfo.stageType == pipelineConstant.SOURCE_STAGE_TYPE ) {//出现弹出框
            var modalInstance = $modal.open({//$modal模块未加载
                templateUrl: 'common/directives/pipelineGraph/deleteOrigin.tpl.html',
                controller: 'DeleteOriginModalInstanceController',
                size: '',
                backdrop: 'static'
              });

            modalInstance.result.then(function (configInfo) {
              deleteSelectedNode(selectedNode);
              $scope.$emit('onOriginStageDelete', selectedNode);
            }, function () {

            });
          } else {*/
        	/*删除映射中的对应节点的value值 */
        	var state = $scope.state.selectedNode;
        	if($scope.all_d_data_obj[state.instanceName]){
        		delete $scope.all_d_data_obj[state.instanceName];
        	}
        	//清空当前删除节点对应的各种表格
        	if(state.uiInfo.stageType === 'SOURCE'){
        		if(state.fieldArr){
        			$scope.fieldArr = [];
        		}
        	}else if(state.uiInfo.stageType === 'PROCESSOR'){
        		$scope.delete_all();
        		if(state.one){
        			$scope.delete_all();
        			$scope.d_data = [];
        			$scope.choice_field_arr = [];
        		}
        		if(state.dropData){
        			$scope.dropData_k = [];
        		}
        		if(state.cognate){ 			
        			$scope.copyhtml = ['1'];
        		}
        	}
        	
        	delete $scope.all_d_data_obj[selectedNode.instanceName];
        	//从画布中删除选中节点
            deleteSelectedNode(selectedNode);
        } else if (selectedEdge) {
        	//删除边
          var edgeIndex = graph.edges.indexOf(selectedEdge);
          if (edgeIndex !== -1) {
            //Update pipeline target input lanes.			
            if (selectedEdge.eventLane) {
              selectedEdge.target.inputLanes = _.filter(selectedEdge.target.inputLanes, function(inputLane) {
                return !_.contains(selectedEdge.source.eventLanes, inputLane);
              });
            } else {
              selectedEdge.target.inputLanes = _.filter(selectedEdge.target.inputLanes, function(inputLane) {
                return !_.contains(selectedEdge.source.outputLanes, inputLane);
              });
            }
            graph.edges.splice(edgeIndex, 1);
            state.selectedEdge = null;
            $scope.$emit('onRemoveNodeSelection', {
              selectedObject: undefined,
              type: pipelineConstant.PIPELINE
            });
            //删除连线时刷新属性
            $scope.update_all_attributes = true;
            graph.updateGraph();
          } 
        }
      },

      /**
       * Callback function for dupl
       * dupl的回调函数
       * 粘贴节点
       */
      duplicateStage: function() {
        $scope.$emit('onPasteNode', $scope.state.selectedNode);
      }

    });

	  
    var showTransition = false,
      graphErrorBadgeLabel = '';


    // define graphcreator object
    //画布对象
    var GraphCreator = function(svg, nodes, edges, issues ){
      var thisGraph = this;
      thisGraph.idct = 0;

      thisGraph.nodes = nodes || [];
      thisGraph.edges = edges || [];
      thisGraph.issues = issues || {};

      // define arrow markers for graph links
      
      var markerWidth = 3.5,
        markerHeight = 3.5,
        cRadius = -7, // play with the cRadius value
        refX = cRadius + (markerWidth * 2),
        defs = svg.append('svg:defs');

      defs.append('svg:marker')
        .attr('id', 'end-arrow')
        .attr('viewBox', '0 -5 10 10')
        .attr('refX', refX)
        .attr('markerWidth', markerWidth)
        .attr('markerHeight', markerHeight)
        .attr('orient', 'auto')
        .append('svg:path')
        .attr('d', 'M0,-5L10,0L0,5');

      thisGraph.svg = svg;

	 
      //Background lines
      //背景线段
      var margin = {top: -5, right: -5, bottom: -5, left: -5};
      
      var svgWidth = 4000;
      var svgHeight = 4000;

      if (svg.length && svg[0] && svg[0].length) {
        var clientWidth = svg[0][0].clientWidth;
        var clientHeight = svg[0][0].clientHeight;

        if (clientWidth > svgWidth) {
          svgWidth = clientWidth;
        }

        if (clientHeight > svgHeight) {
          svgHeight = clientHeight;
        }
      }

      var width = svgWidth - margin.left - margin.right;
      var height = svgHeight - margin.top - margin.bottom;

      var container = svg.append('g');
      container.append('g')
        .attr('class', 'x axis')
        .selectAll('line')
        .data(d3.range(0, width, 10))
        .enter().append('line')
        .attr('x1', function(d) { return d; })
        .attr('y1', 0)
        .attr('x2', function(d) { return d; })
        .attr('y2', height);

      container.append('g')
        .attr('class', 'y axis')
        .selectAll('line')
        .data(d3.range(0, height, 10))
        .enter().append('line')
        .attr('x1', 0)
        .attr('y1', function(d) { return d; })
        .attr('x2', width)
        .attr('y2', function(d) { return d; });

      thisGraph.svgG = svg.append('g')
        .classed(thisGraph.consts.graphClass, true);
      var svgG = thisGraph.svgG;

      // displayed when dragging between nodes
      //在节点之间拖动时显示

      thisGraph.dragLine = svgG.append('svg:path')
        .attr('class', 'link dragline hidden')
        .attr('d', 'M0,0L0,0')
    .style('marker-end', 'url(' + $location.absUrl() + '#mark-end-arrow)');

      // svg nodes and edges--节点和边
      thisGraph.paths = svgG.append('g').selectAll('g');
      thisGraph.rects = svgG.append('g').selectAll('g');

		
      thisGraph.drag = d3.behavior.drag()
        .origin(function(d){
        	return {x: d.uiInfo.xPos, y: d.uiInfo.yPos};
        })
        .on('drag', function(args){
          $scope.state.justDragged = true;
          
          thisGraph.dragmove.call(thisGraph, args);
        })
        .on('dragend', function() {
          // todo check if edge-mode is selected
        });

      // listen for key events
    $scope.delete_selected=function(){//删除选中
    	common_found(1);
        $scope.deleteSelected();
    }
    //svg监听事件--其中键盘按下事件谷歌下失效,故没有使用
      svg.on('keydown', function(d) {
        thisGraph.svgKeyDown.call(thisGraph);
      })
      .on('keyup', function(d) {
        thisGraph.svgKeyUp.call(thisGraph);
      })
      .on('mousedown', function(d) {
        thisGraph.svgMouseDown.call(thisGraph, d);
      })
      .on('mouseup', function(d) {
        thisGraph.svgMouseUp.call(thisGraph, d);
      });

      // listen for dragging
//d3的缩放
      thisGraph.zoom = d3.behavior.zoom()//定义缩放函数
        .scaleExtent([1, 1])//设置最小和最大的缩放比例--此处全设1，表示不缩放，更改数字可以达到缩放的效果
        .on('zoom', function(){
          if (d3.event && d3.event.sourceEvent && d3.event.sourceEvent.shiftKey){
            // TODO  the internal d3 state is still changing
            return false;
          } else{
            thisGraph.zoomed.call(thisGraph);
          }
          return true;
        })
        .on('zoomstart', function() {
          if (d3.event && d3.event.sourceEvent && !d3.event.sourceEvent.shiftKey) {
            d3.select('body').style('cursor', 'move');
          }
        })
        .on('zoomend', function(){
          d3.select('body').style('cursor', 'auto');
        });
      svg.call(thisGraph.zoom)
        .on('dblclick.zoom', null);
        svg.on('mousedown.zoom', null);
        svg.on('mousemove.zoom', null);

      //To disable zoom on mouse scroll
      svg.on('dblclick.zoom', null);
//      svg.on('touchstart.zoom', null);
      svg.on('wheel.zoom', null);
      svg.on('mousewheel.zoom', null);
      svg.on('MozMousePixelScroll.zoom', null);
    };

    GraphCreator.prototype.setIdCt = function(idct){
      this.idct = idct;
    };

    GraphCreator.prototype.consts =  {//配置参数
      selectedClass: 'selected',
      connectClass: 'connect-node',
      rectGClass: 'rectangleG',
      pathGClass: 'pathG',
      graphClass: 'graph',
      startNodeClass: 'startNode',
      endNodeClass: 'endNode',
      BACKSPACE_KEY: 8,
      DELETE_KEY: 46,
      ENTER_KEY: 13,
      COMMAND_KEY: 91,
      CTRL_KEY: 17,
      COPY_KEY: 67,
      PASTE_KEY: 86,
      nodeRadius: 60,
      rectWidth: 120,
      rectHeight: 90,
      rectRound: 14
    };

    /* PROTOTYPE FUNCTIONS */
    /*dragmove
     * 拖拽事件
     * 其中分为节点的拖拽和拖拽连线
     * */
    GraphCreator.prototype.dragmove = function(d) {//每个节点的拖拽
	  $scope.select_drag=d;	  
      var thisGraph = this;
      if ($scope.state.shiftNodeDrag){//拖出箭头时出现

        var sourceX = (d.uiInfo.xPos + $scope.state.shiftNodeDragXPos);
        var sourceY = (d.uiInfo.yPos + $scope.state.shiftNodeDragYPos);
        var targetX = d3.mouse(thisGraph.svgG.node())[0];
        var targetY = d3.mouse(this.svgG.node())[1];
        var sourceTangentX;
	
        if ($scope.state.mouseDownNodeLane) {
          sourceTangentX = sourceX + (targetX - sourceX) / 2;
        } else if ($scope.state.mouseDownNodeEventLane) {
          sourceTangentX = sourceX;
        }
        var sourceTangentY = sourceY;
        var targetTangentX = targetX - (targetX - sourceX) / 2;
        var targetTangentY = targetY;
        //拖拽出连接线段
        if($scope.state.mouseDownNodeLane == 'error'){
      	  thisGraph.dragLine
        .style('stroke','red');
        }else if($scope.state.mouseDownNodeLane == 'success'){
        	 thisGraph.dragLine
             .style('stroke','gray');
        }else{
        	thisGraph.dragLine
            .style('stroke','rgb(204, 204, 204)');
        }
        
        thisGraph.dragLine.attr('d', 'M ' + sourceX + ',' + sourceY +
        'C' + sourceTangentX + ',' + sourceTangentY + ' ' +
        targetTangentX + ',' + targetTangentY + ' ' +
        targetX + ',' + targetY);
      } else{
        $scope.$apply(function() {//拖动节点
          d.uiInfo.xPos += d3.event.dx;
          d.uiInfo.yPos +=  d3.event.dy;
        // 增加判断--加载单条时，--加载多条时循环判断--待添加
        //解决重新加载页面时拖动图形箭头线段不能正常跟随
        if(d.inputLanes||d.outputLanes){
          for(var x in thisGraph.edges){            
            if(d.inputLanes){
              for(var i in d.inputLanes){
                if(thisGraph.edges[x].outputLane == d.outputLanes || thisGraph.edges[x].outputLane == d.inputLanes[i]){
                  if(thisGraph.edges[x].source.instanceName == d.instanceName){
                    thisGraph.edges[x].source.uiInfo.xPos=d.uiInfo.xPos; 
                    thisGraph.edges[x].source.uiInfo.yPos=d.uiInfo.yPos;
                  }else if(thisGraph.edges[x].target.instanceName == d.instanceName){
                    thisGraph.edges[x].target.uiInfo.xPos=d.uiInfo.xPos;  
                    thisGraph.edges[x].target.uiInfo.yPos=d.uiInfo.yPos;
                  }
                }
              }
              if(d.inputLanes&&d.outputLanes){
          		for(var i in d.outputLanes){
          			 if(thisGraph.edges[x].outputLane == d.outputLanes[i] || thisGraph.edges[x].inputLane == d.outputLanes[i]){
          				 if(thisGraph.edges[x].source.instanceName == d.instanceName){
          	                    thisGraph.edges[x].source.uiInfo.xPos=d.uiInfo.xPos; 
          	                    thisGraph.edges[x].source.uiInfo.yPos=d.uiInfo.yPos;
          	                  }else if(thisGraph.edges[x].target.instanceName == d.instanceName){
          	                    thisGraph.edges[x].target.uiInfo.xPos=d.uiInfo.xPos;  
          	                    thisGraph.edges[x].target.uiInfo.yPos=d.uiInfo.yPos;
          	                  }
                         }
          		}
          	}
            }else{
            	if(d.outputLanes){
            		for(var i in d.outputLanes){
            			 if(thisGraph.edges[x].outputLane == d.outputLanes[i] || thisGraph.edges[x].inputLane == d.outputLanes[i]){
            				 if(thisGraph.edges[x].source.instanceName == d.instanceName){
            	                    thisGraph.edges[x].source.uiInfo.xPos=d.uiInfo.xPos; 
            	                    thisGraph.edges[x].source.uiInfo.yPos=d.uiInfo.yPos;
            	                  }else if(thisGraph.edges[x].target.instanceName == d.instanceName){
            	                    thisGraph.edges[x].target.uiInfo.xPos=d.uiInfo.xPos;  
            	                    thisGraph.edges[x].target.uiInfo.yPos=d.uiInfo.yPos;
            	                  }
                           }
            		}
            	}
            }         
          }
        }
          thisGraph.updateGraph();
        });
      }
    };
/*删除画布，此页面没有用到该方法*/
    GraphCreator.prototype.deleteGraph = function(){
      var thisGraph = this;
      thisGraph.nodes = [];
      thisGraph.edges = [];
      $scope.state.selectedNode = null;
      $scope.state.selectedEdge = null;

      $('.graph-bootstrap-tooltip').each(function() {
        var $this = $(this);
        $this.tooltip('destroy');
      });

      thisGraph.updateGraph();
    };

    /* select all text in element: taken from http://stackoverflow.com/questions/6139107/programatically-select-text-in-a-contenteditable-html-element */
 GraphCreator.prototype.selectElementContents = function(el) {
   var range = document.createRange();
   range.selectNodeContents(el);
   var sel = window.getSelection();
   sel.removeAllRanges();
   sel.addRange(range);
 };

    /**
     * http://bl.ocks.org/mbostock/7555321
     * 
     * @param gEl
     * @param title
     * 在节点中插入txt文本
     */
    GraphCreator.prototype.insertTitleLinebreaks = function (gEl, title) {
      var el = gEl.append('text')
        .attr('text-anchor','middle')
        .attr('x', 50)
        .attr('y', 75),
        text = el,
        words = title.split(/\s+/).reverse(),
        word,
        line = [],
        lineNumber = 0,
        lineHeight = 1.1, // ems
        y = text.attr('y'),
        dy = 0,
        tspan = text.text(null).append('tspan').attr('x', 70).attr('y', y).attr('dy', dy + 'em'),
        totalLines = 1;

      if (words.length === 1) {
        tspan.text(title.substring(0, 23));
      } else {
        while (word = words.pop()) {
          line.push(word);
          tspan.text(line.join(' '));
          if (tspan.node().getComputedTextLength() > this.consts.rectWidth - 10) {
            line.pop();
            tspan.text(line.join(' ').substring(0, 23));

            if (totalLines === 2) {
              break;
            }
            line = [word];
            tspan = text.append('tspan').attr('x', 70).attr('y', y).attr('dy', ++lineNumber * lineHeight + dy + 'em').text(word);
            totalLines++;
          }
        }
      }
    };

    // remove edges associated with a node
    GraphCreator.prototype.spliceLinksForNode = function(node) {
      var thisGraph = this,
        toSplice = thisGraph.edges.filter(function(l) {
          return (l.source.instanceName === node.instanceName || l.target.instanceName === node.instanceName);
        });
      toSplice.map(function(l) {
        thisGraph.edges.splice(thisGraph.edges.indexOf(l), 1);
      });
    };

    GraphCreator.prototype.replaceSelectEdge = function(d3Path, edgeData){//替换选择边
      var thisGraph = this;
      if ($scope.state.selectedEdge){
        thisGraph.removeSelectFromEdge();
      }
      d3Path.classed(thisGraph.consts.selectedClass, true);
      $scope.state.selectedEdge = edgeData;
    };

    GraphCreator.prototype.replaceSelectNode = function(d3Node, nodeData){//
     // alert(this);
      var thisGraph = this;
      if ($scope.state.selectedNode){

        thisGraph.removeSelectFromNode();
      }
      d3Node.classed(this.consts.selectedClass, true);
      $scope.state.selectedNode = nodeData;
    };

    GraphCreator.prototype.removeSelectFromNode = function(){
      var thisGraph = this;
      thisGraph.rects.filter(function(cd){
        
        return cd.instanceName === $scope.state.selectedNode.instanceName;
      }).classed(thisGraph.consts.selectedClass, false);
      $scope.state.selectedNode = null;
    };

    GraphCreator.prototype.removeSelectFromEdge = function(){
      var thisGraph = this;
      thisGraph.paths.filter(function(cd){
        return cd === $scope.state.selectedEdge;
      }).classed(thisGraph.consts.selectedClass, false);
      $scope.state.selectedEdge = null;
    };
//将节点移动到可见区域
    GraphCreator.prototype.moveNodeToVisibleArea = function(stageInstance) {
      var thisGraph = this,
        currentScale = $scope.state.currentScale,
        svgWidth = thisGraph.svg.style('width').replace('px', ''),
        svgHeight = thisGraph.svg.style('height').replace('px', ''),
        currentTranslatePos = this.zoom.translate(),
        startX = -(currentTranslatePos[0]),
        startY = -(currentTranslatePos[1]),
        endX = parseInt(startX) + parseInt(svgWidth),
        endY = parseInt(startY) + parseInt(svgHeight),
        nodeStartXPos = ((stageInstance.uiInfo.xPos) * currentScale),
        nodeStartYPos = ((stageInstance.uiInfo.yPos) * currentScale),
        nodeEndXPos = ((stageInstance.uiInfo.xPos + thisGraph.consts.rectWidth) * currentScale),
        nodeEndYPos = ((stageInstance.uiInfo.yPos + thisGraph.consts.rectHeight) * currentScale);

      if (parseInt(svgWidth) > 0 && parseInt(svgHeight) > 0 &&
        (nodeStartXPos < startX || nodeEndXPos > endX || nodeStartYPos < startY || nodeEndYPos > endY)) {
        thisGraph.moveNodeToCenter(stageInstance);
      }
    };
    
    GraphCreator.prototype.pathMouseDown = function(d3path, d){
      var thisGraph = this,
        state = $scope.state;
      d3.event.stopPropagation();
      state.mouseDownLink = d;

      if (state.selectedNode){
        thisGraph.removeSelectFromNode();
      }

      var prevEdge = state.selectedEdge;
      if (!prevEdge || prevEdge !== d){
        thisGraph.replaceSelectEdge(d3path, d);
      }
    };

    // mousedown on node//点击节点
    //点击节点 ----绑定了很多事件包括画布下面table中的所有数据显示
    GraphCreator.prototype.stageMouseDown = function(d3node, d){//d3node,d
//变量 d 是由D3.js提供的一个在匿名函数中的可用变量。这个变量是对当前要处理的元素的_data_属性的引用。
		if(d.one&&d.one.length>0 && d.uiInfo.name=='map'){
			for(var i=0;i<d.one.length;i++){
					d.one[i].now_ins = d.instanceName;
			}
		}

		$scope.options=d;


		if(d.outputLanes.indexOf('error')!==-1){
			_this.change_cotrollSelect = true;
		}
      var thisGraph = this,
        state = $scope.state;
	  var timep=d.instanceName;
	  $scope.down_found=true;
//当前节点为源节点
	if(d.uiInfo.stageType&&d.uiInfo.stageType=='SOURCE'){
			_this.cotrollSelect=true;
			_this.hideTable=false;
			_this.change_cotrollSelect = false;
			$scope.target_data=false;
			if(d.fieldArr){
				$scope.fieldArr = d.fieldArr;
			}else{
				$scope.fieldArr = [];
			}

			if(d.hiveName){
				_this.selectedData = d;
				_this.selectedData.tableName=d.hiveName;
			}else{
				_this.selectedData = [];
			} 		
	}else if(d.uiInfo.stageType&&d.uiInfo.stageType=='PROCESSOR'){
		

	if(d.one.length>0){
		$scope.d_data=d.one;//从one中
		$scope.choice_field_arr = $scope.all_d_data_obj[d.instanceName].choice_fieldArr;
	}else{
		$scope.d_data=[];
		$scope.choice_field_arr = [];
	}
	//以下都是判断当前节点某个key是否存在，如果存在将数据展示到页面上--这里用了ng的双向绑定
	if(d.dropData){
		if(!$scope.dropData_k || !($scope.dropData_k.length>0)){
			$scope.dropData_k = d.dropData;
		}else if($scope.dropData_k && $scope.dropData_k.length>0 && $scope.dropData_k[0].instanceName !== d.instanceName){
			$scope.dropData_k = d.dropData;	
		}
		}else{
			$scope.dropData_k = [];
		}
		
		if(d.cognate){
			$scope.cognate_all_data = d.cognate;
		}else{
			$scope.cognate_all_data = [];
		}
		if(d.filter){
			$scope.xy_filter_all_data = d.filter;
		}else{
			$scope.xy_filter_all_data = [];
		}
		if(d.map_filter){
			$scope.map_filter_all_data = d.map_filter;
		}else{
			$scope.map_filter_all_data = [];
		}
		$scope.target_data=false;	
		if(d.uiInfo.name=='map'){
			_this.cotrollSelect=false;
			_this.hideTable=true;
			_this.change_cotrollSelect = false;

		}else if(d.uiInfo.name=='change_rules'){//需要增加判断，优化性能
			//如果源数据有多个
			$scope.filter_data = [];
			if(d.one.length>0){
					$scope.d_data=d.one;//从one中
					$scope.filter_data = $scope.all_d_data_obj[d.instanceName].choice_fieldArr;
				}else{
					$scope.d_data=[];
					$scope.filter_data = [];
				}
				$scope.$apply();
			_this.change_cotrollSelect = true;
			_this.hideTable=false;
		}	
	}else{
		//如果点击的是target
		_this.cotrollSelect=false;
		_this.hideTable=true;
		_this.change_cotrollSelect = false;
		$scope.target_data=true;
		if(d.targetName){
			$scope.targetName = d.targetName;
		}else{
			$scope.targetName = "";
		}
		if(d.dropData!==null){	
			
			if(d.dropData){
				$scope.dropData_L = d.dropData;
			}else{
				$scope.dropData_L = [];
			}
		}
			this.cotrollSelect=false;
			_this.hideTable=false;
			_this.change_cotrollSelect = false;
	}
	d3.event.stopPropagation();
    this.updateGraph();
    $scope.$apply();
    state.mouseDownNode = d;
      if (state.shiftNodeDrag){
        // reposition dragged directed edge--重定位拖动定向边
        thisGraph.dragLine.classed('hidden', false)        
          .attr('d', 'M' + d.uiInfo.xPos + ',' + d.uiInfo.yPos + 'L' + d.uiInfo.xPos + ',' + d.uiInfo.yPos);
      }
      
  	if($('#myTab').find('.active').css('height')==='0px' && $('#myTab').find('.active').css('width')==='0px' && d.uiInfo && d.uiInfo.name !== 'map'){
  		common_found(1);
	}
  	setTimeout(function(){$scope.title_tip();})
    };

    // mouseup on nodes
    //鼠标抬起事件
    GraphCreator.prototype.stageMouseUp = function(d3node, d){
      var thisGraph = this,
        state = $scope.state,
        consts = thisGraph.consts;
      // reset the states
      state.shiftNodeDrag = false;
      d3node.classed(consts.connectClass, false);
      var mouseDownNode = state.mouseDownNode,
        mouseDownNodeLane = state.mouseDownNodeLane,
        mouseDownNodeEventLane = state.mouseDownNodeEventLane;

      if (!mouseDownNode) {
        return;
      }
      thisGraph.dragLine.classed('hidden', true);
      //判断是否拖拽
      //在其中通过判断source和target的某些属性是否存在来进行值得传递
      if (mouseDownNode.instanceName && mouseDownNode.instanceName !== d.instanceName &&
        d.uiInfo.stageType !== pipelineConstant.SOURCE_STAGE_TYPE && !thisGraph.isReadOnly){
    	
        var newEdge = {//增加新的箭头线段
          source: mouseDownNode,
          target: d
        };
        var t_ins,s_ins;
		t_ins = newEdge.target.instanceName;
		s_ins = newEdge.source.instanceName;
        if (mouseDownNodeLane) {
          newEdge.outputLane = mouseDownNodeLane;
        } else if (mouseDownNodeEventLane) {
          newEdge.eventLane = mouseDownNodeEventLane;
        }
        var filtRes = thisGraph.paths.filter(function(d){
          return d.source.instanceName === newEdge.source.instanceName &&
            d.target.instanceName === newEdge.target.instanceName;
        });
        if (!filtRes[0].length) {      	
//删除更改之后更新
        	newEdge.target.srcName = newEdge.source.instanceName;
        	
        	if(newEdge.source.filter){
        		if(!newEdge.target.filter){
            		newEdge.target.filter = newEdge.source.filter;
        		}else{
        			var obj = {};
        			obj.field=newEdge.source.filter.field;
        			obj.operate=newEdge.source.filter.operate;
        			obj.value=newEdge.source.filter.value;
        			newEdge.target.filter.push(obj);
        		}

        	}
        	
        	if(newEdge.source.hiveName&&!newEdge.target.hiveName){//hive表名
        		newEdge.target.hiveName = newEdge.source.hiveName;	
        	}
        	

			
		  if(newEdge.source.uiInfo.stageType=='SOURCE'&&newEdge.source.fieldArr!==undefined){//如果源节点中存在数据
			  //如果source是源节点
			  
			  newEdge.source.sortNum = 1;			  
	        	//增加层级，初始默认为1
			  if(newEdge.target.sortNum && newEdge.target.sortNum > newEdge.source.sortNum+1){
				  newEdge.target.sortNum = newEdge.target.sortNum;
			  }else{
				  newEdge.target.sortNum = newEdge.source.sortNum+1;				    
			  }
			  
			  var obj={};
				obj.instanceName=newEdge.source.instanceName;
				//obj.fieldArr=$scope.cloneObj(newEdge.source.fieldArr);
				obj.fieldArr = newEdge.source.fieldArr;
				
				
				obj.hiveName = newEdge.source.hiveName;
				newEdge.source.one = [];
				newEdge.source.one.push(obj);
				newEdge.target.one.push(obj);
				
				for(var i=0;i<obj.fieldArr.length;i++){
						if(obj.fieldArr[i][t_ins]!==undefined){
							obj.fieldArr[i][t_ins] = "";
						}
				}
				//存放了所有target的instanceName以及one数据
				if($scope.all_d_data_obj[t_ins]){//建立一个对象存放节点instanceName以及数据,键值对格式存放,随后将其加入sessionstorage，会话结束即销毁
					$scope.all_d_data_obj[t_ins][s_ins] = obj;
				}else{
					$scope.all_d_data_obj[t_ins] = {};
					$scope.all_d_data_obj[t_ins][s_ins] = obj;
				}
				
		  }else if(newEdge.source.uiInfo.stageType=='PROCESSOR'&&newEdge.target.uiInfo.stageType=='PROCESSOR'){
				//如果映射连接映射
			  if(newEdge.source.uiInfo.name=='change_rules' && newEdge.target.uiInfo.stageType=='PROCESSOR'){
				  if(newEdge.target.one && newEdge.target.one.length>0 && newEdge.source.one && newEdge.source.one.length>0){
					  for(var i=0;i<newEdge.source.one.length;i++){
						  	var obj = {};
						  	obj.instanceName=newEdge.source.one[i].instanceName;
							obj.fieldArr=$scope.cloneObj(newEdge.source.one[i].fieldArr);							
							obj.hiveName = newEdge.source.one[i].hiveName;
							obj.source_instanceName = newEdge.source.instanceName;
							newEdge.target.one.push(obj);
					  }
				  }else if(!newEdge.target.one || newEdge.target.one.length<1){
					  newEdge.target.one = [];
					  for(var i=0;i<newEdge.source.one.length;i++){
						  	var obj = {};
						  	obj.instanceName=newEdge.source.one[i].instanceName;
							obj.fieldArr=$scope.cloneObj(newEdge.source.one[i].fieldArr);							
							obj.hiveName = newEdge.source.one[i].hiveName;
							obj.source_instanceName = newEdge.source.instanceName;
							newEdge.target.one.push(obj);
					  }
				  }
			  }else{
				  newEdge.target.dropData=[];					 
				  newEdge.target.dropData=$scope.cloneObj(newEdge.source.dropData);
				  newEdge.target.one = $scope.cloneObj(newEdge.source.one);
			  }
			  
			  
			  if(newEdge.target.sortNum && newEdge.target.sortNum > newEdge.source.sortNum){
				  newEdge.target.sortNum = newEdge.target.sortNum;
			  }else{
				  newEdge.target.sortNum = newEdge.source.sortNum+1;
			  }
			  
				  $scope.all_d_data_obj[t_ins] = $scope.all_d_data_obj[s_ins];
		  }else{
			  if(newEdge.source.uiInfo.stageType=='SOURCE' && newEdge.source.uiInfo.stageType == 'TARGET'){
				  
			  }
			  
			  if(!newEdge.source.sortNum && newEdge.source.uiInfo.stageType=='SOURCE'){
				  newEdge.source.sortNum = 1;
				  if(newEdge.target.sortNum && newEdge.target.sortNum > newEdge.source.sortNum){
					  newEdge.target.sortNum = newEdge.target.sortNum;
				  }else{
					  newEdge.target.sortNum = newEdge.source.sortNum+1;
				  }	
			  }else{
				  if(newEdge.target.sortNum && newEdge.target.sortNum > newEdge.source.sortNum){
					  newEdge.target.sortNum = newEdge.target.sortNum;
				  }else{
					  newEdge.target.sortNum = newEdge.source.sortNum+1;
				  }				  
			  }

		  }
          
		  if(newEdge.source.dropData!==null&&newEdge.target.uiInfo.stageType==='TARGET'){//判断是否存在dropData，输出目标是否是target
			  
			 // newEdge.target.cognate  = newEdge.source.cognate;//关联传入target
			  if(newEdge.target.dropData&&newEdge.target.dropData.length>0){//如果已经存在值，拆解插入target中
				  var other_arr = newEdge.source.dropData;
				  for(var x in other_arr){
					  newEdge.target.dropData.push(other_arr[x])
				  }
			  }else{
				  newEdge.target.dropData = newEdge.source.dropData;
			  }
			  if(newEdge.target.cognate&&newEdge.target.cognate.length>0){
				  var other_arr = newEdge.source.cognate;
				  for(var x in other_arr){
					  newEdge.target.cognate.push(other_arr[x]);
				  }
			  }else{
				  newEdge.target.cognate = newEdge.source.cognate;
			  }
		  }
          thisGraph.edges.push(newEdge);//将新的箭头线段加入画布中
         
          
          $scope.update_all_attributes = true;
          thisGraph.updateGraph();
          
          //此时传值
          $scope.$apply(function() {
            //Double Check--再检查一遍
            if (newEdge.source.instanceName !== newEdge.target.instanceName) {
              if (!newEdge.target.inputLanes) {
                newEdge.target.inputLanes = [];
              }
              	
              if (newEdge.source.outputLanes && newEdge.source.outputLanes.length && mouseDownNodeLane) {
                newEdge.target.inputLanes.push(mouseDownNodeLane);
              } else if (newEdge.source.eventLanes && newEdge.source.eventLanes.length && mouseDownNodeEventLane) {
                newEdge.target.inputLanes.push(mouseDownNodeEventLane);
              }
            }
            
            
          });
          //debugger;
        }
      } else {
        state.justDragged = false;
        // state.selectedNode = null;
        if (state.selectedEdge){
          thisGraph.removeSelectFromEdge();
        }
        var prevNode = state.selectedNode;
        if (!prevNode || prevNode.instanceName !== d.instanceName){
          // if(true){
          thisGraph.replaceSelectNode(d3node, d);
        }
      }
      state.mouseDownNode = null;
      state.mouseDownNodeLane = null;
      state.mouseDownNodeEventLane = null;      
    }; // end of rects mouseup


    
    // mousedown on main svg--svg鼠标按下
    GraphCreator.prototype.svgMouseDown = function(){
	  $scope.down_found=false;
      $scope.state.graphMouseDown = true;
 
    };

    // mouseup on main svg
    GraphCreator.prototype.svgMouseUp = function(){
     
      var thisGraph = this,
        state = $scope.state;
      if (state.justScaleTransGraph) {
        // dragged not clicked
        state.justScaleTransGraph = false;
      } else if (state.shiftNodeDrag){
        // dragged from node
        state.shiftNodeDrag = false;
        thisGraph.dragLine.classed('hidden', true);
      } else if ($scope.state.graphMouseDown) {
        if ($scope.state.selectedNode) {
          this.removeSelectFromNode();
        } else if ($scope.state.selectedEdge) {
          this.removeSelectFromEdge();
        }

        $scope.$apply(function(){
          $scope.$emit('onRemoveNodeSelection', {
            selectedObject: undefined,
            type: pipelineConstant.PIPELINE
          });
        });
      }
      state.graphMouseDown = false;
    };

    // keydown on main svg
    GraphCreator.prototype.svgKeyDown = function() {//在IE下正常，在谷歌下不能正常响应
 	// alert('keydown on main svg');
      var thisGraph = this,
        state = $scope.state,
        consts = thisGraph.consts;

      // make sure repeated key presses don't register for each keydown
      if (state.lastKeyDown !== -1 && state.lastKeyDown !== consts.COMMAND_KEY &&
        state.lastKeyDown !== consts.CTRL_KEY) {
        return;
      }

      state.lastKeyDown = d3.event.keyCode;
      var selectedNode = state.selectedNode,
        selectedEdge = state.selectedEdge;

      switch(d3.event.keyCode) {
        case consts.BACKSPACE_KEY:
        case consts.DELETE_KEY:
          d3.event.preventDefault();
          $scope.$apply(function() {
            $scope.deleteSelected();
          });
          break;

        case consts.COPY_KEY:
          if((d3.event.metaKey || d3.event.ctrlKey) && selectedNode) {
            $rootScope.common.copiedStage = selectedNode;
          }
          break;


        case consts.PASTE_KEY:
          if (thisGraph.isReadOnly) {
            return;
          }
          if((d3.event.metaKey || d3.event.ctrlKey) && $rootScope.common.copiedStage) {
            $scope.$apply(function() {
              $scope.$emit('onPasteNode', $rootScope.common.copiedStage);
            });
          }
          break;
      }
    };

    GraphCreator.prototype.svgKeyUp = function() {
      $scope.state.lastKeyDown = -1;
    
    };
/**
 * 绑定在对象原型上的方法addNode
 * 增加节点
 * 其中this指向对象Graph(画布)
 * */
    GraphCreator.prototype.addNode = function(node, edges, relativeX, relativeY) {

      var thisGraph = this;
      // console.log(thisGraph)
      if(thisGraph.nodes.length&&thisGraph.nodes.length>0){//改变初始坐标
        node.uiInfo.xPos=thisGraph.nodes[thisGraph.nodes.length-1].uiInfo.xPos+180;
      }else{
        node.uiInfo.xPos=30;
      }

      if (relativeX && relativeY) {
/*        var offsets = $element[0].getBoundingClientRect(),
          top = offsets.top,
          left = offsets.left,
          currentTranslatePos = thisGraph.zoom.translate(),
          startX = (currentTranslatePos[0] + left),
          startY = (currentTranslatePos[1] + top);
        node.uiInfo.xPos = (relativeX - startX)/ $scope.state.currentScale;
        node.uiInfo.yPos = (relativeY - startY)/ $scope.state.currentScale;*/
      }

      thisGraph.nodes.push(node);//将节点存入nodes中----

      if (edges) {
        thisGraph.edges = edges;
      }
      thisGraph.updateGraph();
      thisGraph.selectNode(node);//实例化
      //save_pipeline.push(thisGraph);
      $scope.save_pipeline = thisGraph;
      if (relativeX) {
        thisGraph.moveNodeToVisibleArea(node);
      }

    };


    GraphCreator.prototype.selectNode = function(node) {//选中节点
      var thisGraph = this,
        nodeExists,
        addedNode = thisGraph.rects.filter(function(cd){
          if (cd.instanceName === node.instanceName) {
            nodeExists = true;
          }
          return cd.instanceName === node.instanceName;
        });
      if (nodeExists) {
        thisGraph.replaceSelectNode(addedNode, node);
      }
    };

    GraphCreator.prototype.selectEdge = function(edge) {
    	//alert('selectEdge')
      var thisGraph = this,
        edgeExists,
        addedEdge = thisGraph.paths.filter(function(d){
          if (d.source.instanceName === edge.source.instanceName &&
            d.target.instanceName === edge.target.instanceName) {
            edgeExists = true;
            return true;
          }
          return false;
        });

      if (edgeExists) {
        thisGraph.replaceSelectEdge(addedEdge, edge);
      }
    };
    
/*	监听all_d_data_obj//暂时仅存放map映射中的信息
 * 	对象结构为{
 * 		map-instanceName:{
 * 			hive-instanceName:{fieldArr{},hiveName:"",instanceName:""},
 * 			choice-fieldArr:{}
 * 		},		
 *  	map-instanceName:{
 * 			hive-instanceName:{fieldArr{},hiveName:"",instanceName:""},
 * 			choice-fieldArr:{}
 * 		},
 * }
 * */
	$scope.$watch('all_d_data_obj',function(newValue,oldValue){
			//如果存在改变，应该同步改变关联的值
		
			for(var i in newValue){//第一层
				var arr = [];
				for(var j in newValue[i]){//第二层
					for(var k in newValue[i][j].fieldArr){//第三层
						newValue[i][j].fieldArr[k].instanceName = j;
						arr.push(newValue[i][j].fieldArr[k]);
					}				
				}
				newValue[i].choice_fieldArr = arr;	
			}
	},true)
    
	//对象原型上绑定的方法，移动节点到中心，当前产品中没有用到
    GraphCreator.prototype.moveNodeToCenter = function(stageInstance) {
      var thisGraph = this,
        consts = thisGraph.consts,
        svgWidth = thisGraph.svg.style('width').replace('px', ''),
        svgHeight = thisGraph.svg.style('height').replace('px', ''),
        currentScale = $scope.state.currentScale,
        x = svgWidth / 2 - (stageInstance.uiInfo.xPos + consts.rectWidth/2) * currentScale,
        y = svgHeight / 2 - (stageInstance.uiInfo.yPos + consts.rectHeight/2) * currentScale;

      showTransition = true;
      this.zoom.translate([x, y]).event(this.svg);
    };
	
    // call to propagate changes to graph--调用对图的传播更改
    // 关键代码 所有对画布的更改，调用此方法更新到画布
    GraphCreator.prototype.updateGraph = function(){
		  var thisGraph = this,
		    consts = thisGraph.consts,
		    state = $scope.state,
		    stageErrorCounts = thisGraph.stageErrorCounts,
		    firstConfigIssue;
		
		  //判断某个节点是否存在输入连线
    		var check = function (ins){
    			var arr = graph.edges;
    			var s_arr;
    			 for(var i=0;i<arr.length;i++){//判断是否还存在连线
             		if(arr[i].target.instanceName === ins){
             			s_arr = true;
             		}
    			 }
    			 return s_arr;
    	    }
      thisGraph.paths = thisGraph.paths.data(thisGraph.edges, function(d){
        return String(d.source.instanceName) + '+' + String(d.target.instanceName);
      });
      // 更新存在的节点
      //$scope.update_all_attributes 一个属性，默认false，判断是否需要更新所有节点上的属性
      if($scope.update_all_attributes){
  		if(graph.nodes && graph.edges){
  			
  			for(var n=0;n<graph.nodes.length;n++){//循环节点，寻找对应的输入和输出,寻找和节点相关的线段，找到其中最大的sortNum
  				//-----------------------------
  				var node_ins = graph.nodes[n];
  				var node_edge = graph.edges.filter(function(l) {//找到其中的所有输入线段--返回一个数组
  		          return (l.target.instanceName === node_ins.instanceName);
  		        });
  		        var found_max_sort = [];	     
  		        	for(var i=0;i<node_edge.length;i++){//遍历找出其中最大的sortNum，赋值给当前的node
  						if(node_edge[i].source.sortNum){
  							found_max_sort.push(node_edge[i].source.sortNum)
  						}
  					}
  		        if(node_edge.length<1 && graph.nodes[n].uiInfo.stageType !== 'SOURCE'){//如果没有任何输入又不是源节点，就置空属性
  		        	graph.nodes[n].one = [];
  		        	graph.nodes[n].filter = [];
  		        	graph.nodes[n].hiveName = [];
  		        	graph.nodes[n].srcName = [];
  		        	graph.nodes[n].dropData = [];
  		        	graph.nodes[n].cognate = [];
  		        	graph.nodes[n].map_filter = [];
  		        	//$scope.$apply();
  		        }
  				if(found_max_sort.length>0){
  					var max_sortNum = Math.max.apply(null,found_max_sort);
  					if(node_ins.sortNum < max_sortNum+1){
  						node_ins.sortNum = max_sortNum + 1;
  					}
  				}else{
  					node_ins.sortNum = 1;
  				}
  			}
  		}

    $scope.all_source_edges = function(node){//返回node的所有输入线段
  	toSplice = thisGraph.edges.filter(function(l) {
        return (l.target.instanceName === node.instanceName);
      });
  	return toSplice;
    }
  //多条输入，更新
  //连线之后更新--删除之后，重新选择表，
  //根据graph所有边--更新某条边的source和target节点中的属性
  	for(var i=0;i<this.edges.length;i++){
  		if(this.edges[i].source.one && this.edges[i].source.one.length>0){
  			//返回所有输入线段
  			var pause_source = $scope.all_source_edges(this.edges[i].target);
	  		var o_arr = [];
	  		var o_hiveName = [];
	  		for(var h=0;h<pause_source.length;h++){
	  			if(pause_source[h].source.one && pause_source[h].source.one.length>0){
	  	  			if(this.edges[i].source.uiInfo.stageType === 'SOURCE'){
	  	  				//debugger;
	  	  			}
	  				for(var m=0;m<pause_source[h].source.one.length;m++){
	  	  					o_hiveName.push(pause_source[h].source.one[m].hiveName);
	  	  					o_arr.push(pause_source[h].source.one[m]);
	  				}				
	  			}
	  		}
	  		if(o_arr.length>0){
	  			this.edges[i].target.one = o_arr;
	  		}
  		}
  		
  	if(this.edges[i].source.cognate!==undefined){
  		var pause_source = $scope.all_source_edges(this.edges[i].target);
  		var o_arr = [];
  		for(var h=0;h<pause_source.length;h++){
  			if(pause_source[h].source.cognate && pause_source[h].source.cognate.length>0){
  				
  				for(var m=0;m<pause_source[h].source.cognate.length;m++){
  					o_arr.push(pause_source[h].source.cognate[m]);
  				}				
  			}
  		}
  		if(o_arr.length>0){
  			this.edges[i].target.cognate = o_arr;
  		}
  	}
  	if(this.edges[i].source.filter!==undefined){
  		var pause_source = $scope.all_source_edges(this.edges[i].target);
  		var o_arr = [];
  		for(var h=0;h<pause_source.length;h++){
  			if(pause_source[h].source.filter && pause_source[h].source.filter.length>0){
  				for(var m=0;m<pause_source[h].source.filter.length;m++){
  					o_arr.push(pause_source[h].source.filter[m]);
  				}				
  			}
  		}
  		if(o_arr.length>0){
  			this.edges[i].target.filter = o_arr;
  		}
  		//this.edges[i].target.filter = this.edges[i].source.filter;   			
  	}
  	if(this.edges[i].source.map_filter!==undefined){
  		var pause_source = $scope.all_source_edges(this.edges[i].target);
  		var o_arr = [];
  		for(var h=0;h<pause_source.length;h++){
  			if(pause_source[h].source.map_filter && pause_source[h].source.map_filter.length>0){
  				for(var m=0;m<pause_source[h].source.map_filter.length;m++){
  					o_arr.push(pause_source[h].source.map_filter[m]);
  				}				
  			}
  		}
  		if(o_arr.length>0){
  			this.edges[i].target.map_filter = o_arr;
  		}
  		//this.edges[i].target.map_filter = this.edges[i].source.map_filter;   			
  	}
  	if(this.edges[i].source.dropData!==undefined){
  		var pause_source = $scope.all_source_edges(this.edges[i].target);
  		var o_arr = [];
  		for(var h=0;h<pause_source.length;h++){
  			if(pause_source[h].source.dropData && pause_source[h].source.dropData.length>0){
  				for(var m=0;m<pause_source[h].source.dropData.length;m++){
  					o_arr.push(pause_source[h].source.dropData[m]);
  				}				
  			}
  		}
  		if(o_arr.length>0){
  			this.edges[i].target.dropData = o_arr;
  		}
  		//this.edges[i].target.dropData = this.edges[i].source.dropData;
  	}

  	//如果任意一个输入节点都不存在某一属性，那么该输出节点也不应该存在该属性
  	}
  	//将所有map_processor节点以键值对格式存放入all_d_data_obj
  	for(var n=0;n<this.nodes.length;n++){
  		if(this.nodes[n].uiInfo.stageType == 'PROCESSOR'){
  			$scope.all_d_data_obj[this.nodes[n].instanceName] = {};
  			if(this.nodes[n].one && this.nodes[n].one.length>0){
  	  			for(var i=0;i<this.nodes[n].one.length;i++){
  	  				$scope.all_d_data_obj[this.nodes[n].instanceName][this.nodes[n].one[i].instanceName] = this.nodes[n].one[i];
  	  			}
  			}

  			//$scope.all_d_data_obj[this.nodes[n].instanceName] = this.nodes[n].one;
  		}
  	}
  
  	$scope.update_all_attributes = false;
  }
     
      thisGraph.rects = thisGraph.rects.data(thisGraph.nodes, function(d) {
        return d.instanceName;
      });
      thisGraph.rects.attr('transform', function(d) {
        return 'translate(' + (d.uiInfo.xPos) + ',' + (d.uiInfo.yPos) + ')';
      });
	  if(!thisGraph.edges.length){
	  	$scope.judgement=true;
	  }else{
	  	$scope.judgement=false;
	  }
      // 增加新的节点并绑定事件
      var newGs= thisGraph.rects.enter()
        .append('g');
newGs.classed(consts.rectGClass, true)
        .attr('transform', function(d){return 'translate(' + d.uiInfo.xPos + ',' + d.uiInfo.yPos + ')';})
        .on('mouseover', function(d){
          if (state.shiftNodeDrag){
            d3.select(this).classed(consts.connectClass, true);
          }
        })
        .on('mouseout', function(d){
          d3.select(this).classed(consts.connectClass, false);
        })
        .on('mousedown', function(d){
          thisGraph.stageMouseDown.call(thisGraph, d3.select(this), d);
          var options = {
            selectedObject: d,
            type: pipelineConstant.STAGE_INSTANCE
          };
          //if($scope.state.selectedNode)
         // $scope.state.selectedNode=d;
          if (firstConfigIssue) {
            options.detailTabName = 'configuration';
            options.configGroup = firstConfigIssue.configGroup;
            options.configName =  firstConfigIssue.configName;
          }

          if ($scope.state.showBadRecords) {
            options.detailTabName = 'errors';
          } else if ($scope.state.showConfiguration) {
            options.detailTabName = 'configuration';
          }
          //不同层级的controller间的通信，这里没有用到
          /*$scope.$apply(function(){
            $scope.$emit('onNodeSelection', options);
          });*/
        })
        .on('mouseup', function(d){
          thisGraph.stageMouseUp.call(thisGraph, d3.select(this), d);
        })
        .call(thisGraph.drag);

      newGs.append('rect')//画出轮廓方形
        .attr({
          'height': this.consts.rectHeight,
          'width': this.consts.rectWidth,
          'rx': this.consts.rectRound,
          'ry': this.consts.rectRound
        });

      //Event Connectors--事件连接器
      newGs.append('circle')
        .filter(function(d) {
     	// console.log('Event Connectors--事件连接器');
          return d.eventLanes.length;
        })
        .attr({
          'cx': consts.rectWidth/2,
          'cy': consts.rectHeight,
          'r': 10,
          'class': function(d) {
            return 'graph-bootstrap-tooltip ' + d.eventLanes[0]
          },
          'title': 'Events'
        })
        .on('mousedown', function(d){//如果在连接点出按下鼠标，判定连线而非拖拽
          $scope.state.shiftNodeDrag = true;
          $scope.state.shiftNodeDragXPos = consts.rectWidth/2;
          $scope.state.shiftNodeDragYPos = consts.rectHeight;
          $scope.state.mouseDownNodeEventLane = d.eventLanes[0];
        });

      newGs.append('text')
        .filter(function(d) {
          return d.eventLanes.length;
        })
        .attr({
          'x': consts.rectWidth/2 - 5,
          'y': consts.rectHeight + 5,
          'class': 'lane-number graph-bootstrap-tooltip',
          'title': 'Events'
        })
        .text('E')
        .on('mousedown', function(d){
          $scope.state.shiftNodeDrag = true;
          $scope.state.shiftNodeDragXPos = consts.rectWidth/2;
          $scope.state.shiftNodeDragYPos = consts.rectHeight;
          $scope.state.mouseDownNodeEventLane = d.eventLanes[0];
        });

      //Input Connectors
      newGs.append('circle')
        .filter(function(d) {
          return d.uiInfo.stageType !== pipelineConstant.SOURCE_STAGE_TYPE;
        })
        .attr({
          'cx': 0,
          'cy': consts.rectHeight/2,
          'r': 10
        });
      //Output Connectors
      newGs.each(function(d) {
        var stageNode = d3.select(this);
        //Output Connectors
        if (d.uiInfo.stageType !== pipelineConstant.TARGET_STAGE_TYPE && d.uiInfo.stageType !== pipelineConstant.EXECUTOR_STAGE_TYPE) {
            if(typeof(d.outputLanes)==='string'){
              var a = d.outputLanes;
              d.outputLanes = [];
              d.outputLanes.push(a);
            }
            var totalLanes = d.outputLanes.length,
            lanePredicatesConfiguration = _.find(d.configuration, function(configuration) {
              return configuration.name === 'lanePredicates';
            }),
            outputStreamLabels = d.uiInfo.outputStreamLabels;
          angular.forEach(d.outputLanes, function(lane, index) {
            var y = Math.round(((consts.rectHeight) / (2 * totalLanes) ) +
              ((consts.rectHeight * (index))/totalLanes)),
              lanePredicate = lanePredicatesConfiguration ? lanePredicatesConfiguration.value[index] : undefined,
              outputStreamLabel = outputStreamLabels ? outputStreamLabels[index] : undefined;
            stageNode
              .append('circle')
              .attr({
                'cx': consts.rectWidth,
                'cy': y,
                'r': 10,
                'class': 'graph-bootstrap-tooltip ' + lane,
                'title': lanePredicate ? lanePredicate.predicate : ''
              }).on('mousedown', function(d){
                $scope.state.shiftNodeDrag = true;
                $scope.state.shiftNodeDragXPos = thisGraph.consts.rectWidth;
                $scope.state.shiftNodeDragYPos = y;
                $scope.state.mouseDownNodeLane = lane;
              });

            if (totalLanes > 1) {
              stageNode
                .append('text')
                .attr({
                  'x': consts.rectWidth - 3,
                  'y': y + 5,
                  'class': 'lane-number graph-bootstrap-tooltip',
                  'title': lanePredicate ? lanePredicate.predicate : outputStreamLabel
                })
                .text(index+1)
                .on('mousedown', function(d){
                  $scope.state.shiftNodeDrag = true;
                  $scope.state.shiftNodeDragXPos = thisGraph.consts.rectWidth;
                  $scope.state.shiftNodeDragYPos = y;
                  $scope.state.mouseDownNodeLane = lane;
                });
            }

          });
        }
        thisGraph.insertTitleLinebreaks(stageNode, d.uiInfo.label);
      });

      //Add Stage icons
      newGs.append('svg:image')
        .attr('class', 'node-icon')
        .attr('x',(consts.rectWidth - 48)/2)
        .attr('y',10)
        .attr('width', 48)
        .attr('height', 48)
        .attr('xlink:href', function(d) {//增加图标
          //return '\images/icon.png';
        	//判断应该加什么图标
//        	return 'rest/v1/definitions/stages/' + d.library + '/' + d.stageName + '/icon';
       
        	return ''+adress_url+'static/common/img/'+d.uiInfo.name+'.png';
        });
      //Add Error icons
      newGs.append('svg:foreignObject')
        .filter(function(d) {
          return thisGraph.issues && thisGraph.issues.stageIssues &&
            thisGraph.issues.stageIssues[d.instanceName];
        })
        .attr('width', 30)
        .attr('height', 30)
        .attr('x', consts.rectWidth - 20)
        .attr('y', consts.rectHeight - 12)
        .append('xhtml:span')
        .attr('class', 'node-warning fa fa-exclamation-triangle graph-bootstrap-tooltip')
        .attr('title', function(d) {
          var issues = thisGraph.issues.stageIssues[d.instanceName],
            title = '<span class="stage-errors-tooltip">';

          angular.forEach(issues, function(issue) {
            title += pipelineService.getIssuesMessage(d, issue) + '<br>';
          });

          title += '</span>';

          return title;
        })
        .attr('data-html', true)
        .attr('data-placement', 'bottom')
        .on('mousedown', function(d) {
          var issues = thisGraph.issues.stageIssues[d.instanceName];
          angular.forEach(issues, function(issue) {
            if (issue.configName && !firstConfigIssue) {
              firstConfigIssue = issue;
            }
          });
        })
        .on('mouseup', function(d){
          firstConfigIssue = undefined;
        });

      //Add Configuration Icon
//    /*
      newGs.append('svg:foreignObject')
        .filter(function(d) {
          var configurationExists = false;

          angular.forEach(d.configuration, function(c) {
            if (c.value !== undefined && c.value !== null) {
              configurationExists = true;
            }
          });

          return configurationExists;
        })
        .attr('width', 20)
        .attr('height', 20)
        .attr('x', consts.rectWidth - 25)
        .attr('y', 10)
        .append('xhtml:span')
        .attr('class', 'node-config fa fa-gear graph-bootstrap-tooltip')
        .attr('title', function(d) {
        	return '数据'
//        return pipelineService.getStageConfigurationHTML(d);
        })
        .attr('data-html', true)
        .attr('data-placement', 'bottom')
        .on('mousedown', function() {
          $scope.state.showConfiguration = true;
        })
        .on('mouseup', function() {
          $scope.state.showConfiguration = false;
        });
//    */

      //Add bad records count
      newGs.append('svg:foreignObject')
        .attr('width', 100)
        .attr('height', 30)
        .attr('x', 10)
        .attr('y', 10)
        .append('xhtml:span')
        .attr('title', graphErrorBadgeLabel)
        .attr('class', 'badge alert-danger pointer graph-bootstrap-tooltip')
        .style('visibility', function(d) {
          if (stageErrorCounts && stageErrorCounts[d.instanceName] &&
            parseInt(stageErrorCounts[d.instanceName]) > 0) {
            return 'visible';
          } else {
            return 'hidden';
          }
        })
        .html(function(d) {
          if (stageErrorCounts) {
            //return $filter('abbreviateNumber')(stageErrorCounts[d.instanceName]);
          }
          return '';
        })
        .on('mousedown', function() {
          $scope.state.showBadRecords = true;
        })
        .on('mouseup', function() {
          $scope.state.showBadRecords = false;
        });


      // remove old nodes
      thisGraph.rects.exit().remove();

      var paths = thisGraph.paths;

      // update existing paths--更新存在的节点
      paths.selectAll('path')
        .style('marker-end', 'url(' + $location.absUrl() + '#end-arrow)')
        .classed(consts.selectedClass, function(d) {
     	// console.log(state.setlectedEdge);
          return d === state.selectedEdge;
        })
        .attr('d', function(d) {
          return thisGraph.getPathDValue(d);//返回正确的线段路径--直接加载的不能正确显示
        });

      paths.selectAll('.edge-preview-container')
        .classed(consts.selectedClass, function(d) {
          return d === state.selectedEdge;
        })
        .attr('x', function(d) {
          if (d.outputLane) {
            return (d.source.uiInfo.xPos + (consts.rectWidth) + (d.target.uiInfo.xPos -30))/2;
          } else if (d.eventLane) {
            return (d.source.uiInfo.xPos + (consts.rectWidth/2) + (d.target.uiInfo.xPos -30))/2;
          }
        })
        .attr('y', function(d) {
          if (d.outputLane) {
            var totalLanes = d.source.outputLanes.length,
              outputLaneIndex = _.indexOf(d.source.outputLanes, d.outputLane),
              y = Math.round(((consts.rectHeight) / (2 * totalLanes) ) + ((consts.rectHeight * (outputLaneIndex))/totalLanes));

            return ((d.source.uiInfo.yPos + y + d.target.uiInfo.yPos + consts.rectHeight/2))/2 - 20;
          } else if (d.eventLane) {
            return ((d.source.uiInfo.yPos + d.target.uiInfo.yPos + consts.rectHeight))/2 + 30;
          }
        });

      var pathNewGs= paths.enter()
        .append('g');


      pathNewGs
        .classed(consts.pathGClass, true)
        .on('mousedown', function(d) {

          if (!thisGraph.isPreviewMode) {
            thisGraph.pathMouseDown.call(thisGraph, d3.select(this), d);
            $scope.$apply(function(){
              $scope.$emit('onEdgeSelection', d);
            });
          }
        })
        .on('mouseup', function(d) {
          state.mouseDownLink = null;
        });
      // add new paths--绘制连接线段
      pathNewGs
        .append('path')
        .style('marker-end', 'url(' + $location.absUrl() + '#end-arrow)')
        .classed('link', true)
        .attr('d', function(d) {
          return thisGraph.getPathDValue(d);
        });
      var choice = $(pathNewGs[0]);  
      //循环找出效验的节点，给不同的输出加上不同的颜色
      if(choice.length>1){
    	 // var L = $(pathNewGs[0]).length-1;    	  
    	  for(var i = 0;i<choice.length;i++){
    		  if(choice[i]!==null){
        		  if(choice[i].__data__ && choice[i].__data__.outputLane == 'error'){
        			  choice.eq(i).find('path').css('stroke','red');
        		  }else if(choice[i].__data__ && choice[i].__data__.outputLane == 'success'){
        			  choice.eq(i).find('path').css('stroke','gray');
        		  }    			  
    		  }
    	  }    	  
      }

      if (thisGraph.showEdgePreviewIcon) {//中间线上的点
        pathNewGs
          .append('svg:foreignObject')
          .attr('class', 'edge-preview-container graph-bootstrap-tooltip')
          .attr('width', 25)
          .attr('height', 25)
          .attr('x', function(d) {
            if (d.outputLane) {
              return (d.source.uiInfo.xPos + (consts.rectWidth) + (d.target.uiInfo.xPos -30))/2;
            } else if (d.eventLane) {
              return (d.source.uiInfo.xPos + (consts.rectWidth/2) + (d.target.uiInfo.xPos -30))/2;
            }
          })
          .attr('y', function(d) {
            if (d.outputLane) {
              var totalLanes = d.source.outputLanes.length,
                outputLaneIndex = _.indexOf(d.source.outputLanes, d.outputLane),
                y = Math.round(((consts.rectHeight) / (2 * totalLanes) ) + ((consts.rectHeight * (outputLaneIndex))/totalLanes));

              return ((d.source.uiInfo.yPos + y + d.target.uiInfo.yPos + consts.rectHeight/2))/2 - 20;
            } else if (d.eventLane) {
              return ((d.source.uiInfo.yPos + d.target.uiInfo.yPos + consts.rectHeight))/2 + 30;
            }
          })
          .append('xhtml:span')
          .attr('class', function(d) {//
            return getEdgePreviewIcon(graph.pipelineRules, graph.triggeredAlerts, d);
          });
      }

      // remove old links
      paths.exit().remove();

      //Pipeline Warning
      if (graph.issues && graph.issues.pipelineIssues) {
        var pipelineIssuesStr = '';

        angular.forEach(graph.issues.pipelineIssues, function(issue) {
          pipelineIssuesStr += issue.message + '<br>';
        });

        if (graph.errorStage && graph.errorStage.instanceName &&
          graph.issues.stageIssues[graph.errorStage.instanceName]) {
          angular.forEach(graph.issues.stageIssues[graph.errorStage.instanceName], function(issue) {
            pipelineIssuesStr += issue.message + '<br>';
          });
        }

        if (pipelineIssuesStr) {
          graphWarning
            .attr({
              'title': pipelineIssuesStr,
              'data-original-title': pipelineIssuesStr
            })
            .style('visibility', 'visible');
        } else {
          graphWarning.style('visibility', 'hidden');
        }

      } else {
        graphWarning.style('visibility', 'hidden');
      }


      $('.graph-bootstrap-tooltip').each(function() {
        var $this = $(this),
          title = $this.attr('title');
        if (title) {
          $this.attr('title', '');
          $this.tooltip({
            title: title,
            container:'body'
          });
        }
      });
      $scope.save_pipeline = thisGraph; 
    };
    GraphCreator.prototype.getPathDValue = function(d) {
      // this.edges.source.uiInfo.xPos = this.nodes.source.uiInf.xPos;   
      var thisGraph = this;
      var consts = thisGraph.consts;
      var sourceX;
      var sourceY;
      var targetX;
      var targetY;
      var sourceTangentX;
      var sourceTangentY;
      var targetTangentX;
      var targetTangentY;
      if (d.outputLane) {
        var totalLanes = d.source.outputLanes.length;
        var outputLaneIndex = _.indexOf(d.source.outputLanes, d.outputLane);
        var y = Math.round(
          ((consts.rectHeight) / (2 * totalLanes) ) + ((consts.rectHeight * (outputLaneIndex)) / totalLanes)
        );
        sourceX = (d.source.uiInfo.xPos + consts.rectWidth);
        sourceY = (d.source.uiInfo.yPos + y);

        if (d.target.uiInfo.xPos > (sourceX + 30)) {
          targetX = (d.target.uiInfo.xPos - 30);
        } else if (d.target.uiInfo.xPos > sourceX) {
          targetX = (d.target.uiInfo.xPos + 10);
        } else {
          targetX = (d.target.uiInfo.xPos + 30);
        }
        targetY = (d.target.uiInfo.yPos + consts.rectWidth/2 - 20);

        sourceTangentX = sourceX + (targetX - sourceX)/2;
        sourceTangentY = sourceY;
        targetTangentX = targetX - (targetX - sourceX)/2;
        targetTangentY = targetY;

      } else if (d.eventLane) {
        sourceX = (d.source.uiInfo.xPos + (consts.rectWidth / 2));
        sourceY = (d.source.uiInfo.yPos + consts.rectHeight);

        if (d.target.uiInfo.xPos > (sourceX + 30)) {
          targetX = (d.target.uiInfo.xPos - 30);
        } else if (d.target.uiInfo.xPos > sourceX) {
          targetX = (d.target.uiInfo.xPos + 10);
        } else {
          targetX = (d.target.uiInfo.xPos + 30);
        }
        targetY = (d.target.uiInfo.yPos + consts.rectWidth/2 - 20);

        sourceTangentX = sourceX;
        sourceTangentY = sourceY;
        targetTangentX = targetX - (targetX - sourceX)/2;
        targetTangentY = targetY;        
      }
      return 'M ' + sourceX + ',' + sourceY +
        'C' + sourceTangentX + ',' + sourceTangentY + ' ' +
        targetTangentX + ',' + targetTangentY + ' ' +
        targetX + ',' + targetY;
    };

    GraphCreator.prototype.zoomed = function() {
      $scope.state.justScaleTransGraph = true;

      if (showTransition) {
        showTransition = false;
        this.svgG
          .transition()
          .duration(750)
          .attr('transform', 'translate(' + d3.event.translate + ') scale(' + d3.event.scale + ')');
      } else {
        this.svgG
          .attr('transform', 'translate(' + d3.event.translate + ') scale(' + d3.event.scale + ')');
      }

    };
//绑定放大缩小平移的方法
    GraphCreator.prototype.zoomIn = function() {
      if ($scope.state.currentScale < this.zoom.scaleExtent()[1]) {
        $scope.state.currentScale = Math.round(($scope.state.currentScale + 0.1) * 10)/10 ;
        this.zoom.scale($scope.state.currentScale).event(this.svg);
      }
    };

    GraphCreator.prototype.zoomOut = function() {
      if ($scope.state.currentScale > this.zoom.scaleExtent()[0]) {
        $scope.state.currentScale = Math.round(($scope.state.currentScale - 0.1) * 10)/10 ;
        this.zoom.scale($scope.state.currentScale).event(this.svg);
      }
    };

    GraphCreator.prototype.panUp = function() {
      var translatePos = this.zoom.translate();
      translatePos[1] += 150;
      showTransition = true;
      this.zoom.translate(translatePos).event(this.svg);
    };

    GraphCreator.prototype.panRight = function() {
      var translatePos = this.zoom.translate();
      translatePos[0] -= 250;
      showTransition = true;
      this.zoom.translate(translatePos).event(this.svg);
    };

    GraphCreator.prototype.panHome = function(onlyZoomIn) {
      var thisGraph = this,
        nodes = thisGraph.nodes,
        consts = thisGraph.consts,
        svgWidth = thisGraph.svg.style('width').replace('px', ''),
        svgHeight = thisGraph.svg.style('height').replace('px', ''),
        xScale,
        yScale,
        minX,
        minY,
        maxX,
        maxY,
        currentScale;

      if (!nodes || nodes.length < 1) {
        return;
      }

      angular.forEach(nodes, function(node) {
        var xPos = node.uiInfo.xPos,
          yPos = node.uiInfo.yPos;
        if (minX === undefined) {
          minX = xPos;
          maxX = xPos;
          minY = yPos;
          maxY = yPos;
        } else {
          if (xPos < minX) {
            minX = xPos;
          }

          if (xPos > maxX) {
            maxX = xPos;
          }

          if (yPos < minY) {
            minY = yPos;
          }

          if (yPos > maxY) {
            maxY = yPos;
          }
        }
      });

      xScale =  svgWidth / (maxX + consts.rectWidth + 30);
      yScale =  svgHeight / (maxY + consts.rectHeight + 30);

      showTransition = true;
      currentScale = xScale < yScale ? xScale : yScale;

      if (currentScale < 1 || !onlyZoomIn) {
        $scope.state.currentScale = currentScale;
        this.zoom.translate([0, 0]).scale(currentScale).event(this.svg);
      }

    };


    GraphCreator.prototype.panLeft = function() {
      var translatePos = this.zoom.translate();
      translatePos[0] += 250;
      showTransition = true;
      this.zoom.translate(translatePos).event(this.svg);
    };

    GraphCreator.prototype.panDown = function() {
      var translatePos = this.zoom.translate();
      translatePos[1] -= 150;
      showTransition = true;
      this.zoom.translate(translatePos).event(this.svg);
    };
    
 GraphCreator.prototype.moveNodeToCenter = function(stageInstance) {
      var thisGraph = this,
        consts = thisGraph.consts,
        svgWidth = thisGraph.svg.style('width').replace('px', ''),
        svgHeight = thisGraph.svg.style('height').replace('px', ''),
        currentScale = $scope.state.currentScale,
        x = svgWidth / 2 - (stageInstance.uiInfo.xPos + consts.rectWidth/2) * currentScale,
        y = svgHeight / 2 - (stageInstance.uiInfo.yPos + consts.rectHeight/2) * currentScale;

      showTransition = true;
      this.zoom.translate([x, y]).event(this.svg);
    };

    

    GraphCreator.prototype.moveGraphToCenter = function() {
      showTransition = true;
      this.zoom.translate([0,0]).event(this.svg);
    };


    GraphCreator.prototype.clearStartAndEndNode = function() {
      var thisGraph = this;
      thisGraph.rects.classed(thisGraph.consts.startNodeClass, false);
      thisGraph.rects.classed(thisGraph.consts.endNodeClass, false);
    };

    GraphCreator.prototype.addDirtyNodeClass = function() {
      var thisGraph = this;
      thisGraph.rects.selectAll('circle')
        .attr('class', function(d) {
          var currentClass = d3.select(this).attr('class');
          if (currentClass) {
            var currentClassArr = currentClass.split(' '),
              intersection = _.intersection(thisGraph.dirtyLanes, currentClassArr);

            if (intersection && intersection.length) {
              return currentClass + ' dirty';
            }
          }
          return currentClass;
        });
    };

    GraphCreator.prototype.clearDirtyNodeClass = function() {
      var thisGraph = this;
      thisGraph.rects.selectAll('circle')
        .attr('class', function(d) {
          var currentClass = d3.select(this).attr('class');

          if (currentClass && currentClass.indexOf('dirty') !== -1) {
            currentClass = currentClass.replace(/dirty/g, '');
          }

          return currentClass;
        });
    };

    GraphCreator.prototype.updateStartAndEndNode = function(startNode, endNode) {
    	



    	
    	
      var thisGraph = this;

      thisGraph.clearStartAndEndNode();

      if (startNode) {
        thisGraph.rects.filter(function(cd){
          return cd.instanceName === startNode.instanceName;
        }).classed(thisGraph.consts.startNodeClass, true);
      }

      if (endNode) {
        thisGraph.rects.filter(function(cd){
          return cd.instanceName === endNode.instanceName;
        }).classed(thisGraph.consts.endNodeClass, true);
      }

    };

 	/** MAIN SVG **/
  var graphContainer, svg, graph, toolbar, graphWarning,nodes,edges,issues;
 	//

     graphContainer = d3.select('.my-info');
        svg = graphContainer.select('svg');//d3选择器选择出.my-info中的svg
    svg.attr('width','100%').attr('height','100%');//直接设置svg的宽高
      graphWarning = graphContainer.select('.warning-toolbar');
      graph = new GraphCreator(svg, nodes, edges || [], issues);      
    graph.setIdCt(2);
    graph.nodes;//图形添加位置
    
	graph.svg.call(graph.zoom);//增加缩放平移功能
	
      graph.edges;
      graph.issues = [];
      graph.stageErrorCounts = {};
      graph.showEdgePreviewIcon = 1;
      graph.isReadOnly = 0;//
      graph.pipelineRules = 1;
      graph.triggeredAlerts = 1;
      graph.errorStage = [{outputLanes:[]}];
      graph.updateGraph();    
    if (graph.dirtyLanes) {
        graph.addDirtyNodeClass();
      }

 


      
  //  $scope.$on('updateGraph', function(event, options) {//监听--需要上一级controller传值过来
	$scope.updateData=function(options,w,h){	
//	alert(JSON.stringify(options));	
      var nodes = options.nodes,
        edges = options.edges,
        issues = options.issues,
        selectNode = options.selectNode,
        selectEdge = options.selectEdge,
        stageErrorCounts = options.stageErrorCounts,
        showEdgePreviewIcon = options.showEdgePreviewIcon;
      for(var j=0;j<options.nodes.length;j++){//因为直接加载的nodes和edges不存在关联关系，所以让其相互引用
          for(var i=0;i<options.edges.length;i++){
        	  if(options.edges[i].source.instanceName == options.nodes[j].instanceName){
        		  options.edges[i].source = options.nodes[j];
        	  }
        	  if(options.edges[i].target.instanceName == options.nodes[j].instanceName){
        		  options.edges[i].target = options.nodes[j];
        	  }
          } 
      }

      if (graph !== undefined) {
        graph.deleteGraph();
      } else {
      	graphContainer = d3.select('.my-info');
        svg = graphContainer.select('svg');//d3选择器选择出.my-info中的svg
		    svg.attr('width','100%').attr('height','100%');//直接设置svg的宽高
		    graphWarning = graphContainer.select('.warning-toolbar');
		    if(h||w){
		    	graph = new GraphCreator(svg, nodes, edges || [], issues,w,h);
		    }else{
		    	graph = new GraphCreator(svg, nodes, edges || [], issues);
		    }
        graph.setIdCt(2);
      }
      graph.nodes = nodes;
      graph.edges = edges;
      graph.issues = issues;
      graph.stageErrorCounts = stageErrorCounts;
      graph.showEdgePreviewIcon = showEdgePreviewIcon;
      graph.isReadOnly = options.isReadOnly;
      graph.pipelineRules = options.pipelineRules;
      graph.triggeredAlerts = options.triggeredAlerts;
      graph.errorStage = options.errorStage;
//    graph.svg.call(graph.zoom);
      
      graph.updateGraph();
	
      if (graph.dirtyLanes) {
        graph.addDirtyNodeClass();
      }

      if (selectNode) {
        graph.selectNode(selectNode);
      } else if (selectEdge) {
        graph.selectEdge(selectEdge);
      }

      if (options.fitToBounds) {
        graph.panHome(true);
      }
    
    };
    
    
    
    
    var getEdgePreviewIcon = function(pipelineRules, triggeredAlerts, d) {//连线中间图标
      var atLeastOneRuleDefined = false,
        atLeastOneRuleActive = false,
        triggeredAlert = _.filter(triggeredAlerts, function(triggered) {
          return triggered.ruleDefinition.lane === d.outputLane;
        });

      _.each(pipelineRules.dataRuleDefinitions, function(ruleDefn) {
        if (ruleDefn.lane === d.outputLane) {
          if (ruleDefn.enabled) {
            atLeastOneRuleActive = true;
          }
          atLeastOneRuleDefined = true;
        }
      });

      _.each(pipelineRules.driftRuleDefinitions, function(ruleDefn) {
        if (ruleDefn.lane === d.outputLane) {
          if (ruleDefn.enabled) {
            atLeastOneRuleActive = true;
          }
          atLeastOneRuleDefined = true;
        }
      });

      if (triggeredAlert && triggeredAlert.length) {
        return 'fa fa-tachometer fa-16x pointer edge-preview alert-triggered';
      } else if (atLeastOneRuleActive){
        return 'fa fa-tachometer fa-16x pointer edge-preview active-alerts-defined';
      } else if (atLeastOneRuleDefined){
        return 'fa fa-tachometer fa-16x pointer edge-preview alerts-defined';
      } else {
        return 'fa fa-tachometer fa-16x pointer edge-preview';
      }
    };

    var deleteSelectedNode = function(selectedNode) {
      var nodeIndex = graph.nodes.indexOf(selectedNode);
      var state = $scope.state;
      if (nodeIndex !== -1) {
        graph.nodes.splice(nodeIndex, 1);
        //Remove the input lanes in all stages having output/event lanes of delete node.
        //删除具有删除节点的输出/事件通道的所有阶段中的输入通道
        _.each(graph.edges, function(edge) {
          if (edge.source.instanceName === selectedNode.instanceName) {
            edge.target.inputLanes = _.filter(edge.target.inputLanes, function(inputLane) {
              return !_.contains(edge.source.outputLanes, inputLane) && !_.contains(edge.source.eventLanes, inputLane);
            });
          }
        });
        //删除节点时，后续节点属性更新
        for(var i=0;i<graph.edges.length;i++){
        	if(selectedNode.uiInfo.stageType === 'SOURCE'){
        		if(graph.edges[i].target.one && graph.edges[i].target.one.length>0){
            		for(var j=0;j<graph.edges[i].target.one.length;j++){
            			if(graph.edges[i].target.one[j].instanceName == selectedNode.instanceName){
            				graph.edges[i].target.one.splice(j,1);
            			}
            		}
            	}
        	}        	
        	
        	if(selectedNode.uiInfo.stageType === 'PROCESSOR'){
        		if(selectedNode.uiInfo.name !== 'map'){
        			if(graph.edges[i].target.filter && graph.edges[i].target.filter.length>0){
                		for(var j=0;j<graph.edges[i].target.filter.length;j++){
                			if(graph.edges[i].target.filter[j].action_instanceName == selectedNode.instanceName){
                				graph.edges[i].target.filter.splice(j,1);
                			}
                		}
                	}
        		}else{
        			if(selectedNode.cognate && selectedNode.cognate.length>0){
                		if(graph.edges[i].target.cognate && graph.edges[i].target.cognate.length>0){
                    		for(var j=0;j<graph.edges[i].target.cognate.length;j++){
                    			if(graph.edges[i].target.cognate[j].action_instanceName == selectedNode.instanceName){
                    				graph.edges[i].target.cognate.splice(j,1);
                    			}
                    		}
                    	}
                	}
        			if(graph.edges[i].target.map_filter && graph.edges[i].target.map_filter.length>0){
                		for(var j=0;j<graph.edges[i].target.map_filter.length;j++){
                			if(graph.edges[i].target.map_filter[j].action_instanceName == selectedNode.instanceName){
                				graph.edges[i].target.map_filter.splice(j,1);
                			}
                		}
                	}
        			if(graph.edges[i].target.dropData && graph.edges[i].target.dropData.length>0){
                		for(var j=0;j<graph.edges[i].target.dropData.length;j++){
                			if(graph.edges[i].target.dropData[j].action_instanceName == selectedNode.instanceName){
                				graph.edges[i].target.dropData.splice(j,1);
                			}
                		}
                	}
        		}
        	}
        	
        	
        	
        	
        }
        graph.spliceLinksForNode(selectedNode);
        state.selectedNode = null;
        $scope.$emit('onRemoveNodeSelection', {
          selectedObject: undefined,
          type: pipelineConstant.PIPELINE
        });
        $scope.update_all_attributes = true;//更新所有节点的属性信息
        graph.updateGraph();
      }
    }
  $scope.ajaxFunc=function(opt) {
        opt = opt || {};
        opt.method = opt.method.toUpperCase() || 'POST';
        opt.url = opt.url || '';
        opt.async = opt.async || true;
        opt.data = opt.data || null;
        opt.success = opt.success || function () {};
        var xmlHttp = null;
        if (XMLHttpRequest) {
            xmlHttp = new XMLHttpRequest();
        }
        else {
            xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
        }var params = [];
        for (var key in opt.data){
            params.push(key + '=' + opt.data[key]);
        }
        var postData = params.join('&');
        if (opt.method.toUpperCase() === 'POST') {
            xmlHttp.open(opt.method, opt.url, opt.async);
            xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=utf-8');
            xmlHttp.send(postData);
        }
        else if (opt.method.toUpperCase() === 'GET') {
            xmlHttp.open(opt.method, opt.url + '?' + postData, opt.async);
            xmlHttp.send(null);
        } 
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                opt.success(xmlHttp.responseText);
            }
        };
    }
  /**
   * 通过在通用-信息中的设置步骤名称,改变画布对应节点上的名称
   * */
  $scope.change_step_name=function(step_name){
	  if(step_name.length>18){//如果名字过长,则改变坐标--由于svg中的文字难以用js控制样式,插入的标签页没有反应,所以没有做换行处理
		  $('svg').find('.selected').find('tspan').text(step_name).attr('x',graph.consts.rectWidth/2).attr('y',graph.consts.rectHeight*0.9);
		  
		 /* var str0 = step_name.substr(0,9);
		  var str1 = step_name.substr(9);
		  $('svg').find('.selected').find('tspan').text(str0).attr('x',graph.consts.rectWidth/2).attr('y',graph.consts.rectHeight*0.9-13);
		  $('svg').find('.selected').find('tspan').eq(0).clone(true).appendTo( $('svg').find('.selected').find('tspan').eq(0).parent());
		  $('svg').find('.selected').find('tspan').eq(1).text(str1).attr('x',graph.consts.rectWidth/2).attr('y',graph.consts.rectHeight*0.9).attr('dy','0em');
		  */
		 }else{
		  $('svg').find('.selected').find('tspan').text(step_name).attr('x',graph.consts.rectWidth/2).attr('y',graph.consts.rectHeight*0.9);
	  }		  	
  }
  /**
   * targetName_arr()
   * 保存节点时调用
   * 这个函数是为了判断当前画布的所有target输出节点是否存在没有输入名字的
   * */
 function targetName_arr(){
			var check_tableName = graph.nodes.filter(function(n){
				return (n.uiInfo.stageType === 'TARGET')
			});
			
			
			var check_name_arr = [];
			if(check_tableName<1){
				check_name_arr.push(undefined);
				//check_name_arr.push($scope.state.selectedNode.targetName)
			}else{
				for(var i=0;i<check_tableName.length;i++){
					
					check_name_arr.push(check_tableName[i].targetName)
				}
			}
			
			return check_name_arr.indexOf(undefined);

	
  }
  /**
   * 输出节点的名称验证,不能和已有的名称重复
   * 保存画布时必填
   * */
  $scope.dropName=function(n){
	  if($scope.state.selectedNode==null){
		  return;
	  }
	$('svg').find('.selected').find('tspan').text(n).attr('x',graph.consts.rectWidth/2).attr('y',graph.consts.rectHeight*0.9);	  
	$scope.state.selectedNode.uiInfo.label = n;
	var now_target_ins = $scope.state.selectedNode.instanceName;//当前的节点
	var check_tableName = graph.nodes.filter(function(n){
		return (n.uiInfo.stageType === 'TARGET' && n.instanceName !== now_target_ins)
	});
	var check_name_arr = [];
	for(var i=0;i<check_tableName.length;i++){
		check_name_arr.push(check_tableName[i].targetName)
	}
	if(check_name_arr.indexOf(n)!==-1){//第一次检测
		$scope.warning = true;
	}else{
		var settings = {
				  //"async":false,
				  "crossDomain": true,
				  "url": ""+adress_url+"rest/translate/checkHiveTableName",
				  "method": "POST",
				  "headers": {
				    "content-type": "application/x-www-form-urlencoded",
				  },
				  "data": {
				    "tableName": n
				  }
				}
		
		
		
		$.ajax(settings).done(function (response) {
			response = JSON.parse(response)
			if(response.rst_msg === 'false'){
				//console.log('和已有表名重复！');
				$scope.warning = true;
			}else{
				$scope.warning = false;
			  	$scope.dropData_L.drop_name = n;//最后生成新的表名
			  	$scope.state.selectedNode.targetName = n;
				//console.log($scope.dropData_L);
			}
		})
	}


  }

/**
 * crossSelected
 * 源节点传值
 * ui-select选择表名，根据表名来查找对应的表并将其显示在列表中
 * */
$scope.crossSelected=function(data){//使用controller as可以使用this指代scope
	//选中传值，请求数据
	//需要添加更新，更新表格数据
	//console.log(data);
	//var step_name = '源节点';
	$scope.down_found=true;
	$scope.selectedDataJadge=true;
	if($scope.state.selectedNode&&$scope.state.selectedNode.uiInfo.stageType==='SOURCE'){
		//$('svg').find('.selected').find('foreignObject').text(step_name).attr('x',graph.consts.rectWidth/2).attr('y',graph.consts.rectHeight*0.9);
		$scope.state.selectedNode.uiInfo.label=data.tableName;
	}
	$scope.state.selectedNode.choiced_table = data;//传入所选表名信息
	var str = $location.absUrl();
	var adress_url = str.toString().split('page')[0];
	var settings = {
	  "async":true,
	  "crossDomain": true,
	  "url": ""+adress_url+"rest/translate/queryHiveFieldByTable",
	  "method": "POST",
	  "headers": {
	    "content-type": "application/x-www-form-urlencoded",
	  },
	  "data": {
	    "tableName": data.tableName
	  }
	}
	//节点发生改变，去除所有相关的数组元素
	var select_source = $scope.state.selectedNode; 
	 var thisGraph = graph;
	 for(var i=0;i<thisGraph.nodes.length;i++){
	     if(thisGraph.nodes[i].dropData){
           var arr = thisGraph.nodes[i].dropData;
           for(var j=0;j<arr.length;i++){
	           if(arr[j].instanceName == select_source.instanceName){
	        	   arr.splice(j,1);
	           }
           }
        }
	 }
	 for(var i=0;i<thisGraph.edges.length;i++){
	     if(thisGraph.edges[i].target.dropData){
            var arr = thisGraph.edges[i].target.dropData;
	        for(var j=0;j<arr.length;i++){
	            if(arr[j].instanceName == select_source.instanceName){
	            	arr.splice(j,1);
	            }
	        }
	    }
	 }
/*     toSplice = thisGraph.edges.filter(function(l) {
       return (l.source.instanceName === select_source.instanceName || l.target.instanceName === select_source.instanceName);
     });*/
	$.ajax(settings).done(function (response) {
		response = response.replace(/\\t/g,"");
		response = JSON.parse(response);
			  $scope.fieldArr = response.fieldArr;
			  $scope.state.selectedNode.fieldArr = $scope.fieldArr;
			  $scope.state.selectedNode.hiveName = data.tableSpace+"."+data.tableName;//取出表名
			  _this.selectedData = $scope.state.selectedNode;
			  //$scope.state.selectedNode.one.fieldArr = $scope.fieldArr;
			  var ins = $scope.state.selectedNode.instanceName;  //通过选中节点的instanceName来寻找相关的边，并做更新--选中值时，做更新
			  for(var i = 0;i<graph.edges.length;i++){
				  if(graph.edges[i]['source'].instanceName === ins){
					  //更新数据
					  var obj={};
						obj.instanceName=graph.edges[i].source.instanceName;
						obj.fieldArr=graph.edges[i].source.fieldArr;
						obj.hiveName = graph.edges[i].source.hiveName;
						//for(var j=0;j<graph.edges[i].target)
						graph.edges[i].source.one=[];//重置当前选中的源节点
						graph.edges[i].source.one.push(obj);
						graph.edges[i].target.hiveName = graph.edges[i].source.hiveName;
						if(graph.edges[i].target.one.length>0){			
							var arr = [];
							for(var j=0;j<graph.edges[i].target.one.length;j++){
								arr.push(graph.edges[i].target.one[j].instanceName);
							}
							if(arr.indexOf(ins)!==-1){
								var index = arr.indexOf(ins);
								graph.edges[i].target.one[index] = obj;
							}else{
								graph.edges[i].target.one.push(obj);
							}							
						}else{
							graph.edges[i].target.one.push(obj);
						}
				  }
			  }
			  $scope.update_all_attributes = true;
			  $scope.$apply();
			  graph.updateGraph();
	});
}
/**
 * 深度复制对象,令特定的对象互相独立
 * 
 * */
$scope.cloneObj = function (obj) {  //解决重复点击的问题，一旦重复点击，复制点击的对象
	    var newObj = {};  
	    if (obj instanceof Array) {  
	        newObj = [];  
	    }  
	    for (var key in obj) {  
	        var val = obj[key];  
	        //newObj[key] = typeof val === 'object' ? arguments.callee(val) : val; //arguments.callee 在哪一个函数中运行，它就代表哪个函数, 一般用在匿名函数中。  
	        newObj[key] = typeof val === 'object' ? $scope.cloneObj(val): val;
	    }  
	    return newObj;  
}
	
	
$scope.check_number = function(type){
	var arr = [];
	for(var i=0;i<graph.nodes.length;i++){
		if(graph.nodes[i].uiInfo.stageType === type){
			arr.push(graph.nodes[i].instanceName);
		}
	}
	return arr
}
$scope.nameArr = [];//建立一个临时数组来判断是否重复
/*
 * addSourceNode
 * 增加节点
 * 其中通过判断增加节点的类型,来改变html某些区域的显示隐藏--通过ng-if来改变
 * */
$scope.addSourceNode=function(value,t){
var title_desc = "";//title_desc增加节点时默认的步骤名称
var output_num;
//新增时直接跳转到通用页面
common_found(0);
//判断新增节点的类型
	if(value=='SOURCE'){		
		$scope.fieldArr = [];  		
		_this.cotrollSelect=true;
		_this.hideTable=false;
		$scope.target_data=false;
		output_num = ["dev"];		
		title_desc = "源节点"+ $scope.check_number(value).length;
	}else if(value=='PROCESSOR'){
		if(!t){//正常的映射处理
			var t = "map";
			_this.cotrollSelect=false;
			_this.hideTable=true;
			$scope.d_data=[];
			$scope.choice_field_arr = [];
			output_num = ["dev"];
			title_desc = "转换过程"+ $scope.check_number(value).length;
			$scope.map_filter_all_data = [];
		}else{//区分正常映射和转换规则
			_this.change_cotrollSelect = true;
			_this.hideTable=false;
			output_num = ["error","success"];
			title_desc = "转换规则"+ $scope.check_number(value).length;
			$scope.xy_filter_all_data = [];
		}

	}else if(value=='TARGET'){
		_this.cotrollSelect=false;//隐藏选择
		_this.hideTable=false;//隐藏映射表格
		$scope.target_data=true;
		$scope.dropData_L = [];
		output_num = [];
		title_desc = '输出' +"_"+ $scope.check_number(value).length;
	}
	/*节点对象的基本组成*/
  	var stageOption={
	    "name": "hive_table",
	    "tableSpace": "",
	    "instanceName": "",
	    "stageinstance": [
	        {
	            "uiInfo": {
	                "description": "",
	                "xPos": 300,
	                "yPos": 10,
	                "name": t,
	                "stageType": value,
	                "label": title_desc//标签名节点中的文字
	            },
	            "instanceName": "",//instanceName时间戳
	            "eventLanes": "",//另外的可连接的节点
	            "outputLanes": output_num,//输出的节点，可多个
				"one":[]
	        }
	    ],
	    "stageType": value
	}
  	//映射右边处理字段表格数据清空
	$scope.dropData_k=[];
	
    options=stageOption.stageinstance;
  
    if(value!=='PROCESSOR'){
		_this.selectedData=stageOption;//绑定数据    	
    }
    //

    var arr = $scope.nameArr;
if(!options[0]){
	options[0]=options;
}
if(value=='SOURCE'){
	options[0].sortNum = 1;
}
//增加时添加判断，

if(options[0].instanceName.length<2){//将instanceName强制改成时间戳
    var newObj = $scope.cloneObj(options);
    newObj[0].instanceName = newObj[0].uiInfo.name +"_"+ Date.parse(new Date());
    newObj[0].uiInfo.title_desc = newObj[0].instanceName;
    var options=newObj;
}else{
    var newObj = $scope.cloneObj(options);
    newObj[0].instanceName = newObj[0].uiInfo.name +"_"+ Date.parse(new Date());
    newObj[0].uiInfo.title_desc = newObj[0].instanceName;
    var options=newObj;	
   
}
if($scope.nameArr.indexOf(newObj[0].instanceName)==-1){//由于使用的是时间戳来当做节点的唯一标识,所以不能点击过快
	$scope.nameArr.push(newObj[0].instanceName)
}else{
	console.log('不要点击太快')
	return;
}

$scope.options=options;//基本信息
	var 
    relativeX,
    relativeY;
    edges;
    relativeX=500;
    relativeY=0;  
    graph.addNode(options[0], edges, relativeX, relativeY);
    graph.updateGraph();
    
    $(graph.svg[0]).focus();
   // $scope.$apply();
}

$scope.dropData=[];
/**
 * dropComplete
 * 使用了基于ng的拖拽插件drag.js
 * dropComplete是拖拽成功后执行的函数
 * */
$scope.dropComplete=function(index,data,event){//拖动到转换表格上--拖拽成功之后添加线段
data[$scope.state.selectedNode.instanceName] = true;
data.itemK = data.instanceName+"."+data.fieldName;
if(!$scope.state.selectedNode.dropData){
	$scope.state.selectedNode.dropData=[];
	$scope.state.selectedNode.dropData.push(data);
}else{
	$scope.state.selectedNode.dropData.push(data);
}
$scope.update_all_attributes = true;
	$scope.dropData_k=$scope.state.selectedNode.dropData;
	setTimeout(function(){$scope.title_tip();})
	graph.updateGraph();
}

/**submit_data
 * hlframe.js中的方法，为了方便调用将其单独拿出来
 * */
$scope.submit_data=function(url,param,successFunc,errorFunc,type,dataType,async){
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
		beforeSend:function () {//发送请求之前加载个进度条
			top.layer.load(1,{content:'<p class="loading_style">保存中，请稍候。</p>'});
        },
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

$scope.pipeline_detail_change=function(value){//绑定设计名称
	if(value){
		$scope.designDetail = value.toString();
	}
}
$scope.pipeline_name_change=function(name){//设计说明
	if(name){
		$scope.designName = name.toString();
	}
}
/**save_pipeline_data
 * 判断是否填入必填项
 * 保存画布
 * common_found是tab切换的函数
 * */
$scope.save_pipeline_data=function($event){//保存数据，将数据保存成一个json发送到后台
//	判断是否有添加表名，如果有添加将表名作为设计图的名字，否则将第一个节点的instanceName作为名字
	//debugger;
	if($scope.designName && $scope.designDetail && targetName_arr()==-1){
		var name = $scope.designName;
		var value = $scope.designDetail;
		if($scope.save_pipeline == null){
			return;
		}
		var design_id = $('#design_id').val();
		var designObj = {
			'designName':name,	//设计转换任务名称 不为空
			'designDesc':value,//设计转换任务描述 不为空
			'designJson':'{"nodes":'+JSON.stringify($scope.save_pipeline.nodes)+',"edges":'+JSON.stringify($scope.save_pipeline.edges)+'}',
			'status':'',	//状态,新建/发布...(可为空)
			'sortNum':10,	//排序(可为空)
			'id':design_id			
		};
		
			if($scope.designName && $scope.designDetail && targetName_arr()==-1){
				
				$scope.submit_data(''+$scope.ctx+'/dc/dataProcess/process/ajaxSave', designObj, function (data) {
					//刷新表格		
					table.ajax.reload();
					top.layer.alert(data.msg, {
						title : '系统提示'
					});
					top.layer.closeAll('loading');
					close_layer();
					//关闭form面板 TODO
					top.layer.close($('#cur_indexId').val());
				});
			}
	

	}else{
		if(!$scope.designName){
			common_found(0);
			top.layer.alert('请填写设计名称', {
				title : '请填写设计名称'
			});
			$event.stopPropagation();
			return false;
		}
		if(!$scope.designDetail){
			common_found(0);
			top.layer.alert('请填写设计描述', {
				title : '请填写设计描述'
			});
			$event.stopPropagation();
			return false;
		}
		if(targetName_arr()!==-1){
			common_found(1);
			top.layer.alert('请填写输出表名', {
				title : '请填写输出表名'
			});
			$event.stopPropagation();
			return false;
		}
	}			
}


   GraphCreator.prototype.removeOldPipeline = function(oldPipeline) {//加载新的图表时将原有节点覆盖
      var thisGraph=this;
      thisGraph.nodes=[];
      thisGraph.edges=[];     
   }

   /* found_pipeline_data
    * 加载数据
    * */
$scope.found_pipeline_data=function(data,desc,name){//直接传值--加载历史记录
	if(!data){
		return;
	}
	
	$scope.updateData({
		"nodes":data.nodes,
		"edges":data.edges
	});//加载图形
	
	$scope.targetName = data.nodes[data.nodes.length-1].targetname;//表名
	$scope.designName = name;
	$scope.designDetail = desc;
	$scope.update_all_attributes = true;
	graph.updateGraph();
}

//判断是否有画布的数据传入--如果有传入调用found_pipeline_data();
if(get_obj.indexOf('nodes')!==-1&&get_desc&&get_name){
	$scope.found_pipeline_data(JSON.parse(get_obj),get_desc,get_name);
}
/*found_origin
 *该方法是为了找到映射数据的来源
 *map映射的下方右侧列表
 **/
$scope.found_origin=function(item,k,data,index){//item拖拽过来的数据，k指item中的itemK，data-拖拽来的数据集合，index当前下标
//比较instanceName和hiveName
	for(var d in $scope.d_data){//第一层
		for(var f=0;f<$scope.d_data[d].fieldArr.length;f++){//第二层
			if($scope.d_data[d].fieldArr[f].itemK && $scope.d_data[d].fieldArr[f].itemK == item.itemK){
				$('.map_table').find('tr').css({"color":"#333"});
				$('.map_table').find('table').eq(d).find('tr').eq(f+1).css({"color":"red"}).siblings().css({"color":"#333"});

			}
		}
	}
	
		$scope.itemK=k;
		if(index){
			data[index].itemK=k;		
			$scope.state.selectedNode.dropData[index].itemK = k;
		}
		graph.updateGraph()
}

/*delete_field
 *删除字段
 *map映射右侧表格删除触发
 * */
$scope.delete_field=function(index,drop_data_k){//删除相应字段--根据item找到对应的下标并删除
	
	for(var i in $scope.state.selectedNode.one){
		if($scope.state.selectedNode.one[i].instanceName === drop_data_k[index].instanceName){
			for(var x in $scope.state.selectedNode.one[i].fieldArr){
				if($scope.state.selectedNode.one[i].fieldArr[x].fieldName === drop_data_k[index].fieldName){
					//console.log($scope.state.selectedNode.one[i].fieldArr[x]);
					$scope.state.selectedNode.one[i].fieldArr[x][$scope.state.selectedNode.instanceName] = false;
				}
			}
		}
	}
	
	$scope.dropData_k.splice(index,1);
	$scope.state.selectedNode.dropData = $scope.dropData_k;
	$scope.update_all_attributes = true;
	graph.updateGraph();
}
//清空所有映射字段
$scope.delete_all = function(){
	var one_arr = $scope.state.selectedNode.one;
	for(var i in one_arr){
		for(var j in one_arr[i].fieldArr){
			one_arr[i].fieldArr[$scope.state.selectedNode.instanceName] = false;
			one_arr[i].fieldArr[j][$scope.state.selectedNode.instanceName] = false;
		}
	}
	$scope.dropData_k = [];
	$scope.state.selectedNode.dropData = $scope.dropData_k;
	$scope.update_all_attributes = true;
	graph.updateGraph();
}
	//表达式输入框失去焦点清除所有颜色
	$scope.clear_color=function(item,k,data,index){
		if($scope.d_data.length<2){
			$('tr').css({
				'color':'#333'
			})
		}else{
			$('tr').css({
				'color':'#333'
			})
		}
		$scope.itemK=k;
		if(index!==undefined){
			data[index].itemK=k;		
			$scope.state.selectedNode.dropData[index].itemK = k;
		}
		graph.updateGraph()
	}

	$scope.choseArr=[];//定义数组用于存放前端显示  
	var str="";//  
	var flag=[];//是否点击了全选，是为a  
	$scope.m=false;//默认未选中  
	$scope.master=[];
	/* all  chk  checkbox_cross
	 * 全选        单选	   传值操作
	 * 通过在字段上绑定ago_checked属性来判断选中状态
	 * */
	$scope.all= function (c,v,index) {//全选  传入该表格的所有值
	    if(c==true){  
	    	flag[index]='a';  
	        $scope.m[index]=true;
	        $scope.choseArr=$scope.cloneObj(v.fieldArr);
	        str = $scope.choseArr;
	        $scope.obj_y[v.hiveName] = v.fieldArr;
	        var Length = v.fieldArr.length;
	        
	        function remove(arr, item,selected) {  
   			 var result=[];  
   			    for(var i=0; i<arr.length; i++){  
	   			    if(arr[i].fieldName !== item.fieldName){
	   			    	result.push(arr[i]);
	   			    }  
   			    }  
   			 return result;  
   			}  

	        var one_time = {};
	        var one_time_arr = [];
	        for(var i=0;i<Length;i++){
	        	//以hiveName为键，其对应的字段为值建立一个对象--其中是全选选中的字段,之前已经选中的排除
	        	if(v.fieldArr[i][$scope.state.selectedNode.instanceName]){
	        		one_time_arr.push(v.fieldArr[i]);
	        	}
	        }
	        for(var i=0;i<one_time_arr.length;i++){
	        	$scope.obj_y[v.hiveName] = remove($scope.obj_y[v.hiveName],one_time_arr[i],'m');
	        }
	    }else{  
	    	flag[index]="";
	        $scope.m[index]=false;
	        $scope.choseArr =[""];
	        str = $scope.choseArr;
	        $scope.index_arr=[];
	    }	 
	    $scope.checked_index = index;
	};  
	
	//值传递过去之后禁止选择，传递
	var save_check = {};
	$scope.obj_y = {};
	var splice_index = {};
	$scope.chk= function (z,x,index,y) {//单选或者多选 --index下标
		//debugger;
	    if(flag[$scope.checked_index]=='a') {//在全选的基础上操作  --再次单选取消
	    	//x为假，则为取消选中
	    	if(x == false){
	    		
	    		function remove(arr, item,selected) {  
	    			 var result=[];  
	    			 for(var i=0; i<arr.length; i++){  
	 	   			    if(arr[i]!=item){
	 	   			    	result.push(arr[i]);  		       
	 	   			    }  
	    			      
	    			}  
	    			 return result;  
	    		}  
	    		$scope.obj_y[y.hiveName] = remove($scope.obj_y[y.hiveName],$scope.obj_y[y.hiveName][index],'m');    	
	    	}else if(x == true){
	    		if($scope.obj_y[y.hiveName] && $scope.obj_y[y.hiveName].length>0){
	    			$scope.obj_y[y.hiveName].push(z);
	    		}else{
	    			$scope.obj_y[y.hiveName]=[];
	    			$scope.obj_y[y.hiveName].push(z);
	    		}
	    	}	    	
	    	return;
	    }else{
	    	z = JSON.stringify(z);
	    }
	    if (x == true) {//选中  
	    	if(!save_check[y.hiveName] || save_check[y.hiveName].indexOf(index)==-1){	    		
	    		//增加判断，多个表格里的字段同时选中
	    		//y中的hiveName
	    		if(save_check[y.hiveName] && save_check[y.hiveName].length>0){
	    			save_check[y.hiveName].push(index);
	    		}else{
	    			save_check[y.hiveName] = [];
	    			save_check[y.hiveName].push(index);
	    		}
	    		
	    		 str = str +  z + 'H,' + y.hiveName +'i,'+index+ 'K,';  //传入当前下标
	    		 $scope.index_arr.push(index);
	    		 $scope.master[$scope.checked_index]=false;
	    	}	        
	    } else {  
	    	if(save_check[y.hiveName] && save_check[y.hiveName].indexOf(index)!==-1){
	    		str = str.replace( z + 'H,' + y.hiveName +'i,'+index+ 'K,', '');//取消选中
	    		save_check[y.hiveName].splice(index,1);
	    	}
	    }

	    $scope.choseArr=str;
	    $scope.obj_y[y.hiveName] = y;    
	};
	//修改--所有值仅能传递一次，一旦选中传值，即变为不可选
	$scope.checkbox_cross = function () {// 操作CURD  
	    if($scope.choseArr[0]==""||$scope.choseArr.length==0){//没有选择一个的时候提示   
	        return;  
	    };
	    //全选传值，全选部分传值，单选传值，多选 传值
	    if(flag[$scope.checked_index]=='a'){//全选的基础上操作
	    	for(var w in $scope.obj_y){
	    		for(var i=0;i<$scope.obj_y[w].length;i++){
	    			var a = $scope.obj_y[w][i];
	    				a.itemK = a.instanceName+"."+a.fieldName;
					
				    if(!$scope.state.selectedNode.dropData){
				    	$scope.state.selectedNode.dropData=[];
				    	$scope.state.selectedNode.dropData.push(a);
				    }else{
				    	$scope.state.selectedNode.dropData.push(a);
				    }
				
				    $scope.obj_y[w][i][$scope.state.selectedNode.instanceName]=true;
	    		}
	    	}
	    }else{//单选多选
	    	//$scope.choseArr = $scope.choseArr.replace(/\\t/g,"")
	    	var L = $scope.choseArr.split('K,');//所有字段
	    	
	    	for(var i=0;i<L.length;i++){
	    		if(L[i]!==''){
	    			var a_field = L[i].split('H,')[0];
	    			var spl = L[i].split('H,')[1];
	    			var a_hiveName = spl.split('i,')[0];
	    			var a_index = spl.split('i,')[1];
 					var a_field = JSON.parse(a_field);
					$scope.obj_y[a_hiveName].fieldArr[a_index][$scope.state.selectedNode.instanceName] = true;
					
					a_field.itemK = a_field.instanceName+"."+a_field.fieldName;
					 	if(!$scope.state.selectedNode.dropData){
					    	$scope.state.selectedNode.dropData=[];
					    	$scope.state.selectedNode.dropData.push(a_field);
					    }else{
					    	$scope.state.selectedNode.dropData.push(a_field);
					    }	 
	    		}
			} 	
	    }	    
	    $scope.dropData_k=$scope.state.selectedNode.dropData;
	    setTimeout(function(){$scope.title_tip();})
	    $scope.update_all_attributes = true;
	    graph.updateGraph();

	    flag[$scope.checked_index] = "";//传值之后取消全选
	    $scope.index_arr=[];//传值之后清空数组，不影响后来的使用
	    save_check = {};
	    $scope.obj_y = {};
	    $scope.master[$scope.checked_index] = false;
	    $scope.choseArr=[];
	    str="";
	}
function found_name(ins,f_name,arr){
	var re_index;
	for(var i=0;i<arr.length;i++){
		if(arr[i].instanceName == ins && arr[i].fieldName == f_name){
			re_index = i;
		}
	}
	return re_index;
}
	
	$scope.express_value = '=';//关联关系--暂时只设置一个=
	_this.operate = [];
//点击添加字段关联
/*click_cognate
 * 增加字段关联
 * 页面中所有表格的增加按钮都是通过增加某一数组的长度来增加表格行数
 * */
$scope.click_cognate = function(cognate_A,cognate_B,index){
	//在d_data中寻找对应的instanceName
	//检测是否传入相同的关联
	$scope.update_all_attributes = true;
	//找出所在下标
	if(cognate_A.length>0 && cognate_B.length>0){//多条关联
		if($scope.state.selectedNode.cognate && $scope.state.selectedNode.cognate.length>0){//如果存在关联
			for(var i=0;i<cognate_A.length;i++){
				if(cognate_A[i] && cognate_B[i]){
					var obj = {};
					/*A字段信息*/
					obj.fieldName_a = cognate_A[i].fieldName;
					obj.instanceName_a = cognate_A[i].instanceName;
					obj.tableName_a = cognate_A[i].hiveName;
					/*B字段信息*/
					obj.fieldName_b = cognate_B[i].fieldName;
					obj.instanceName_b = cognate_B[i].instanceName;
					obj.tableName_b = cognate_B[i].hiveName;
					obj.action_instanceName = $scope.state.selectedNode.instanceName;
					/*表达式信息*/
					obj.join = $scope.express_value;
					cognate_A[i].ago_cognated = true;
					cognate_B[i].ago_cognated = true;
					$scope.state.selectedNode.cognate.push(obj);
					
					//$scope.choice_field_arr.splice([found_name(cognate_A[i].instanceName,cognate_A[i].fieldName,$scope.choice_field_arr)],1);
					//$scope.choice_field_arr.splice([found_name(cognate_B[i].instanceName,cognate_B[i].fieldName,$scope.choice_field_arr)],1);
				}
			}		
		}else{//如果不存在关联
			$scope.state.selectedNode.cognate=[];
			for(var i=0;i<cognate_A.length;i++){
				if(cognate_A[i] && cognate_B[i]){
					var obj = {};
					/*A字段信息*/
					obj.fieldName_a = cognate_A[i].fieldName;
					obj.instanceName_a = cognate_A[i].instanceName;
					obj.tableName_a = cognate_A[i].hiveName;
					/*B字段信息*/
					obj.fieldName_b = cognate_B[i].fieldName;
					obj.instanceName_b = cognate_B[i].instanceName;
					obj.tableName_b = cognate_B[i].hiveName;
					obj.action_instanceName = $scope.state.selectedNode.instanceName;
					/*表达式信息*/
					obj.join = $scope.express_value;
					cognate_A[i].ago_cognated = true;
					cognate_B[i].ago_cognated = true;
					$scope.state.selectedNode.cognate.push(obj);
					//$scope.choice_field_arr.splice([found_name(cognate_A[i].instanceName,cognate_A[i].fieldName,$scope.choice_field_arr)],1);
					//$scope.choice_field_arr.splice([found_name(cognate_B[i].instanceName,cognate_B[i].fieldName,$scope.choice_field_arr)],1);
				
				}
			}
		}
		//点击之后清空
		_this.cognate_A = [];
		_this.cognate_B = [];
		/*_this.operate[index] = true;*/
		$scope.copyhtml = ['1'];
		$scope.cognate_all_data = $scope.state.selectedNode.cognate;
		graph.updateGraph();
	}
	
	


}


$scope.change_km = function(){
		if(_this.km){
			_this.km = !_this.km;
		}else{
			return;
		}
}
//删除关联
$scope.delete_cognate = function(index){
	var obj = $scope.cognate_all_data[index],
	ins_a = obj.instanceName_a,
	f_name_a = obj.fieldName_a,
	ins_b = obj.instanceName_b,
	f_name_b = obj.fieldName_b,
	arr = $scope.choice_field_arr;
	arr[found_name(ins_a,f_name_a,arr)].ago_cognated = false;
	arr[found_name(ins_b,f_name_b,arr)].ago_cognated = false;
		$scope.cognate_all_data.splice(index,1);
		$scope.update_all_attributes = true;
		graph.updateGraph();
}


$scope.copyhtml=['1'];
//增加关联--判断是否可增加关联
$scope.add_cognate = function(){//使用ng-repeat
	var selected_node = $scope.state.selectedNode || null;
	if(selected_node!== null && selected_node.one.length>1){
		$scope.copyhtml.push('1');
		setTimeout(function(){
			var ab = $('#cognate').find('.ui-select-container');
			 for(var i=0;i<ab.length;i++){
			 	ab.eq(i).css({"width":ab.eq(i).parent().width()+'px'})
			 }
			 
			 $scope.title_tip();
		})
	}
	
}
$scope.choice_field_arr = [];

/*去掉全屏，改成可拖拽形式*/
/*$scope.change_flag = true;
$scope.change_svg=function(change_flag){//画布全屏
	百分比自适应布局，全屏条件改变
	if(change_flag){
		var height = window.screen.height*0.7;
        svg = d3.select('.my-info').select('svg').attr('height',height);
		$scope.change_flag = !change_flag;
	}else{
		svg = d3.select('.my-info').select('svg').attr('height',400);
		$scope.change_flag = !change_flag;
	}
}*/
_this.hide_filter_choice = [];
_this.map_filter_field = [];
_this.map_filter_operate = [];
_this.map_user_write = [];
/* filter_message
 * 增加过滤条件
 * */
$scope.filter_message=function(field,operate,value,index){//添加过滤条件
	$scope.update_all_attributes = true;
	if($scope.state.selectedNode==null || field == "" || operate == ""){//检测是否存在选中节点
		return;
	}
		if($scope.state.selectedNode.uiInfo.name !== 'change_rules'){//判断校验和映射节点
			if($scope.state.selectedNode.map_filter){//判断是否存在过滤条件
				for(var i in field){//以字段进行第一次判断
					if(i!=='undefined'){//必须有字段
						var arr = $scope.choice_field_arr,
						ins = field[i].instanceName,
						f_name = field[i].fieldName;
						arr[found_name(ins,f_name,arr)].ago_map_filter = true;
						var obj = {};
						obj.field = field[i];
						obj.operate = operate[i];
						obj.value = value[i];
						obj.action_instanceName = $scope.state.selectedNode.instanceName;
						$scope.state.selectedNode.map_filter.push(obj);
					}
				}
			}else{
				$scope.state.selectedNode.map_filter = [];
				for(var i in field){//以字段进行第一次判断
					if(i!=='undefined'){//必须有字段
						var arr = $scope.choice_field_arr,
						ins = field[i].instanceName,
						f_name = field[i].fieldName;
						arr[found_name(ins,f_name,arr)].ago_map_filter = true;
						var obj = {};
						obj.field = field[i];
						obj.operate = operate[i];
						obj.value = value[i];
						obj.action_instanceName = $scope.state.selectedNode.instanceName;
						$scope.state.selectedNode.map_filter.push(obj);
					}
				}
			}
			$scope.map_filter_all_data = $scope.state.selectedNode.map_filter;
			_this.map_filter_field = '';
			_this.map_filter_operate = '';
			_this.map_user_write = '';
			$scope.add_map_filter_table = ['1'];			
		}else {//校验的过滤
				if($scope.state.selectedNode.filter){//判断是否存在过滤条件
					for(var i in field){//以字段进行第一次判断
						if(i!=='undefined'){//必须有字段
							var arr = $scope.choice_field_arr,
							ins = field[i].instanceName,
							f_name = field[i].fieldName;
							arr[found_name(ins,f_name,arr)].ago_filter = true;
							
							var obj = {};
							obj.field = field[i];
							obj.operate = operate[i];
							obj.value = value[i];
							obj.action_instanceName = $scope.state.selectedNode.instanceName;
							$scope.state.selectedNode.filter.push(obj);
						}
					}
				}else{
					$scope.state.selectedNode.filter = [];
					for(var i in field){//以字段进行第一次判断
						if(i!=='undefined'){//必须有字段
							var arr = $scope.choice_field_arr,
							ins = field[i].instanceName,
							f_name = field[i].fieldName;
							arr[found_name(ins,f_name,arr)].ago_filter = true;
							var obj = {};
							obj.field = field[i];
							obj.operate = operate[i];
							obj.value = value[i];
							obj.action_instanceName = $scope.state.selectedNode.instanceName;
							$scope.state.selectedNode.filter.push(obj);
						}
					}
				}
			$scope.xy_filter_all_data = $scope.state.selectedNode.filter;
			_this.filter_field = '';
			_this.filter_operate = '';
			_this.user_write = '';
			$scope.add_filter_table = ['1'];
		}
}
/* delete_filter_message
 * 删除过滤
 * */
$scope.delete_filter_message=function(index,data,p){
	if(p=='xy'){
		data[index].field.ago_filter = false;
	}else{
		data[index].field.ago_map_filter = false;
	}
	data.splice(index,1);
	$scope.update_all_attributes = true;
	graph.updateGraph();
}
})
.filter('myFilter',function(){//过滤规则--使用地方：关联
	    return function(inputArray,keyname,value){
	    	if(!inputArray){
	    		return [];
	    	}
	        var array = [];

	        	for(var i=0;i<inputArray.length;i++){
		        	
		            if(inputArray[i][keyname]!==value){
		                array.push(inputArray[i]);
		            }
		        }
	        return array;
	    }
})
.filter('Filter_ago',function(){
		    return function(inputArray,keyname,value){
	    	if(!inputArray){
	    		return [];
	    	}
	        var array = [];
	        	for(var i=0;i<inputArray.length;i++){
		        	if(!inputArray[i][keyname]){
		        		array.push(inputArray[i]);
		        	}
		        }
	        return array;
	    }
})
