insert into lang_tbl (rid, message_id, lang, message, 	mod_user)
values(sid.nextval, @{message_id}, @{lang}, @{message}, @{session.user_id});
 