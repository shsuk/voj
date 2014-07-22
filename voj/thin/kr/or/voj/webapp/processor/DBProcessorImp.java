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


/**
 * <pre>
 * 시스템명 : KT_MVNO_KPM
 * 작 성 자 : 석승한
 * 작 성 일 : 2014. 3. 18
 * 설    명 : Test
 * 
 * </pre>
 */
@Component
public abstract class DBProcessorImp extends SimpleJdbcDaoSupport implements DBProcessor {
	@Autowired
	private DataSource baseDataSource;

	@PostConstruct
	void init() {
		setDataSource(baseDataSource);
	}

	public ApplicationContext getApplicationContext() {
		return ProcessorServiceFactory.getApplicationContext();
	}

	public static Object getDao(Class paramClass) throws Exception {
		String[] daos = ProcessorServiceFactory.getApplicationContext().getBeanNamesForType(paramClass);
		if (daos.length != 1) {
			throw new Exception(paramClass.getName() + "의 클래스의 객체가 1개 없거나 이상입니다. 최종구현된 클래스를 호출하세요.");
		}

		return ProcessorServiceFactory.getApplicationContext().getBean(daos[0]);
	}
	public static DBProcessor getDaoUtils() throws Exception {
		return ProcessorServiceFactory.getProcessorService("system_autodatabase");
	}


	/**
	 * 쿼리파일에 있는 쿼리를 실행하여 결과를 반환한다.
	 * 
	 * 쿼리파일 작성규칙:
	 * 쿼리는 하나의 파일에 여러개 올 수 있다.
	 * 예)
	 * id:page := SELECT contract_id, section_id , count(*) over()  as totl_cunt  FROM   tbl_kpm_lte_price_adjt_info WHERE rownum < 100  ;
	 * id:row := SELECT contract_id, section_id  FROM   tbl_kpm_lte_price_adjt_info WHERE rownum < 2  ;
	 * id := SELECT contract_id, section_id  FROM   tbl_kpm_lte_price_adjt_info WHERE rownum < 2  ;
	 * id:noSys := UPDATE tbl_kpm_zip SET addr1 = 'addr' WHERE seqno = 1;
	 * id := UPDATE tbl_kpm_zip SET addr1 = 'addr' WHERE seqno = 1;
	 * UPDATE tbl_kpm_zip SET addr1 = 'addr' WHERE seqno = 1;
	 * 
	 * @param name
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> executeQuerys(String path, CaseInsensitiveMap params) throws Exception {
		Map<String, Object> resultSet = new HashMap<String, Object>();
		
		Map<String, JSONObject> queryInfos = QueryInfoFactory.findQuerys(path, params);
		
		if(queryInfos==null){
			return resultSet;
		}
		
		for(String key : queryInfos.keySet()){
			JSONObject queryInfo = queryInfos.get(key);
			
			boolean subQuery =  queryInfo.containsKey("subQuery") ? queryInfo.getBoolean("subQuery") : false;
			if(subQuery){
				continue;
			}
			boolean isSingleRow =  queryInfo.containsKey("singleRow") ? queryInfo.getBoolean("singleRow") : false;
			
			String query = queryInfo.getString("query");
			query = makeQuery(key, query, queryInfos);
			Object rows = executeQuery(query, isSingleRow, params);
			//결과저장
			resultSet.put(key, rows);	
		
		}
		
		return resultSet;
	}
	/**
	 * 쿼리를 실행하여 결과를 반환한다.	
	 * @param query
	 * @param isPaging
	 * @param isSingleRow
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Object executeQuery(String query, boolean isSingleRow, CaseInsensitiveMap params) throws Exception {
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
