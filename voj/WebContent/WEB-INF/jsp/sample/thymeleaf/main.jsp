<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="ui" uri="/WEB-INF/tlds/ui.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
	<link href="./css/contents.css" rel="stylesheet" type="text/css" />
	<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" >
	<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css">
	<link href="./jquery/dynatree/doc/skin-custom/custom.css" rel="stylesheet" type="text/css" >
	
	<script src="./jquery/js/jquery-1.9.1.min.js"></script>
	<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
</head>
<body>
<jsp:include page="header.jsp"/>

<div id="detail" >
<jsp:include page="body.jsp"/>
</div>
<br/>
<a href="http://www.thymeleaf.org/" target="_new">http://www.thymeleaf.org/</a><br/><br/>
<a href="./file/Tutorial_Thymeleaf_Spring_3_20120131.pdf" target="_new">Tutorial_Thymeleaf_Spring_3_20120131.pdf</a><br/>
<a href="./file/Tutorial_Using_Thymeleaf_20120131.pdf" target="_new">Tutorial_Using_Thymeleaf_20120131.pdf.pdf</a><br/>
</body>
</html>
