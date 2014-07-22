package net.ion.webapp.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

public class Lang {
	private static Map<String, String> langMap = new HashMap<String, String>();
	private static JSONObject langJson;
	private static Map<String,String[]> changeDataMap = new HashMap<String,String[]>();

	public static JSONObject getDataMap() {
		JSONObject jo = new JSONObject();
		jo.put("Changed messages", changeDataMap);
		return jo;
	}

	public static void clear() {
		langMap.clear();
	}

	private static synchronized void init() throws Exception {

		if (langMap.size() > 0) return;
		//System.out.println("\n\n\n==============================================\n다국어 초기화 시작");
		langJson = new JSONObject();
		//Map<String, Map<String, String>> langMap2 = new HashMap<String, Map<String, String>>();
		String queryPath = "system/lang/list";
		List<LowerCaseMap<String, Object>> list = DbUtils.select(queryPath, null);

		for (LowerCaseMap<String, Object> row : list) {
			String lang = (String)row.get("lang");
			String message_id = (String)row.get("message_id");
			langMap.put(lang+'.'+message_id, (String)row.get("message"));

			if(!StringUtils.startsWith(message_id, "valid_") && !StringUtils.startsWith(message_id, "errid_")) continue;
			
			@SuppressWarnings("unchecked")
			Map<String, String> msgMap = (Map<String, String>)langJson.get(lang);
			
			if(msgMap==null) {
				msgMap = new HashMap<String, String>();
			}
			
			msgMap.put(message_id, (String)row.get("message"));
			langJson.put(lang, msgMap);
		}
		
		langMap.put("__TEMP__", "");
		
		//System.out.println("langMap : " + langMap);
		//System.out.println("langJson : " + langJson);

		//langJson = JSONObject.fromObject(langMap2);
	}
	public static String getMessage(String messageId, String lang, String defaultValue) throws Exception {
		return getMessage(messageId, lang, defaultValue, false);
	}
	public static String getMessageAuto(String messageId, String lang, String defaultValue) throws Exception {
		return getMessage(messageId, lang, defaultValue, true);
	}
	
	public static String getMessage(String messageId, String lang, String defaultValue, boolean isAuto) throws Exception {
		
		try {
			init();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		if(StringUtils.isEmpty(lang)) lang = "kr";
		
		String key = lang + "." + messageId;
		String val = langMap.get(key);
		if(val==null){
			
			if(!isAuto && StringUtils.isNotEmpty(messageId) && StringUtils.isNotEmpty(defaultValue)){
				try {
					JSONObject pDetail = new JSONObject();
					pDetail.put("jobId", "db");
					pDetail.put("query", "/system/lang/ato_insert");
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("lang", lang);
					params.put("message_id", messageId);
					params.put("message", ("kr".equals(lang) ? "" : "xx_") + defaultValue);
					ProcessorFactory.exec(pDetail, params);
				} catch (Exception e) {
					//e.printStackTrace();
				}
				
				clear();
			}
			return defaultValue;
		}else{
			if("kr".equals(lang) && !val.equals(defaultValue) && !changeDataMap.containsKey(messageId)){
				String[] msgs = {val, defaultValue};
				changeDataMap.put(messageId, msgs);
			}
			return val;
		}
	}
	
	public static String replaceLang(String messageId, String lang, String vals, String defaultValue) throws Exception{
		String message = getMessage(messageId, lang, defaultValue);
		String newVals = vals!=null && !vals.startsWith("[") ? "[" + vals + "]" : vals;

		try {
			@SuppressWarnings("rawtypes")
			List list = JSONArray.fromObject(newVals);
			for(int i=0; i<list.size(); i++){
				Object val = list.get(i);
				message = StringUtils.replace(message, "{" + i + "}", val.toString());
			}
		} catch (Exception e) {
			String[] list = vals.split(",");
			for(int i=0; i<list.length; i++){
				message = StringUtils.replace(message, "{" + i + "}", list[i]);
			}
		}
		
		return message;
	}
	
	public static String getJSMessage(String key) throws Exception {
		JSONObject jo = getLangJson();

		return jo==null ? null : jo.get("kr").toString();
	}
	public static JSONObject getLangJson() throws Exception {
		try {
			init();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return langJson;
	}
}
