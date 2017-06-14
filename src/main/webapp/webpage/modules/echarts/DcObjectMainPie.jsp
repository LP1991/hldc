<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<%@ include file="/webpage/include/echarts.jsp"%>
	<br>
	<br>
		<div style="width:100%">
	<div id="pie"  class="main000" style="width:45%;float: left"></div>
	<div id="bar_normal"  class="main000" style="width:45%;float: right"></div>
	<div id="barstack_normal"  class="main000" style="width:100%;float: right"></div>
	</div>
		<echarts:pie
	    id="pie"
		title="元数据分类" 
		orientData="${orientDataA}"
		colorList="${colorList}"/>
	<echarts:bar 
	  	id="bar_normal"
		title="数据库类型统计" 
		xAxisData="${xAxisData}" 
		yAxisData="${yAxisData}" 
		colorList="${colorList}"
		xAxisName="数据库"
		yAxisName="表(个)" 
		/>

	<%-- <echarts:line
	  	id="barstack_normal"
		title="元数据类型更新个数统计" 
		xAxisData="${xAxisData2}" 
		yAxisData="${yAxisData2}" 
		xAxisName="日期"
		yAxisName="更新个数(个)" 
		/>  --%>
		<echarts:stackbar 
	  	id="barstack_normal"
		title="元数据类型更新个数统计" 
		xAxisData="${xAxisData2}" 
		yAxisData="${yAxisData2}" 
		colorList="${colorList}"
		xAxisName="日期"
		yAxisName="更新个数(个)" 
		/>