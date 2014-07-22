<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<title>ISlim</title>
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<link href="./favicon.ico" rel="shortcut icon" type="image/x-icon" />
	
	<link href="./jquery/mobile/css/themes/default/jquery.mobile-1.3.2.css" rel="stylesheet" type="text/css" />
	<link href="./jquery/mobile/_assets/css/jqm-demos.css" rel="stylesheet" />
	
	<script src="./jquery/mobile/js/jquery.js"></script>
	<script src="./jquery/mobile/js/jquery.mobile-1.3.2.min.js"></script>
	
	<script src="./js/commonUtil.js"></script>
	<script src="./js/formValid.js"></script>
	<script src="./js/mb.js"></script>
		
	<script type="text/javascript">
		function view_pc(){
			document.location.href = 'at.sh?_ps=main&mb=N';
		}
	</script>

</head>
<body style="overflow-x:hidden; overflow-y:hidden;">

		<div data-role="page"  class="type-interior" id="${node1.rid }">
			<div data-role="header" data-theme="f">
				<img src="./images/log.png" height="60" border="0"><div style="float: right;padding-top: 15px;padding-right: 15px;"><a href="javascript:view_pc()">PC버전</a></div>
			</div><!-- /header -->

			<div data-role="content" >
					<jsp:include page="main_m_menu.jsp"  />
			</div>
			<div data-role="footer" class="footer-docs" data-theme="c">
				<p>Copyright shsuk. All right reserved.</p>
			</div>
		</div>

</body>
</html>

