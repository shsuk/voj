

INSERT INTO  joblog_tbl (
	
	job_class,
	job_id,
	message_id,
	message,
	log_status,
	server,
	class_name,
	file_id,
	log_dt
)VALUES(
	
	@{job_class},
	@{job_id},
	@{message_id},
	@{message},
	@{log_status},
	@{server},
	@{class_name},
	@{file_id},
	now()
);

UPDATE attach_tbl
SET 
	REF_ID = last_insert_id(),
	REF_TBL = 'JOBLOG_TBL'
WHERE file_id = @{file_id};

