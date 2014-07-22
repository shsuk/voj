query:=
/*
{
	id:'joblog_tbl',
	button_search: {
		log_status: '',
		job_class: '',
		job_id: 'placeholder="Job 아이디"',
		class_name: 'placeholder="클래스명"',
		message_id: 'placeholder="메세지 아이디"',
		start_date:'placeholder="로그일자"', label:'~', end_date:'placeholder="로그일자"'
	},
	link:{
		log_id  :"view('system/job/log_view','log_id=${row.log_id}')",
		src_id :"${row.view_script}"
	},
	before_value : "${row.job_id}",
	curr_value : "${row.job_id!=before_value ? (curr_value=='#faebff' ? '#f2ffed' : '#faebff') : curr_value}",
	style:"background-color:${curr_value};",
}
*/
SELECT 
	log_id,
	log_status,
	job_class,
	job_id,
	class_name,
	file_id,
	message_id,
	server,
	log_dt
FROM joblog_tbl
WHERE 
	log_dt between str_to_date(date_format(${empty(req.start_date) ? 'now()' : '@{start_date}'},'%Y-%m-%d'),'%Y-%m-%d')
			   and str_to_date(date_format(${empty(req.end_date) ? 'now()' : '@{end_date}'},'%Y-%m-%d 23:59:59'),'%Y-%m-%d %H:%i:%s')
	${empty(req.job_id) ? '--' : ''}and job_id = @{job_id}
	${empty(req.job_class) ? '--' : ''}and job_class = @{job_class}
	${empty(req.message_id) ? '--' : ''}and message_id = @{message_id}
	${empty(req.log_status) ? '--' : ''}and log_status = @{log_status}
	${empty(req.class_name) ? '--' : ''}and class_name = @{class_name}
ORDER BY log_id desc
;

cols:= 
	log_id,
	log_status,
	job_class,
	job_id,
	class_name,
	(case when file_id is null then '' else 'Y'end) att,
	message_id,
	(select substr(message,1,50) from joblog_tbl where log_id = base.log_id) message,
	server,
	log_dt
	;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;