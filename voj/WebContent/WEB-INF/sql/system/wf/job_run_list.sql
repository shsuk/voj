
SELECT 
  t1.wf_id,
  t1.wf_proc_id,
  t1.wf_proc_name,
  t1.order_no,
  wf_job_id,
	src_id, 
	current_wf_proc_id,
	last_run_dt,
	t1.reg_dt,
	job_status,
	t2.retry_cnt, 
	t1.retry_cnt max_retry_cnt,
	waite_time,
	next_run_dt,
	view_script
FROM workflow_process_tbl t1
LEFT JOIN workflow_job_tbl t2 ON t1.wf_id = t2.wf_id and wf_proc_id = current_wf_proc_id 
															and (job_status in('SCS', 'RET', 'RUN', 'WAT') or (job_status = 'ERR'  and last_run_dt > (now()-7)))
WHERE t1.wf_id = @{wf_id} 
	
UNION 

SELECT
	to_number(@{wf_id}) wf_id,
	0 wf_proc_id,
	'준비중' wf_proc_name,
	0 order_no,
	wf_job_id,
	src_id, 
	current_wf_proc_id,
	last_run_dt,
	reg_dt,
	job_status,
	retry_cnt, 
	0 max_retry_cnt,
	0 waite_time,
	next_run_dt,
	'' view_script
FROM dual
LEFT JOIN workflow_job_tbl ON  wf_id = @{wf_id}  and current_wf_proc_id = 0
ORDER BY order_no;