SELECT 
	cast(user_no as CHAR) user_no,
	user_id,pwd,user_nm,nick_name,mb_email,mb_homepage,mb_password_q,mb_password_a,mb_level,mb_sex,mb_birth,mb_tel,mb_hp,mb_zip1,mb_zip2,mb_addr1,mb_addr2,mb_icon,mb_image,mb_signature,mb_recommend,mb_point,mb_today_login,mb_login_ip,mb_datetime,mb_ip,mb_leave_date,mb_grade,mb_intercept_date,mb_email_certify,mb_memo,mb_lost_certify,mb_mailling,mb_sms,mb_open,mb_open_date,mb_profile,mb_memo_call,user_group,session_id
FROM st_user_info t1
WHERE t1.user_id = @{uid} and t1.pwd = password(@{pwd}) and user_status = 'Y';
