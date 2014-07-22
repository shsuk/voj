UPDATE voj_board_header
SET
	bd_cat = @{bd_cat},
	title = @{title},
	header = @{header}
WHERE id = @{id};