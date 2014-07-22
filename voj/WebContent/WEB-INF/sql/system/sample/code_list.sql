query:=
/*
{
	id:'code_tbl',
	button_search: {group_id:'',search_value:'placeholder="검색어"'},
	button_add:'_q=system/code/edit',
	link:{code_name:"view('system/code/edit','rid=${row.rid}')"},
	hidden:'rid'
}
*/
SELECT * 
FROM code_tbl
WHERE (code_value like '%' || @{search_value} || '%' 
		or code_name like '%' || @{search_value} || '%' 
		or group_id like '%' || @{search_value} || '%'
		or edit_type like '%' || @{search_value} || '%'
	)
	${empty(req.group_id) ? '--' : ''}and group_id = @{group_id}
ORDER BY group_id, order_no, code_value;

cols:= base.*;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;