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
	<job:db id="row" query="voj/usr/dup_id" singleRow="true" />
]</uf:organism>

<c:if test="${row.dup==0 }">
	<font color="blue">사용가능한 아이디입니다.</font>
</c:if>
<c:if test="${row.dup!=0 }">
	<font color="red">이 아이디는 다른 사용자가 사용중인 아이디입니다.</font>
	<script type="text/javascript">
		$(function($){
			$('#user_id').val('');
		});
	</script>
</c:if>