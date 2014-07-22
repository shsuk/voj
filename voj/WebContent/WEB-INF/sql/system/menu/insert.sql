
INSERT INTO menu_tbl(
	upper_rid,
	menu_id,
	menu_name,
	auth_id,
	url,
	order_no,
	new_win,
	disply_yn,
	mobile_yn,
	use_yn,
	menu_img_id,
	mod_user
)VALUES(
	@{upper_rid},
	@{menu_id_sys},
	@{menu_name},
	@{auth_id},
	@{url},
	@{order_no},
	@{new_win},
	@{disply_yn},
	@{mobile_yn},
	@{use_yn},
	@{menu_img_id},
	@{session.user_id}
);

UPDATE attach_tbl
SET 
	REF_ID = LAST_INSERT_ID(),
	REF_TBL = 'MENU_TBL'
WHERE file_id = @{menu_img_id};
