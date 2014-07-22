
SELECT *
FROM voj_board
WHERE  bd_cat= 'intro' 
	and (bd_id= @{bd_id}  or bd_key = '${empty(param.bd_key) ? "xxx" : param.bd_key}')
	
;
