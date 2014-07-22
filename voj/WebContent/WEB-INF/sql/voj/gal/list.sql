query:=
SELECT t1.*,t2.file_ext
FROM voj_gallery t1 
LEFT JOIN attach_tbl t2 ON t1.file_id = t2.file_id
WHERE bd_cat= @{bd_cat} 
${empty(req.search_val) ? '--' : ''} and title like concat('%', @{search_val}, '%') 
ORDER BY gal_id desc ;

cols:= 	base.*, 
		reg_dt > DATE_SUB(now(),INTERVAL 1 DAY) new_item,
		(SELECT user_nm FROM st_user_info WHERE user_no = reg_id) user_nm,
		(SELECT count(*) FROM voj_gallery_reply x1 WHERE x1.gal_id= base.gal_id) re_count,
		(SELECT count(*) FROM voj_gallery_reply x1 WHERE x1.gal_id= base.gal_id and x1.reg_dt > DATE_SUB(now(),INTERVAL 1 DAY)) re_new
;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;