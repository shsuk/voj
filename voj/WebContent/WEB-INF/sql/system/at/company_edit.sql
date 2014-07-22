/*{
	id:'company_tbl', singleRow:true,
	params_update:{_q:'test/insert'},
	params_insert:{_q:'test/insert'}
}*/
SELECT * 
FROM company_tbl
WHERE rid = @{rid};
