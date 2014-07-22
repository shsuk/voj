UPDATE st_user_info 
SET pwd =  password(@{pwd})
WHERE user_no = @{user_no} and '${session.myGroups['user']}'='true' ;