UPDATE schedule_tbl
SET
	err_dt = now(),
	err_msg = @{err_msg}
WHERE scd_id = @{scd_id};
