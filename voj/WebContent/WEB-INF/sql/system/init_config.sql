/*
{
	id:'t_system_auto_init',
	hidden:'rid',
	singleRow:'true',
	params_update:'_q=system/init_config_update'
}
*/
SELECT
	code_ato_init,
	lang_ato_init,
	schedule_ato_init,
	workflow_ato_init,
	menu_ato_init
FROM init_config_tbl
;