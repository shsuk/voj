/*{
	id:'app_tbl',
	button_edit: {_q:'test/edit'},
	singleRow:true,
	link:{cp_id:"'company_tbl',${row.cp_id}"},
	hidden:'rid',
	group:{
		default_info:'rid ,app_id ,contents_nm ,con_intro_text, keyword ,app_status ,free_chk ,price ,discount_price ,app_make_date ,app_ver ,app_path ,app_file_name',
		multi_lang_info:'contents_nm_en ,con_intro_text_en ,contents_nm_cn ,con_intro_text_cn ,contents_nm_jp ,con_intro_text_jp ,contents_nm_etc ,con_intro_text_etc'
	}
}*/
SELECT rid ,app_id ,contents_nm ,con_intro_text, keyword ,app_status ,free_chk ,price ,discount_price ,app_make_date ,app_ver ,app_path ,app_file_name ,
	cate_child ,cate_a ,cate_b ,grade_min ,grade_max ,registed ,register ,changed ,modifier ,cp_id ,app_update_info ,
	contents_nm_en ,con_intro_text_en ,contents_nm_cn ,con_intro_text_cn ,contents_nm_jp ,con_intro_text_jp ,contents_nm_etc ,con_intro_text_etc ,
	app_service_date ,inspect_req_date ,verify_msg ,intro_writer ,email_writer 
FROM app_tbl
WHERE rid = @{rid};

/*{
	id:'app_img_tbl',hidden:'img_path'
}*/
SELECT *
FROM app_img_tbl
WHERE app_rid = @{this.app_tbl.rid};

/*{
	id:'company_tbl',singleRow:true,
	button_edit:  {_q:'test/company_edit'},
}*/
SELECT * 
FROM company_tbl
WHERE cp_id = @{this.app_tbl.cp_id};

/*{
	id:'attach_tbl',img:'file_id',
	button_edit:  {_q:'test/attach_edit'},
}*/
SELECT top 10 file_id,file_name 
FROM attach_tbl
WHERE file_ext = 'jpg'
ORDER BY rid desc ;