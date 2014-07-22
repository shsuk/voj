<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="title" type="java.lang.String" required="true"%>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="start_date" type="java.lang.String"%>
<%@ attribute name="end_date" type="java.lang.String"%>
<%@ attribute name="start_data_init_value" type="java.lang.Integer" description="시작일이 없는 경우 초기 설정일 (7:7일전으로 설정) "%>
<c:set var="temp_val" value="${uf:formatDate(uf:addDays(uf:now(),10),'yyyy-MM-dd')}" />
<c:set var="start_date" value="${empty(start_date) ? uf:formatDate(uf:addDays(uf:now(),start_data_init_value),'yyyy-MM-dd') : start_date }" />
<c:set var="end_date" value="${empty(end_date) ? uf:getDate('yyyy-MM-dd') : end_date }" />
<table class="${className }" style="margin: 0px;"><tr><td>
	<b>${title }:</b>
</td><td>
	<input type="text" id="start_date" name="start_date" readonly="readonly" value="${start_date}" style="width: 80px;" title="${title }" class="datepicker">
</td><td> ~ </td><td>
	<input type="text" id="end_date" name="end_date" readonly="readonly" value="${end_date}" style="width: 80px;" title="${title }" class="datepicker">
</td></tr></table>

