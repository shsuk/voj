SELECT 
	*
FROM voj_board
WHERE bd_cat= 'sch'
	and bd_key between @{start_date} and @{end_date}
ORDER BY bd_id ;

