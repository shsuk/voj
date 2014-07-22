/*
{
	id:'st_user_info',
	params_update:'',
	params_insert:'',
	button_edit: '',
	singleRow:true,
	read_only:'tmp, user_no'
}
*/
SELECT 
	user_no, user_id, user_nm
FROM st_user_info t1
WHERE 1=1  and user_no = @{user_no};
