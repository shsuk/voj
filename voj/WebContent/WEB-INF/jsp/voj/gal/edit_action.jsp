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
	<c:when test="${session.user_id=='guest'}">
	</c:when>
	<c:when test="${req.action=='d' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/gal/delete"/>
		]</uf:organism>
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='ut' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/gal/update_time"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='a' }">
		<uf:organism noException="true">[
			<uf:job id="rtn" jobId="attachFile"  defaultValues="{unZip:true}"/>
			<job:db id="row" query="voj/gal/attach_file_add" forEach="param.pic_file" var="pic" emptySkip="true"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='i' }">
		<uf:organism noException="true">[
			<uf:job id="rtn" jobId="attachFile" defaultValues="{unZip:true}"/>
			<job:db id="row" query="voj/gal/insert"/>
			<job:db id="row" query="voj/gal/attach_file_update" forEach="param.pic_file" var="pic" emptySkip="true"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='u' }">
		<tp:cookie name="save_nick" expiry="${24*60*30 }" value="${empty(req.save_nick) ? '' : req.reg_nickname }"/>
		<uf:organism noException="true">[
			<job:db id="row" query="voj/gal/update"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='act' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/gal/active"/>
		]</uf:organism>
	</c:when>
</c:choose>

<script type="text/javascript">
	document.location.href = 'at.sh?_ps=voj/gal/list&bd_cat=${req.bd_cat}&gal_id=${req.gal_id}&pageNo=${req.pageNo}';
</script>

	