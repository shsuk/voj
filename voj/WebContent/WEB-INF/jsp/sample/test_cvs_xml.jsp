<%@page import="net.ion.webapp.processor.ProcessorFactory"%><%@page import="net.ion.webapp.process.ReturnValue"%><%@page import="net.sf.json.JSONObject"%><%@ page contentType="text/javascript; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu" noException="true">
[
	<uf:job id="csv" jobId="fileRead"  >
		path: 'd:/temp/book2.csv',
		charset: 'utf-8'
	</uf:job>
	<uf:job id="xml" jobId="xml"  singleRow="false">
		src: 'd:/temp/test.xml',
		xpath:['/result/meta/author/text()','/result/meta/author/@val', '/result/meta/subj/text()', '/result/create/text()']
	</uf:job>
]
</uf:organism>${JSON }
