INSERT INTO code_tbl(
	group_id,
	code_value,
	code_name,
	reference_value,
	order_no,
	depth,
	edit_type,
	code_img_id,
	use_yn,
	mod_dt,
	reg_dt,
	mod_user
)VALUES(
	@{group_id},
	@{code_value},
	@{code_name},
	@{reference_value},
	@{order_no},
	@{depth},
	@{edit_type},
	@{code_img_id},
	@{use_yn},
	now(),
	now(),
	@{session.user_id}
);

UPDATE attach_tbl
SET 
	REF_ID = last_insert_id(),
	REF_TBL = 'CODE_TBL'
WHERE file_id = @{code_img_id};
