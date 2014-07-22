UPDATE workflow_job_tbl
SET 
	working_id = null,
	job_status = 'END',
	next_run_dt = now()
WHERE job_status = 'SCS' 
	and wf_id not in (SELECT distinct wf_id FROM workflow_process_tbl WHERE USE_YN = 'Y');
