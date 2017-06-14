package com.hlframe.common.tag.echarts;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;

import org.apache.commons.collections.CollectionUtils;

import com.github.abel533.echarts.code.Orient;
import com.github.abel533.echarts.code.SeriesType;
import com.github.abel533.echarts.code.Tool;
import com.github.abel533.echarts.code.Trigger;
import com.github.abel533.echarts.code.X;
import com.github.abel533.echarts.code.Y;
import com.github.abel533.echarts.data.Data;
import com.github.abel533.echarts.json.GsonOption;
import com.github.abel533.echarts.series.Line;

public class EChartsPieTag extends BodyTagSupport {
	private static final long serialVersionUID = 1L;
	private String id;
	private String title;
	private String subtitle;
	private Map<String, Object> orientData;
	private List<String> colorList;

	@Override
	public int doStartTag() throws JspException {
		return BodyTag.EVAL_BODY_BUFFERED;
	}

	@Override
	public int doEndTag() throws JspException {
		StringBuffer sb = new StringBuffer();
		sb.append("<script type='text/javascript'>");
		sb.append("var myChart= echarts.init(document.getElementById('" + id+ "'));");
		// 创建GsonOption对象，即为json字符串
		GsonOption option = new GsonOption();
		option.tooltip().trigger(Trigger.item).formatter("{a} <br/>{b} : {c} ({d}%)");
		option.title(title, subtitle);
		List<Object> colors=new ArrayList<Object>();
		//[ '#5B9CD6','#ED7E2D','#c23531','#2f4554', '#61a0a8', '#d48265', '#91c7ae','#749f83',  '#ca8622', '#bda29a','#6e7074', '#546570', '#c4ccd3' ]
		if(CollectionUtils.isNotEmpty(colorList)){
			for(String color:colorList){
				colors.add(color);
			}
			option.setColor(colors);
		}
		//['#5282e1','#5b9cd6','#6ed5e6','#7ceac5','#b0f4b0','#f5c786','#ed7e2d']
		// 工具栏
		option.toolbox().show(true).feature(
		// Tool.mark,
		// Tool.dataView,
				Tool.saveAsImage
				// new MagicType(Magic.line, Magic.bar,Magic.stack,Magic.tiled),
		//		Tool.dataZoom, Tool.restore
				);
		option.calculable(true);
		
		// 数据轴封装并解析
		for(String xdata : orientData.keySet()) {
			option.legend().orient(Orient.horizontal).x(X.left).y(Y.bottom).data(xdata);
		}
		
		if (orientData != null) {
			Line line = new Line();
			line.name(title).type(SeriesType.pie);
			for (String title : orientData.keySet()) {
				Object value = orientData.get(title);		
				Data data = new Data().name(title);
				data.value(value);
				line.data(data);				
			}
			option.series(line);
		}
		sb.append("var option=" + option.toString() + ";");
		sb.append("myChart.setOption(option);");
		sb.append("</script>");
		try {
			this.pageContext.getOut().write(sb.toString());
		} catch (IOException e) {
			System.err.print(e);
		}
		return Tag.EVAL_PAGE;// 继续处理页面
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSubtitle() {
		return subtitle;
	}

	public void setSubtitle(String subtitle) {
		this.subtitle = subtitle;
	}

	public Map<String, Object> getOrientData() {
		return orientData;
	}

	public void setOrientData(Map<String, Object> orientData) {
		this.orientData = orientData;
	}

	public List<String> getColorList() {
		return colorList;
	}

	public void setColorList(List<String> colorList) {
		this.colorList = colorList;
	}
	
	
}
