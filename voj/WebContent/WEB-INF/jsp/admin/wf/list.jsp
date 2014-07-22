<%@page import="net.ion.webapp.workflow.WorkflowService"%>
<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<script type="text/javascript">
$(function() {
	$('#job_pool_reload').button({icons: {primary: "ui-icon-refresh"}}).click(function( event ) {
		$('#job_pool').load('at.sh?_ps=admin/wf/job_pool');
		goPage(1, 'system/wf/wf_list_job.workflow_tbl');
	});


});

</script>
<div id="scd_list">
	<table style="width: 100%">
		<tr>
			<td>
				<c:set var="_q" scope="request" value="system/wf/wf_list_job"/>
				<c:set var="_t" scope="request" value="list"/>
				<jsp:include page="../../at/at.jsp"/>
			</td>
		</tr>
		<tr>
			<td id="job_pool_reload">
				<div id="">새로고침</div>
			</td>
		</tr>
		<tr>
			<td id="job_pool">
				<jsp:include page="job_pool.jsp"/>
			</td>
		</tr>
	</table>
</div>

