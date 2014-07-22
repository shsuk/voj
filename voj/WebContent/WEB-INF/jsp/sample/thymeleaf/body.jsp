<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="ui" uri="/WEB-INF/tlds/ui.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<ui:thymeleaf id="sample/thymeleaf/body">
	<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu" noException="true">
	[
		<uf:job id="prod" jobId="db" query="system/sample/code_view"  singleRow="true"/>
	]
	</uf:organism>
</ui:thymeleaf>
