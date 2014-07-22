<%@tag import="net.ion.webapp.utils.CookieUtils"%>
<%@tag import="org.apache.commons.lang.StringUtils"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="값이 없으면 삭제한다."%>
<%@ attribute name="expiry" type="java.lang.Integer" required="true" description="단위 분"%>
<%
	if(StringUtils.isNotEmpty(value)) {
		CookieUtils.setCookie(response, name, value, expiry.intValue()*60);
	}else{
		CookieUtils.removeCookie(response, name);
	}
%>