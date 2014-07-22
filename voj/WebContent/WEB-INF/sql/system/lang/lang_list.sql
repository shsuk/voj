query:=
/*
{
	id:'tb_system_lang',
	button_search: {message_id:'placeholder="MESSAGE_ID"',message:'placeholder="MESSAGE"'},
	button_add:'_q=system/lang/lang_view',
	sort:'message_id,lang,message',
	hidden:'rid',
	link:{
		message_id:"view('system/lang/lang_view','_tab=n&rid=${row.rid}', this, true)"
	}
}
*/
SELECT
	rid,
	message_id,
	lang,
	message
FROM lang_tbl
WHERE (message_id like CONCAT('%',  @{message_id}, '%') )
	and (message like CONCAT('%',  @{message}, '%') )  
#{_sort_val};

cols:= base.* ;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;