
SELECT 
	count(*) dup
FROM st_user_info  
WHERE user_id = @{user_id};