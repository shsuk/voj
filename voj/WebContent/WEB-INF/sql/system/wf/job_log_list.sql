/*
{
	id:'workflow_job_log_tbl'
}
*/
SELECT 
	t1.wf_job_log_id,
	WF_PROC_NAME,
	t1.run_dt,
	t1.end_dt,
	t1.proc_status,
	t2.err_msg
FROM workflow_job_log_tbl t1
LEFT JOIN workflow_job_err_log_tbl t2 ON t1.wf_job_log_id = t2.wf_job_log_id
LEFT JOIN workflow_process_tbl t3 ON t1.WF_PROC_ID = t3.WF_PROC_ID
WHERE wf_job_id = @{wf_job_id}
ORDER BY wf_job_log_id
;