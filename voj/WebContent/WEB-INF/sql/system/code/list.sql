query:=
/*
{
	id:'code_tbl',
	button_search: {group_id:'', edit_type:'', search_value:'placeholder="코드값"'},
	button_add:'_q=system/code/edit',
	style:"${row.group_id=='root' ? 'background-color:#eeeeee; color:#0054FF' : ''}",
	link:{code_name:"view('system/code/edit','rid=${row.rid}')"},
	hidden:'rid',
	img: 'code_img_id'
}
*/
SELECT 
	rid,
	group_id,
	code_img_id,
	code_value,
	code_name,
	reference_value,
	order_no,
	depth,
	use_yn,
	edit_type
FROM code_tbl
WHERE 1=1
	${empty(req.group_id) ? '--' : ''}and group_id = @{group_id}
	${empty(req.edit_type) ? '--' : ''}and edit_type = @{edit_type}
	${empty(req.search_value) ? '--' : ''}and (code_value = @{search_value} ) 
ORDER BY case when group_id='root' then code_value else group_id end, case when group_id='root' then 0 else order_no end, code_value
;

cols:= base.*;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;