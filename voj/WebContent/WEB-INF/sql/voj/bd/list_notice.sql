SELECT 
	bd_id,title,reg_dt,reg_id,reg_ip,view_count,re_count
FROM voj_board
WHERE bd_cat= @{bd_cat} and notice = 'Y'
ORDER BY bd_id desc
limit 0,2;