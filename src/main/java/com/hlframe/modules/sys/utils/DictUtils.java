/**
 * Copyright &copy; 2015-2020 <a href="http://www.hleast.com/">hleast</a> All rights reserved.
 */
package com.hlframe.modules.sys.utils;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hlframe.common.utils.CacheUtils;
import com.hlframe.common.utils.SpringContextHolder;
import com.hlframe.modules.sys.dao.DictDao;
import com.hlframe.modules.sys.entity.Dict;

/**
 * 字典工具类
 * @author hlframe
 * @version 2013-5-29
 */
public class DictUtils {
	
	private static Logger logger = LoggerFactory.getLogger(DictUtils.class);
			
	private static DictDao dictDao = SpringContextHolder.getBean(DictDao.class);

	public static final String CACHE_DICT_MAP = "dictMap";
	
	/**
	 * @方法名称: getDictLabel 
	 * @实现功能: 根据数据字典代码获取对应的label值
	 * @param value
	 * @param type
	 * @param defaultValue
	 * @return
	 * @modified by peijd at 2016年11月8日 上午9:32:15
	 */
	public static String getDictLabel(String value, String type, String defaultValue){
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(value)){
			for (Dict dict : getDictList(type)){
				//无需再获取单项分类
//				if (type.equals(dict.getType()) && value.equals(dict.getValue())){
				if (value.equals(dict.getValue())){
					return dict.getLabel();
				}
			}
		}
		return defaultValue;
	}
	
	public static String getDictLabels(String values, String type, String defaultValue){
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(values)){
			List<String> valueList = Lists.newArrayList();
			for (String value : StringUtils.split(values, ",")){
				valueList.add(getDictLabel(value, type, defaultValue));
			}
			return StringUtils.join(valueList, ",");
		}
		return defaultValue;
	}

	/**
	 * @方法名称: getDictValue 
	 * @实现功能: 根据label获取对应的数据字典代码值
	 * @param label
	 * @param type
	 * @param defaultLabel
	 * @return
	 * @modified by peijd at 2016年11月8日 上午9:32:42
	 */
	public static String getDictValue(String label, String type, String defaultLabel){
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(label)){
			for (Dict dict : getDictList(type)){
				//无需再获取单项分类
//				if (type.equals(dict.getType()) && label.equals(dict.getLabel())){
				if (label.equals(dict.getLabel())){
					return dict.getValue();
				}
			}
		}
		return defaultLabel;
	}
	
	/**
	 * @方法名称: getDictList 
	 * @实现功能: 获取数据字典列表  
	 * @param type
	 * @return
	 * @Modefied by peijd at 2016年11月7日 下午9:23:43   	原先加载的方法存在问题, 数据字典配对方式不对 
	 * @Modefied by peijd at 2017年03月11日11:00:43   	解决新建数据字典无法加载的问题 
	 */
	public static List<Dict> getDictList(String type){
		@SuppressWarnings("unchecked")
		Map<String, List<Dict>> dictMap = (Map<String, List<Dict>>)CacheUtils.get(CACHE_DICT_MAP);
		Map<String, String> typeMap = null;
		if (dictMap==null){
			//map用于保存分类的id-type
			typeMap = new HashMap<String, String>();
			dictMap = Maps.newHashMap();
			for (Dict dict : dictDao.findAllList(new Dict())){
				//创建顶级分类
				if("0".equals(dict.getParentId())){
					typeMap.put(dict.getId(), dict.getType());
					dictMap.put(dict.getType(), Lists.newArrayList(dict));
					
				}else{//添加子分类
//					List<Dict> dictList = dictMap.get(dict.getType());
					if(typeMap.containsKey(dict.getParentId())){
						dictMap.get(typeMap.get(dict.getParentId())).add(dict);
					}
				}
			}
			CacheUtils.put(CACHE_DICT_MAP, dictMap);
		}
		List<Dict> dictList = dictMap.get(type);
		
		//数据字典为空 重新加载
		if (CollectionUtils.isEmpty(dictList)){
			Dict param = new Dict();
			param.setType(type+"_");
			dictList = dictDao.queryListByTypeId(param);
			dictMap.put(type, dictList);
		}
		
		if(CollectionUtils.isEmpty(dictList)){
			logger.error("未获取到["+type+"]的数据字典, 请检查!");
			return new ArrayList<Dict>();
		}
		return dictList;
	}

	/*
	 * 反射根据对象和属性名获取属性值
	 */
	public static Object getValue(Object obj, String filed) {
		try {
			Class clazz = obj.getClass();
			PropertyDescriptor pd = new PropertyDescriptor(filed, clazz);
			Method getMethod = pd.getReadMethod();//获得get方法

			if (pd != null) {

				Object o = getMethod.invoke(obj);//执行get方法返回一个Object
				return o;

			}
		} catch (Exception e) {
			logger.error("-->getValue: ", e);
		}
		
		return null;
	}
	
	/**
	 * @方法名称: getDictListLike 
	 * @实现功能: 获取数据字典的所有分类
	 * @param type
	 * @return
	 * @Modify by peijd at 2016年11月8日 下午9:25:55 增加排序设置
	 */
	public static List<Dict> getDictListLike(String type){
		
		List<Dict> dictList = dictDao.findAllList(new Dict());
		List<Dict> list = Lists.newArrayList();
		for (Dict dict : dictList){
			if (dict.getType().indexOf(type+"_")>-1 ){
				list.add(dict);
			}
		}
		//根据序号设置排序 Modify By peijd 2016-11-08
		Collections.sort(list, new Comparator<Dict>(){  
            public int compare(Dict d1, Dict d2) {  
                return d1.getSort() - d2.getSort();  
            }  
        });   
		return list;
	}
	
	
}
