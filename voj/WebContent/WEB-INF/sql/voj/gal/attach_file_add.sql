UPDATE attach_tbl
SET 
	REF_TBL = 'VOJ_GALLERY',
	${empty(req.start_date) ? '--' : ''}start_date = @{start_date},
	${empty(req.end_date) ? '--' : ''}end_date = @{end_date},
	GAL_ID = @{gal_id}
WHERE file_id = @{pic.pic_file} ;

UPDATE voj_gallery
SET 
	file_id = (SELECT file_id FROM attach_tbl WHERE  rid = (SELECT case when  bd_cat = 'img' then max(rid) else min(rid) end FROM attach_tbl WHERE  gal_id = @{gal_id}) )
WHERE GAL_ID = @{gal_id};