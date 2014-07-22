update voj_board_reply 
SET rep_text = @{rep_text}
WHERE rep_id=@{rep_id} and reg_id=@{session.user_id};
