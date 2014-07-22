/*
{
	id:'code_tbl',
	params_update:'_q=voj/header/update&id=${param.id}',
	params_insert:'_q=voj/header/insert',
	button_edit: '_q=voj/header/edit&id=${param.id}',
	singleRow:true,
	hidden:'id',
	img: 'code_img_id',
	read_only:'reg_dt, mod_dt, mod_user'
}
*/
SELECT 
	* 
FROM voj_board_header
WHERE id = @{id} or bd_cat = @{bd_cat};
