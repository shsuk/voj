/*
{
	id:'code_tbl',
	params_update:'_q=system/schedule/update&scd_id=${param.scd_id}',
	params_insert:'_q=system/schedule/insert',
	button_edit: '_q=system/schedule/edit&scd_id=${param.scd_id}',
	singleRow:true,
	read_only:'scd_id,scd_svr_reg_dt,scd_str_dt,err_dt,err_msg,scd_end_dt,mod_dt,mod_user',
	edit_comment: {
		scd_path: '예) http://www.naver.com 또는 <br>net.ion.webapp.schedule.TestTimerTask (ImplTimerTask extends 하세요.)',
		log_write: '스케쥴러에서 제공하는 로그 기록 여부를 설정합니다.<br> 실제 소스상에서 남기는 로그는 개발된 소스에 따라 기록됩니다.'
	}
}
*/
SELECT scd_id,
	scd_name,
	scd_path,
	scd_period,
	scd_run_ip,
	log_write,
	dsc,
	use_yn,
	scd_svr_reg_dt,
	scd_str_dt,
	scd_end_dt,
	err_dt,
	err_msg,
	mod_dt,
	mod_user
FROM schedule_tbl t1
WHERE scd_id = @{scd_id};
