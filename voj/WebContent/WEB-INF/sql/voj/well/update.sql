UPDATE voj_board
SET
	title = @{title},
	contents = @{ir1},
	disply_date = @{disply_date},
	bd_key = @{bd_key},
	notice = '${empty(req.notice) ? 'N' : 'Y'}',
	security = '${empty(req.security) ? 'N' : 'Y'}'
	
WHERE bd_id=@{bd_id} 
	and bd_cat = 'well'
	and @{session.myGroups.intro}='true'
;
