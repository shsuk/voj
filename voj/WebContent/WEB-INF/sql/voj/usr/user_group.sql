/*
{
	id:'st_user_info_edit',	
	singleRow:true,
	read_only:'user_no',
	desc:'일반회원 가입, 수정 페이지'
}
*/
SELECT 
	*
FROM st_user_info
WHERE user_no = @{user_no};