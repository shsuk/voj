INSERT INTO voj_vod(
	title,
	contents_id,
	preacher,
	wk_dt,
	bible,
	contents,
	reg_id,
	reg_dt,
	reg_ip,
	file_id,
	bd_cat
)VALUES(
	@{title},
	@{contents_id},
	@{preacher},
	@{wk_dt},
	@{bible},
	@{ir1},
	@{session.user_id},
	now(),
	@{session.ip},
	@{file_id},
	@{bd_cat}
);

UPDATE attach_tbl
SET 
	REF_TBL = 'VOJ_VOD',
	REF_ID = LAST_INSERT_ID()
WHERE file_id = @{file_id}