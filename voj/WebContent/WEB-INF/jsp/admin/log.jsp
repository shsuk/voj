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
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<link href="./css/contents.css" rel="stylesheet" type="text/css" />
<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css"/>
<link href="./jquery/dynatree/doc/skin-custom/custom.css" rel="stylesheet" type="text/css" />

<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="./jquery/js/jquery.json-2.3.js"></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>
<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="./jquery/js/excanvas.min.js"></script><![endif]-->
<script src="./jquery/js/jquery.dynatree.js" type="text/javascript"></script>

<script src="./jquery/flot/jquery.flot.js"></script>
<script src="./jquery/flot/jquery.flot.pie.js"></script>

<script src="./at.sh?_ps=js/message" type="text/javascript" ></script>
<script src="./js/graph.js" type="text/javascript" ></script>
<script src="./js/commonUtil.js"></script>
<script src="./js/web.js"></script>
<script src="./js/formValid.js" type="text/javascript" ></script>
<style>
	h3 { margin: 0; padding: 0.2em;}
</style>
<script type="text/javascript">

$(function($) {

	setInterval(function () {
		$('#log').load('view.sh?type=${req.type}');
		$('#log_list').append($('#log').html());
		$('#log').html("");
	}, 3000);
	
});


</script>
</head>
<body>
<a target="log_${req.type}" href="at.sh?_ps=admin/log&type=${req.type}">새창</a>
<div>${empty(req.type) ? '접속된 세션' : '백그라운드 작업'}의 서버 로그 조회</div>
<div id="log_list"></div>
<div id="log"></div>

</body>
</html>