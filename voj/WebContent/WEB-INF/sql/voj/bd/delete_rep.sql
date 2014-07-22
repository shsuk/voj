SELECT rep_id FROM voj_board_reply WHERE rep_id=@{rep_id} and reg_id=@{session.user_id};

DELETE FROM voj_board_reply
WHERE upper_rep_id = @{this.rep_id} or (rep_id=@{rep_id} and reg_id=@{session.user_id});
