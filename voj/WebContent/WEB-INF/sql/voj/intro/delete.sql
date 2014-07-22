DELETE FROM voj_board
WHERE bd_id=@{bd_id} 
	and bd_cat= 'intro' 
	and (reg_id=@{session.user_id} or '${session.myGroups['intro']}'='true' ) ;
