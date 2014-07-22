UPDATE st_user_info
SET session_id = '',
	pwd =  password(@{pwd})
WHERE session_id = @{id} ;
