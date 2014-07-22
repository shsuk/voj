query:=
/*
{
	id:'code_tbl',
	button_search: {group_id:'',search_value:'placeholder="검색어"'},
	button_add:'_q=system/code/edit',
	link:{code_name:"select_${req._field }(this, '${req.return_fields}')"},
	hidden:'rid'
}
*/
SELECT group_id,
	code_value,
	code_name
FROM code_tbl
WHERE (code_value like '%' || @{search_value} || '%' 
		or code_name like '%' || @{search_value} || '%' 
		or group_id like '%' || @{search_value} || '%'
		or edit_type like '%' || @{search_value} || '%'
	)
	and group_id = decode(@{group_id},'',group_id,@{group_id})
ORDER BY group_id, order_no, code_value;

cols:= base.*;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;