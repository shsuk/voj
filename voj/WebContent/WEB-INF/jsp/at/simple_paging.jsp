<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="f" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<div class="page_nevi" style="text-align: center;">
<script type="text/javascript">
$(function() {
	goPage_formName = '${_q}.${pageInfo}';
});
</script>
<c:set var="infoRows" value="${result.rset.data[pageInfo]}" />
<c:if test="${infoRows != null}">
	<c:set var="info" value="${infoRows[0] }"/>
</c:if>
<c:choose>
	<c:when test="${info==null}"><!-- 데이타가 없는 경우 -->
		데이타가 없습니다.
	</c:when>
	<c:when test="${info.totcount==null || info.totcount==0}">
		<c:if test="${hss_row==''}">
			<script type="text/javascript">
				$('.contents-list tr:last').remove();
			</script>
			데이타가 없습니다.
		</c:if>
	</c:when>
	<c:otherwise><!-- 데이타가 있는 경우 -->
		<c:set var="pageNo" value="${f:parseInt(info.pageno) }"/>
		<c:set var="listCount" value="${f:parseInt(info.listcount) }"/>
		<c:set var="totCount" value="${f:parseInt(info.totcount) }"/>
		<c:set var="totPage" value="${f:round(f:ceil(totCount/listCount))}"/>
		<c:set var="startPage" value="${f:double2long(f:ceil(pageNo/10)-1)*10+1}"/>
		<c:set var="endPage" value="${startPage + 9 }"/>
		<c:set var="endPage" value="${endPage > totPage ? totPage : endPage }"/>
		<!-- 이전 페이지 -->
		<c:choose>
			<c:when test="${startPage == 1}">
				<img src="images/btn_prev.gif" alt="이전" />&nbsp;
			</c:when>
			<c:otherwise>
				<a href="javascript:goPage(${startPage-1},'${_q}.${pageInfo}')" style="cursor:pointer;" ><img src="images/btn_prev.gif" alt="이전" /></a>
			</c:otherwise>
		</c:choose>
		<!-- 페이지 네비게이션 -->
		<c:forEach var="page" begin="${startPage}" end="${endPage}" step="1" varStatus="status">
			<c:choose>
				<c:when test="${page!=pageNo}"><a href="javascript:goPage(${page},'${_q}.${pageInfo}')">${page }</a></c:when>
				<c:otherwise>[${page }]</c:otherwise>
			</c:choose>${status.last ? "" : "."}
		</c:forEach>
		<!-- 다음 페이지 -->&nbsp;
		<c:choose>
			<c:when test="${endPage<totPage}">
				<a href="javascript:goPage(${endPage+1},'${_q}.${pageInfo}')" style="cursor:pointer;"><img src="images/btn_next.gif" alt="다음" /></a>
			</c:when>
			<c:otherwise>
				<img src="images/btn_next.gif" alt="다음" />
			</c:otherwise>
		</c:choose>
		(${info.totcount }건)
	</c:otherwise>
</c:choose>
</div>