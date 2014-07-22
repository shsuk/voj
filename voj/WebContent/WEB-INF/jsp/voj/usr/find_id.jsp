<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<%@ taglib prefix="jobu"  tagdir="/WEB-INF/tags/job/user" %> 
<%@ taglib prefix="tpu"  tagdir="/WEB-INF/tags/user" %> 
<uf:organism  noException="true">[
	<job:requestEnc id="reuestEnc" aes256="user_id,user_nm,pwd,mb_email" />
	<job:db id="row" query="voj/usr/find_id" singleRow="true" />
]</uf:organism>

<c:if test="${row.cnt!=0}">
	<font color="blue">${row['USER_ID@dec@email'] }</font>
	<c:if test="${row.cnt!=1}">
		<br>${row.cnt}개의 아이디가 검색되었습니다. 그중 하나입니다.
	</c:if>
</c:if>
<c:if test="${row.cnt==0 }">
	<font color="red">아이디를 찾을 수 없습니다.</font>
</c:if>