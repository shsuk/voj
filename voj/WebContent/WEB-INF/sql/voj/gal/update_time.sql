UPDATE attach_tbl
SET 
	start_date = @{start_date},
	end_date = @{end_date}
WHERE file_id = @{file_id} ;

