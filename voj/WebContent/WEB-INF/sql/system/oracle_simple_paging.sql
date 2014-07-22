SELECT SQL_CALC_FOUND_ROWS ${cols}, @{listCount} listCount, @{pageNo} pageNo
FROM (
	${query}
) base
LIMIT ${limit};