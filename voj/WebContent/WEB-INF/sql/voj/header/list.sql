/*
{
	id:'voj_board_header',
	button_add:'_q=voj/header/edit',
	style:"${row.group_id=='root' ? 'background-color:#eeeeee; color:#0054FF' : ''}",
	link:{title:"view('voj/header/edit','id=${row.id}')"},
	hidden:'rid',
	img: 'code_img_id'
}
*/
SELECT 
	id, bd_cat, title
FROM voj_board_header
ORDER BY bd_cat
;
