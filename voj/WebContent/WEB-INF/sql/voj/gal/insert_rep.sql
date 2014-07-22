INSERT INTO voj_gallery_reply(
	gal_id,
	rep_text,
	reg_id,
	reg_dt,
	reg_ip
)VALUES(
	@{gal_id},
	@{rep_text},
	@{session.user_id},
	now(),
	@{session.ip}
);
