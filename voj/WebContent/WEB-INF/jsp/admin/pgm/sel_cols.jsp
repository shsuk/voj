<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu" 
	processInfo="[
	{
		id:'rset', jobId:'db', query:'${req._q }', isReturnColumInfo:true
	},{
		id:'rows', jobId:'db', query:'system/at/valid_list',defaultValues:{query_id:'${req._q }'}
	},{
		id:'colMap', jobId:'list2Map', src:'rows', key:'col_id'
	}
]"/>
<c:forEach var="rows" items="${rset.data }">
	<c:set var="meta" value="${rset.meta[rows.key]}"/>
	<div id="sel_flds_${rows.key }">
		<c:forEach var="attr" items="${meta}">
		 	<div class="button-l" style="cursor: pointer;" group="field_set" title="${code:lang(attr.name, 'kr', attr.name) }" val="${attr.name }">${attr.name },</div>
		</c:forEach>
	</div>
</c:forEach>