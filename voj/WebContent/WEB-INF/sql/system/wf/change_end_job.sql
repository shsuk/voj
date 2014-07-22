UPDATE workflow_job_tbl
SET 
	job_status = 'END',
	next_run_dt = now()
WHERE wf_id = @{wf_id}
	and job_status = 'SCS'
	and current_wf_proc_id = @{wf_proc_id};
