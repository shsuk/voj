<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="net.ion.webapp.utils.Function"%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 

<jsp:include page="../voj_layout${mobile}.jsp" >
	<jsp:param name="bd_cat"  value="well"/>
</jsp:include>

<tp:calendar year="${req.year }" month="${req.month }"/>

<uf:organism >
[
	<job:db id="rows" query="voj/sch/list" >
		defaultValues:{
			start_date: '${start_date }',
			end_date: '${end_date }'
		}
	
	</job:db>
]
</uf:organism>

<c:set scope="request" var="rows" value="${rows }"/>
<tp:list2mapList targetId="schMap" key="bd_key" sourceId="rows"/>

<script type="text/javascript">
	
	$(function() {
	    init_load();
		var menuid = "m4";
    	setCurrentMenu(menuid);
    	$('.sch').css('width',$('#body_main_contents').width()/7-13);

    	if(!${req.id=='newfam' || empty(req.id)}){
    		show('${req.id}');
	    }
	});
	
	function show(id){
		id = 'id_' + id + '_data';
		open_popup('sch_pop');
		$('#sch_pop').html($('#'+id).html());
	}
</script>

<tp:popup title="일정" id="sch_pop" height="300" width="${mobile=='m' ? '300' : '500'}">
</tp:popup>
<div  id="body_main">

	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		<div style="font-size: 20px;font-weight: bold;color:#2fb9d1;"><span  style="color:#a39c97;">예수마을교회</span> 
		<span> 교회일정</span><hr size="1" color="#a29c97" noshade></div>	
	</div>

	<div  class="bd_body" style="color:#f6a400;">
		<table style="color:#f6a400; ;margin-top: 10px;"><tr>
			<td width="50" align="center">
				<a href="at.sh?_ps=voj/sch/show&year=${bYear }&month=${bMonth }" style=""><img src="../images/icon/actions-go-previous-view-icon.png"  align="top" border="0">${bMonth }월</a>
			</td>
			<td width="100" align="center">
				<b>${cYear }년 ${cMonth }월</b> 
			</td>
			<td width="50" align="center">
				<a href="at.sh?_ps=voj/sch/show&year=${aYear }&month=${aMonth }" style="">${aMonth }월<img src="../images/icon/actions-go-next-view-icon.png" align="top"  border="0"></a>
			</td>
			<td width="*" align="center">
				 
			</td>
		</tr></table>
		
		
		<div style="color: #999999;">날짜를 클릭하면 맥체인 성경 읽기로 가실 수 있습니다.</div>
		
	
		<table style="  background:#B6B5DB;"  cellpadding="3" cellspacing="1"><tr>
			<c:forEach var="w" items="${week }" >
				<td style=" color:${w=='일' ? 'red' : '#000000'}; width: 13%;height: 30px;background:#cccccc; margin-top: 1px; margin-left: 1px;text-align: center;"><b>${w }요일</b></td>
			</c:forEach>
		
			<c:forEach var="day" items="${month }" >
				<c:set var="week">${day[0]}</c:set>
				<c:if test="${day[0]=='0' }">
					${'</tr><tr>'}
				</c:if>
	
				<c:set var="m">${cMonth}</c:set>
				<c:set var="cm">${day[1]}</c:set>
				<td style="width:13%; color:${week=='0' ? 'red' : ''};  background:#${cur_date==day[3] ? 'B2CCFF' : (cm==m ? 'ffffff' : 'eeeeee') };  margin-top: 1px; margin-left: 1px;vertical-align: top;">
					<a href="at.sh?_ps=voj/mc/day_view${isMobile ? 'm' : '' }&mc_dt=${day[4] }" title="맥체인 성경읽기" style="color: ${day[0]=='0' ? 'red' : ''};">${day[2] }일</a>
					<c:if test="${session.myGroups['sch'] && viewAdminButton}">
						<a href="at.sh?_ps=voj/sch/edit&bd_key=${day[3]}" target="new" title="일정추가"><img src="../images/icon/document-add-icon.png" height="13" border="0"></a>
					</c:if>
					<div style="min-height: 40px;color: #000000 ">
					<c:forEach var="row" items="${schMap[day[3]] }">
						<div id="id_${row.bd_id}" onclick="show(${row.bd_id})" class="sch d_ib c_p o_h to_h" style="margin-bottom: 1px;">${row.title }</div>
						<div id="id_${row.bd_id }_data" class="se2_inputarea " style="display: none;">
							<b>${row.title }</b><br>
							${row.CONTENTS }
							
							<c:if test="${session.myGroups['sch'] && viewAdminButton }">
								<a href="at.sh?_ps=voj/sch/edit&bd_id=${row.bd_id}" target="new" class="action_blue btn-r">수정</a>
							</c:if>
						</div>
					</c:forEach>
					</div>
				</td>
			</c:forEach>
			
		</tr></table>
	</div>

</div>
	