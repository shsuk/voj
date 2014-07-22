<%@page import="net.ion.user.session.SessionService"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="f" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%
	//LOCAL SYSTEM LOG OUT
	SessionService.logOut(request, response);
	
%>
<html>
<head>
<title>
login out
</title>
<script language="JavaScript">

	document.location.href = "/";

</script>
</head>
<body bgcolor="#ffffff">
</body>
</html>

