INSERT INTO voj_board_reply(
	bd_id,
	upper_rep_id,
	rep_text,
	reg_id,
	reg_dt,
	reg_ip
)VALUES(
	@{bd_id},
	@{upper_rep_id},
	@{rep_text},
	@{session.user_id},
	now(),
	@{session.ip}
);

update voj_board_reply
set upper_rep_id = rep_id
where upper_rep_id = 0;