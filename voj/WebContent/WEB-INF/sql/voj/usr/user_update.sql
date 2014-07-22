UPDATE st_user_info 
SET village = @{village}, pwd=${empty(req.npwd) ? 'pwd' : 'password(@{npwd})'}
WHERE user_no = @{session.user_id}  and pwd = password(@{pwd})  ;