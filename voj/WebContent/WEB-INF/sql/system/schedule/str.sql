UPDATE schedule_tbl
SET
	scd_str_dt = now()
WHERE scd_id = @{scd_id};
