/*
{
	id:'menu_tbl',
	params_update:'_q=system/menu/update&rid=${param.rid}',
	params_insert:'_q=system/menu/insert',
	singleRow:true,
	img: 'menu_img_id',
	hidden:'rid',
	read_only:'upper_rid, mod_dt'
}
*/
SELECT  rid,
	upper_rid,
	menu_id menu_id_sys,
	menu_name,
	auth_id,
	url,
	order_no,
	new_win,
	disply_yn,
	mobile_yn,
	use_yn,
	menu_img_id,
	mod_dt
FROM menu_tbl 
WHERE rid = @{rid};