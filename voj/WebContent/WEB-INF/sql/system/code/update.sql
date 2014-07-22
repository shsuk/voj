UPDATE code_tbl
SET
	group_id = @{group_id},
	code_value = @{code_value},
	code_name = @{code_name},
	reference_value = @{reference_value},
	order_no = @{order_no},
	depth = @{depth},
	edit_type = @{edit_type},
	code_img_id = @{code_img_id},
	use_yn = @{use_yn},
	mod_dt = now(),
	mod_user = @{session.user_id}
WHERE rid = @{rid};

UPDATE attach_tbl
SET 
	REF_ID = @{rid},
	REF_TBL = 'CODE_TBL'
WHERE file_id = @{code_img_id};
