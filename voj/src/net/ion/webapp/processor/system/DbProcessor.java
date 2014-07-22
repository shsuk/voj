package net.ion.webapp.processor.system;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;
import javax.sql.DataSource;

import org.apache.jasper.runtime.JspApplicationContextImpl;
import org.springframework.stereotype.Service;

import net.ion.webapp.db.DataSourceUtils;
import net.ion.webapp.db.QueryInfo;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.utils.LowerCaseMap;
import net.ion.webapp.utils.StackTraceUtils;


@Service
public class DbProcessor extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();	
		boolean isCache = false;
		int refreshTime = 0;

		String queryPath = processInfo.getString("query");

		boolean isSingleRow = processInfo.getBooleanValue("singleRow", false);
		
		if(!processInfo.isDebug() && !processInfo.isTest()){
			isCache = processInfo.getBooleanValue("isCache", false);
			
			refreshTime = processInfo.getIntValue("refreshTime", refreshTime);
		}
		
		boolean isColumInfo = processInfo.getBooleanValue("isReturnColumInfo", false);

		PageContext pageContext = (PageContext)request.getAttribute("__PAGECONTEXT__");
		Object rtn = execute((String)processInfo.get("ds"), queryPath, processInfo.getSourceDate(), pageContext, isColumInfo, isCache, refreshTime);
		
		if (rtn instanceof Map[]) {
			Map[] data = (Map[]) rtn;
			Map<String, Object> dataMap = new LinkedHashMap<String, Object>();
			LinkedHashMap<String, Object> rSets = (LinkedHashMap<String, Object>)data[0];
			for(String id : rSets.keySet()){
				List<Map<String, Object>> list = (List<Map<String, Object>>)rSets.get(id);
				if(list.size()==1){
					Map<String, Object> row = list.get(0);
					boolean hsData = false;
					for(String key : row.keySet()){
						if(row.get(key)!=null){
							hsData = true;
							break;
						}
					}
					if(!hsData) row.put("totcount", 0);
				}
			}
			dataMap.put("data", rSets);//쿼리결과 반환
			dataMap.put("meta", data[1]);//Table 컬럼 설정정보를 리스트 형태로 제공
			dataMap.put("metaMap", data[2]);//Table 컬럼 설정정보를 맵 형태로 제공
			dataMap.put("ui", data[3]);//쿼리 파일에 설정한 정보를 제공
			returnValue.setResult(dataMap);
		}else if (rtn instanceof Integer || !isSingleRow) {
			returnValue.setResult(rtn);
		}else{
			List<Object> list = (List<Object>)rtn;
			if(list.size()>0){
				Object o = list.get(0);
				if (o instanceof List) {
					List lst = (List) o;
					returnValue.setResult(lst.size()>0 ? lst.get(0) : new LowerCaseMap<String, Object>());
				}else{
					returnValue.setResult(o);
				}
			}else{
				returnValue.setResult(new LowerCaseMap<String, Object>());
			}
		}
		
		if(processInfo.isDebug() || processInfo.isTest()){
			returnValue.append("\n").append("queryInfo :" + QueryInfo.getQuery(queryPath).toString());
		}
		return returnValue;
	}
	
	public static Object execute(String dataSourceName, String queryPath, Map<String, Object> params, boolean isCache, int refreshTime) throws Exception {
		return execute(dataSourceName, queryPath, params, null, false, isCache, refreshTime);
	}
	public static Object execute(String dataSourceName, String queryPath, Map<String, Object> params, PageContext pageContext, boolean isCache, int refreshTime) throws Exception {
		return execute(dataSourceName, queryPath, params, pageContext, false, isCache, refreshTime);
	}
	public static Object execute(String dataSourceName, String queryPath, Map<String, Object> params, boolean isColumInfo, boolean isCache, int refreshTime) throws Exception {
		return execute(dataSourceName, queryPath, params, null, false, isCache, refreshTime);
	}
		
	public static Object execute(String dataSourceName, String queryPath, Map<String, Object> params, PageContext pageContext, boolean isColumInfo, boolean isCache, int refreshTime) throws Exception {
		DataSource ds = DataSourceUtils.getDataSource(dataSourceName);
		QueryInfo queryInfo = QueryInfo.getQuery(queryPath);
		queryInfo.setDataSource(ds);
		queryInfo.setReturnColumInfo(isColumInfo);
		
		return queryInfo.execute(params, pageContext, isCache, refreshTime);
	}
}
