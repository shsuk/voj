<%@page import="net.ion.webapp.workflow.WorkflowService"%>
<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism>
[
	<uf:job id="rows" jobId="db"  query="system/wf/job_run_list" />
]
</uf:organism>

<script type="text/javascript">
$(function() {
	 setTimeout(function(){
			$('#scd_list_graph').parent().load('at.sh?_ps=admin/wf/job_run_list&wf_id=${req.wf_id}');
	 }, 1500);
});

</script>
<div id="scd_list_graph" >
	<table style="width: 100%; "   class="ui-widget ui-widget-content contents-contain" >
		<tr><td>
		<c:forEach var="row" items="${rows }" varStatus="status">
				<c:if test="${bef_froc_id!=row.wf_proc_id }">
					<c:if test="${status.index!=0}">
						</td></tr><tr><td>
					</c:if>
					<div  class="ui-state-default" style="padding: 4px;margin: 0px;">${row.wf_proc_name } - (재시도횟수:${row.max_retry_cnt }, 대기시간:${row.waite_time })</div>
				</c:if>
				<c:if test="${row.src_id!=null }">${sts }
					<c:set var="script" ><uf:tpl src="${row.view_script}" data="row"/></c:set>
					<div  style=" margin:10px;float: left;text-align: center;" >
						<img src="images/wf/${row.job_status }.png"  style="cursor: pointer;" title="${code:name('job_status', row['job_status'], lang)} (작업일시:<fmt:formatDate value="${row.last_run_dt }" pattern="MM-dd HH:mm" />, 재시도횟수:${row.retry_cnt })" onclick="win_load('_q=system/wf/job_log_list&wf_job_id=${row.wf_job_id  }&_t=list', '로그정보 - ${row.wf_job_id}', {width:800, height:410, resizable: true})"><br>
						<span  style="cursor: pointer;" onclick="${script}"  title="${code:lang('src_id', lang, '')}">${row.src_id }<br></span>
					</div> 
				</c:if>
				<c:set var="bef_froc_id" value="${row.wf_proc_id }" />
		</c:forEach>
		</td></tr>
	</table>
</div>

