package net.ion.webapp.utils;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang.StringUtils;

public class Function {
	public static String formatDate(Date date, String pattern) {
		if(date==null) return "";
		SimpleDateFormat DateFormater = new SimpleDateFormat(pattern);

		return DateFormater.format(date);
	}
	public static String formatDate(String pattern) {
		return formatDate(new Date(), pattern);
	}
	public static Date now() {
		return (new Date());
	}
	public static long double2long(double val) {
		
		return (new Double(val)).longValue();
	}
	public static long replaceData(double val) {
		
		return (new Double(val)).longValue();
	}
	public static String escapeXml(String val) {
		return org.apache.taglibs.standard.functions.Functions.escapeXml(val).replaceAll("\n", "<br>");
	}
	public static String concat(String val1, String val2) {
		return val1+val2;
	}
	
	public static void mkDir(String path) {
		File f = new File(path);
		if(!f.exists()) f.mkdirs();
	}

	public static String masking(String val, String format) {
		int p = 0;
		StringBuffer sb = new StringBuffer();
		
		for(int i=0;i<format.length(); i++){
			char f = format.charAt(i);
			
			if(i == val.length()){
				break;
			}
			
			char c = val.charAt(i);

			if(f=='_'){
				sb.append(c);
			}else{
				sb.append(f);
			}
		}
		return sb.toString();
	}
	public static String format(String val, String format) {
		int p = 0;
		StringBuffer sb = new StringBuffer();
		
		for(int i=0;i<val.length(); i++){
			char c = val.charAt(i);
			
			if(p > format.length()){
				sb.append(c);
				continue;
			}
			
			char f = format.charAt(p);
			p++;
			
			if(f=='_'){
				sb.append(c);
			}else{
				sb.append(f);
				sb.append(c);
				p++;
			}
		}
		return sb.toString();
	}

	public static File[] getFiles(String root, String path) {
		if (!("".equals(path))) {
			if (path.startsWith("."))
				path = "";
			else if (!(path.startsWith("/")))
				path = "/" + StringUtils.substringBeforeLast(path, "/");
		}
		File f = new File(root + path);
		if (!(f.isDirectory()))
			f = f.getParentFile();
		return f.listFiles();
	}
	
	public static void main(String[] args) {
		System.out.println(		format("12121232", "___@___.___"));
	}
}
