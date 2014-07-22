
SELECT 
	*
FROM voj_board
WHERE bd_cat= 'sch'
	and bd_key >= @{start_date}
ORDER BY bd_key
LIMIT 0, ${listCount};

