package net.ion.webapp.db;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.ion.user.interceptor.LoginInterceptor;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;
import net.ion.webapp.workflow.WorkflowService;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;


public class CodeUtils {
	protected static final Logger logger = Logger.getLogger(CodeUtils.class);
	private static Map<String, Map> codeListMap = new HashMap<String, Map>();
	private static Map<String, List<Map>> codeGroupListMap = new HashMap<String, List<Map>>();
	private static JSONObject codeJson = new JSONObject();


	public static void clear() {
		codeListMap.clear();
		codeGroupListMap.clear();
	}
	
	public static synchronized void init() throws Exception {

		if (codeListMap.size() > 0) return;

		setCode();
		setAllCodeName();
		initPublicUrl();
	}
	private static void initPublicUrl(){
		Map<String, Boolean> publicUrl = new HashMap<String, Boolean>();
		try {
			publicUrl.put("login/login_form", true);
			publicUrl.put("login/login", true);
			publicUrl.put("login/logout", true);
			publicUrl.put("voj/usr/user_add", true);
			publicUrl.put("js/message", true);
			publicUrl.put("at/upload/dl", true);
			
			List<Map> pubUrlList = (List<Map>)getList("public_url");
			
			for(Map map : pubUrlList){
				publicUrl.put((String)map.get("REFERENCE_VALUE"), true);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			ProcessInitialization.PUBLIC_URL = publicUrl;						
		}
	}
	private static void setAllCodeName() throws Exception {
		Map<String, String> codeNameMAp = new HashMap<String, String>();
		for(String key : codeListMap.keySet()){
			Map code = codeListMap.get(key);
			
			if(!StringUtils.startsWith(key, "code_mapping->")) continue;
			
			String newGrpCd = StringUtils.substringAfter(key, "->");
			String grpCd = (String)code.get("REFERENCE_VALUE");
			List<Map> list = codeGroupListMap.get(grpCd);
			
			if(list==null) continue;
			
			for(Map row : list){
				codeNameMAp.put(newGrpCd + "->" + row.get("CODE_VALUE"), (String)row.get("CODE_NAME"));
			}
		}
		
		codeNameMAp.put("system->vod_server", getReferenceValue("system", "vod_server"));
		codeNameMAp.put("system->vod_server_port_web", getReferenceValue("system", "vod_server_port_web"));
		codeNameMAp.put("system->vod_server_port_httpts", getReferenceValue("system", "vod_server_port_httpts"));
		codeNameMAp.put("system->vod_server_port_sv", getReferenceValue("system", "vod_server_port_sv"));
		codeNameMAp.put("system->vod_server_port_rtmp", getReferenceValue("system", "vod_server_port_rtmp"));
		codeNameMAp.put("system->vod_server_port_rtsp", getReferenceValue("system", "vod_server_port_rtsp"));
		
		codeJson.put("code", codeNameMAp);
	}
	
	public static String getCodeJson() {
		return codeJson.get("code").toString();
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private static void setCode() throws Exception {


		String queryPath = "system/code_list";
		List<LowerCaseMap<String, Object>> list = null;
		Exception ex = null;
		try {
			list = DbUtils.select(queryPath, null);
		} catch (Exception e) {
			ex = e;
		}
		queryPath = "system/code_list_etc";
		List<LowerCaseMap<String, Object>> list2 = null;

		try {
			list2 = DbUtils.select(queryPath, null);
			if(list2.size() > 0) list.addAll(list2);
		} catch (Exception e) {
			ex = e;
		}
		
		List<Map> groupCodeInfos = new ArrayList<Map>();
		codeGroupListMap.put("group_id", groupCodeInfos);

		//if (list == null) throw ex;
		boolean isCheck = false;

		

		for (LowerCaseMap<String, Object> row : list) {
			if (!isCheck) {
				if (!row.containsKey("group_id")
						|| !row.containsKey("code_name")
						|| !row.containsKey("code_value")
						|| !row.containsKey("reference_value")
						|| !row.containsKey("use_yn"))
					throw new Exception(
							"SELECT 절에 다음 컬럼이 있어야 합니다. group_id, code_name, code_value, reference_value, use_yn");
				isCheck = true;
			}
			List<Map> codeInfos = null;
			String key = null;
			int depth = 2;
			
			if(row.get("depth")==null){
				logger.error("코드 데이타 depth 오류 : " + row);
				continue;
			}else{
				depth = Integer.parseInt(row.get("depth").toString());
			}
			
			if(depth==1){
				key = (String) row.get("CODE_VALUE");
				codeInfos = codeGroupListMap.get(key);				
				if (codeInfos == null) {
					codeInfos = new ArrayList<Map>();
					codeGroupListMap.put(key, codeInfos);
					
					Map groupCode = new HashMap();
					groupCode.put("group_id", "group_id");
					groupCode.put("code_name", (String)row.get("CODE_VALUE") + ":"+ row.get("CODE_NAME"));
					groupCode.put("code_value", row.get("CODE_VALUE"));
					groupCodeInfos.add(groupCode);
				}
			}
			
			key = (String) row.get("group_id");
			codeInfos = codeGroupListMap.get(key);
			if (codeInfos == null) {
				codeInfos = new ArrayList<Map>();
				codeGroupListMap.put(key, codeInfos);
				
				Map groupCode = new HashMap();
				groupCode.put("group_id", "group_id");
				groupCode.put("code_name", (String)row.get("group_id"));
				groupCode.put("code_value", row.get("group_id"));
				groupCodeInfos.add(groupCode);
			}

			if ("Y".equalsIgnoreCase((String) row.get("use_yn"))){
				codeInfos.add(row);
			}

			
			String keys = key + "->" + (String) row.get("CODE_VALUE");
			codeListMap.put(keys, row);
		}
			
		
	}

	private static Map getMappingCodeInfo(String groupId, String codeId) throws Exception {
		try {
			init();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		List<Map> codeInfos = codeGroupListMap.get(groupId);
		
		if(codeInfos==null && !"code_mapping".equals(groupId)){
			groupId = getReferenceValue("code_mapping", groupId);
		}

		String keys = groupId + "->" + codeId.trim();
		Map row = codeListMap.get(keys);
		
		return row;
	}
	
	public static Map getCodeInfo(String groupId, String codeId) throws Exception {
		try {
			init();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		Map codeInfos = getCodeInfoMap(groupId, codeId);
		
		if(codeInfos==null){
			codeInfos = getCodeInfoMap("code_mapping", codeId);
		}


		return codeInfos;
	}
	
	private static Map getCodeInfoMap(String groupId, String codeId) throws Exception {
		try {
			init();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}

		String keys = groupId + "->" + codeId.trim();
		return codeListMap.get(keys);
	}

	public static String getNameAuto(String groupId, String codeId, String lang)throws Exception{
		return getName(groupId, codeId, lang, true);
	}
	public static String getName(String groupId, String codeId, String lang)throws Exception{
		return getName(groupId, codeId, lang, false);
	}
	private static String getName(String groupId, String codeId, String lang, boolean isAuto)throws Exception{
		String name = CodeUtils.getName(groupId, codeId);
		
		if(!"kr".equals(lang) && !"".equals(lang)){
			String key = groupId + "." + codeId;
			name = Lang.getMessage(key, lang, name, isAuto);
		}

		return name;
	}

	public static String getName(String groupId, String codeId)
			throws Exception {
		init();

		String vals = "";
		String[] ids = StringUtils.splitPreserveAllTokens(codeId, ",");

		for (String id : ids) {
			if(StringUtils.isEmpty(id)){
				continue;
			}
			Map codeInfo = getMappingCodeInfo(groupId, id);

			if (codeInfo == null){
				if(ids.length==1) return codeId;
				continue;
			}
				

			vals += ", " + (String) codeInfo.get("CODE_NAME");
		}
		return vals.length() > 1 ? vals.substring(2) : "";
	}
	
	public static String getReferenceValue(String groupId, String codeId)
			throws Exception {
		init();

		Map codeInfo = getMappingCodeInfo(groupId, codeId);

		if (codeInfo == null) return "";

		return (String) codeInfo.get("REFERENCE_VALUE");
	}

	public static List<Map> getList(String groupId) throws Exception {
		init();

		List<Map> codeInfos = codeGroupListMap.get(groupId);

		if(codeInfos==null){
			String newGrpId = getReferenceValue("code_mapping", groupId);
			codeInfos = codeGroupListMap.get(newGrpId);
		}
		return codeInfos;
	}
	
	public static String getCateName(String fId, String cateId)throws Exception{

		List<LowerCaseMap<String, Object>> list = null;

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("cate_id", cateId);
			list = DbUtils.select("system/tree/"+fId, param, true, 600);
		}catch(Exception e){
			Logger.getLogger(CodeUtils.class).error(e);
			return null;
		}
		
		return list.size()>0 ? (String)list.get(0).get("name") : cateId;
		
	}
}
