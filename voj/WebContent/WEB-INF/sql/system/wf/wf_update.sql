UPDATE workflow_tbl
SET
	wf_name = @{wf_name},
	job_trigger_yn = @{job_trigger_yn},
	job_trigger_chk_val = @{job_trigger_chk_val},
	job_trigger_path = @{job_trigger_path},
	job_type = @{job_type},
	job_desc = @{job_desc},
	use_yn = @{use_yn},
	mod_dt = now(),
	mod_user = @{session.user_id}
WHERE wf_id  = @{wf_id };