/*
{
	id:'workflow_proc_edit',
	params_update:'_q=system/wf/wf_proc_update',
	params_insert:'_q=system/wf/wf_proc_insert&wf_id=${param.wf_id}',
	singleRow:true,
	read_only:'wf_proc_id',
	hidden:'wf_id'
}
*/
SELECT 
	wf_proc_id,
	wf_id,
	wf_proc_name,
	run_memo,
	wf_proc_path,
	job_type,
	retry_cnt,
	waite_time,
	view_script,
	order_no,
	use_yn
FROM workflow_process_tbl 
WHERE wf_proc_id  = @{wf_proc_id };
