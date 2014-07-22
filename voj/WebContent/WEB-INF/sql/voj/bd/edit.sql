/*
 {key:'row',singleRow="true"}
 */
SELECT *
FROM voj_board
WHERE bd_id= @{bd_id}
	and (
		(reg_id='guest' and pw=@{pw})
		or (reg_id!='guest' and reg_id = @{session.user_id}) 
	) 
;
/*
 {key:'attrows'}
 */
SELECT *
FROM attach_tbl
WHERE REF_ID= @{bd_id}
;