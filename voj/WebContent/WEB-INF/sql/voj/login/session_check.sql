
SELECT count(*) session_count 
FROM st_user_info 
WHERE user_no = @{user_id} and session_id = @{session_id};
