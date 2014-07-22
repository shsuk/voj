<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="f" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<div data-role="controlgroup" data-type="horizontal" data-mini="true" style="text-align: center;">
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
			데이타가 없습니다.
		</c:if>
	</c:when>
	<c:otherwise><!-- 데이타가 있는 경우 -->
		<c:set var="nevCount" value="5"/>
		<c:set var="pageNo" value="${f:parseInt(info.pageno) }"/>
		<c:set var="listCount" value="${f:parseInt(info.listcount) }"/>
		<c:set var="totCount" value="${f:parseInt(info.totcount) }"/>
		<c:set var="totPage" value="${f:round(f:ceil(totCount/listCount))}"/>
		<c:set var="startPage" value="${f:double2long(f:ceil(pageNo/nevCount)-1)*nevCount+1}"/>
		<c:set var="endPage" value="${startPage + nevCount-1 }"/>
		<c:set var="endPage" value="${endPage > totPage ? totPage : endPage }"/>
		<!-- 이전 페이지 -->
		<c:choose>
			<c:when test="${startPage == 1}">
				<a href="#" data-role="button" data-iconpos="notext" data-icon="arrow-l" data-theme="b" class="ui-disabled">이전</a>
			</c:when>
			<c:otherwise>
				<a href="javascript:goPage(${startPage-1})" data-role="button" data-iconpos="notext" data-icon="arrow-l" data-theme="b">이전</a>
			</c:otherwise>
		</c:choose>
		<!-- 페이지 네비게이션 -->
		<c:forEach var="page" begin="${startPage}" end="${endPage}" step="1" varStatus="status">
			<c:choose>
				<c:when test="${page!=pageNo}"><a href="javascript:goPage(${page})" data-role="button"  data-theme="b">${page }</a></c:when>
				<c:otherwise><a href="#" data-role="button" class="ui-disabled">${page }</a></c:otherwise>
			</c:choose>
		</c:forEach>
		<!-- 다음 페이지 -->
		<c:choose>
			<c:when test="${endPage<totPage}">
				<a href="javascript:goPage(${endPage+1})" data-role="button" data-iconpos="notext" data-icon="arrow-r" data-theme="b">다음</a>
			</c:when>
			<c:otherwise>
				<a href="#" data-role="button" data-iconpos="notext" data-icon="arrow-r" data-theme="b" class="ui-disabled">다음</a>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
</div>