/*
{
	id:'schedule_tbl',
	params_insert:'_q=system/schedule/insert',
	singleRow:true,
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
	dsc,
	log_write,
	use_yn
FROM schedule_tbl t1
WHERE scd_id = @{scd_id};
