<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism noException="true" token="true" tokenName="${req._params_insert }:${req._params_update }.${req._params_delete }" useTrigger="true" >
[
	<uf:job id="rset" jobId="db" ds="${req._ds==null || req._ds=='' ? '' : req._ds }" query="${req._q }" />
]
</uf:organism>
${JSON}