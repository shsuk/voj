package net.ion.webapp.utils;

import java.lang.reflect.Method;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.httpclient.methods.GetMethod;

public class StackTraceUtils {
	

	public static boolean isCallClass(String clsName) {
		Exception ex = new Exception();
		StackTraceElement[] stes = ex.getStackTrace();
		
		for(StackTraceElement ste : stes){
			String className = ste.getClassName();
			if (className.equals(clsName)) {
				return true;
			} 
		}
		return false;
	}

}
