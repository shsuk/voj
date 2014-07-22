<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="codes" type="java.lang.String" required="true" description=" =선택, id1=val1 , id2=val2 ...(공백은 앞뒤 공백은 제거됨, 길이가 0인 값을 넣고 싶으면 공백을 넣으세요.)"%>
<%@ attribute name="selected" type="java.lang.String" %>
<%@ attribute name="className" type="java.lang.String"%>
<%@ attribute name="secederRecord" type="java.lang.String" description="레코드 분리자 기본값 (,)"%>
<%@ attribute name="secederField" type="java.lang.String" description="필드 분리자 기본값 (=)"%>
<%@ attribute name="style" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<c:set var="secederR" value="${empty(secederRecord) ? ',' : secederRecord}" />
<c:set var="secederF" value="${empty(secederField) ? '=' : secederField}" />
<c:set var="codeList" value="${fn:split(codes, secederR)}" />
<select id="${name }" name="${name }" valid="${valid }"  style="${style }"  title="${title }"  ${attr } class="${className }" >
<c:forEach var="row" items="${codeList}"> 
	<c:set var="code" value="${fn:split(row, secederF)}" />
	<c:set var="val" value="${fn:trim(code[0])}" />
	<option value="${val }" ${selected == val ? 'selected' : ''}>${fn:trim(code[1])}</option>
</c:forEach>
</select>