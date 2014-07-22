INSERT INTO voj_board(
	title,
	contents,
	reg_id,
	reg_dt,
	reg_ip,
	reg_nickname,
	notice,
	security,
	bd_key,
	bd_cat
)VALUES(
	@{title},
	@{ir1},
	@{session.user_id},
	now(),
	@{session.ip},
	@{session.nick_name},
	'${empty(req.notice) ? 'N' : 'Y'}',
	'${empty(req.security) ? 'N' : 'Y'}',
	@{bd_key},
	'intro'
);
