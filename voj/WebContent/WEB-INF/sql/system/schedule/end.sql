UPDATE schedule_tbl
SET
	scd_end_dt = now()
WHERE scd_id = @{scd_id};
