/*
{
	id:'schedule_tbl',
	button_search: {use_yn:'', search_value:'placeholder="스케쥴명"'},
	button_add:'_q=system/schedule/add',
	link:{scd_name:"view('system/schedule/edit','scd_id=${row.scd_id}')"}
}
*/
SELECT scd_id,
	scd_name,
	scd_path,
	scd_period,
	scd_run_ip,
	log_write,
	use_yn,
	scd_svr_reg_dt,
	scd_str_dt,
	scd_end_dt,
	err_dt,
	mod_dt,
	mod_user
FROM schedule_tbl
WHERE scd_name like '%' || @{search_value} || '%' 
--	and use_yn = decode(@{use_yn},'',use_yn, @{use_yn})
ORDER BY scd_name;
