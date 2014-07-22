UPDATE ST_USER_INFO 
SET 
	user_nm = @{user_nm}, 
	user_id = @{user_id},
	mb_hp = @{mb_hp},
	mb_email = @{mb_email}
WHERE user_no = @{user_no} ;