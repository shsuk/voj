<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="리턴받을 변수명"%>
<%@ attribute name="aes256" type="java.lang.String" description="aes256 으로 암호화된 필드를 해독할 필드 예) f1,f2"%>

<%@ attribute name="forEach" type="java.lang.String" description="for문을 돌릴 배열 객체명"%>
<%@ attribute name="var" type="java.lang.String" description="for문에서 반환하는 객체를 받을 변수명"%>
<%@ attribute name="emptySkip" type="java.lang.Boolean" description="for문실행시 empty이면 처리를 스킵한다."%>
<%@ attribute name="defaultValues" type="java.lang.String" description="기본으로 설정할 값"%>
<%@ attribute name="desc" type="java.lang.String" description="설명"%>
{
	jobId: 'requestEnc',
	id: '${id}',
	<c:if test="${!empty(aes256)}">aes256: '${aes256}', </c:if>
	
	<c:if test="${!empty(forEach)}">forEach: '${forEach}', </c:if>
	<c:if test="${!empty(var)}">var: '${var}', </c:if>
	<c:if test="${!empty(emptySkip)}">emptySkip: ${emptySkip}, </c:if>
	<c:if test="${!empty(defaultValues)}">defaultValues: ${defaultValues}</c:if>
	<c:if test="${empty(defaultValues)}"><jsp:doBody/></c:if>
},