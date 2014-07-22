query:=

SELECT 
	bd_id,title,reg_dt,reg_nickname,reg_id,reg_ip,view_count,re_count,security,bd_key,bd_cat
FROM voj_board
WHERE bd_cat= @{bd_cat} and notice = 'N' 
	${empty(req.bd_key) ? '--' : ''} and bd_key = @{bd_key}
	${empty(req.search_val) ? '--' : ''} and title like concat('%', @{search_val}, '%')
	${req.bd_cat!='ser' || session.myGroups['ser'] ? '--' : '' } and (disply_date < now() or disply_date is null)
ORDER BY bd_id desc ;

cols:= 	base.*, 
		reg_dt > DATE_SUB(now(),INTERVAL 1 DAY) new_item,
		(SELECT count(*) FROM attach_tbl WHERE REF_ID = bd_id) file_id,
		(SELECT user_nm FROM st_user_info WHERE user_no = reg_id) user_nm,
		(SELECT count(*) FROM voj_board_reply x1 WHERE x1.bd_id= base.bd_id) re_count,
		(SELECT count(*) FROM voj_board_reply x1 WHERE x1.bd_id= base.bd_id and x1.reg_dt > DATE_SUB(now(),INTERVAL 1 DAY)) re_new
;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;