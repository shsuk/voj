<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<c:choose >
	<c:when test="${req.action=='i' && session.user_id!='guest'}">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/sch/insert_rep"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='d' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/sch/delete_rep"/>
		]</uf:organism>	
	</c:when>
</c:choose>

<uf:organism >
[
	<job:db id="row" query="voj/sch/view"  singleRow="true"/>
]
</uf:organism>

<script type="text/javascript">
	
	$(function() {
		<c:if test="${empty(row)}">
			alert('존재하지 않는 글이거나 패스워드가 불일치 합니다.');
			goPage(${req.pageNo});
			return;
		</c:if>
	    init_load();
	    
	});
	
</script>

<div  id="body_main">
	<br><br>

	<div style="width:100%;height:30px;">
		<div style="float:left;font-size: 20px;font-weight: bold;">홈페이지 내용관리</div>
	</div>
	
	<table style="width:100%; clear:both;border:1px solid #B6B5DB; padding: 5px;margin-bottom: 5px;"><tr><td>
		<div style="float:left;"><b>제목 : <font color="#0000C9">${row.title }</font></b></div>
	</td></tr></table>
	<%//본문 %>
	<div style="width:100%;clear:both;border:1px solid #B6B5DB;min-height: 300px;margin-bottom: 5px;overflow: auto;">
		<div style="padding: 5px;">${row['CONTENTS@dec'] }</div>
	</div>
	<%//버튼 %>
	<a style="float:right;margin-left: 5px;" class="cc_bt" href="#" onclick="goPage(${req.pageNo})">목 록</a>
	<c:if test="${session.myGroups['sch']}">
		<a style="float:right;margin-left: 5px;" class="cc_bt"  href="#" onclick="edit(${req.bd_id})" style="margin-right: 10px;">수 정</a>
		<a style="float:right;margin-left: 5px;" class="cc_bt" href="#" onclick="del(${req.bd_id })" style="margin-right: 10px;">삭 제</a>
	</c:if>
	<br><br>

</div>
	