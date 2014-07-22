/*
 {key:'cnt'}
 */
UPDATE voj_board
SET view_count = view_count + 1
WHERE bd_id= @{bd_id}
	and (security<>'Y' 
		or (reg_id='guest' and pw=@{pw})
		or (reg_id!='guest' and reg_id = @{session.user_id}) 
	)
;
/*
 {key:'row',singleRow="true"}
 */
SELECT t1.*, 
	(SELECT user_nm FROM st_user_info WHERE user_no = reg_id) user_nm
FROM voj_board t1
WHERE bd_id = @{bd_id}
	and (security<>'Y' 
		or (reg_id='guest' and pw=@{pw})
		or (reg_id!='guest' and reg_id = @{session.user_id}) 
		or '${session.myGroups['rev']}'='true' 
	)
;
/*
 {key:'prev',singleRow="true"}
 */
SELECT bd_id
FROM voj_board
WHERE bd_id = (SELECT max(bd_id) FROM voj_board WHERE bd_id < @{bd_id} and bd_cat = @{this.bd_cat} and notice <> 'Y')
;
/*
 {key:'next',singleRow="true"}
 */
SELECT bd_id
FROM voj_board
WHERE bd_id = (SELECT min(bd_id) FROM voj_board WHERE bd_id > @{bd_id} and bd_cat = @{this.bd_cat} and notice <> 'Y')
;
/*
 {key:'reprows'}
 */
SELECT t1.*, t2.nick_name, t2.user_nm
FROM voj_board_reply t1
INNER JOIN st_user_info t2 on t1.reg_id = t2.user_no 
WHERE bd_id= @{bd_id}
ORDER BY upper_rep_id, rep_id 
;
/*
 {key:'attrows'}
 */
SELECT *
FROM attach_tbl
WHERE REF_ID= @{bd_id}
;
