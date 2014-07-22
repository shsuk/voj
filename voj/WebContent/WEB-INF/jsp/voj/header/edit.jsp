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
	<c:when test="${req.action=='i' }">
		<c:set var="JSON" scope="request" value="{\"success\":false,\"error_message\":\"다시 작성하세요.\"}"/>
			<uf:organism noException="true">[
				<job:db id="row" query="voj/header/insert"/>
			]</uf:organism>
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='u' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/header/update"/>
		]</uf:organism>
	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
</c:choose>

<uf:organism >
[
	<job:db id="row" query="voj/header/edit" singleRow="true"/>
]
</uf:organism>

<script type="text/javascript">

	$(function() {
	    init_load();
	});


	
</script>

<div  id="body_main">
	<br><br>
	<div style="width:100%;height:30px;">
		<div style="float:left;font-size: 20px;font-weight: bold;">게 시 판</div>
		<a class="cc_bt" style="float:right;" href="#" onclick="goPage(${req.pageNo})">목 록</a>
	</div>
	
	<form id="content_form" action="sample.php" method="post" style="clear: both;">
		<input type="hidden" name="action" value="${empty(req.id) ? 'i' : 'u' }">
		<input type="hidden" name="_ps" value="${req._ps }">
		<input type="hidden" name="bd_cat" value="${row.bd_cat }">
		<input type="hidden" name="id" value="${req.id }">
		<table style="width: 100%;border:1px solid #B6B5DB;color:#002266;margin-bottom: 5px;">
			<tr>
				<th width="55">제목:</th>
				<td><input type="text" name="title" id="title" title="제목" style="width: 95%;" value="${row.title }" valid="[['notempty'],['maxlen:50']]"></td>
			</tr>
		</table>
		
		<textarea name="header" id="header" title="내용" rows="10" cols="100" style="width:100%; height:212px; " valid="[['notempty'],['maxlen:10000']]">${row.header_start}</textarea>
		
	</form>
	<p>

	<table style="width: 100%">
		<tr>
			<td width="250"></td>
			<td></td>
			<td width="250">
				<a href="#" class="cc_bt" onclick="goPage(${req.pageNo})" style="float: right;margin-left: 10px;">목 록</a>
				<a href="#" class="cc_bt" onclick="form_submit();" style="float: right;">저 장</a>
			</td>
		</tr>
	</table>
	
	<div id="_contemts" style="display: none;">${row['CONTENTS@dec'] }</div>
	
</div>
	