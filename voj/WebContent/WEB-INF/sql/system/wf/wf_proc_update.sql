UPDATE workflow_process_tbl
SET
	wf_id = @{wf_id},
	wf_proc_name = @{wf_proc_name},
	wf_proc_path = @{wf_proc_path},
	view_script = @{view_script},
	job_type = @{job_type},
	retry_cnt = @{retry_cnt},
	waite_time = @{waite_time},
	run_memo = @{run_memo},
	order_no = @{order_no},
	use_yn = @{use_yn},
	mod_dt = sysdate,
	mod_user = @{session.user_id}
WHERE wf_proc_id  = @{wf_proc_id };