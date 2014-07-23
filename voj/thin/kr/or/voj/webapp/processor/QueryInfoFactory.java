package kr.or.voj.webapp.processor;

import java.io.File;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.collections.map.ListOrderedMap;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
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
public abstract class QueryInfoFactory {
	protected static Map<String, Map<String, JSONObject>> queryInfoMap;
	protected static Map<String, Long> queryChangeMap;
	protected static String root = "";

	/**
	 * 쿼리파일에 있는 쿼리를 가져온다.
	 * @param path
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public static Map<String, JSONObject> findQuerys(String path, CaseInsensitiveMap params) throws Exception {
		if(queryInfoMap==null){
			queryInfoMap = new ListOrderedMap();
			queryChangeMap = new ListOrderedMap();
			root = ProcessorServiceFactory.getQueryFullPath();
		}
		
		File f = new File(root,path+".sql");
		
		Map<String, JSONObject> queryInfos = queryInfoMap.get(path);
		
		if(queryInfos!=null) {
			long time = queryChangeMap.get(path);
			
			if(time==f.lastModified()){
				return queryInfos;
			}
		}
		
		if(!f.exists()){
			return queryInfos;
		}
		

		queryInfos = new ListOrderedMap();
		
		
		//쿼리를 로딩하여 저장한 후 리턴 한다.
		int idx = 1;
		StringBuffer sb = new StringBuffer();

		List<String> queryList = FileUtils.readLines(f, "utf-8");
		
		for(String line : queryList){
			sb.append(StringUtils.substringBefore(line, "//")).append('\n');
		}
		
		String[] querys = sb.toString().split(";");
		
		for(String query : querys){
			String infoStr = "{}";
			JSONObject info = null;
			query = query.trim();
			
			if(query.startsWith("/*")){
				infoStr = StringUtils.substringBetween(query, "/*", "*/");
				query = StringUtils.substringAfter(query, "*/").trim();
			}
			
			if(StringUtils.isEmpty(query)){
				continue;
			}

			info = JSONObject.fromObject(infoStr);

			String id = (String)info.get("id");
			if(id==null){
				id = "_rows"+idx;
				idx++;
			}

			info.put("id", id);
			info.put("query", query);
			
			if(queryInfos.containsKey(id)){
				id += "_" + info.get("action");
			};
			queryInfos.put(id,info);
		}
		
		queryInfoMap.put(path, queryInfos);
		queryChangeMap.put(path, f.lastModified());

		return queryInfos;
	}
	/**
	 * 쿼리파일에 있는 특정 id의 쿼리를 가져온다.
	 * @param path
	 * @param id
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public static String findQuery(String path, String id, CaseInsensitiveMap params) throws Exception {
		
		String query = findQuerys(path, params).get(id).getString("query");
		
		return query;
	}
/*
	private static FunctionMapper  fm = new FunctionMapper() {
		Map<String, Method> functionMap = null;
		public void init(){
			Map<String, Method> tempFunctionMap = new HashMap<String, Method>();

			Method[] ms = ELFunctions.class.getDeclaredMethods();
			for(Method m : ms){
				String fname1 = m.toString();
				System.out.println(fname1);
				String fname = "f:"+m.getName();
				if(tempFunctionMap.containsKey(fname)){
					throw new RuntimeException(ELFunctions.class.getName() + " 클래스에 동일이름의 클래스가 존재합니다. 이클래스에는 동일 명의 클래스를 정의하지 마세요.");
				}
				tempFunctionMap.put(fname, m);
			}
			functionMap = tempFunctionMap;
		}

		
		public Method resolveFunction(String g, String n) {
			if(functionMap==null){
				init();
			}
			String fname = g+":"+n;

			return functionMap.get(fname);
		}
	};
	public static Object evaluate(String src, Map<String, Object> map) throws Exception{
		Object value = src;
		PageContext pc = new PageContextImpl();
			
		for(String key : map.keySet()){
			Object data = map.get(key);
			
			pc.setAttribute(key.toLowerCase(), data);
		}
		
		VariableResolver varResolver = new VariableResolverImpl(pc); 
		
		ExpressionEvaluatorImpl exprEval = new ExpressionEvaluatorImpl();
	
	    Expression expression = exprEval.parseExpression(src, String.class, fm);
	    value = expression.evaluate(varResolver);
	
		return value;
	}
	
	public static Object evaluate(String src, EcmParams params) throws Exception{
		Object value = src;
		PageContext pc = new PageContextImpl();
		ValueStack valueStack = params.getValueStack();
		
		if(valueStack==null){
			return src;
		}
		
		CompoundRoot cr = valueStack.getRoot();
		
		for(Object o : cr){
			if (!(o instanceof Map))  {
				continue;
			}
			
			Map<String, Object> map = (Map<String, Object>) o;
			
			for(String key : map.keySet()){
				Object data = map.get(key);
				
				pc.setAttribute(key, data);
			}
			
			pc.setAttribute("session", params.getSession());
		}
		VariableResolver varResolver = new VariableResolverImpl(pc); 
		
		ExpressionEvaluatorImpl exprEval = new ExpressionEvaluatorImpl();
	
	    Expression expression = exprEval.parseExpression(src, String.class, fm);
	    value = expression.evaluate(varResolver);
	
		return value;
	}
*/
}
