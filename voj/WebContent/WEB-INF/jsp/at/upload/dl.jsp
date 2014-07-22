<%@ page contentType="text/html; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="f" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu">
[
	{
		id:'row', jobId:'download', fid:'@{file_id}', desc:"path:'http:@{f1}' 웹 or 'rep:@{f1}' 저장소 or path:'@{f1}' 전체경로"
	}
]
</uf:organism>