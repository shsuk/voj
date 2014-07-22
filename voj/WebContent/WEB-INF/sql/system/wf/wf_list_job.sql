/*
{
	id:'workflow_tbl',
	button_search: {wf_name:'placeholder="워크플로우명"'},
	button_add:'_q=system/wf/wf_edit',
	link:{
		wf_name:"win_load('_ps=admin/wf/job_run_list&wf_id=${row.wf_id}', '${row.wf_name}', {height:'600',width: '95%'})",
		run_job:"fwin_load('atm.sh?_t=list&_q=system/wf/job_list&wf_id=${row.wf_id}&job_status=RUN', '${row.wf_name}', {height:'600',width: '95%'})",
		wat_job:"fwin_load('atm.sh?_t=list&_q=system/wf/job_list&wf_id=${row.wf_id}&job_status=WAT', '${row.wf_name}', {height:'600',width: '95%'})",
		scs_job:"fwin_load('atm.sh?_t=list&_q=system/wf/job_list&wf_id=${row.wf_id}&job_status=SCS', '${row.wf_name}', {height:'600',width: '95%'})",
		ret_job:"fwin_load('atm.sh?_t=list&_q=system/wf/job_list&wf_id=${row.wf_id}&job_status=RET', '${row.wf_name}', {height:'600',width: '95%'})",
		job_end24h:"fwin_load('atm.sh?_t=list&_q=system/wf/job_list&wf_id=${row.wf_id}&job_status=END', '${row.wf_name}', {height:'600',width: '95%'})",
		job_err7:"fwin_load('atm.sh?_t=list&_q=system/wf/job_list&wf_id=${row.wf_id}&job_status=ERR', '${row.wf_name}', {height:'600',width: '95%'})"
	}
}
*/
SELECT t1.wf_id, wf_name , 
	(SELECT count(*) FROM workflow_job_tbl WHERE wf_id = t1.wf_id and JOB_STATUS = 'RUN' ) run_job,
	(SELECT count(*) FROM workflow_job_tbl WHERE wf_id = t1.wf_id and JOB_STATUS = 'WAT' ) wat_job,
	(SELECT count(*) FROM workflow_job_tbl WHERE wf_id = t1.wf_id and JOB_STATUS = 'SCS' ) scs_job,
	(SELECT count(*) FROM workflow_job_tbl WHERE wf_id = t1.wf_id and JOB_STATUS = 'RET' ) ret_job,
	(SELECT count(*) FROM workflow_job_tbl WHERE wf_id = t1.wf_id and JOB_STATUS = 'ERR' and last_run_dt > (now()-7)) job_err7,
	(SELECT count(*) FROM workflow_job_tbl WHERE wf_id = t1.wf_id and JOB_STATUS = 'END' and last_run_dt > (now()-1)) job_end24h
FROM workflow_tbl t1
WHERE wf_name like '%' || @{wf_name} || '%'
	and use_yn = 'Y'
ORDER BY wf_name;
