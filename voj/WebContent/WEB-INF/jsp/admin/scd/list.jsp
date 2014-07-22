<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<script type="text/javascript">
$(function() {
	
	change_color();
	
	$(document).ajaxSuccess(function(e,e1,e2,e3,e4,e5) {
		change_color();
	});

	function change_color(){
		//접속된서버에서 실행되는 스케줄 색상 변경
		var ip = $('span#ip').text();
		
		var scd_run_ip = $('div[name=scd_run_ip]', '#scd_list');

		for(var i=0; i<scd_run_ip.length; i++){
			if(ip.indexOf($(scd_run_ip[i]).text()) > 0){
				$(scd_run_ip[i]).css('color', 'green');
			}
		}
		//수정된 정보가 반영되지 않은 스케줄의 작업 등록일시 색상 변경
		var scd_svr_reg_dt = $('div[name=scd_svr_reg_dt]', '#scd_list');
		var mod_dt = $('div[name=mod_dt]', '#scd_list');

		if(scd_svr_reg_dt.length!=mod_dt.length) return;
		
		for(var i=0; i<scd_svr_reg_dt.length; i++){
			if($(scd_svr_reg_dt[i]).text() < $(mod_dt[i]).text()){
				$(scd_svr_reg_dt[i]).css('color', 'red');
			}
		}
	}
});


</script>
<div id="scd_list">

	<c:set var="_q" scope="request" value="system/schedule/list"/>
	<c:set var="_t" scope="request" value="list"/>
	<jsp:include page="../../at/at.jsp"/>

	<div>
		서버 IP : <span id="ip" ><%=ProcessInitialization.getServseIps() %></span> <br>
		수정일시가 작업 등록일시 보다 크면 수정사항이 반영되지 않은 상태입니다.
	</div>

</div>

