query:=

SELECT 
	bd_id,title,reg_dt,reg_nickname,file_id,reg_id,reg_ip,view_count,re_count,security
FROM voj_board
WHERE bd_cat= 'intro' and notice = 'N'
${empty(req.search_val) ? '--' : ''} and title like concat('%', @{search_val}, '%')
ORDER BY bd_id desc ;

cols:= 	base.*
;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;