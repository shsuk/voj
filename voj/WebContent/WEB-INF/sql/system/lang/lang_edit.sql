/*
{
	id:'tb_system_lang',
	hidden:'rid',
	singleRow:'true',
	params_update:'_q=system/lang/lang_update',
	params_insert:'_q=system/lang/lang_insert',
	read_only:'message_id'
}
*/
SELECT
	rid,
	message_id,
	lang,
	message
FROM lang_tbl
WHERE rid = @{rid}
;