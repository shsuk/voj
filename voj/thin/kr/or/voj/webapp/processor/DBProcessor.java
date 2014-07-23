package kr.or.voj.webapp.processor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;








import kr.or.voj.webapp.utils.DefaultMapRowMapper;
import net.ion.webapp.utils.LowerCaseMap;
import net.sf.json.JSONObject;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.collections.map.ListOrderedMap;
import org.apache.commons.el.ExpressionEvaluatorImpl;
import org.apache.commons.el.VariableResolverImpl;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.taglibs.standard.lang.jstl.test.PageContextImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.core.simple.SimpleJdbcDaoSupport;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;


/**
 * <pre>
 * 시스템명 : KT_MVNO_KPM
 * 작 성 자 : 석승한
 * 작 성 일 : 2014. 3. 18
 * 설    명 : Test
 * 
 * </pre>
 */
@Service
public class DBProcessor extends SimpleJdbcDaoSupport implements ProcessorService{
	@Autowired
	private DataSource baseDataSource;

	@PostConstruct
	void init() {
		setDataSource(baseDataSource);
	}

	public ApplicationContext getApplicationContext() {
		return ProcessorServiceFactory.getApplicationContext();
	}

	@Override
	public Object execute(Map<String, Object> paramMap) throws Exception {
		return executeQuerys((String)paramMap.get("queryPath"), (CaseInsensitiveMap)paramMap.get("params"), (String)paramMap.get("action"));
	}
	
	private Map<String, Object> executeQuerys(String path, CaseInsensitiveMap params, String action) throws Exception {
		Map<String, Object> resultSet = new HashMap<String, Object>();
		
		Map<String, JSONObject> queryInfos = QueryInfoFactory.findQuerys(path, params);
		
		if(queryInfos==null){
			return resultSet;
		}
		
		for(String key : queryInfos.keySet()){
			JSONObject queryInfo = queryInfos.get(key);
			String queryAction = getString("action", queryInfo, "");
			//action이 없거나 같은 쿼리만 실행한다.
			if(!"".equals(queryAction) && !StringUtils.equals(action, queryAction)){
				continue;
			}
			//다른 쿼리의 부속 쿼리는 스킵한다.
			if(getBoolean("subQuery", queryInfo, false)){
				continue;
			}
			
			String query = queryInfo.getString("query");
			query = makeQuery(key, query, queryInfos);
			Object rows = executeQuery(query, getBoolean("singleRow", queryInfo, false), params);
			//결과저장
			resultSet.put(queryInfo.getString("id"), rows);	
		
		}
		
		return resultSet;
	}
	private boolean getBoolean(String key, JSONObject queryInfo, boolean defaultValue) throws Exception {
		return queryInfo.containsKey(key) ? queryInfo.getBoolean(key) : defaultValue;
	}
	private String getString(String key, JSONObject queryInfo, String defaultValue) throws Exception {
		Object val = queryInfo.get(key);
		return val==null ? "" : val.toString();
	}

	private Object executeQuery(String query, boolean isSingleRow, CaseInsensitiveMap params) throws Exception {
		Object result = null;
		//query = (String)QueryInfoFactory.evaluate(query, params);
		queryLogPrint(query, params);

		long st = System.currentTimeMillis();
		
		if(StringUtils.startsWithIgnoreCase(query, "select")){
			List<Map<String,Object>> rows = getSimpleJdbcTemplate().query(query, new DefaultMapRowMapper(), params);
			
			if(isSingleRow){
				result = rows.size()>0 ? rows.get(0) : new HashMap<String,Object>();
			}else{
				result = rows;
			}
		}else{
			result = new Integer(getSimpleJdbcTemplate().update(query, params));
		}
		
		long et = System.currentTimeMillis();
		queryExecuteTimePrint(st, et);
		
		return result;
	}
	
	private String makeQuery(String queryId, String query, Map<String, JSONObject> queryInfos) throws Exception {
		String[] subQueryIds = StringUtils.substringsBetween(query, "${", "}");
		
		if(subQueryIds==null){
			return query;
		}
		
		for(String subQueryId : subQueryIds){
			JSONObject queryInfo = queryInfos.get(subQueryId);
			if(queryInfo==null){
				throw new RuntimeException(queryId + "쿼리에서 사용하는 서브쿼리 " + subQueryId + "가 존재하지 않습니다.");
			}
			String subQuery = queryInfo.getString("query");
			query = StringUtils.replace(query, "${"+subQueryId+"}", subQuery);
		}
		
		return query;
	}

	private void queryLogPrint(String sql, CaseInsensitiveMap params) {
		String log_line = "\n--------------------------------------------------------------"
		                + "--------------------------------------------------------------\n";
		logger.info(log_line+paramMarkingValue(sql, params)+log_line);
	}
	private String paramMarkingValue(String sql, CaseInsensitiveMap params) {
    	String[] s = sql.split(":");

    	for(int i=1; i<s.length; i++){
    		String[] names = s[i].split("[, ();='\n\r\t/*-+%^|]");
    		if (!(names[0].toUpperCase()).equals("MI")&&!(names[0].toUpperCase()).equals("SS")) {
    			if (params.get(names[0]) != null && !params.get(names[0]).equals("")) {
    				sql = sql.replace(":"+names[0], "'"+params.get(names[0])+"'");
    			}
    		}
    	}
		return sql;
	}
	private void queryExecuteTimePrint(long st, long et) {
		String log_line = "\n--------------------------------------------------------------"
			+ "--------------------------------------------------------------\n";
		
		logger.info(log_line+"-- query execute time : " + (et-st)/1000);
	}


}
