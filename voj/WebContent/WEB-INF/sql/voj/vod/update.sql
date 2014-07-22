UPDATE voj_vod
SET
	title = @{title},
	${empty(param.file_id) ? '--' : ''} file_id = @{file_id},
	contents_id = @{contents_id},
	preacher = @{preacher},
	wk_dt = @{wk_dt},
	bible = @{bible},
	contents = @{ir1}
WHERE vod_id=@{vod_id} 
	and '${session.myGroups[req.bd_cat]}'='true' 	
;

${empty(param.file_id) ? '--' : ''} UPDATE attach_tbl SET REF_TBL = 'VOJ_VOD', REF_ID = LAST_INSERT_ID() WHERE file_id = @{file_id} and '${session.myGroups[req.bd_cat]}'='true' ;