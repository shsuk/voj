DELETE FROM voj_vod_reply
WHERE rep_id=@{rep_id} 
	and (reg_id=@{session.user_id}
		
	);
