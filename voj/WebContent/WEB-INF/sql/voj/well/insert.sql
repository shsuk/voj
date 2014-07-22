INSERT INTO voj_board(
	title,
	contents,
	disply_date,
	reg_id,
	reg_ip,
	reg_dt,
	reg_nickname,
	notice,
	security,
	bd_key,
	bd_cat
)VALUES(
	@{title},
	@{ir1},
	@{disply_date},
	@{session.user_id},
	@{session.ip},
	now(),
	@{session.nick_name},
	'${empty(req.notice) ? 'N' : 'Y'}',
	'${empty(req.security) ? 'N' : 'Y'}',
	@{bd_key},
	'well'
);
