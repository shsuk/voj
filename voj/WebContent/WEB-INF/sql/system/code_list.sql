SELECT
	group_id,
	code_name,
	code_value,
	USE_YN,
	reference_value,
	edit_type,
	order_no,
	depth,
	CASE WHEN depth=1 THEN code_value ELSE '1' END temp,
	code_img_id
FROM code_tbl
ORDER BY depth, temp, order_no;