<%@tag import="org.apache.commons.lang.StringUtils"%>
<%@tag import="net.ion.webapp.utils.Function"%>
<%@tag import="java.util.ArrayList"%>
<%@tag import="java.util.List"%>
<%@tag import="java.util.Calendar"%>
<%@tag import="java.util.Date"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="year" type="java.lang.Integer"%>
<%@ attribute name="month" type="java.lang.Integer"%>
<%
String[] week = {"일","월","화","수","목","금","토"};
Date date = new Date();
Calendar cal = Calendar.getInstance();
String cur_date = Function.formatDate(cal.getTime(), "yyyy-MM-dd");


if(year>0){
	cal.set(cal.YEAR, year);
	cal.set(cal.MONTH, month-1);
}
Calendar calcal = (Calendar)cal.clone();
int cmon = cal.get(cal.MONTH);

cal.set(cal.DATE, 1);
int sWeek = cal.get(cal.DAY_OF_WEEK)-1;

if(sWeek>0){
	cal.add(cal.DATE, -sWeek);
}

String start_date = Function.formatDate(cal.getTime(), "yyyy-MM-dd");
List list = new ArrayList();

for(int i=0; i<6; i++){
	for(int j=0; j<7; j++){
	
		String mon = Integer.toString(cal.get(cal.MONTH)+1);
		String day = Integer.toString(cal.get(cal.DATE));
		
		String md = StringUtils.leftPad(mon, 2, '0') + '-' + StringUtils.leftPad(day, 2, '0');
		
		String sch_date = Function.formatDate(cal.getTime(), "yyyy-MM-dd");
		
		String[] info = {Integer.toString(j), mon, day, sch_date, md};
		
		list.add(info);
		
		cal.add(cal.DATE, 1);
	}
	
}

String end_date = Function.formatDate(cal.getTime(), "yyyy-MM-dd");

month = cal.get(cal.MONTH)+1;
cal.set(cal.MONTH,month);
date = cal.getTime();
cal.add(cal.DATE, -1);
int eDay = cal.get(cal.DATE);


int cMonth = calcal.get(cal.MONTH)+1;
int cYear = calcal.get(cal.YEAR);
calcal.add(cal.MONTH, -1);
int bYear = calcal.get(cal.YEAR);
int bMonth = calcal.get(cal.MONTH)+1;

calcal.add(cal.MONTH, 2);
int aYear = calcal.get(cal.YEAR);
int aMonth = calcal.get(cal.MONTH)+1;

request.setAttribute("month", list);
request.setAttribute("cMonth", cMonth);
request.setAttribute("cYear", cYear);
request.setAttribute("bYear", bYear);
request.setAttribute("bMonth", bMonth);
request.setAttribute("aYear", aYear);
request.setAttribute("aMonth", aMonth);
request.setAttribute("week", week);

request.setAttribute("start_date", start_date);
request.setAttribute("end_date", end_date);
request.setAttribute("cur_date", cur_date);

%>