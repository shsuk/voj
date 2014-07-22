INSERT INTO voj_vod_reply(
	vod_id,
	rep_text,
	reg_id,
	reg_dt,
	reg_ip
)VALUES(
	@{vod_id},
	@{rep_text},
	@{session.user_id},
	now(),
	@{session.ip}
);
