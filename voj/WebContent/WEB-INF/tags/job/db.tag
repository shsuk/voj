<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="리턴받을 변수명"%>
<%@ attribute name="query" type="java.lang.String" required="true" description="쿼리소스 경로"%>
<%@ attribute name="ds" type="java.lang.String" description="데이타 소스 아이디, context 파일에 설정된 아이디를 기본값으로 처리한다."%>
<%@ attribute name="singleRow" type="java.lang.Boolean" description="단일레코드 반환 여부"%>
<%@ attribute name="isCache" type="java.lang.Boolean" description="조회결과 캐쉬 여부 설정"%>
<%@ attribute name="refreshTime" type="java.lang.Integer" description="캐쉬 갱신주기 (단위 분)"%>
<%@ attribute name="isReturnColumInfo" type="java.lang.Boolean" description="컬럼정보를 같이 반환한다."%>

<%@ attribute name="isReturn" type="java.lang.Boolean" description="처리결과를 JSON결과로 반환한다."%>
<%@ attribute name="forEach" type="java.lang.String" description="for문을 돌릴 배열 객체명"%>
<%@ attribute name="var" type="java.lang.String" description="for문에서 반환하는 객체를 받을 변수명"%>
<%@ attribute name="emptySkip" type="java.lang.Boolean" description="for문실행시 empty이면 처리를 스킵한다."%>
<%@ attribute name="defaultValues" type="java.lang.String" description="기본으로 설정할 값"%>
<%@ attribute name="desc" type="java.lang.String" description="설명"%>
{
	jobId: 'db',
	id: '${id}',
	query: '${query}',
	<c:if test="${!empty(ds)}">ds: '${ds}', </c:if>
	<c:if test="${!empty(singleRow)}">singleRow: ${singleRow}, </c:if>
	<c:if test="${!empty(isCache)}">isCache: ${isCache}, </c:if>
	<c:if test="${!empty(refreshTime)}">refreshTime: ${refreshTime}, </c:if>
	<c:if test="${!empty(isReturnColumInfo)}">isReturnColumInfo: ${isReturnColumInfo}, </c:if>
	
	<c:if test="${!empty(isReturn)}">isReturn: ${isReturn}, </c:if>
	<c:if test="${!empty(forEach)}">forEach: '${forEach}', </c:if>
	<c:if test="${!empty(var)}">var: '${var}', </c:if>
	<c:if test="${!empty(emptySkip)}">emptySkip: ${emptySkip}, </c:if>
	<c:if test="${!empty(defaultValues)}">defaultValues: ${defaultValues}</c:if>
	<c:if test="${empty(defaultValues)}"><jsp:doBody/></c:if>
},