<%@tag import="java.util.ArrayList"%>
<%@tag import="java.util.List"%>
<%@tag import="java.util.Map"%>
<%@tag import="java.util.HashMap"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fm" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %>
<%@ attribute name="sourceId" type="java.lang.String" required="true" description="상태코드"%>
<%@ attribute name="key" type="java.lang.String" required="true" description="상태결과코드"%>
<%@ attribute name="targetId" type="java.lang.String" required="true" description="상태결과코드"%>
<%
	Map<String,List<Map<String,Object>>> map = new HashMap<String,List<Map<String,Object>>>();
	List<Map<String,Object>> list = (List<Map<String,Object>>) request.getAttribute(sourceId);

	for(Map<String,Object> row : list){
		String keyVal = (String)row.get(key);
		List<Map<String,Object>> rows = (List<Map<String,Object>>)map.get(keyVal);
		
		if(rows==null){
			rows = new ArrayList();
			
		}
		rows.add(row);
		
		map.put(keyVal, rows);
	}
	
	request.setAttribute(targetId, map);
%>