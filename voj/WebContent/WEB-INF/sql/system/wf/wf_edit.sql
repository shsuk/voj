/*
{
	id:'workflow_edit',
	params_update:'_q=system/wf/wf_update',
	params_insert:'_q=system/wf/wf_insert',
	button_edit: '_q=system/wf/edit&wf_id=${param.wf_id}',
	singleRow:true,
	read_only:'mod_dt,mod_user,reg_dt',
	hidden:'wf_id'
}
*/
SELECT 
	wf_id,
	wf_name,
	use_yn,
	job_trigger_yn,
	job_trigger_chk_val,
	job_trigger_path,
	job_type,
	job_desc,
	reg_dt,
	mod_dt,
	mod_user
FROM workflow_tbl
WHERE wf_id = @{wf_id};
