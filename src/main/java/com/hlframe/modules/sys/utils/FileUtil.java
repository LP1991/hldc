package com.hlframe.modules.sys.utils;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.hlframe.modules.dc.utils.Log4jPropertyUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FileUtil{
	private static final String sensiFilePath = "sensitiveWords.properties";
	public static String filePath = Log4jPropertyUtils.getProperty("log4j.appender.RollingFile.File").replace("${catalina.home}", System.getProperty("catalina.home"));//日志所在目录

	private final static Logger logger = LoggerFactory.getLogger(FileUtil.class);

	public static void main(String[] args) throws Exception {
	//	String path = "C:\\server\\apache-tomcat-7.0.67\\logs\\hleast\\hlframe.log";//测试文件路径
		int lineNum = getTotalLines(filePath);
		int startLine = 0;
		if (lineNum <= 500) {
			startLine = 1;
		} else {
			startLine = lineNum - 500;
		}

		String str = null;
		try {
			Reader r = new FileReader(new File(filePath));
			char c[] = new char[(int) new File(filePath).length()];
			r.read(c);
			str = new String(c);
			System.out.println(getText(str, startLine, lineNum));
			r.close();
		} catch (RuntimeException e) {
			logger.error("-->RuntimeException:",e);
		} catch (FileNotFoundException e) {
			logger.error("-->FileNotFoundException:",e);
		} catch (IOException e) {
			logger.error("-->IOException:",e);
		}

	}

	/**
	 * @方法名称: getText
	 * @实现功能: 获取第几行到第几行的数据
	 * @param str
	 * @param st
	 * @param ed
	 * @return
	 * @create by cdd at 2016年11月30日 下午3:01:08
	 */
	private static String getText(String str, int st, int ed) {
		int n = 0;
		int pos = -1;
		while (n < st) {
			pos = str.indexOf("\n", pos + 1);
			if (pos == -1) {
				return "";
			}
			n++;
		}
		int st_pos = pos;
		while (n < ed) {
			pos = str.indexOf("\n", pos + 1);

			if (pos == -1) {
				return str.substring(pos + 1);

			}
			n++;
		}
		return "...\n" + str.substring(st_pos + 1, pos);
	}
	 
	/**
	 * @方法名称: getTotalLines
	 * @实现功能: 获取文件的总行数
	 * @param path
	 * @return
	 * @throws Exception
	 * @create by cdd at 2016年11月29日 上午8:39:36
	 */
	public static int getTotalLines(String path) throws Exception {
		FileReader fr = new FileReader(path); // 这里定义一个字符流的输入流的节点流，用于读取文件（一个字符一个字符的读取）
		BufferedReader br = new BufferedReader(fr); // 在定义好的流基础上套接一个处理流，用于更加效率的读取文件（一行一行的读取）
		int x = 0; // 用于统计行数，从0开始
		while (br.readLine() != null) { // readLine()方法是按行读的，返回值是这行的内容
			x++; // 每读一行，则变量x累加1
		}
		return x;
	}

	/**
	 * @方法名称: ShowTomcatInformation
	 * @实现功能: 显示tomcat日志信息
	 * @return
	 * @throws Exception
	 * @create by cdd at 2016年11月30日 上午8:40:23
	 */
	public static String ShowTomcatInformation() throws Exception {
	//	String path = "C:\\server\\apache-tomcat-7.0.67\\logs\\hleast\\hlframe.log";// 定义文件路径
		String content = null;
		int lineNum = getTotalLines(filePath);
		int startLine = lineNum - 500;
		String str = null;
		try {
			Reader r = new FileReader(new File(filePath ));
			char c[] = new char[(int) new File(filePath ).length()];
			r.read(c);
			str = new String(c);

		 content = getText(str, startLine, lineNum);
			r.close();

		} catch (RuntimeException e) {
			logger.error("-->RuntimeException:",e);
		} catch (FileNotFoundException e) {
			logger.error("-->FileNotFoundException:",e);
		} catch (IOException e) {
			logger.error("-->IOException:",e);
		}
		return isFilter(content);
	}
 
	/**
	 * @方法名称: LoadTomcatInformation
	 * @实现功能: 下载tomcat日志信息
	 * @return
	 * @throws Exception
	 * @create by cdd at 2016年11月30日 上午8:40:23
	 */
    public static void LoadTomcatInformation(HttpServletRequest request, HttpServletResponse response) throws Exception{
    	
	 // String exportPath = "D:\\cdd\\cdd.txt";//路径可配置
	  // PrintWriter pw = new PrintWriter( new FileWriter(exportPath) );
      //  pw.print(ShowTomcatInformation());
      //  pw.close();
		//return "下载成功";
    	String content = ShowTomcatInformation();
        byte[] data = content.getBytes("UTF-8"); 
		response.reset();
		response.setHeader("Content-Disposition", "attachment; filename=\"" + "log" + ".txt\"");
		response.addHeader("Content-Length", "" + data.length);
		response.setContentType("application/octet-stream;charset=UTF-8");
		OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
		outputStream.write(data);
		outputStream.flush();
		outputStream.close();
		response.flushBuffer();
	}
    
    /**
     * 
     * @方法名称: isFilter 
     * @实现功能: 敏感词处理方法
     * @param inputWords
     * @return
     * @create by cdd at 2016年12月1日 上午11:56:22
     */
	public static String isFilter(String inputWords) throws IOException {
		String result = inputWords;// 此部分是从sensitiveWords.properties读到敏感词的正则表达式，及屏蔽规则
		Properties prop = DcPropertyUtils.load(DcPropertyUtils.dirPath+sensiFilePath);

		Map<String, Object> map = new HashMap<String, Object>();// 将配置文件中的内容存到map中
		map.put(prop.getProperty("password_reg"), prop.getProperty("password_format"));//前一个参数是密码的正则表达式，后一个参数是找到密码后所做的修改
		map.put(prop.getProperty("username_reg"), prop.getProperty("username_format"));//前一个参数是用户名的正则表达式，后一个参数是找到用户名后所做的修改
		map.put(prop.getProperty("URI_reg"), prop.getProperty("URI_format"));
		
		Iterator it = map.keySet().iterator();
		while (it.hasNext()) {
			String key = (String) it.next();
			String value = map.get(key).toString();
			result = result.replaceAll(key, value);// 构建inputWords.replaceAll(key, value).replaceAll(key, value)
		}
		return result;
	}
}
