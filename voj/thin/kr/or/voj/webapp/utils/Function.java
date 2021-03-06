package kr.or.voj.webapp.utils;

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
	public static String security(String val, String type){
		type=type.toLowerCase();
		
		if("email".equals(type)){
			int at=val.indexOf("@");
			val = StringUtils.substring(val,0 ,at-3) + "***" + StringUtils.substring(val,at,val.length());
		}else if("name".equals(type)){
			int l = val.length()==2 ? 1 : 2;
			val = StringUtils.rightPad(val.substring(0,l), val.length(), "*");
		}else if("tel".equals(type)){
			String[] tels = val.split("-");
			if(tels.length==3){
				val = tels[0] + "-" + StringUtils.substring(tels[1],0, tels[1].length()-2) + "**-*" +StringUtils.substring(tels[2],1);
			}else {
				val = StringUtils.substring(val,0, 5) + "***" +StringUtils.substring(val,8,val.length());
			}
		}else if("com_num".equals(type)){
			val = StringUtils.substring(val,0, val.length()-3) + "***";
		}else if("biz_num".equals(type)){
			val = StringUtils.substring(val,0, 3) + "-" + StringUtils.substring(val,3, 5) + "-" + StringUtils.substring(val,5, val.length());
		}else{
			val = Function.masking(val, type);
		}
		return val;
	}
	/**
	 * 보안을 위해 문자열을 마킹한다.
	 * @param val
	 * @param format
	 * @return
	 */
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
	/**
	 * 숫자로된 문자열을 전화번호형식이나 우편번호등의 포맷으로 변환
	 * ___-___
	 * @param val
	 * @param format
	 * @return
	 */
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
