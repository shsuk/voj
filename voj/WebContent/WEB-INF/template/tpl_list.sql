query:=
/*
{
	id:'#id#',
	button_search: {#button_search#},
	link:{#pk#:"view('#_q#','#key#')"}
}
*/
SELECT 
	*
FROM #table_name# t1
WHERE 1=1 #where#;

cols:= base.*;

TEMPLATE:=system/oracle_simple_paging;