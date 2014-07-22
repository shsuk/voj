/*
 {key:'cnt'}
 */
UPDATE voj_vod
SET view_count = view_count + 1
WHERE vod_id= @{vod_id}
;
/*
 {key:'row',singleRow="true"}
 */
SELECT *
FROM voj_vod
WHERE vod_id= @{vod_id}
;
/*
 {key:'reprows'}
 */
SELECT t1.*, t2.nick_name
FROM voj_vod_reply t1
INNER JOIN st_user_info t2 on t1.reg_id = t2.user_no 
WHERE vod_id= @{vod_id}
ORDER BY rep_id desc
;
