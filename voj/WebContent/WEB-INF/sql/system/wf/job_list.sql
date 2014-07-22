query:=
/*
{
	id:'workflow_tbl',
	button_search: {
		wf_id: 'placeholder="워크플로우 아이디"',
		src_id: 'placeholder="작업대상 아이디"',
		job_status: ''
	},
	link:{
		wf_job_id :"win_load('_q=system/wf/job_log_list&wf_job_id=${row.wf_job_id  }&_t=list', '${row.wf_job_id} (${row.wf_name}-${row.last_wf_proc_name})', {width:800, height:410, resizable: true})",
		wf_name :"win_load('_q=system/wf/wf_view&wf_id=${row.wf_id  }&_t=view', '${row.wf_name}', {width:800, height:410, resizable: true})",
		src_id :"${row.VIEW_SCRIPT}"
	},
	hidden: 'wf_id,view_script'
}
*/
SELECT wf_job_id,
	wf_id,
	src_id, 
	current_wf_proc_id,
	last_run_dt,
	reg_dt,
	job_status,
	retry_cnt, 
	next_run_dt
FROM workflow_job_tbl
WHERE 1=1
	${empty(req.wf_id) ? '--' : ''}and wf_id = @{wf_id}
	${empty(req.src_id) ? '--' : ''}and src_id = @{src_id}
	${empty(req.job_status) ? '--' : ''}and job_status = @{job_status}
	and wf_id = decode(@{wf_id},'',wf_id,@{wf_id})
ORDER BY wf_job_id desc
;

cols:= wf_job_id,
	(SELECT wf_name FROM workflow_tbl WHERE wf_id = base.wf_id) wf_name,
	src_id, 
	(SELECT wf_proc_name FROM workflow_process_tbl WHERE  wf_id = base.wf_id and wf_proc_id = base.current_wf_proc_id) current_wf_proc_name,
	(SELECT view_script FROM workflow_process_tbl WHERE  wf_id = base.wf_id and wf_proc_id = base.current_wf_proc_id) view_script,
	last_run_dt,
	reg_dt,
	job_status,
	retry_cnt,
	CASE WHEN (job_status='WAT' or job_status='RET') THEN round((next_run_dt - now())*1440, 0)  ELSE null END next_run_time
;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;