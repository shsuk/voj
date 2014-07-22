UPDATE voj_board
SET
	title = @{title},
	contents = @{ir1},
	bd_key = @{bd_key},
	notice = '${empty(req.notice) ? 'N' : 'Y'}',
	security = '${empty(req.security) ? 'N' : 'Y'}'
	
WHERE bd_id=@{bd_id} 
	and bd_cat = 'sch'
	and @{session.myGroups.sch}='true'
;
