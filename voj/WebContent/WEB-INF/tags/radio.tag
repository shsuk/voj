<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="groupId" type="java.lang.String" required="true"%>
<%@ attribute name="checked" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<c:forEach var="row" items="${code:list(groupId)}"> 
	<input name="${name}" id="${name}_${row.code_value }"  type="radio" value="${row.code_value }" ${att } ${checked == row.code_value ? 'checked' : ''} valid="${valid }"  title="${title }" style="float: left;"  ${attr } ><label style="float: left;line-height: 20px;" for="${name}_${row.code_value }">${code:name(groupId, row.code_value, lang)}&nbsp;&nbsp;</label>
</c:forEach>