SELECT *, volume || file_path path
FROM attach_tbl
WHERE file_id = @{file_id};