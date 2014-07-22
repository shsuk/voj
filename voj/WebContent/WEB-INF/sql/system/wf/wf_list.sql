/*
{
	id:'workflow_tbl',
	button_search: {wf_name:'placeholder="워크플로우명"'},
	button_add:'_q=system/wf/wf_edit',
	link:{
		wf_name:"view('system/wf/wf_view','&wf_id=${row.wf_id}', this, true)"
	}
}
*/
SELECT wf_id,
	wf_name,
	job_trigger_yn,
	job_trigger_path,
	job_type,
	use_yn,
	mod_user,
	mod_dt,
	reg_dt
FROM workflow_tbl
WHERE wf_name like '%' || @{wf_name} || '%'
ORDER BY wf_name;
