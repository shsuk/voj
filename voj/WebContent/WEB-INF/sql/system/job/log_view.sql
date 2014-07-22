/*
{
	id:'joblog_tbl',
	singleRow:true,
	file: 'file_id:file_name',
	hidden: 'file_name',
}
*/
SELECT 
	log_id,
	job_class,
	job_id,
	message_id,
	message,
	class_name,
	file_id,
	(SELECT file_name FROM ATTACH_TBL WHERE file_id = t1.file_id) file_name,
	log_status,
	server,
	log_dt
FROM joblog_tbl t1
WHERE 
	log_id = @{log_id}
;
