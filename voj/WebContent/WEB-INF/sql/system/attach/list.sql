query:=
/*
{
	id:'attach_tbl',
	hidden:'rid, file_name',
	file:'file_id:file_name',
	button_search: {
		file_id: 'placeholder="파일 아이디"',
		file_ext: 'placeholder="파일 확장자"',
		mime_type: 'placeholder="MimeType%"',
		start_date:'placeholder="생성일"', label:'~', end_date:'placeholder="생성일"'
	}
}
*/
SELECT 
	rid,
	file_id,
	file_name,
	file_ext,
	mime_type,
	volume,
	file_path,
	file_size,
	creater,
	created,
	ref_tbl,
	ref_id
FROM attach_tbl
WHERE 1=1
	${empty(req.file_id) ? '--' : ''}and file_id = @{file_id}
	${empty(req.mime_type) ? '--' : ''}and mime_type = @{mime_type}
	${empty(req.file_ext) ? '--' : ''}and file_ext = @{file_ext}
	and created between trunc(decode(@{start_date},'',now(),to_date(@{start_date},'YYYY-MM-DD'))) and trunc(decode(@{end_date},'',now(),to_date(@{end_date}, 'YYYY-MM-DD'))+1)
ORDER BY rid desc
;

cols:= base.*
	;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;