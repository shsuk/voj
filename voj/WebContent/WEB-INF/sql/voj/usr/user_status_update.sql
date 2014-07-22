UPDATE st_user_info 
SET user_status = @{user_status}
WHERE user_no = @{user_no} and user_status <> @{user_status} ;