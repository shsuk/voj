UPDATE workflow_job_tbl
SET 
	current_wf_proc_id = @{next_wf_proc_id},
	job_status = 'WAT',
	next_run_dt = now()
WHERE wf_id = @{wf_id}
	and job_status = 'SCS'
	and current_wf_proc_id = @{wf_proc_id};
