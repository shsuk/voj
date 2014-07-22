<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="리턴받을 변수명"%>
<%@ attribute name="host" type="java.lang.String" required="false" description="메일 POP3서버"%>
<%@ attribute name="port" type="java.lang.Integer" required="false" description="포트"%>
<%@ attribute name="from" type="java.lang.String" required="false" description="보내는사람주소"%>
<%@ attribute name="to" type="java.lang.String" required="true" description="받는사람주소 (예: xxx@mail.com or ['xxx1@mail.com','xxx2@mail.com'])"%>
<%@ attribute name="subject" type="java.lang.String" required="false" description="제목"%>
<%@ attribute name="body" type="java.lang.String" required="false" description="본문"%>
<%@ attribute name="protocol" type="java.lang.String" description="ssl"%>
<%@ attribute name="cc" type="java.lang.String" description="참조 (예: xxx@mail.com or ['xxx1@mail.com','xxx2@mail.com'])"%>
<%@ attribute name="bcc" type="java.lang.String" description="숨은참조 (예: xxx@mail.com or ['xxx1@mail.com','xxx2@mail.com'])"%>
<%@ attribute name="template" type="java.lang.String" description="템플릿경료 (구현안됨)"%>
<%@ attribute name="authenticate" type="java.lang.Boolean" description="로그인 필요"%>
<%@ attribute name="user" type="java.lang.String" description="로그인시 유저아이디"%>
<%@ attribute name="pwd" type="java.lang.String" description="패스워드"%>

<%@ attribute name="isReturn" type="java.lang.Boolean" description="처리결과를 JSON결과로 반환한다."%>
<%@ attribute name="forEach" type="java.lang.String" description="for문을 돌릴 배열 객체명"%>
<%@ attribute name="var" type="java.lang.String" description="for문에서 반환하는 객체를 받을 변수명"%>
<%@ attribute name="emptySkip" type="java.lang.Boolean" description="for문실행시 empty이면 처리를 스킵한다."%>
<%@ attribute name="defaultValues" type="java.lang.String" description="기본으로 설정할 값"%>
<%@ attribute name="desc" type="java.lang.String" description="설명"%>
{
	jobId: 'mail',
	id: '${id}',
	host: '${host}',
	port: '${port}',
	subject: '${subject}',
	body: '${body}',
	<c:if test="${!empty(from)}">from: '${from}', </c:if>
	
	to: <c:if test="${fn:startsWith(to,'[')}">${to}</c:if>
		<c:if test="${!fn:startsWith(to,'[')}">'${to}' </c:if>,
	<c:if test="${!empty(authenticate)}">
		cc: <c:if test="${fn:startsWith(cc,'[')}">${cc}</c:if>
			<c:if test="${!fn:startsWith(cc,'[')}">'${cc}' </c:if>,
	</c:if>
	<c:if test="${!empty(authenticate)}">
		bcc: <c:if test="${fn:startsWith(bcc,'[')}">${bcc}</c:if>
			<c:if test="${!fn:startsWith(bcc,'[')}">'${bcc}' </c:if>,
	</c:if>
	
	<c:if test="${!empty(protocol)}">protocol: '${protocol}', </c:if>
	<c:if test="${!empty(template)}">template: '${template}', </c:if>

	<c:if test="${!empty(authenticate)}">authenticate: ${authenticate}, </c:if>
	<c:if test="${!empty(user)}">user: '${user}', </c:if>
	<c:if test="${!empty(pwd)}">pwd: '${pwd}', </c:if>
	
	<c:if test="${!empty(isReturn)}">isReturn: ${isReturn}, </c:if>
	<c:if test="${!empty(forEach)}">forEach: '${forEach}', </c:if>
	<c:if test="${!empty(var)}">var: '${var}', </c:if>
	<c:if test="${!empty(emptySkip)}">emptySkip: ${emptySkip}, </c:if>
	<c:if test="${!empty(defaultValues)}">defaultValues: ${defaultValues}</c:if>
	<c:if test="${empty(defaultValues)}"><jsp:doBody/></c:if>
},