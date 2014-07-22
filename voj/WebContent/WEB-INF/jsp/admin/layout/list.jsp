<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu">
[
	<uf:job id="rows" jobId="db" query="system/menu/list" />
	<uf:job id="rows" jobId="list2Tree">
		data: 'rows',
		singleKey: true,
		upperIdField: 'upper_rid',
		idField: 'rid',
		title: 'menu_name',
		rootId: '1000'
	</uf:job>
]
</uf:organism>

<c:set var="target" scope="request" value="menu_tree"/>
<script type="text/javascript">


</script>

<div>
	<table style="width: 100%;">
		<tr>
			<td style="width: 300px;vertical-align: top;">
					<c:set var="_q" scope="request" value="system/sample/lang_list"/>
					<c:set var="_t" scope="request" value="list"/>
					<jsp:include page="../../at/at.jsp"/>
			</td>
			<td id="menu_form" style="vertical-align: top;">
			</td>
		</tr>
	</table>
</div>

