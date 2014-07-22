DELETE FROM attach_tbl
WHERE file_id = @{file_id} and gal_id = @{gal_id};

UPDATE voj_gallery
SET 
	file_id = (SELECT file_id FROM attach_tbl WHERE  rid = (SELECT min(rid) FROM attach_tbl WHERE  gal_id = @{gal_id}) )
WHERE gal_id = @{gal_id};

DELETE FROM voj_gallery
WHERE gal_id = @{gal_id}
	and (SELECT count(*) FROM attach_tbl WHERE  gal_id = @{gal_id} ) = 0
;
