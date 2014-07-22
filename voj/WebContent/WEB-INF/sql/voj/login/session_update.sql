UPDATE st_user_info
SET session_id = @{session_id} 
WHERE user_no = @{user_id};