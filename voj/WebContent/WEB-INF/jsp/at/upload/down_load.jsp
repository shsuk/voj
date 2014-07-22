<%@ page contentType="text/html; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="f" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><uf:organism>
[
	{
		id:'row', jobId:'download', fid:'${uf:orgFileId(req.file_id,session.user_id) }'
	}
]
</uf:organism>