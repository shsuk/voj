/*
{
	id:'workflow_view',
	button_edit: '_q=system/wf/wf_edit&wf_id=${param.wf_id}',
	singleRow:true,
	hidden:'wf_id'
}
*/
SELECT 
	wf_id,
	wf_name,
	use_yn,
	job_trigger_yn,
	job_type,
	job_trigger_chk_val,
	job_trigger_path,
	job_desc,
	reg_dt,
	mod_dt,
	mod_user
FROM workflow_tbl
WHERE wf_id = @{wf_id};
/*
{
	id:'workflow_process_view',
	button_add: '_q=system/wf/wf_proc_edit&_t=add&wf_id=${param.wf_id}',
	link:{
		wf_proc_name: "view_sub('system/wf/wf_proc_edit', '&wf_proc_id=${row.wf_proc_id}', this, true)"
	},
	hidden:'wf_id'
}
*/
SELECT 
	wf_proc_id,
	wf_id,
	wf_proc_name,
	job_type,
	wf_proc_path,
	run_memo,
	order_no,
	use_yn,
	retry_cnt,
	waite_time,
	mod_user,
	reg_dt,
	mod_dt
FROM workflow_process_tbl
WHERE wf_id = @{wf_id}
ORDER BY order_no ;
