INSERT INTO  workflow_job_tbl (
	wf_job_id,
	wf_id,
	src_id
)VALUES(
	rid.nextval,
	@{wf_id},
	@{rid}
)
