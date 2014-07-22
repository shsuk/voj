<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="리턴받을 변수명"%>
<%@ attribute name="host" type="java.lang.String" required="true" description="메일 POP3서버"%>
<%@ attribute name="port" type="java.lang.Integer" required="true" description="포트"%>
<%@ attribute name="user" type="java.lang.String" required="true" description="유저아이디"%>
<%@ attribute name="pwd" type="java.lang.String" required="true" description="패스워드"%>
<%@ attribute name="searchSubject" type="java.lang.String" description="제목 검색어"%>
<%@ attribute name="searchFrom" type="java.lang.String" description="보낸사람 메일주소 검색"%>
<%@ attribute name="receivedTime" type="java.lang.Integer" description="x분전 이후 전송된 메일 검색"%>
<%@ attribute name="limit" type="java.lang.Integer" description="읽어올 레코드 수"%>

<%@ attribute name="isReturn" type="java.lang.Boolean" description="처리결과를 JSON결과로 반환한다."%>
{
	jobId: 'mailRcv',
	id: '${id}',
	host: '${host}',
	port: '${port}',
	user: '${user}',
	pwd: '${pwd}',
	<c:if test="${!empty(receivedTime)}">receivedTime: ${receivedTime}, </c:if>
	<c:if test="${!empty(isReturn)}">isReturn: ${isReturn}, </c:if>
	<c:if test="${!empty(limit)}">limit: ${limit}, </c:if>
	searchSubject: '${searchSubject}',
	searchFrom: '${searchFrom}'
},