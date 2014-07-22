<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Enumeration"%>
<%@page import="net.ion.webapp.utils.JobLogger"%><%@ page contentType="text/javascript; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>

{
	"success":false,
	"error_id": "${requestScope["javax.servlet.error.status_code"]}"
	"error_message": "${requestScope["javax.servlet.error.message"]}"
}
<%
Object errorId = request.getAttribute("javax.servlet.error.status_code");

Exception e = (Exception)request.getAttribute("javax.servlet.error.exception");
if(e==null){
	Enumeration en = request.getAttributeNames();
	while(en.hasMoreElements()){
		Object key = en.nextElement();
		System.out.println(key + " : " + request.getAttribute(key.toString()));
	}
}else{
	JobLogger.write(this.getClass(), "jsp","exception", request.getServletPath(), false, e);
}	

if(errorId != null && StringUtils.startsWith(errorId.toString(), "4")){
	response.sendRedirect("/");
}

%>