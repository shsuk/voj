<%@page import="net.ion.webapp.workflow.WorkflowTask"%>
<%@page import="net.ion.webapp.workflow.WorkflowService"%>
<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%
		pageContext.setAttribute("wfPool", WorkflowService.getPoolInfo());
%>

<table  class="ui-widget ui-widget-content contents-contain" style="width:300px">
	<tr>
		<td style="text-align:right; width:35%">처리중인 Job</td><td style="text-align:right; width:15%">${wfPool.active_job }</td>
		<td style="text-align:right; width:35%">대기중인 Job</td><td style="text-align:right; width:15%">${wfPool.waiting_job }</td>
	</tr>
	<tr>
		<td style="text-align:right; width:35%"> Pool Size</td><td style="text-align:right; width:15%">${wfPool.pool_size }</td>
		<td style="text-align:right; width:35%"> 가용 사이즈</td><td style="text-align:right; width:15%">${wfPool.pool_capacity }</td>
	</tr>
</table>
샐행중인 작업 정보 : <%=WorkflowTask.getRunInfo() %>
