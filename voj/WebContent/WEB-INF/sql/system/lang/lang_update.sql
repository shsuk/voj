UPDATE lang_tbl
SET  
	lang = @{lang},
	message = @{message},
	mod_dt = now(),
	mod_user = @{session.user_id}
WHERE rid = @{rid};
