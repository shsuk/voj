/*
{
	id:'code_tbl',
	params_update:'_q=system/code/update&rid=${param.rid}',
	params_insert:'_q=system/code/insert',
	button_edit: '_q=system/code/edit&rid=${param.rid}',
	singleRow:true,
	hidden:'rid',
	read_only:'contents_nm'
}
*/
SELECT rid,
	group_id,
	code_value,
	code_name,
	reference_value,
	order_no,
	depth,
	use_yn,
	edit_type
FROM code_tbl
WHERE rid = @{rid};
