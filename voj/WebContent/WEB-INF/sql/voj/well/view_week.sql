
SELECT *
FROM voj_board
WHERE bd_cat= @{bd_cat}
	${empty(param.bd_id) ? '--' : ''} and bd_id = @{bd_id} 
	${empty(param.bd_id) ? '' : '--'} and disply_date < now()
ORDER BY disply_date desc
LIMIT 0,1
;