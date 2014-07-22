<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<script type="text/javascript">

</script>
<center>
<br><br>
<b>공용 접근 URL 정보</b><br><br><br>
<div style="width: 300px;text-align: left;">
<%=ProcessInitialization.PUBLIC_URL.toString().replaceAll(",", ",<br>") %>
</div><br>
추가 설정은 코드관리 public_url에 등록하세요.<br>
설정값은 참조값 _ps 값을 넣거나 최종 경로까지 넣으면 그 하위 페이지는 일괄 적용됩니다..<br>
</center>