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

<c:forEach var="row" items="${rows}">
	<div style=" border: 1px solid #cccccc; padding: 5px;margin:2px;cursor: pointer;" onclick="setColumn('${row.column_name}')">${row.column_name}</div>
</c:forEach>
