package net.ion.webapp.utils;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.HashMap;
import java.util.Map;

public class SaveObject {
	private static String root = "";
	public static void setSavePath(String savePath){
		root = savePath + "/";
	}
	public static void main(String[] args)throws Exception {
		Map<String, String> m = new HashMap<String, String>();
		m.put("sss", "sdsdsd");
		m.put("sss1", "sdsdsd1");
		m.put("sss2", "sdsdsd2");
		save("test", m);
		
		Map<String, String> m1 = (Map<String, String>)load("test", HashMap.class);
		System.out.println(m1);
	}
	
	public static void save(String key, Object obj) throws Exception  {
		FileOutputStream fos = null;
		ObjectOutputStream oos = null;
		try {
			String fname = obj.getClass().getName();
			fos = new FileOutputStream(root + fname+"."+key);
			oos = new ObjectOutputStream(fos);
			oos.writeObject(obj);
			
		} finally{
			oos.close();
		}
		
	}
	public static Object load(String key, Class clazz) throws Exception {
		FileInputStream fis = null;
		ObjectInputStream ois = null;
		Object obj = null;
		try {
			clazz.getPackage();
			fis = new FileInputStream(root + clazz.getName()+"."+key);
			ois = new ObjectInputStream(fis);
			obj = ois.readObject();
			
		} finally{
			ois.close();
			
		}
		return obj;
	}
}
