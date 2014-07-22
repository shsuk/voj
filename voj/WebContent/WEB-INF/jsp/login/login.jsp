<%@page import="net.ion.webapp.utils.Function"%>
<%@page import="net.ion.webapp.utils.CookieUtils"%>
<%@page import="net.ion.user.interceptor.PagePermission"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="net.ion.user.session.SessionService"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%><%@page import="net.ion.webapp.process.ReturnValue"%><%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<%@ taglib prefix="jobu"  tagdir="/WEB-INF/tags/job/user" %> 
<%@ taglib prefix="tpu"  tagdir="/WEB-INF/tags/user" %> 
<uf:organism noException="true" token="false">
[
	<job:requestEnc id="reuestEnc" aes256="uid" />
	<job:db id="rows" query="voj/login/login" isReturn="false" />
]
</uf:organism>

<%
JSONObject result = new JSONObject();

List<Map> rows = (List<Map>)pageContext.getAttribute("rows");

if(rows.size()>0){
	SessionService.saveUserInSession(request, response, rows.get(0));
	//로그인 쿠키 설정
	PagePermission.setLoginInfo(request, response);
	result.put("success", true);
	
	if("Y".equals(request.getParameter("svuid"))) {
		CookieUtils.setCookie(response, "uid", request.getParameter("uid"), 30*24*60*60);
	}else{
		CookieUtils.removeCookie(response, "uid");
	}

}else{
	result.put("success", false);
}
out.print(result.toString());
%>

