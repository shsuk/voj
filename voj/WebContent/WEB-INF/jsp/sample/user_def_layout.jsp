<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<script type="text/javascript">
$(function() {

	$('#save').button({icons: {primary: "ui-icon-disk"}}).click(function( event ) {
		
		default_submit('u', $('form[name="system/sample/lang_view.tb_system_lang"]'), function(a){
			$('#detail').empty();
			$('#save').hide();
		});
	});

	$('#save').hide();
});

function load_page(rid){
	var params = {
		_q: 'system/sample/lang_view',
		_t: 'view',
		rid: rid
	};
	
	$('#detail').load('at.sh',params);
	$('#save').hide();
}
function edit_page(rid){
	var params = {
		_q: 'system/sample/lang_view',
		_t: 'edit',
		rid: rid
	};
	
	$('#detail').load('at.sh',params);
	$('#save').show();
}
function load_page1(rid){
	var params = {
		_q: 'system/sample/code_view',
		_t: 'view',
		rid: rid
	};
	
	$('#detail1').load('at.sh',params);
}


</script>
<div>
	<table style="width: 100%">
		<tr>	
			<td colspan="2">
				<h2>이 예제는 사용자 정의 화면 구성을 위한 예제 입니다.</h2>
			</td>
		</tr>
		<tr>
			<td width="50%" valign="top">
				<div>
					<div class="ui-state-default" style="padding: 10px;">상세정보</div>
					<div id="detail" style=" width:100%;"></div>
					<div id="save" >저장</div>
				</div>
				<div>
					<c:set var="_q" scope="request" value="system/sample/lang_list"/>
					<c:set var="_t" scope="request" value="list"/>
					<jsp:include page="../at/at.jsp"/>
				</div>
			</td>
			<td valign="top">
				<c:set var="_q" scope="request" value="system/sample/code_list"/>
				<c:set var="_t" scope="request" value="list"/>
				<jsp:include page="../at/at.jsp"/>
			</td>
		</tr>
	</table>
</div>
