UPDATE schedule_tbl
SET
	scd_svr_reg_dt = now()
WHERE scd_id = @{scd_id};
