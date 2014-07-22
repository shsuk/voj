
SELECT 
	count(*) dup
FROM st_user_info  
WHERE nick_name = @{nick_name};