
SELECT *
FROM voj_board
WHERE bd_cat= 'intro' 
	and (bd_key='${empty(param.id) ? "xxx" : param.id}' or bd_id=@{bd_id})
;