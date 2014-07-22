/*{
	id:'attach_tbl',img:'file_id',
	params_update:{_ps:'',_q:'test/insert'},
	params_insert:{_ps:'',_q:'test/insert'}
}*/
SELECT top 10 file_id,file_class,file_name 
FROM attach_tbl
WHERE file_ext = 'jpg' and file_class = ''
ORDER BY rid desc ;