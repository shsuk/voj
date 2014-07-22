<%@tag import="java.text.SimpleDateFormat"%><%@tag import="org.apache.commons.lang.StringUtils"%><%@tag import="net.ion.webapp.utils.Function"%><%@tag import="java.util.ArrayList"%><%@tag import="java.util.List"%><%@tag import="java.util.Calendar"%><%@tag import="java.util.Date"%><%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ attribute name="m_d" type="java.lang.String"%><%
String[] week = {"일","월","화","수","목","금","토"};

Calendar cal = Calendar.getInstance();

SimpleDateFormat DateFormater = new SimpleDateFormat("yyyy-MM-dd");
Date date = DateFormater.parse(cal.get(cal.YEAR) + "-" + m_d);
cal.setTime(date);
int sWeek = cal.get(cal.DAY_OF_WEEK)-1;
out.print(week[sWeek]);
%>