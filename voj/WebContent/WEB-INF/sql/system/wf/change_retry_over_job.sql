UPDATE workflow_job_tbl t1
SET 
	job_status = 'ERR',
	next_run_dt = now()
WHERE job_status = 'RET'
	and retry_cnt >= (SELECT retry_cnt FROM workflow_process_tbl t2 WHERE  t2.wf_proc_id = t1.current_wf_proc_id);
