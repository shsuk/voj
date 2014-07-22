/*
 {key:'cnt',singleRow="true"}
 */
UPDATE voj_gallery
SET view_count = view_count+1
WHERE gal_id= @{gal_id};
/*
 {key:'row',singleRow="true"}
 */
SELECT *
FROM voj_gallery
WHERE gal_id= @{gal_id} 
;
/*
 {key:'prev',singleRow="true"}
 */
SELECT gal_id
FROM voj_gallery
WHERE gal_id = (SELECT max(gal_id) FROM voj_gallery WHERE gal_id < @{gal_id} and bd_cat = @{this.bd_cat})
;
/*
 {key:'next',singleRow="true"}
 */
SELECT gal_id
FROM voj_gallery
WHERE gal_id = (SELECT min(gal_id) FROM voj_gallery WHERE gal_id > @{gal_id} and bd_cat = @{this.bd_cat})
;
/*
 {key:'rows'}
 */
SELECT *
FROM attach_tbl
WHERE gal_id= @{gal_id}
ORDER BY end_date desc, rid
;
/*
 {key:'reprows'}
 */
SELECT t1.*, t2.nick_name, t2.user_nm
FROM voj_gallery_reply t1
INNER JOIN st_user_info t2 on t1.reg_id = t2.user_no 
WHERE gal_id= @{gal_id}
ORDER BY gal_rep_id desc
;
