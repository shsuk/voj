<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="value" type="java.lang.String" required="true"%>
<%@ attribute name="valid" type="java.lang.String" %>
<input type="hidden" name="${name }" value="${value }"  valid="${valid}" >
<c:set var="hp" value="${fn:split(value,'-')}"/>
<table  style="margin: 0px;padding: 0px;width: 200px"><tr>
	<td style="border:0px;padding:0 0 0 0;">
		<tp:select name="${name }1" groupId="hp" selected="${hp[0]}" style="width:50px;" className="btn-l"  />
	</td><td style="border:0px;padding:0 0 0 0;">
		&nbsp;-&nbsp;
	</td><td style="border:0px;padding:0 0 0 0;">
		<input type="text" name="${name }2" value="${hp[1]}" style="width:50px;" valid="['minlen:3']"  maxlength="4">
	</td><td style="border:0px;padding:0 0 0 0;">
		&nbsp;-&nbsp;
	</td><td style="border:0px;padding:0 0 0 0;">
		<input type="text" name="${name }3" value="${hp[2]}" style="width:50px;" valid="['minlen:3']"  maxlength="4">
	</td></tr></table>
