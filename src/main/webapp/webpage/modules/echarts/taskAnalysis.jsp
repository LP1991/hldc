<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<%@ include file="/webpage/include/echarts.jsp"%>
<meta name="decorator" content="default"/>

<div id="barstack_taskresource"  class="main000" style="width:75%;"></div>
<div id="barstack_taskstatus"  class="main000" style="width:75%;"></div>


	<echarts:stackbar
		id="barstack_taskresource"
		title="任务类型和来源分类"
		xAxisData="${xAxisData}"
		yAxisData="${yAxisData}"
		colorList="${colorList}"
		xAxisName="任务类型"
		yAxisName="个数(个)"
	/>

    <echarts:stackbar
        id="barstack_taskstatus"
        title="任务出发方式"
        xAxisData="${xAxisDataStatus}"
        yAxisData="${yAxisDataStatus}"
        colorList="${colorList}"
        xAxisName="任务类型"
        yAxisName="个数(个)"
    />