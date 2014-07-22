INSERT INTO workflow_job_log_tbl (
	wf_job_id,
	wf_id,
	wf_proc_id,
	run_dt,
	end_dt,
	proc_status
)
SELECT 
	@{wf_job_id},
	@{wf_id},
	@{current_wf_proc_id},
	to_date(@{last_run_dt}, 'YYYY-MM-DD HH24:MI:SS'),
	now(),
	decode(@{job_status}, 'ERR', 'F', 'S')
FROM dual
WHERE @{job_status} <> 'WAT' ;

	
INSERT INTO WORKFLOW_JOB_ERR_LOG_TBL (
	wf_job_log_id,
	err_msg
)
SELECT 
	 last_insert_id(),
	@{error_message}
FROM dual
WHERE @{job_status} = 'ERR' ;


UPDATE workflow_job_tbl
SET 
	job_status = decode(@{job_status}, 'ERR', decode(@{max_retry_cnt}, '0', 'ERR', 'RET'), @{job_status}),
	retry_cnt = retry_cnt + decode(@{job_status}, 'ERR', 1, 0),
	next_run_dt = decode(@{job_status}, 'SCS', now(), (now() + (to_number(@{waite_time})/1440)))
WHERE wf_job_id = @{this.wf_job_id};
