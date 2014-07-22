/*
 {
 	id:'cnt',
 	action:'u',
 	singleRow:true
 }
 */
update voj_gallery
set view_count = view_count + 1;
/*
 {
 	id:'row',
 	action:'i',
 	singleRow:true
 }
 */
SELECT *
FROM voj_gallery t1
LEFT JOIN attach_tbl t2 ON t1.gal_id = t2.gal_id 
WHERE bd_cat='img' 
;
/*
 {
 	id:'rows'
 }
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
