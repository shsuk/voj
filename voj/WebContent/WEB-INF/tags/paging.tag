<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="totCount" type="java.lang.Integer" required="true" description="전체 레코드수"%>
<%@ attribute name="pageNo" type="java.lang.Integer" required="true" description="조회한 현재 페이지"%>
<%@ attribute name="listCount" type="java.lang.Integer" required="true" description="페이지에 표시될 레코드의 갯수"%>
<%@ attribute name="functionName" type="java.lang.Integer" description="네비게이션 클릭시 호출할 함수명 (기본값:goPage(pageNo))"%>
<%@ attribute name="loadingLayerSelector" type="java.lang.String" description="페이지를 읽어 출력할 레이어의 셀렉터"%>
<div class="page_nevi" style="text-align: center;">
<c:choose>
	<c:when test="${totCount==null}">
			
	</c:when>
	<c:otherwise><!-- 데이타가 있는 경우 -->
		<c:set var="functionName" value="${empty(functionName) ? 'goPage' : functionName}"/>
		<c:set var="nevSize" value="${isMobile ? 5 : 10}"/>
		<c:set var="pageNo" value="${pageNo==0 ? 1 : pageNo}"/>
		<c:set var="totPage" value="${uf:round(uf:ceil(totCount/listCount))}"/>
		<c:set var="startPage" value="${uf:double2long(uf:ceil(pageNo/nevSize)-1)*nevSize+1}"/>
		<c:set var="endPage" value="${startPage + nevSize-1 }"/>
		<c:set var="endPage" value="${endPage > totPage ? totPage : endPage }"/>
		<!-- 이전 페이지 -->
		<c:choose>
			<c:when test="${startPage == 1}">
				<img src="images/btn_prev.gif" alt="이전" />&nbsp;
			</c:when>
			<c:otherwise>
				<a href="javascript:${empty(functionName) ? 'goPage' : functionName}(${startPage-1},'${loadingLayerSelector}')" style="cursor:pointer;" ><img src="images/btn_prev.gif" alt="이전" /></a>
			</c:otherwise>
		</c:choose>
		<!-- 페이지 네비게이션 -->
		<c:forEach var="page" begin="${startPage}" end="${endPage}" step="1" varStatus="status">
			<c:choose>
				<c:when test="${page!=pageNo}"><a href="javascript:${empty(functionName) ? 'goPage' : functionName}(${page},'${loadingLayerSelector}')">${page }</a></c:when>
				<c:otherwise>[${page }]</c:otherwise>
			</c:choose>${status.last ? "" : "."}
		</c:forEach>
		<!-- 다음 페이지 -->&nbsp;
		<c:choose>
			<c:when test="${endPage<totPage}">
				<a href="javascript:${empty(functionName) ? 'goPage' : functionName}(${endPage+1},'${loadingLayerSelector}')" style="cursor:pointer;"><img src="images/btn_next.gif" alt="다음" /></a>
			</c:when>
			<c:otherwise>
				<img src="images/btn_next.gif" alt="다음" />
			</c:otherwise>
		</c:choose>
		(${totCount }건)
	</c:otherwise>
</c:choose>
</div>