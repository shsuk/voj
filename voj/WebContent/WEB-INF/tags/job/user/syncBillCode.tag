<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="src" type="java.lang.String" required="true" description="코드를 생성할 소스 데이타"%>
<%@ attribute name="groupId" type="java.lang.String" required="true" description="구룹코드"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="리턴받을 변수명"%>
{
	jobId: 'syncBillCode',
	id: '${id}',
	src: '${src}',
	groupId: '${groupId}'
},