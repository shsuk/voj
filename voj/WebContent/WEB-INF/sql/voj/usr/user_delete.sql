DELETE FROM st_user_info 
WHERE user_no = @{user_no} and  user_status != 'Y' ;