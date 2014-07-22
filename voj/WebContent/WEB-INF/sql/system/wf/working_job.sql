
SELECT wf_job_id
FROM workflow_job_tbl
WHERE job_status in ('WAT','RET')
	and next_run_dt <= now() 
LIMIT 0, 1;
	
UPDATE workflow_job_tbl
SET 
	job_status = 'RUN',
	run_ip = @{run_ip},
	last_run_dt = now()
WHERE wf_job_id = @{this.wf_job_id};
	
SELECT 
	t1.wf_job_id,
	t1.wf_id,
	current_wf_proc_id,
	date_format(last_run_dt, '%Y-%m-%d %H:%i:%s') last_run_dt,
	t1.reg_dt,
	job_status,
	src_id,
	t1.retry_cnt,
	next_run_dt,
	wf_proc_id,
	wf_proc_name,
	wf_proc_path,
	run_memo,
	order_no,
	use_yn,
	job_type,
	t2.retry_cnt max_retry_cnt,
	waite_time
FROM workflow_job_tbl t1
INNER JOIN workflow_process_tbl t2 ON t1.current_wf_proc_id = t2.wf_proc_id
WHERE wf_job_id = @{this.wf_job_id};