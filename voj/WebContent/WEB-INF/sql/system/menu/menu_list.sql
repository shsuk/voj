SELECT t1.*,menu_img_id icon,
	(SELECT count(*) FROM menu_tbl WHERE upper_rid = t1.rid and  use_yn = 'Y') isFolder
FROM menu_tbl t1
WHERE use_yn = 'Y' and disply_yn = 'Y'
ORDER BY upper_rid, order_no;