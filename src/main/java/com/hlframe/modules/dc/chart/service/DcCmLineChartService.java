package com.hlframe.modules.dc.chart.service;

import com.hlframe.common.service.BaseService;
import com.hlframe.modules.dc.utils.DcPropertyUtils;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.core.util.MultivaluedMapImpl;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.MediaType;
import java.net.URI;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @类名: DcCmLineChartService
 * @职责说明:
 * @创建者: Primo
 * @创建时间: 2017/3/17
 */
@Service
public class DcCmLineChartService extends BaseService {
    protected DecimalFormat  df   = new DecimalFormat(".##");
    protected int byte2MByte = 1000000;
    protected int byte2KByte = 1000;
    //参数配置文件化
    /**
     * @name: getDcCmData
     * @funciton: get data by restful service for CmData
     * @param
     * @return
     * @Create by lp at 2017/3/20 9:42
     * @throws
     */
    public String getDcCmData(HttpServletRequest request){
        String result = "";
        double max = 100;
        try {
            Client client = Client.create();
            // restful 地址
            URI u = new URI(DcPropertyUtils.getProperty("clouderaManager.rest.api.url", null)+"/rest/cm/getData/");

            WebResource resource = client.resource(u);
            // 构建form参数
            MultivaluedMapImpl params = new MultivaluedMapImpl();
            JSONObject param = initParam();

            params.add("data",param);
            result = resource.type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, params);
            System.out.println(result);

            List<String> xAxisData = new ArrayList<>();
            Map<String,List<Double>> yAxisData = new HashMap<>();
            JSONArray o = new JSONArray(result);

            List<Double> data1 = new ArrayList<>();
            for(int i =0;i<o.length();i++){
                JSONObject varO = (JSONObject)o.get(i);
                double r_v = Double.parseDouble(varO.get("cpu").toString());
                data1.add(Double.valueOf(df.format(r_v)));
                xAxisData.add(varO.get("date").toString());
            }
            Map<String, Integer> yAxisIndex = new HashMap<>();
            for (int i=1;i<6;i++){
                int index = (int)max*i/5;
                yAxisIndex.put(""+index,index);
            }
            yAxisData.put("CPU使用率", data1);
            request.setAttribute("xAxisData4cpu", xAxisData);
            request.setAttribute("yAxisData4cpu", yAxisData);
            request.setAttribute("yAxisIndex", yAxisIndex);
            return result;
        } catch (Exception e) {
            logger.error("-->executeSql: ", e);
            request.setAttribute("zt","监控项目没有开启");
            e.printStackTrace();
        }
        return result;
    }


    /**
     * @name: getDiskIOData
     * @funciton: get data by restful service for CmData
     * @param
     * @return
     * @Create by lp at 2017/3/20 9:42
     * @throws
     */
    public void getDiskIOData(HttpServletRequest request){
        String result = "";
        double max = 0;
        try {
            Client client = Client.create();
            // restful 地址
            URI u = new URI(DcPropertyUtils.getProperty("clouderaManager.rest.api.url", null)+"/rest/cm/getDiskIOData/");

            WebResource resource = client.resource(u);
            // 构建form参数
            MultivaluedMapImpl params = new MultivaluedMapImpl();
            JSONObject param = initParam();

            params.add("data",param);
            result = resource.type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, params);

            List<String> xAxisData = new ArrayList<>();
            Map<String,List<Double>> yAxisData = new HashMap<>();
            JSONArray o = new JSONArray(result);

            List<Double> read = new ArrayList<>();
            List<Double> write = new ArrayList<>();
            for(int i =0;i<o.length();i++){
                JSONObject varO = (JSONObject)o.get(i);
                double r_v = Double.parseDouble(varO.get("read").toString())/byte2MByte;
                double w_v = Double.parseDouble(varO.get("write").toString())/byte2MByte;
                if(r_v>max){
                    max = r_v;
                }
                if(w_v>max){
                    max = w_v;
                }
                read.add(Double.valueOf(df.format(r_v)));
                write.add(Double.valueOf(df.format(w_v)));
                xAxisData.add(varO.get("date").toString());
            }
            Map<String, Integer> yAxisIndex = new HashMap<>();
            max = max +10;

            for (int i=1;i<6;i++){
                int index = (int)max*i/5;
                yAxisIndex.put(abbreviateIndex(index),index);
            }
            yAxisData.put("总磁盘字节数写入", write);
            yAxisData.put("总磁盘字节数读取", read);
            request.setAttribute("xAxisData4disk", xAxisData);
            request.setAttribute("yAxisData4disk", yAxisData);
            request.setAttribute("yAxisIndex", yAxisIndex);
        } catch (Exception e) {
            logger.error("-->executeSql: ", e);
            e.printStackTrace();
        }
    }

    private JSONObject initParam() throws Exception{
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar c = Calendar.getInstance();
        c.setTimeInMillis(System.currentTimeMillis());

        String now = sdf.format(c.getTime());
        c.add(Calendar.DATE,+1);
        String tomorrow = sdf.format(c.getTime());
        JSONObject param = new JSONObject();
        param.put("from",now);
        param.put("to", tomorrow);
        return param;
    }

    private String abbreviateIndex(int index) {
        if (index > 1000000){
            return String.valueOf(index/1000000.0)+"M";
        }else if (index > 1000){
            return String.valueOf(index/1000.0)+"K";
        }else{
            return index+"";
        }
    }

    /**
     * @name: getNetIOData
     * @funciton: get data by restful service for CmData
     * @param
     * @return
     * @Create by lp at 2017/3/20 9:42
     * @throws
     */
    public void getNetIOData(HttpServletRequest request){
        String result = "";
        double max = 0;
        try {
            Client client = Client.create();
            // restful 地址
            URI u = new URI(DcPropertyUtils.getProperty("clouderaManager.rest.api.url", null)+"/rest/cm/getNetIOData/");

            WebResource resource = client.resource(u);
            // 构建form参数
            MultivaluedMapImpl params = new MultivaluedMapImpl();
            JSONObject param = initParam();

            params.add("data",param);
            result = resource.type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, params);

            List<String> xAxisData = new ArrayList<>();
            Map<String,List<Double>> yAxisData = new HashMap<>();
            JSONArray o = new JSONArray(result);

            List<Double> transmit = new ArrayList<>();
            List<Double> receive = new ArrayList<>();
            for(int i =0;i<o.length();i++){
                JSONObject varO = (JSONObject)o.get(i);
                double t_v = Double.parseDouble(varO.get("transmit").toString())/byte2KByte;
                double r_v = Double.parseDouble(varO.get("receive").toString())/byte2KByte;
                if(t_v>max){
                    max = t_v;
                }
                if(r_v>max){
                    max = r_v;
                }
                transmit.add(Double.valueOf(df.format(t_v)));
                receive.add(Double.valueOf(df.format(r_v)));
                xAxisData.add(varO.get("date").toString());

            }
            Map<String, Integer> yAxisIndex = new HashMap<>();
            max = max +10;
            for (int i=1;i<6;i++){
                int index = (int)max*i/5;
                yAxisIndex.put(abbreviateIndex(index),index);
            }
            yAxisData.put("网络接口总传输字节", transmit);
            yAxisData.put("网络接口总接受字节", receive);
            request.setAttribute("xAxisData4net", xAxisData);
            request.setAttribute("yAxisData4net", yAxisData);
            request.setAttribute("yAxisIndex", yAxisIndex);
        } catch (Exception e) {
            logger.error("-->executeSql: ", e);
            e.printStackTrace();
        }
    }

    /**
     * @name: getHdfsCapacity
     * @funciton: get data by restful service for CmData
     * @param
     * @return
     * @Create by lp at 2017/3/20 9:42
     * @throws
     */
    public void getHdfsCapacity(HttpServletRequest request){
        String result = "";
        try {
            Client client = Client.create();
            // restful 地址
            URI u = new URI(DcPropertyUtils.getProperty("clouderaManager.rest.api.url", null)+"/rest/cm/getHdfsCapacity/");

            WebResource resource = client.resource(u);
            // 构建form参数
            MultivaluedMapImpl params = new MultivaluedMapImpl();
            JSONObject param = initParam();

            params.add("data",param);
            result = resource.type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, params);

            Map<String,Object>  orientData = new HashMap<>();
            JSONArray o = new JSONArray(result);

            JSONObject varO = (JSONObject)o.get(o.length()-1);
            double capacity = Double.parseDouble(  varO.get("capacity").toString());
            double capacity_used = Double.parseDouble(varO.get("capacity_used").toString());
            double capacity_used_non_hdfs = Double.parseDouble(varO.get("capacity_used_non_hdfs").toString());

            orientData.put("Hdfs容量",Double.valueOf(capacity_used*100/capacity));
            orientData.put("非Hdfs容量",Double.valueOf(capacity_used_non_hdfs*100/capacity));
            orientData.put("剩余容量",Double.valueOf((capacity-capacity_used-capacity_used_non_hdfs)*100/capacity));
            request.setAttribute("orientData", orientData);
        } catch (Exception e) {
            logger.error("-->executeSql: ", e);
            e.printStackTrace();
        }
    }

    public static  void main(String[] args){
        DcCmLineChartService dc = new DcCmLineChartService();
        dc.getDcCmData(null);
    }
}
