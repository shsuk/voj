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
			<job:db id="row" query="voj/vod/insert_rep"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='d' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/vod/delete_rep"/>
		]</uf:organism>	
	</c:when>
</c:choose>

<uf:organism >
[
	<job:db id="rset" query="voj/vod/view" />
]
</uf:organism>
<c:set var="row" value="${rset.row }"/>
<script type="text/javascript">
	
	$(function() {
	    init_load();
	});
	
</script>

<div  id="body_main">
	
	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		${HEADER }
	</div>

	<div class="bd_body">
		
		<table style="width:100%; clear:both;border:1px solid #B6B5DB; padding: 5px;margin-bottom: 5px;"><tr><td>
			<div style="float:left;"><b>제목 : <font color="#0000C9">${row.title }</font></b></div>
		</td></tr></table>
		<%//본문 %>
		<div style="width:100%;clear:both;border:1px solid #B6B5DB;min-height: 300px;margin-bottom: 5px; overflow: auto;">
			<table style="width:100%;">
				<tr><td width="${isMobile ? '100%' : '560'}">
					<iframe width="${isMobile ? '100%' : '560'}" ${isMobile ? '' : 'height="315"'} frameborder="0" allowfullscreen="" mozallowfullscreen="" webkitallowfullscreen="" src="http://player.vimeo.com/video/${row.contents_id }?title=0&byline=0&portrait=0"></iframe>
				</td>
				<c:if test="${isMobile}">
					</tr><tr>
				</c:if>
				<td valign="top">
					<table  class="bd" style="margin: 5px;width: 98%; ">
						<c:if test="${row.bd_cat=='sun' }">
							<tr><td width="80"><b>제목</b></td><td>${row.title }</td></tr>
							<tr><td width="80"><b>설교자</b></td><td>${row.preacher }</td></tr>
							<tr><td><b>설교일</b></td><td>${row['wk_dt@yyyy-MM-dd'] }</td></tr>
							<tr><td><b>성경본문</b></td><td>${row.bible }</td></tr>
						</c:if>
						<c:if test="${row.bd_cat!='sun' }">
							<tr><td><b>날짜</b></td><td>${row['wk_dt@yyyy-MM-dd'] }</td></tr>
							<tr><td colspan="2" valign="top" style="border:0;">${row.CONTENTS}</td></tr>
						</c:if>
					</table>
				</td></tr>
			</table>
		</div>
		<%//답글 작성 %>
		<c:if test="${session.user_id=='guest' }">
			<table style="width: 100%;;clear:both; margin-bottom: 5px;">
				<tr>
					<td width="60" align="right"><a href="at.sh?_ps=voj/login/login_form">로그인</a> 후 글을 작성하세요.</td>
				</tr>
			</table>
			<hr color="#0000ff" size="1" />
		</c:if>
		<c:if test="${session.user_id!='guest' }">
			<form id="reply_form" action="sample.php" method="post">
				<input type="hidden" name="_ps" value="${req._ps }">
				<input type="hidden" name="vod_id" value="${req.vod_id }">
				<input type="hidden" name="action" value="i">
				<table style="width: 100%;border:1px solid #B6B5DB;clear:both; margin-bottom: 5px;">
					<tr>
						<td><input type="text" name="rep_text" id="rep_text" title="이곳에 글을 입력하여 주세요." style="width: 99%;" value="" valid="[['notempty'],['maxlen:300']]"></td>
						<td width="60"><a style="float:right;margin-left: 5px;" class="cc_bt"  href="#" onclick="save_reply()" style="margin-right: 10px;">등 록</a></td>
					</tr>
				</table>
			</form>
		</c:if>
		
		<%//답글목록 %>
		<c:forEach var="item" items="${rset.reprows }">
			<table style="width: 100%;">
				<tr>
					<td width="80" ><b>${item.nick_name }:</b></td>
					<td>${item.rep_text }</td>
					<td width="20">
						<c:if test="${session.user_id==item.reg_id || session.myGroups[item.bd_cat]}">
							<a style="float:right;margin-left: 5px;" href="#" onclick="del_reply(${req.vod_id },${item.rep_id})" style="margin-right: 10px;"><img title="삭제" src="images/icon/${session.user_id==item.reg_id ? 'Close-icon.png' : 'Actions-window-close-icon.png'}"></a>
						</c:if>
					</td>
				</tr>
			</table>
			<hr color="#cccccc" />
		</c:forEach>
		<%//버튼 %>
		<a style="float:right;margin-left: 5px;" class="cc_bt" href="#" onclick="goPage(${req.pageNo})">목 록</a>
		<c:if test="${viewAdminButton && session.myGroups[row.bd_cat] }">
			<a style="float:right;margin-left: 5px;" class="cc_bt"  href="#" onclick="edit(${req.vod_id},${row.reg_id=='guest' })" style="margin-right: 10px;">수 정</a>
	
			<a style="float:right;margin-left: 5px;" class="cc_bt" href="#" onclick="del(${req.vod_id },${row.reg_id=='guest' })" style="margin-right: 10px;">삭 제</a>
		</c:if>
		<br><br>
	</div>
</div>
	