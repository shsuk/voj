query:=

SELECT *
FROM voj_vod
WHERE bd_cat= @{bd_cat}
${empty(req.search_val) ? '--' : ''} and (title like concat('%', @{search_val}, '%') or preacher like concat('%', @{search_val}, '%') or bible like concat('%', @{search_val}, '%') or contents like concat('%', @{search_val}, '%'))
ORDER BY wk_dt desc ;

cols:= 	base.*
;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;