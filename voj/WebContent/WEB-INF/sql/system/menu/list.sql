SELECT rid,
	upper_rid,
	menu_id,
	menu_name,
	auth_id,
	url,
	menu_img_id icon,
	new_win,
	order_no,
	disply_yn,
	use_yn,
	(SELECT count(*) FROM menu_tbl WHERE upper_rid = t1.rid and  use_yn = 'Y') isFolder
FROM menu_tbl t1
ORDER BY upper_rid, order_no;