/*
{
	id:'tb_system_lang',
	pk:'rid',
	hidden:'rid',
	singleRow:'true',
	params_update:'_q=system/lang/lang_update&rid=${row.rid}',
	params_insert:'_q=system/lang/lang_insert',
	button_edit: '_q=system/lang/lang_edit&_t=edit&_tab=n&rid=${row.rid}',
	params_delete:'_q=system/lang/lang_delete&rid=${row.rid}',
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