SELECT img_id, title, link_url, t2.file_id
FROM voj_gallery t1
LEFT JOIN attach_tbl t2 ON t1.gal_id = t2.gal_id 
WHERE bd_cat='img' 
	and active='Y'
	and start_date < now()
	and end_date > DATE_SUB(now(),INTERVAL 1 DAY) 
	and img_id = @{img_id}
;
