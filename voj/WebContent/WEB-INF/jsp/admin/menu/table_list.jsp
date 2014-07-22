<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="net.ion.webapp.utils.DbUtils"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<title>ISlim</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">	<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
	<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css"/>
	<link href="./css/contents.css" rel="stylesheet"  id="css" />
</head>
<body>
	<table class="ui-widget ui-widget-content contents-contain"  style="width: 100%;padding-right: 5px;">
		<tr class="ui-state-default">
			<th>테이블명</th>
		</tr>
	</table>
	<c:forEach var="row" items="${rows}">
		<div class="button-l" style=" border: 1px solid #cccccc;width: 30%;padding: 5px;"><a href="atm.sh?_t=list&_q=sm/${fn:toLowerCase(row.table_name) }/list" target="_new">${row.table_name }</a></div>
	</c:forEach>
</body>
</html>

	