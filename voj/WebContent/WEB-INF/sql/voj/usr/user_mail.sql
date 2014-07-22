
SELECT *
FROM voj_board
WHERE bd_cat= 'intro' 
	and (bd_key = @{bd_key})
;