/********************** 版权声明 *************************
 * 文件名: IntfJson2ObjectUtils.java
 * 包名: com.hlframe.modules.dc.dataprocess.utils
 * 版权:	杭州华量软件  hldc
 * 职责: 
 ********************************************************
 *
 * 创建者：Primo  创建时间：2017/5/11
 * 文件版本：V1.0
 *
 *******************************************************/
package com.hlframe.modules.dc.dataprocess.utils;

import com.hlframe.modules.dc.metadata.entity.DcObjectField;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.util.Assert;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IntfJson2ObjectUtils {
    private static Map<String,JsonMapper> mappers = null;
    public static final String dirPath = Thread.currentThread().getContextClassLoader().getResource("").getPath();
    public static String folderPath = "jsonMapping";

    //最后修改时间 //TODO 保存文件需要更新folder 信息
    static long lastTime;

    static{
        lastTime = new File(dirPath+folderPath).lastModified();
        System.out.println("---->"+lastTime);
        initiate();
    }
    /**
     * @name: getNamespaceByUrl
     * @funciton: get the namespace by url
     * @param url  ex: http://localhost:8800/db/rest/rtls/locationmap?asd=sad
     * @return     ex: /rest/rtls/locationmap?asd=sad
     * @Create by lp at 2017/5/11 15:36
     * @throws
     */
    public static String getNamespaceByUrl(String url){
        if (url == null){
            return null;
        }
        StringBuilder sb = new StringBuilder();
        String[] splits = url.split("/");
        for(int i=0;i<splits.length;i++){
          if (i>3){
              sb.append("/").append(splits[i]);
          }
        }
        return sb.toString();
    }

    public static void initiate(){
        //clear the old mapper
        mappers = new HashMap<>();
        File folder = new File(dirPath+folderPath);
        ObjectMapper mapper = new ObjectMapper();
        if (folder.exists() && folder.isDirectory()){
            File[] files = folder.listFiles(new FileFilter() {
                @Override
                public boolean accept(File pathname) {
                    String f = pathname.getName();
                    String suffix = f.substring(f.lastIndexOf(".") + 1, f.length());
                    return pathname.isFile() && suffix.equals("json");
                }
            });
            for (File file : files) {
                InputStream input = null;
                try {
                    input = new FileInputStream(file);
                    JsonMapper o =  mapper.readValue(input,JsonMapper.class);
                    mappers.put(o.getUrl(),o);
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        input.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    public static JsonMapper getMapperByUrl(String url){
        Assert.hasText(url, "URL不能为空!");
        //如果配置文件发生修改, 则重新加载
        if (lastTime!=new File(dirPath+folderPath).lastModified()) {
            initiate();
        }
        if (mappers == null) {
            initiate();
        }

        return mappers.get(url);
    }

    public static List<DcObjectField> getFieldsByUrl(String url){
        List<DcObjectField> fields = new ArrayList<>();
        JsonMapper mapper = getMapperByUrl(url);
        if (mapper != null){
            getFieldsByMapper(mapper,fields);
        }
        return fields;
    }

    public static void getFieldsByMapper(JsonMapper mapper,List<DcObjectField> fields){
        fields.addAll(mapper.getFields());
        if(mapper.getInnerTables() != null){
            for (JsonMapper jsonMapper : mapper.getInnerTables()) {
                getFieldsByMapper(jsonMapper,fields);
            }
        }
    }

    public static void main(String[] args) {
//        String s = getNamespaceByUrl("http://localhost:8800/db/rest/rtls/locationmap?asd=sad");
//        System.out.println(s);
        initiate();
        JsonMapper jsonMapper = getMapperByUrl("http://localhost:8800/db/rest/rtls/locationmap");
//        System.out.println(jsonMapper.getFields().get(1).getFieldDesc());
//        System.out.println(jsonMapper.getInnerTables().get(0).getFields().get(0).getFieldLeng());
//        System.out.println(jsonMapper.getInnerTables().get(1).getFields().get(1).getFieldName());
        List<DcObjectField> fields = new ArrayList<>();
        fields =  getFieldsByUrl("http://localhost:8800/db/rest/rtls/locationmap");
        System.out.println(fields.size());
        for (DcObjectField field : fields) {
            System.out.println(field);
        }
    }


}
