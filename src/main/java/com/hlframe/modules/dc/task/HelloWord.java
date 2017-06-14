package com.hlframe.modules.dc.task;

import java.lang.reflect.Method; 

/** 
* Created by baiyunpeng on 2016/8/26. 
*/ 
public class HelloWord { 

    /** 
     * @param args 
     */ 
    public static void main(String[] args) { 
        try { 
            Hello h=new Hello(); 
            Object[] argspara=new Object[]{}; 
            Object aa = HelloWord.invokeMethod(h,"helloStrs",argspara); 
            System.out.println("*******"+aa.toString()+"*******"); 

            HelloWord.invokeMethod(h, "helloStrs",argspara); 
            argspara=new Object[]{"he"}; 
            HelloWord.invokeMethod(h, "helloStrs",argspara); 
            argspara=new Object[]{"she",2}; 
            HelloWord.invokeMethod(h, "helloStrs2",argspara); 

        } catch (Exception e) { 
            e.printStackTrace(); 
        } 
    } 

    /** 
     * 反射调用方法 
     * @param newObj 实例化的一个对象 
     * @param methodName 对象的方法名 
     * @param args 参数数组 
     * @return 返回值 
     * @throws Exception 
     */ 
    public static Object invokeMethod(Object newObj, String methodName, Object[] args)throws Exception { 
        Class ownerClass = newObj.getClass(); 
        Class[] argsClass = new Class[args.length]; 
        for (int i = 0, j = args.length; i < j; i++) { 
            argsClass[i] = args[i].getClass(); 
        } 
        Method method = ownerClass.getMethod(methodName, argsClass); 
        return method.invoke(newObj, args); 
    } 

} 

class Hello{ 

    public String helloStrs(){ 
        //根据不同的方法名称，调用不用的方法 
        System.out.println("hello1"); 
        return "hello1"; 
    } 

    public void helloStrs(String a) { 
        //根据不同的方法名称，调用不用的方法 
        System.out.println("hello11"); 
    } 

    public void helloStrs2(String a ,Integer b) throws Exception{ 
        //根据不同的方法名称，调用不用的方法 
        System.out.println("hello12"); 
    } 
} 