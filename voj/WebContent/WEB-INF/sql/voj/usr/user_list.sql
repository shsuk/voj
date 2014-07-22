query:=
/*
{
	id:'seller_user_list',	
	desc: '셀러의 사용자 목록' 
}
*/
SELECT 
	*
FROM st_user_info  
WHERE 1=1
	${empty(req.search_val) ? '--' : ''} and (user_id = @{search_val} or user_nm = @{search_val} or nick_name like concat('%', @{param.search_val}, '%')) 
	${empty(req.user_sts) ? '--' : ''} and user_status = @{user_sts}
ORDER BY user_status desc,user_group desc, user_nm;


cols:= base.*;

limit:=  ${listCount * ((empty(req.pageNo) ? pageNo : req.pageNo) - 1)} , ${listCount};

TEMPLATE:=system/oracle_simple_paging;