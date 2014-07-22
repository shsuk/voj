query:=

SELECT 
	*
FROM voj_board
WHERE bd_cat= 'sch'
ORDER BY bd_key desc;

cols:= 	base.*
;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;