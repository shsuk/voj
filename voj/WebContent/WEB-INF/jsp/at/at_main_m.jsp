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
	<link href="./favicon.ico" rel="shortcut icon" type="image/x-icon" />
	
	<link href="./jquery/mobile/css/themes/default/jquery.mobile-1.3.2.css" rel="stylesheet" type="text/css" />
	<link href="./jquery/mobile/_assets/css/jqm-demos.css" rel="stylesheet" />

	<script src="./jquery/mobile/js/jquery.js"></script>
	<script src="./jquery/mobile/js/jquery.mobile-1.3.2.min.js"></script>
	
	<script src="./js/commonUtil.js"></script>
	<script src="./js/formValid.js"></script>
	<script src="./js/mb.js"></script>
</head>
<body style="border:0px; overflow: auto;margin: 0 0 0 0;padding: 0 0 0 0;">


<div data-role="page" id="${req.pageIdx==null || req.pageIdx=='' ? 'main_page' : req.pageIdx }" history="${reqJS}">
	<div data-role="header" data-theme="f">
		<img src="./images/log.png" onclick="home()" style="cursor: pointer;" height="60" border="0"/>
		<div style="float: right; margin-top: 11px;margin-right: 10px;"><a href="#leftpanel_menu" data-role="button"  data-icon="bars" data-iconpos="notext" data-theme="c" data-inline="true">Navigation</a></div>
	</div><!-- /header -->
	
	<div data-role="content" class="jqm-content" style="padding-top: 0px;padding-bottom: 0px;">
	
		<c:if test="${req._q!='' && req._q!=null}">
			<jsp:include page="at_m.jsp"  />
		</c:if>
		<c:if test="${req._q=='' || req._q==null}">
			<c:if test="${req._ps!='' && req._ps != null}">
				<jsp:include page="../${req._ps }.jsp"  />
			</c:if>
		</c:if>
	
	</div>
	<div data-role="footer" class="footer-docs" data-theme="f">
		<p>Copyright shsuk. All right reserved.</p>
	</div>
	
	<div id="leftpanel_menu" class="ui-panel ui-panel-position-left ui-panel-display-overlay ui-body-a ui-panel-animate ui-panel-open" data-theme="c" data-display="overlay" data-position="left" data-role="panel">
		<jsp:include page="../main_m_menu.jsp"  />
	</div>
</div>

</body>
</html>