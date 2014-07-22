/*
 {id:'row',singleRow:true}
 */
SELECT img_id, title, link_url, t2.file_id, :a a, :p1[1] p1
FROM voj_gallery t1
LEFT JOIN attach_tbl t2 ON t1.gal_id = t2.gal_id 
WHERE bd_cat='img' 
;
/*
 {id:'rows'}
 */

SELECT *
FROM (
	${list}
) base
;
/*
 {id:'list', subQuery:true}
 */
SELECT img_id, title, link_url, t2.file_id
FROM voj_gallery t1
LEFT JOIN attach_tbl t2 ON t1.gal_id = t2.gal_id 
WHERE bd_cat='img' 
;
update voj_gallery
set title = title;
