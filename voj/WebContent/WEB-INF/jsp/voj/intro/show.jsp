<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<jsp:include page="../voj_layout${mobile}.jsp" />

<uf:organism >
[
	<job:db id="row" query="voj/intro/view"  singleRow="true"/>
]
</uf:organism>

<script type="text/javascript">
	
	$(function() {
		if(${isMobile}){
			$('.info_mobile').show();
			$('.info_web').hide();
		}else{
			$('.info_web').show();
			$('.info_mobile').hide();
		}
	    init_load();
	    var menuid = '${empty(req.mid) ? "m1" : req.mid}';
    	setCurrentMenu(menuid);
	});
	
</script>

<div  id="body_main">
	<%//본문 %>
	<div style="width:100%;clear:both;min-height: 300px;margin-bottom: 5px; overflow: auto;">
		<div style="padding: 5px;">${row['CONTENTS']}</div>
	</div>
	<c:if test="${session.myGroups['intro'] && viewAdminButton}">
		<a href="at.sh?_ps=voj/intro/edit&bd_key=${req.id }" target="new" class="action_blue btn-r">수정</a>
	</c:if>
</div>
	