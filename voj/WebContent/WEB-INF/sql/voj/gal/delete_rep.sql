DELETE FROM voj_gallery_reply
WHERE gal_rep_id=@{gal_rep_id} 
	and (reg_id=@{session.user_id} or '${session.myGroups[req.bd_cat]}'='true' );
