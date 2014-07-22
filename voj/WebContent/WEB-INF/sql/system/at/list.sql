query:=
/*
{
	id:'app_tbl',
	button_search: {contents_nm:'placeholder="검색어"',app_status:''},
	button_add:{_q:'test/edit'},
	link:{contents_nm:"view('test/test_ref',${row.rid})"},
	hidden:'rid'
}
*/
	select rid ,app_id ,contents_nm, keyword ,app_status,
		ROW_NUMBER() over(order by rid desc) rnum, count(*) over() totCount
	from app_tbl t1
	where app_status = CASE WHEN @{app_status} = '' THEN app_status  ELSE  @{app_status} END
		and CASE WHEN @{contents_nm} = '' THEN  '1' ELSE contents_nm END  like  CASE WHEN @{contents_nm} = '' THEN  '1' ELSE '%' + @{contents_nm} + '%' END;

cols:= base.*;

TEMPLATE:=system/mssql_paging;