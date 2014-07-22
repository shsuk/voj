<%@page import="java.util.Map"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.io.File"%>
<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.ion.webapp.utils.Function"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%
	String root = ProcessInitialization.getQueryFullPath();
	String path = (String)((Map<String, Object>)request.getAttribute("req")).get("path");
	path = path==null ? "" : path;
	
	File[] fs = Function.getFiles(root, path);
	JSONArray jsList = new JSONArray();
	for(File ff : fs){
		JSONObject data = new JSONObject();
		data.put("path", path+"/"+ff.getName());
		data.put("name", ff.getName());
		jsList.add(data);
	}
	request.setAttribute("parent", StringUtils.substringBeforeLast(path, "/"));
	request.setAttribute("files", jsList); 
 %>
<select id="path"  style="width:100%;">
	<option value="">선택</option>
	<option value="${parent }">..</option>
	<c:forEach var="f" items="${files }">
		<option value="${f.path }">${f.name }</option>
	</c:forEach>
</select>
