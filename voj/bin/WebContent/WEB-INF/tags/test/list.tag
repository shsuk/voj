<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="src" type="java.util.List" required="true"%>
<c:set var="tpl"><jsp:doBody/></c:set>
<c:forEach var="row" items="${src }" >
	<c:set var="temp">${tpl }</c:set>
	<c:forEach var="col" items="${row}" >
		<c:set var="key">@{${col.key }}</c:set>
		<c:set var="temp">${fn:replace(temp, key, col.value)}</c:set>
	</c:forEach>
	${temp }
</c:forEach>
