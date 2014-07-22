package net.ion.webapp.db;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.PageContext;

import net.ion.webapp.controller.tag.TemplateUtils;
import net.ion.webapp.exception.IslimException;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.service.ProcessService;
import net.ion.webapp.utils.LowerCaseMap;
import net.ion.webapp.utils.ParamUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcDaoSupport;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;

public class QueryInfo extends SimpleJdbcDaoSupport{
	protected static final Logger logger = Logger.getLogger(QueryInfo.class);
	private static Map<String, QueryInfo> queryInfoMap = null;
	private List<QueryProperty> queryPropertys = new ArrayList<QueryProperty>();

	private long lastModified = 0;
	private String templateId = null;
	private String queryId = null;
	private String filePath = null;
	private boolean isApply = false;
	private boolean isReturnColumInfo = false;
	private long lastModifyCheck = 0;
	private long modifyCheckInterval = 1000*5;
	
	public boolean isApply() {
		return isApply;
	}
	public void setReturnColumInfo(boolean isReturnColumInfo) {
		this.isReturnColumInfo = isReturnColumInfo;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public boolean remove() {
		File f = new File(filePath);

		boolean isDelete = f.exists() ? f.delete() : true;
		
		if(isDelete) queryInfoMap.remove(this.queryId);
		
		return isDelete;
	}
	public boolean apply() {
		if(this.isApply) return true;
		
		File f = new File(filePath);
		String orgName = filePath.replaceAll(".test.", ".");
		File orgF = new File(orgName);
		File bakF = new File(orgName + ".bak");
		
		bakF.delete();
		
		boolean isOK = orgF.renameTo(bakF);
		//실패
		if(!isOK) return isOK;
		
		isOK = f.renameTo(orgF);
		
		if(isOK){//적용성공으로 변경
			this.isApply = true;
		}else{//실패시 원복
			bakF.renameTo(orgF);			
		}
		
		return isOK;
	}
	public boolean recovery() {
		if(!this.isApply) return true;
		File f = new File(filePath);
		String orgName = filePath.replaceAll(".test.", ".");
		File orgF = new File(orgName);
		File bakF = new File(orgName + ".bak");
		
		//혹시나 있을지 모르는 테스트 파일 삭제
		f.delete();
		//백업파일을 원복하기 위해 적용된 테스트파일을 삭제 한다.
		boolean isOK = orgF.delete();
		//원복 실패
		if(!isOK) return isOK;
		//원복한다.
		isOK = bakF.renameTo(orgF);
		//테스트 정보를 지운다		
		if(isOK){
			queryInfoMap.remove(this.queryId);			
		}
			
		return isOK;
	}
	
	public String getQueryId() {
		return queryId;
	}

	public void setQueryId(String queryId) {
		this.queryId = queryId;
	}
	public String getTemplateId() {
		return templateId;
	}
	public void setTemplateId(String templateId) {
		this.templateId = templateId;
	}
	public List<QueryProperty> getQueryPropertys() {
		return queryPropertys;
	}
	public JSONArray getQueryInfos() {
		JSONArray ja = new JSONArray();
		
		for(QueryProperty queryProperty : queryPropertys){
			JSONObject queryInfo = new JSONObject();
			String query = queryProperty.getSrcQuery();
			JSONObject uiInfo = queryProperty.getUiInfo();
			queryInfo.put("query", getSrcQuery(query));
			queryInfo.put("ui", uiInfo);
			ja.add(queryInfo);
		}
		
		return ja;
	}
	
	private String getSrcQuery(String query){
		String[] rems = StringUtils.substringsBetween(query, "/*", "*/");
		
		if(rems!=null){
			for(String rem : rems){
				query = StringUtils.replace(query, "/*"+rem+"*/", "");
			}
		}
		
		return query;
	}
	public void setQuery(List<String[]> querys) {

		for(String[] query : querys){
			ArrayList<String[]> paramList = new ArrayList<String[]>();
			ArrayList<String> paramConstantList = new ArrayList<String>();
			String sql = ParameterParser.getParamList(query[0], paramList, paramConstantList);
			
			QueryProperty queryProperty = new QueryProperty();
			queryProperty.setParamConstantList(paramConstantList);
			queryProperty.setParamList(paramList);
			queryProperty.setQuery(sql);
			queryProperty.setOrgQuery(query[0]);
			queryProperty.setSrcQuery(query[1]);
			queryPropertys.add(queryProperty);
		}
	}
	/**
	 * 변경여부를 체크하는 주기에 따라 변경여부를 체크한다.
	 * @param path
	 * @return
	 */
	public boolean isModified(String path) {
		//변경체그 주기가 되었는지 확인
		long curTime = (new Date()).getTime();
		if(lastModifyCheck > curTime){
			return false;
		}
		lastModifyCheck = curTime + modifyCheckInterval;

		//파일이 변경되었는지 확인한다.
		File f = new File(ProcessInitialization.getQueryFullPath() + path + ".sql");
		
		boolean isChange = this.lastModified != f.lastModified();
		
		if(templateId!=null){
			f = new File(ProcessInitialization.getQueryFullPath() + templateId + ".sql");
			QueryInfo queryInfo = getQueryInfo(templateId);
			
			if(queryInfo==null) return true;
			
			if(queryInfo.isModified(templateId)) return true;
		}
		return isChange;
	}
	public void setLastModified(long lastModified) {
		this.lastModified = lastModified;
	}

	public String toString() {
		
		return "\n\tId : " + getQueryId() + 
				"\n\tTemplateId : " + getTemplateId() + 
				"\n\tQuerys : " + getQueryPropertys();
	}
	public static Map<String, QueryInfo> getQueryInfoMap() {
		return queryInfoMap;
	}
	private static QueryInfo getQueryInfo(String key) {
		if(queryInfoMap==null){
			queryInfoMap = new HashMap<String, QueryInfo>();
		}
		return queryInfoMap.get(key);
	}
	private static QueryInfo addQueryInfo(String key, QueryInfo queryInfo) {
		if(queryInfoMap==null){
			queryInfoMap = new HashMap<String, QueryInfo>();
		}
		return queryInfoMap.put(key, queryInfo);
	}
	
	public Object execute(Map<String, Object> sourceDate, PageContext pageContext, boolean isCache, int refreshTime) {
		List resultList = new ArrayList();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> dataMap = new LinkedHashMap<String, Object>();
		Map<String, Object> metaDataMap = new LinkedHashMap<String, Object>();//Table 컬럼 설정정보를 리스트 형태로 제공
		Map<String, Object> metaDataMap2 = new LinkedHashMap<String, Object>();//Table 컬럼 설정정보를 맵 형태로 제공
		Map<String, Object> uiInfoMap = new LinkedHashMap<String, Object>();
		Map[] resultUiMaps = {dataMap, metaDataMap, metaDataMap2, uiInfoMap};
		Map<String, Object> This = new HashMap<String, Object>();
		
		for(QueryProperty queryProperty : queryPropertys){
			Object rtn = null;
			if(sourceDate!=null) sourceDate.put("this", This);
			String query = queryProperty.getQuery();
			
			String type = queryProperty.getQueryType();
			JSONObject queryInfo = queryProperty.getUiInfo();
			String id = null;
			String key = null;
			boolean isSingleRow = false;

			if( queryInfo!=null){
				id = (String)queryInfo.get("id");
				key = (String)queryInfo.get("key");
				if(queryInfo.get("singleRow")!=null){
					isSingleRow = queryInfo.getBoolean("singleRow");
				}
			}
			
			if(id != null) uiInfoMap.put(id, queryInfo);

			if("select".equals(type)){
				List<LowerCaseMap<String, Object>> list = getRows(queryProperty, sourceDate, isCache, refreshTime, pageContext);
				rtn = list;
				if(list.size()>0){
					if(id==null) This.putAll(list.get(0));
					else{
						This.put(id, list.get(0));
					}
				}
			}else{
				rtn = update(queryProperty, sourceDate, pageContext);
			}
			//쿼리결과를 요청 상태에 따라 저장 한다.
			if(id!=null && isReturnColumInfo){//UI자동설정 방식인 경우
				if (rtn instanceof List) {
					List<Map<String, Object>> list = (List<Map<String, Object>>) rtn;
					if(list.size()>0){
						Map<String, Object> tableMetaData = (Map<String, Object>)list.get(0).get("table_meta_data");
						list.get(0).remove("table_meta_data");
						metaDataMap.put(id, tableMetaData.get("cols"));
						metaDataMap2.put(id, tableMetaData.get("cols2"));
						
						if(queryInfo!=null && queryInfo.get("group")==null){
							Map<String, String> info = new HashMap<String, String>();
							String val = "";
							List<Map<String,Object>> cols = (List<Map<String,Object>>)tableMetaData.get("cols");
							for(Map<String,Object> col : cols){
								val += "," + col.get("name");
							}
							info.put("default_info", val.substring(1));
							queryInfo.put("group", info);
						}
					}
				}
				dataMap.put(id, rtn);
				
			}else if(id == null && key!=null){//key에의한 요청의 경우
				if(isSingleRow && rtn instanceof List) {
					List lst = (List) rtn;
						
					if(lst.size()>0){
						resultMap.put(key, lst.get(0));
					}else{
						resultMap.put(key, new LowerCaseMap<String, Object>());
					}
				
				}else{
					resultMap.put(key, rtn);
				}
			}else{//일반적인 경우
				resultList.add(rtn);
			}
		}
		
		if(dataMap.size()>0){
			return resultUiMaps;
		}else if(resultList.size() > 0 && resultMap.size() > 0){
			throw new RuntimeException("결과 값을 key방식이 아닌 궈리가 혼재합니다.(id는 사용할 수 없습니다.");
		}else if(resultMap.size() > 0){
			return resultMap;
		}else{
			return resultList.size()==1 ? resultList.get(0) : resultList;
		}
	}
	
	private String getNewQuery(String query, boolean isSelect) {

		query = removeComment(query);
	
		if(isSelect && isReturnColumInfo && query.indexOf("SQL_CALC_FOUND_ROWS") < 0){
			query = "SELECT base.* " +
					"\nFROM (SELECT 1 a from dual) temp " +
					"\nLEFT JOIN (" +
					query +
					"\n) base ON 1=1";			
		}
		
	
		return query;
	}
	/**
	 * 주석제거
	 * @param query
	 * @return
	 */
	protected static String removeComment(String query) {
		String[] rems = StringUtils.substringsBetween(query, "/*", "*/");
		
		if(rems!=null){
			for(String rem : rems){
				if(rem.startsWith("+")) continue;
				query = StringUtils.replace(query, "/*"+rem+"*/", "");
			}
		}
		String[] querys = query.split("\n");
		StringBuffer sb = new StringBuffer();
		for(String str : querys){
			if(str.trim().startsWith("--")) continue;
			sb.append(str).append('\n');
		}
		return sb.toString();
	}
	/*
	public Map executeStoredProcedure(QueryProperty queryProperty, JSONObject sourceDate) {
		//TODO 스토드 프로시져 구현 필요
		String query = queryProperty.getQuery();
		String spName = query.substring(0, query.indexOf('@'));
		StoredProc sp = new StoredProc(super.getDataSource(), spName);
		
		Map<String, Object> params = sp.getParamMap();
		
		getQuery(queryProperty, sourceDate, params);
		
		Map out = sp.exec();
		return out;
	}
*/	
	public List<LowerCaseMap<String, Object>> getRows(QueryProperty queryProperty, Map<String, Object> sourceDate, boolean isCache, int refreshTime, PageContext pageContext) { 
		Map<String, Object> params = new HashMap<String, Object>();
		String query = queryProperty.getQuery();
		List<LowerCaseMap<String, Object>> list = null;
		try {
			query = getQuery(queryProperty, sourceDate, params, pageContext, true);
			
			if(isCache){
				list = DataBaseCache.getCache(query, params, refreshTime);
				if(list!=null) return list;
			}

			ParameterizedRowMapper<LowerCaseMap<String, Object>> rowMapper = (isReturnColumInfo) ? new MapRowInfoMapper() : new MapRowMapper();
			SimpleJdbcTemplate sjt = getSimpleJdbcTemplate();
			list = sjt.query(query, rowMapper, params);

			if(query.indexOf("SQL_CALC_FOUND_ROWS")>0){
				List<LowerCaseMap<String, Object>> count = sjt.query("SELECT FOUND_ROWS() totCount", rowMapper, params);	
				//System.out.println("list count : " + count );
				
				for(LowerCaseMap<String, Object> row : list){
					row.put("totCount", count.get(0).get("totCount"));
				}
			}
			if(isCache && list.size()>0){
				DataBaseCache.addCache(query, params, list);
			}
			
		} catch (Exception e) {
			String message = e.toString() + "\n[쿼리정보]\nQueryId : " + this.queryId + "\nQuery : " + query + "\nParameter : " + params + "\n";
			logger.error(message);
			
			throw new RuntimeException(message, e);
		}

		return list;
	}
	public int update(QueryProperty queryProperty, Map<String, Object> sourceDate, PageContext pageContext) {
		Map<String, Object> params = new HashMap<String, Object>();
		String query = null;
		int count = 0;
		
		try {
			params = new HashMap<String, Object>();
			query = getQuery(queryProperty, sourceDate, params, pageContext, false);
			
			if("".equals(query)){
				return 0;
			}
			
			count = getSimpleJdbcTemplate().update(query, params);
		} catch (Exception e) {
			throw new RuntimeException(e.toString() + "\n[쿼리정보]\nQueryId : " + this.queryId + "\nQuerys : " + query + "\nParameter : " + params + "\n", e);
		}

		return count;
	}
	
	private String getQuery(QueryProperty queryProperty, Map<String, Object> sourceDate, Map<String, Object> params, PageContext pageContext, boolean isSelect){ 
		String query = queryProperty.getQuery();
		ArrayList<String> paramConstantList = queryProperty.getParamConstantList();
		query = paramConstantList.size() > 0 ? queryProperty.getOrgQuery() : query;
		
		for(String param : paramConstantList){
			query = StringUtils.replaceOnce(query, "#{" + param + "}", ParamUtils.getValue(param, sourceDate).toString()) ;
		}
		
		if(pageContext==null){
			if(StringUtils.contains(query, "${")){
				String[] els = StringUtils.substringsBetween(query, "${", "}");
				
				//for(String el : els){
				//	query = StringUtils.replace(query, "${" + el + "}", "");
				//}
				throw new RuntimeException("PageContext가 없는 경우에는 EL문법을 사용할 수 없습니다.\nOrganismTag태그에서만 사용이 가능합니다.");
			}
		}else{
			Object newQuery = TemplateUtils.proprietaryEvaluate(query, String.class, pageContext, null, false);
			query = (String) newQuery;
		}
		List<String[]> paramList = null;

		if(StringUtils.isEmpty(StringUtils.substringBetween(query, "@{", "}"))){
			paramList = queryProperty.getParamList();
		}else{
			Map<String, Object> map = getParamList(query);
			paramList = (List<String[]>)map.get("paramList");
			query = (String)map.get("query");
		}
		
		boolean isDefaultValue = false;
		
		if(sourceDate!=null){
			Map param = (Map)sourceDate.get(ProcessService.REQUEST_PARAMS);
			if(param!=null){
				String[] defaultValue = (String[])param.get("defaultValue");
				isDefaultValue = defaultValue!=null && "true".equals(defaultValue[0]);
			}
		}
		
		for(int i=0; i<paramList.size(); i++){
			String[] paramInfo = paramList.get(i);
			try {
				params.put(paramInfo[0], ParamUtils.getValue(paramInfo[0], sourceDate));
			} catch (RuntimeException e) {
				if(isDefaultValue){
					params.put(paramInfo[0], "");
				}else throw e;
			}
		}
		
		queryProperty.setQueryValues(params);
		
		return getNewQuery(query,isSelect);
	}
	public Map<String, Object> getParamList(String query) {
		ArrayList<String[]> paramList = new ArrayList<String[]>();
		ArrayList<String> paramConstantList = new ArrayList<String>();
		String sql = ParameterParser.getParamList(query, paramList, paramConstantList);
			
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("paramList", paramList);
		map.put("query", sql);
		return map;
	}

	public synchronized static QueryInfo getQuery(String queryPath) throws Exception {
		String filePath = "";
		
		File f = null;
		
		filePath = ProcessInitialization.getQueryFullPath() + queryPath + ".sql";
		f = new File(filePath);
		
		QueryInfo queryInfo = QueryInfo.getQueryInfo(queryPath);
		
		if(queryInfo==null || queryInfo.isModified(queryPath)){
			queryInfo = new QueryInfo();
			queryInfo.setFilePath(filePath);
			queryInfo.setLastModified(f.lastModified());
			List<String[]> queryList = new ArrayList<String[]>();
			Map<String, String> info = new HashMap<String, String>();

			String queryStr = replaceBetween(FileUtils.readFileToString(f, "utf-8"));
			String[] querys = queryStr.split(";");
			
			for(String query : querys){
				query = query.trim();
				
				if("".equals(query)) continue;
				
				String[] clip = query.split(":=");
				if(clip.length>1) {
					String key = clip[0].trim();
					String val = clip[1].trim();
					if("template".equalsIgnoreCase(key)){
						QueryInfo qi = getQuery(val);
						String tpl = qi.getQueryPropertys().get(0).getOrgQuery();
						String[] queryData = {tpl, queryStr};
						queryList.add(queryData);
						queryInfo.setTemplateId(qi.getQueryId());
					}else{
						info.put(key, val);
					}
				}else{
					String[] queryData = {query, query};
					queryList.add(queryData);
				}
			}
			
			for(String key : info.keySet()){
				String value = info.get(key);
				value = value.replaceAll("\n", "\n\t");
				
				for(int i=0; i<queryList.size(); i++){
					String[] query = queryList.get(i);
					String newQuery = StringUtils.replace(query[0], "${" + key + "}", value);
					String[] queryData = {newQuery, query[1]};
					queryList.set(i, queryData);
				}
			}
			
			queryInfo.setQueryId(queryPath);
			queryInfo.setQuery(queryList);
			QueryInfo.addQueryInfo(queryPath, queryInfo);
			
		}
		return queryInfo;
	}

	private static String replaceBetween(String str){
		if(str==null) return str;
		
		int sp = StringUtils.indexOf(str, "/*");
		
		if(sp<0) return str;
		
		int ep = StringUtils.indexOf(str, "*/", sp);
		
		if(ep<0) return str;
		
		ep = ep+2;
		
		String inStr = str.substring(sp, ep);
		
		inStr = StringUtils.replace(inStr, "\r", "");
		inStr = StringUtils.replace(inStr, "\n", "");
		inStr = StringUtils.replace(inStr, ";", "__::__");
		
		
		StringBuffer sb = new StringBuffer();
		sb.append(str.substring(0, sp));
		sb.append(inStr);
		sb.append(str.substring(ep));
		return sb.toString();
	}
	
	private static SimpleDateFormat DateFormater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
}
