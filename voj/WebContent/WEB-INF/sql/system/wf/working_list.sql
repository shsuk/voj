
SELECT *
FROM workflow_job_tbl
WHERE job_status = 'RUN'
	and LAST_RUN_DT < (now() - 5/1440)
	and run_ip = @{run_ip};