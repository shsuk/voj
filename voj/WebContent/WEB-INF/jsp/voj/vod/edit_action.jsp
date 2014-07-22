<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 

<c:choose >
	<c:when test="${!session.myGroups[req.bd_cat] }">
	</c:when>
	<c:when test="${req.action=='d' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/vod/delete"/>
		]</uf:organism>
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='i' }">
		<uf:organism noException="true">[
			<uf:job id="rtn" jobId="attachFile"/>
			<job:db id="row" query="voj/vod/insert"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='u' }">
		<uf:organism noException="true">[
			<uf:job id="rtn" jobId="attachFile"/>
			<job:db id="row" query="voj/vod/update"/>
		]</uf:organism>
	</c:when>
</c:choose>

<script type="text/javascript">
	document.location.href = 'at.sh?_ps=voj/vod/list&bd_cat=${req.bd_cat}&vod_id=${req.vod_id}&pageNo=${req.pageNo}';
</script>

	