INSERT INTO voj_board(
	title,
	contents,
	${empty(req.disply_date) ? '--' : ''} disply_date,
	reg_id,
	reg_dt,
	reg_ip,
	reg_nickname,
	file_id,
	notice,
	security,
	pw,
	bd_cat,
	bd_key
)VALUES(
	@{title},
	@{ir1},
	${empty(req.disply_date) ? '--' : ''} @{disply_date},
	@{session.user_id},
	now(),
	@{session.ip},
	@{reg_nickname},
	@{file_id},
	'${empty(req.notice) ? 'N' : 'Y'}',
	'${empty(req.security) ? 'N' : 'Y'}',
	@{pw},
	@{bd_cat},
	@{bd_key}
);

UPDATE attach_tbl
SET 
	REF_TBL = 'VOJ_BOARD',
	REF_ID = LAST_INSERT_ID()
WHERE file_id = @{file_id}