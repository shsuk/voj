<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<c:choose>
	<c:when test="${req._ps=='at/api'}">
		{
			"success":false,
			"error_id": "2",
			"error_message":"접근 권한이 없습니다."
		}	
	</c:when>
	<c:otherwise>
		<html>
		<head>
		<script>
			top.document.location.href='at.sh?_ps=login/login_form';
		</script>
		</head>
		<body>
		
		</body>
		</html>
	</c:otherwise>
</c:choose>
