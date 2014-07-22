<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="qyeryId" type="java.lang.String" required="true"%>
<%@ attribute name="selected" type="java.lang.String" %>
<%@ attribute name="defaultValues" type="java.lang.String" description="예) fild1: 'val1', fld2: 2 ...." %>
<%@ attribute name="emptyText" type="java.lang.String"%>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="style" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<uf:organism>[
	<uf:job id="rows" jobId="db" query="${qyeryId }" isCache="true" refreshTime="3600">
		defaultValues:{${defaultValues}}
	</uf:job>
]</uf:organism>
<select id="${name }" name="${name }" valid="${valid }"  style="${style }"  title="${title }"  ${attr } class="${className }" >
<c:if test="${!empty(emptyText)}"><option value="">${emptyText}</option></c:if>
<c:forEach var="row" items="${rows}"> 
	<option value="${row.id }" ${selected == row.id ? 'selected' : ''}>${row.name}</option>
</c:forEach>
</select>