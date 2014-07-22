package net.ion.webapp.process;

import java.util.Map;

import org.apache.commons.lang.StringUtils;

import net.ion.webapp.utils.ParamUtils;
import net.sf.json.JSONObject;

public class ProcessInfo {
	private JSONObject processDetail;
	private Map<String, Object> sourceDate;
	private boolean isTest = false;
	private boolean isDebug = false;
	
	public ProcessInfo(JSONObject processDetail, Map<String, Object> sourceDate, boolean isTest, boolean isDebug) {
		this.processDetail = processDetail;
		this.sourceDate = sourceDate;
		this.isTest = isTest;
		this.isDebug = isDebug;
	}
	
	public boolean isTest() {
		return isTest;
	}
	public void setTest(boolean isTest) {
		this.isTest = isTest;
	}
	public boolean isDebug() {
		return isDebug;
	}
	public void setDebug(boolean isDebug) {
		this.isDebug = isDebug;
	}
	public JSONObject getProcessDetail() {
		return processDetail;
	}
	public Map<String, Object> getSourceDate() {
		return sourceDate;
	}
	public Object get(String key) {
		return processDetail.get(key);
	}
	public static boolean getBooleanValue(JSONObject pDetail, Map<String, Object> sDate, String key, boolean defaultValue) throws Exception{
		Object val = pDetail.get(key);
		if(val==null){
			return defaultValue;
		}else{			
			if (val instanceof String) {
				try {
					if(!((String) val).startsWith("${")) val = "${" + val + "}";

					return (Boolean)ParamUtils.getReplaceValue((String) val, sDate);
				} catch (Exception e) {
					throw new Exception(key + " 연산식 오류 : " + val, e);
				}
			}else if (val instanceof Boolean){
				return ((Boolean) val).booleanValue();
			}else{
				throw new Exception(key + " 연산식 오류 : " + val);
			}
		}
	}
	public boolean getBooleanValue(String key, boolean defaultValue) throws Exception{
		return getBooleanValue(processDetail, sourceDate, key, defaultValue);
	}
	public int getIntValue(String key, int defaultValue) {
		Object val = processDetail.get(key);
		return val!= null ? (Integer)val : defaultValue;
	}
	
	public String getString(String key, String defaultValue) {
		String value = (String)processDetail.get(key);
		value = (String)ParamUtils.getReplaceValue(value, sourceDate);
		value = StringUtils.isEmpty(value) ? defaultValue : value;
		return value;
	}
	public String getString(String key) {
		String value = (String)processDetail.get(key);
		value = (String)ParamUtils.getReplaceValue(value, sourceDate);
		
		return value;
	}
	public String replaceString(String val) {
		
		return ParamUtils.getReplaceValue(val, sourceDate).toString();
	}
	public Object replaceObject(String val) {
		
		return ParamUtils.getReplaceValue(val, sourceDate);
	}
	public Object getData(String key) {
		return sourceDate.get(key);
	}
}
