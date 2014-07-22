<%@ page contentType="text/html; charset=utf-8"%>
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
			<job:db id="row" query="voj/gal/insert_rep"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='d' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/gal/delete_rep"/>
		]</uf:organism>	
	</c:when>
</c:choose>

<uf:organism >
[
	<job:requestEnc id="reuestEnc" aes256="pw" />
	<job:db id="rset" query="voj/gal/view" />
]
</uf:organism>
<c:set var="row" value="${rset.row }"/>

<script>
	$(function() {

		changeEmoticon();
	});
	
</script>

<a style="float:right;margin" href="#" onclick="$('#rep_list').hide()"><img src="images/icon/Close-2-icon.png"></a>
	<%//댓글 작성 %>
<c:if test="${session.user_id=='guest' }">
	<table style="width: 100%;;clear:both; margin-bottom: 5px;">
		<tr>
			<td width="60" align="right"><a href="at.sh?_ps=voj/login/login_form">로그인</a> 후 글을 작성하세요.</td>
		</tr>
	</table>
	<hr color="#cccccc" />
</c:if>

<form id="reply_form" action="sample.php" method="post" style=" ${session.user_id=='guest' ? 'display:none;' : ''}">
	<input type="hidden" name="_ps" value="${req._ps }">
	<input type="hidden" name="gal_id" value="${req.gal_id }">
	<input type="hidden" name="action" value="i">
	<input type="hidden" name="_layout" value="n">
	<table style="width: 100%;border:1px solid #B6B5DB;clear:both; margin-bottom: 5px;">
		<tr>
			<td>
				<tp:emoticon/>
				<input type="text" name="rep_text" id="rep_text" title="이곳에 글을 입력하여 주세요." style="width: 99%;" value="" valid="[['notempty'],['maxlen:300']]">
			</td>
			<td width="60"><a style="float:right;margin-left: 5px;" class="cc_bt"  href="#" onclick="save_reply()" style="margin-right: 10px;">저 장</a></td>
		</tr>
	</table>
</form>


<%//답글목록 %>
<table class="rep" style="width: 100%"  cellpadding="0" cellspacing="0"  border="0">
	<c:forEach var="row" items="${rset.reprows }">
			<tr >
				<td width="80" ><b>${row.nick_name }:</b></td>
				<td class="rep_cont">
					<c:if test="${!fn:endsWith(row.rep_text, 'png') }">
						${row.rep_text }
					</c:if>
					<c:if test="${fn:endsWith(row.rep_text, 'png') }">
						<img class="emoticon" height="28" src="voj/images/re/${row.rep_text }">
					</c:if>
				</td>
				<td width="20">
					<c:if test="${session.user_id==row.reg_id || session.myGroups[row.bd_cat]}">
						<a style="float:right;margin-left: 5px;" href="#" onclick="del_reply(${req.gal_id }, ${row.gal_rep_id })" style="margin-right: 10px;"><img title="삭제" src="images/icon/${session.user_id==row.reg_id ? 'Close-icon.png' : 'Actions-window-close-icon.png'}"></a>
					</c:if>
				</td>
			</tr>
		
	</c:forEach>
</table>

