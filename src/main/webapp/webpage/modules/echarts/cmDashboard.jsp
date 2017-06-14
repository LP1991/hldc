<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<%@ include file="/webpage/include/echarts.jsp"%>
<meta name="decorator" content="default"/>
<c:if test="${zt==null}">
	<div style="width:100%">
		<div id="line_netio"  class="main000" style="width:45%;float: left"></div>
		<div id="line_diskio"  class="main000" style="width:45%;float: right"></div>
		<div id="line_dcDashboard_cpu"  class="main000" style="width:45%;float: right"></div>
		<div id="capacityOfHdfs"  class="main000" style="width:45%;float: left"></div>
	</div>

	<echarts:line
			id="line_dcDashboard_cpu"
			title="集群CPU"
			subtitle="整个集群CPU使用率"
			xAxisName="时间"
			yAxisName="使用率(%)"
			xAxisData="${xAxisData4cpu}"
			yAxisData="${yAxisData4cpu}"
			colorList="${colorList}"
	/>

	<echarts:line
			id="line_diskio"
			title="群集磁盘 IO"
			subtitle="群集磁盘 IO"
			xAxisData="${xAxisData4disk}"
			yAxisData="${yAxisData4disk}"
			xAxisName="时间"
			yAxisName="Mbytes/s"
			colorList="${colorList}"/>
	<echarts:line
			id="line_netio"
			title="群集网络 IO"
			subtitle="群集网络 IO"
			xAxisData="${xAxisData4net}"
			yAxisData="${yAxisData4net}"
			xAxisName="时间"
			yAxisName="Kbytes/s"
			colorList="${colorList}"/>

	<echarts:pie
			id="capacityOfHdfs"
			title="hdfs容量"
			subtitle="hdfs容量"
			orientData="${orientData}"
			colorList="${colorList}"
	/>
</c:if>
<c:if test="${zt!=null}">
	<sys:message content="${zt}"/>
</c:if>