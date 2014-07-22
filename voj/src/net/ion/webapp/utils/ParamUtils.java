package net.ion.webapp.utils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.db.Lang;
import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.service.ProcessService;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;


public class ParamUtils {
	protected static final Logger logger = Logger.getLogger(ParamUtils.class);
	/**
	 * 문자열의 값을 치환한다.
	 * @{$groupid.value}코드 테이블에서 찾아 치환한다.
	 * @{&code}다국어 테이블에서 찾아 치환한다.
	 * @{code}데이타 소스에서 찾아 치환
	 * ${param}EL 문법처리
	 * @param value
	 * @param sourceDate
	 * @return
	 */
	public static Object getReplaceValue(String value, Map<String, Object> sourceDate) {
		if(StringUtils.isEmpty(value)) return "";
		
		String val = value;
		
		while(true){
			String keyStr = StringUtils.substringBetween(val, "@{", "}");
			
			if(StringUtils.isEmpty(keyStr)) break;
			if(keyStr.startsWith("$")){
				try {
					keyStr = keyStr.substring(1);
					String[] keys = StringUtils.split(keyStr, '.');
					String tempValue = CodeUtils.getReferenceValue(keys[0], keys[1]);
					if(keys[1].equals(tempValue)) throw new RuntimeException("미등록 코드 : '" + keyStr + "'의 값이 코드 테이블에 등록되지 않았습니다.");

					val = StringUtils.replace(val, "@{$" + keyStr + "}", tempValue);
					continue;
				} catch (Exception e) {
					//e.printStackTrace();
					throw new RuntimeException("미등록 코드 : '" + keyStr + "'의 값이 코드 테이블에 등록되지 않았습니다.");
				}
			}else if(keyStr.startsWith("&")){
				try {
					String lang = ((Map)sourceDate.get("session")).get("lang").toString();
					keyStr = keyStr.substring(1);
					String[] keys = StringUtils.split(keyStr, ',');
					
					String tempValue = Lang.getMessage(keys[0].trim(), lang, keys.length>1 ? keys[1] : "");

					val = StringUtils.replace(val, "@{&" + keyStr + "}", tempValue);
					continue;
				} catch (Exception e) {
					throw new RuntimeException("미등록 언어 : '" + keyStr + "'의 값이 다국어 테이블에 등록되지 않았습니다.");
				}
			}else{
				Object tempValue = getValue(keyStr, sourceDate);
				val = StringUtils.replace(val, "@{" + keyStr + "}", tempValue.toString());
			}
		}
		
		while(true){
			String orgVal = val;
			String keyStr = StringUtils.substringBetween(val, "${", "}");
			
			if(StringUtils.isEmpty(keyStr)) break;

			try {
				Object tempValue = Evaluate.eval(keyStr);
				
				if(("${" + keyStr + "}").equals(orgVal)){
					return tempValue;
				}
				val = StringUtils.replace(val, "${" + keyStr + "}", tempValue.toString());
			} catch (Exception e) {
				throw new RuntimeException("다음 표현식이 잘못되었습니다. \n" + value + "", e);
			}
		}
		
		return val;
	}
	
	public static String getValue(String paramName, Map<String, Object> sourceDate) {
		return getObject(paramName, sourceDate).toString();
	}
	public static Map<String, String> getReqMap(Map<String, String[]> map) {
		Map<String, String> param = new HashMap<String, String>();
		
		for(String key : map.keySet()){
			param.put(key, map.get(key)[0]);
		}
		return param;
	}
	public static Object getObject(String paramName, Map<String, Object> sourceDate) {

		String keyStr = paramName;
				
		Object tempValue = sourceDate;
		
		String[] keys = StringUtils.split(keyStr, '.');
		
		if("param".equals(keys[0])) keys[0] = ProcessService.REQUEST_PARAMS;
				
		for(int i=0; i<keys.length; i++){
			String keyVal = keys[i];
			String key = keyVal;
			String idxS = "0";
			
			if(keyVal.endsWith("]")){
				idxS = StringUtils.substringBetween(keyVal, "[", "]").trim().toLowerCase();
				key = StringUtils.substringBefore(keyVal, "[");
			}
			
			if (tempValue instanceof Map) {
				tempValue = getValueByMap(tempValue, key, idxS);
			}else if (tempValue instanceof List){
				List list = (List) tempValue;
				int idx = "last".equals(idxS) ? list.size()-1 : Integer.parseInt(idxS);
				tempValue = list.get(idx);
				if(StringUtils.isNotEmpty(key)){
					if (tempValue instanceof Map) {
						tempValue = getValueByMap(tempValue, key, idxS);
					}else{
						throw new RuntimeException("파라메터의 값을 찾을 수 없습니다. : " + paramName);
					}
				}
			}else{
				throw new RuntimeException("파라메터의 값을 찾을 수 없습니다. : " + paramName);
			}
			
			if(tempValue==null && keys.length>2 && i==1) return "";
		}
		if(tempValue==null){
			//logger.debug("===========================================");
			//logger.debug("파라메터의 값을 찾을 수 없습니다. : " + paramName);
			//logger.debug("===========================================");
			tempValue = "";
		}
		return tempValue;
	}
	private static Object getValueByMap(Object tempValue, String key, String idxS) {
			Map map = (Map) tempValue;
			
			tempValue = map.get(key.trim());
			
			if(tempValue instanceof Map){
				Map jo = (Map)tempValue;
				if(jo==null) tempValue = null;
			}else if(tempValue==null){
				//if(keys.length>2 && i==1) return "";
				return null;
				//throw new RuntimeException("파라메터의 값을 찾을 수 없습니다. : " + paramName);
			}else if (tempValue instanceof List) {
				List list = (List) tempValue;
				int idx = "last".equals(idxS) ? list.size()-1 : Integer.parseInt(idxS);
				
				tempValue = list.size()>0 ? list.get(idx) : "";
			}else if (tempValue instanceof String[]) {
				String[] list = (String[]) tempValue;
				int idx = "last".equals(idxS) ? list.length-1 : Integer.parseInt(idxS);
				
				tempValue = list.length>0 ? list[idx] : "";
			}
			return tempValue;
	}
}
