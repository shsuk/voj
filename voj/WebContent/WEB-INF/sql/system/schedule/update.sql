UPDATE schedule_tbl
SET
	scd_name = @{scd_name},
	scd_path = @{scd_path},
	scd_period = @{scd_period},
	scd_run_ip = @{scd_run_ip},
	log_write = @{log_write},
	dsc = @{dsc},
	use_yn = @{use_yn},
	mod_dt = now(),
	mod_user = @{session.user_id}
WHERE scd_id = @{scd_id};
