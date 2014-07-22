DELETE FROM voj_board
WHERE bd_id=@{bd_id}
	and ((reg_id='guest' and pw=@{pw}) or reg_id=@{session.user_id} or '${session.myGroups[req.bd_cat]}'='true' ) ;
	
DELETE FROM voj_board_reply
WHERE bd_id=@{bd_id} 
	and (SELECT count(*) FROM voj_board WHERE bd_id=@{bd_id}) = 0;
