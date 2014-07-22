query:=
/*
{
	id:'tb_system_lang',
	button_search: {message_id:'placeholder="MESSAGE_ID"',message:'placeholder="MESSAGE"'},
	button_add:'_q=system/lang/lang_view',
	sort:'message_id,lang,message',
	hidden:'rid',
	link:{
		message: "load_page('${row.rid}')",
		message_id: "edit_page('${row.rid}')"
	}
}
*/
SELECT
	rid,
	message_id,
	lang,
	message
FROM lang_tbl
WHERE (message_id like '%' || @{message_id} || '%' )
AND (message like '%' || @{message} || '%' )
#{_sort_val};

cols:= base.* ;
TEMPLATE:=system/oracle_simple_paging;