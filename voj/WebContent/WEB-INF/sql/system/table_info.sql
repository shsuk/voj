SELECT
	2 AS object_level, 
	table_name,
	column_name AS column_id, 
	column_name AS column_name,
	data_type,
	data_length AS length,
	'' AS is_nullable,
	'' AS is_identity,
	'' AS cmt
FROM user_tab_columns tb
