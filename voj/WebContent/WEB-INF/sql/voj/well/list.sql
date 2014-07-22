query:=

SELECT 
	bd_id,title,reg_dt,reg_nickname,file_id,reg_id,reg_ip,view_count,re_count,security,   
	CASE WHEN (disply_date < now()) THEN 'Y' ELSE 'N' END disply
FROM voj_board
WHERE bd_cat= 'well' 
	and notice = 'N'
	${session.myGroups['well'] ? '--' : '' } and disply_date < now()
	${empty(req.search_val) ? '--' : ''} and title like concat('%', @{search_val}, '%')
ORDER BY disply_date desc ;

cols:= 	base.*
;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;