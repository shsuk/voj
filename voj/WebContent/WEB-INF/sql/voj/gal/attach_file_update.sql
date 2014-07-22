UPDATE attach_tbl
SET 
	REF_TBL = 'VOJ_GALLERY',
	${empty(req.start_date) ? '--' : ''}start_date = @{start_date},
	${empty(req.end_date) ? '--' : ''}end_date = @{end_date},
	GAL_ID = LAST_INSERT_ID()
WHERE file_id = @{pic.pic_file};

UPDATE voj_gallery
SET 
	file_id = (SELECT file_id FROM attach_tbl WHERE  rid = (SELECT min(rid) FROM attach_tbl WHERE  gal_id = LAST_INSERT_ID()))
WHERE GAL_ID = LAST_INSERT_ID();