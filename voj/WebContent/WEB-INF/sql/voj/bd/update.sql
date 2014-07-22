UPDATE voj_board
SET
	title = @{title},
	${empty(param.file_id) ? '--' : ''} file_id = @{file_id},
	contents = @{ir1},
	${empty(req.disply_date) ? '--' : ''} disply_date = @{disply_date},
	notice = '${empty(req.notice) ? 'N' : 'Y'}',
	security = '${empty(req.security) ? 'N' : 'Y'}'
	
WHERE bd_id=@{bd_id} 
	and (reg_id!='guest' and reg_id=@{session.user_id} or pw=@{pw})	
;

${empty(param.file_id) ? '--' : ''} UPDATE attach_tbl SET REF_TBL = 'VOJ_BOARD', REF_ID = @{bd_id} WHERE file_id = @{file_id};