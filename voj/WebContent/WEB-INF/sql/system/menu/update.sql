UPDATE menu_tbl
SET
	upper_rid = @{upper_rid},
	menu_id = @{menu_id_sys},
	menu_name = @{menu_name},
	auth_id = @{auth_id},
	url = @{url},
	order_no = @{order_no},
	new_win = @{new_win},
	disply_yn = @{disply_yn},
	mobile_yn = @{mobile_yn},
	use_yn = @{use_yn},
	menu_img_id = @{menu_img_id},
	mod_dt = now(),
	mod_user = @{session.user_id}
WHERE rid = @{rid};

UPDATE attach_tbl
SET 
	REF_ID = @{rid},
	REF_TBL = 'MENU_TBL'
WHERE file_id = @{menu_img_id};
