INSERT INTO lang_tbl (message_id, lang, message, reg_dt, mod_dt,	mod_user)
VALUES( @{message_id}, @{lang}, @{message},now(), now(), @{session.user_id});
