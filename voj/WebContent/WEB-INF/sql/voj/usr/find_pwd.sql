UPDATE st_user_info
SET session_id = @{session_id}
WHERE user_id = @{user_id} ;

SELECT 
	*
FROM st_user_info  
WHERE user_id = @{user_id} ;