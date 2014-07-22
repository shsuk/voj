UPDATE workflow_job_tbl
SET 
	job_status = 'WAT',
	next_run_dt = now()
WHERE wf_job_id = @{wf_job_id};
