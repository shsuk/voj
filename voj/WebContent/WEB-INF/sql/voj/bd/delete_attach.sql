DELETE FROM attach_tbl
WHERE file_id = @{file_id} and ref_id=@{bd_id} ;
