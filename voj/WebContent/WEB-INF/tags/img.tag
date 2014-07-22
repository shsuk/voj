<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<%@ attribute name="file_id" required="true" type="java.lang.String"%>
<%@ attribute name="thum" required="true" type="java.lang.String"%>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="style" type="java.lang.String" %>
<%@ attribute name="id" type="java.lang.String" %>
<%@ attribute name="name" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<c:if test="${!empty(file_id )}">
	<c:set var="thum" value="${thum=='100%' ? '0' : thum}"/>
	<img id="${id }" name="${name }" value="${file_id }" class="${className }" style="${style}" title="${title}" ${attr } src="thum/${thum }/${fn:substring(file_id,0,4) }/${file_id }.jpg"  onerror="reLoadImg(this, '${thum}', '${file_id }')"/>
</c:if>