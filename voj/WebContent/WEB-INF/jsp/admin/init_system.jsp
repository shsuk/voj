<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<script type="text/javascript">
$(function() {
	$('#save').button({icons: {primary: "ui-icon-disk"}}).click(function( event ) {
		
		if(confirm('변경사항을 적용할까요?')){
			default_submit('u', $('form'));
		}
	});

});
</script>
<center>
<br><br>
<c:if test="${!isMobileView }"><b>시스템 자동 초기화 설정</b><br></c:if>
<div style="width: 80%;">
	<c:set var="_q" scope="request" value="system/init_config"/>
	<c:set var="_t" scope="request" value="edit"/>
	<jsp:include page="../at/at.jsp"/>
	<c:if test="${!isMobileView }"><div id="save" class="button-r" >저장</div></c:if>
</div><br>
사용으로 하면 변경사항이 자동으로 적용됩니다.<br><br>
</center>