<%@tag import="net.ion.user.processor.SyncBillCodeProcessor"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="groupId" type="java.lang.String" required="true"%>
<%@ attribute name="selected" type="java.lang.String" %>
<%@ attribute name="emptyText" type="java.lang.String"%>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="style" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<%@ attribute name="searchValue" type="java.lang.String" %>
<select id="${name }" name="${name }" valid="${valid }"  style="${style }"  title="${title }"  ${attr } class="${className }" >
<c:if test="${!empty(emptyText)}"><option value="">${emptyText}</option></c:if>
<c:forEach var="row" items="<%=SyncBillCodeProcessor.billCodeMap.get(groupId) %>"> 
	<c:if test="${empty(searchValue) || fn:containsIgnoreCase(row[1],searchValue)}">
		<option value="${ row[0] }" ${selected == row[0] ? 'selected' : ''}>${row[1]}</option>
	</c:if>
</c:forEach>
</select>