SELECT  ${cols}, @{listCount} listCount, @{pageNo} pageNo, tot_Count totCount
FROM (
	SELECT bas1.*
	FROM (
		SELECT org.*, rownum rnum, count(*) over() tot_Count 
		FROM (
			${query}
		) org
	) bas1
	WHERE rnum between @{listCount} * (@{pageNo} - 1) + 1 and @{pageNo} * @{listCount}
) base
${join_table}
ORDER BY rnum
