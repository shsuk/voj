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
	<job:requestEnc id="reuestEnc" aes256="user_id" />
	<job:db id="rows" query="voj/usr/find_pwd" >
		defaultValues:{
			session_id: '${uf:uuid() }'
		}
	</job:db>
]</uf:organism>

<c:set var="row" value="${rows[1][0] }"/>

<c:if test="${rows[0]==1}">
	<c:set var="row" value="${rows[1][0] }"/>
	<uf:organism noException="true">[
		<job:mail id="send" to="${empty(row.mb_email) ? row['USER_ID@dec'] : row['MB_EMAIL@dec'] }" 
			 template="find_pwd"  defaultValues="{link:'${req.server }at.sh?_ps=voj/usr/chg&id=${row.session_id}'}"
			/>
	]</uf:organism>
	<font color="blue">등록한 메일로 비밀번호 찾기 메일을 발송하였습니다.</font>
</c:if>
<c:if test="${rows[0]==0}">
	<font color="red">입력한 아이디를 찾을 수 없습니다.${JSON }</font>
</c:if>
