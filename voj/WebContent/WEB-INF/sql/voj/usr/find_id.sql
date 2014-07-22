
SELECT 
	count(*) cnt, min(user_id) user_id
FROM st_user_info  
WHERE nick_name = @{param.user_id} or mb_email = @{user_id} or  user_nm = @{user_id};