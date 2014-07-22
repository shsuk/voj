package net.ion.webapp.db;

import java.util.ArrayList;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import net.sf.json.JSONObject;

public class QueryProperty {
	String query = null;
	String orgQuery = null;
	String srcQuery = null;
	ArrayList<String[]> paramList = null;
	ArrayList<String> paramConstantList = null;
	Map<String, Object> queryValues = null;
	
	String queryType = null;
	JSONObject uiInfo = null;

	public String getQueryType() {
		return queryType;
	}

	public JSONObject getUiInfo() {
		return uiInfo;
	}
	
	public String getSrcQuery() {
		return srcQuery;
	}
	public void setSrcQuery(String srcQuery) {
		this.srcQuery = srcQuery;
	}
	public Map<String, Object> getQueryValues() {
		return queryValues;
	}
	public void setQueryValues(Map<String, Object> queryValues) {
		this.queryValues = queryValues;
	}
	public String toString() {
		return "\n\t\tOrgQuery : " + orgQuery.replaceAll("\n", "\n\t\t\t") + 
				"\n\t\tQuery : " + query.replaceAll("\n", "\n\t\t\t") + 
				"\n\t\tQuery Values : " + queryValues;
	}
	public String getOrgQuery() {
		return orgQuery;
	}
	
	public void setOrgQuery(String orgQuery) {
		this.orgQuery = orgQuery;
	}

	public String getQuery() {
		return query;
	}
	public void setQuery(String query) {
		this.query = query.trim();
		initQueryType();
		initUiInfo();
	}
	public ArrayList<String[]> getParamList() {
		return paramList;
	}
	public void setParamList(ArrayList<String[]> paramList) {
		this.paramList = paramList;
	}
	public ArrayList<String> getParamConstantList() {
		return paramConstantList;
	}
	public void setParamConstantList(ArrayList<String> paramConstantList) {
		this.paramConstantList = paramConstantList;
	}
	private void initQueryType() {
		String temp = QueryInfo.removeComment(query).trim();
		
		temp = StringUtils.substring(temp,0,6).toLowerCase();
		if("select".equals(temp)){
			queryType = "select";
		}else{
			queryType = "update";
		}
	}
	private void initUiInfo() {
		String str = StringUtils.substringBetween(query, "/*", "*/");
		if(StringUtils.isEmpty(str)){
			uiInfo = null;
			return;
		}
		
		setQuery(removeBetween(query, "/*", "*/"));
		
		int s = str.indexOf('{');
		int e = str.lastIndexOf('}');
		String info = (s<0 && e<=s) ? "" : str.substring(s, e+1);
		
		uiInfo = (StringUtils.isNotEmpty(info)) ? JSONObject.fromObject(info) : null;
		
		if(uiInfo==null) return;
		
		Object javascript = uiInfo.get("javascript");
		
		if(javascript==null) return;
		
		javascript = ((String)javascript).replaceAll("__::__", ";\n");
		uiInfo.put("javascript", javascript);
	}
	
	private String removeBetween(String str, String s, String e){
		if(str==null) return str;
		
		int sp = StringUtils.indexOf(str, s);
		
		if(sp<0) return str;
		
		int ep = StringUtils.indexOf(str, e, sp);
		
		if(ep<0) return str;
		
		ep = ep+2;
		
		
		StringBuffer sb = new StringBuffer();
		sb.append(str.substring(0, sp));
		sb.append(str.substring(ep));
		return sb.toString();
	}
	
}
