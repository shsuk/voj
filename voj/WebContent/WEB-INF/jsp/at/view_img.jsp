<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="net.ion.webapp.utils.CookieUtils"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
</head>
<body style="border:0px; overflow: auto;margin: 0 0 0 0;padding: 0 0 0 0;">
	<div data-role="page" data-close-btn="right">
		<div data-role="header">
			<h1></h1>
		</div>

		<div data-role="content">		
			<a href="docs-dialogs.html" data-rel="back" data-theme="b"><center ><img width="100%" src="at.sh?_ps=at/upload/dl&file_id=${req.file_id }" ></center></a>       
		</div>
	</div>
</body>
</html>