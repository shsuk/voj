/*
{
	id:'#id#',
	params_update:'#params_update#',
	params_insert:'#params_insert#',
	button_edit: '#button_edit#',
	singleRow:true,
	read_only:'#read_only#'
}
*/
SELECT 
	t1.*
FROM #table_name# t1
WHERE 1=1 #pk_where#;
