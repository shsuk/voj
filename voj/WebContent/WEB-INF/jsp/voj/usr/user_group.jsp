
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
<c:choose >
	<c:when test="${req.action=='u' }">
		<uf:organism>[
			<job:db id="count" query="voj/usr/user_group_update"/>
		]</uf:organism>
	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='c' }">
		<uf:organism>[
			<job:db id="count" query="voj/usr/user_pwd_update"/>
		]</uf:organism>
	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
</c:choose>

<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu">[
	<uf:job id="row" jobId="db" query="voj/usr/user_group" singleRow="true"/>
]</uf:organism>


<script type="text/javascript">
	$(function() {
		$('#pwd_btn').button({icons: {primary: "ui-icon ui-icon-key"}}).click(function(){
			change_pwd(); 
		});
		$('#cancel_btn').button({icons: {primary: "ui-icon ui-icon-circle-close"}}).click(function(){
			close_popup('pop_user_status');
		});
		$('#save_btn').button({icons: {primary: "ui-icon-disk"}}).click(function(){
			form_submit('u');
		});
		
		<c:if test="${!session.myGroups['rev']}">
			$('#user_group_rev').attr('disabled','disabled');
		</c:if>
	});
	function change_pwd(){
		if(confirm('비밀번호를 초기화 합니다. 비밀번호는 ${uf:getDate("yyyyMMdd")}로 초기화 됩니다.')){
			form_submit('c');
		}
	}	
	function form_submit(action){
		var form = $('#main_pop_form');
		if(form.attr('isSubmit')==='true') return false;
		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;
		
		var formData =$(form).serializeArray();

		var url = 'at.sh?action=' + action + '&_ps=${req._ps}';	
		
		if($(form).attr('isSubmit')==='true') return false;
		$(form).attr('isSubmit',true);
	
		$.post(url, formData, function(response, textStatus, xhr){
			$(form).attr('isSubmit',false);
	
			var data = $.parseJSON(response);
	
			if(data.success){
				if(data.count < 1){
					alert('변경에 실패하였습니다.');
				}
				close_popup('pop_user_status');
				goPage(${req.pageNo});
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
			}
		});
		return false;
	}
</script>

<jsp:include page="../voj_layout.jsp" />

<div>
	<form id="main_pop_form" name="main_form" action="" onsubmit="return form_submit()">
		<input type="hidden" id="user_no" name="user_no" value="${row['user_no']}"  >
		<input type="hidden" id="pwd" name="pwd" value="${uf:getDate('yyyyMMdd')}"  >
		<div style="height: 300px;">
		<table class="${tpl_class_table}" >			
			<tr>
				<th class="${tpl_class_table_header}" title="user_no">회원번호</th>
				<td>
					${row['user_no']}
				</td>
			</tr>
			<tr>
				<th class="${tpl_class_table_header}" title="user_id">아이디</th>
				<td>
					${row['USER_ID@dec'] }
				</td>
			</tr>
			<tr>
				<th class="${tpl_class_table_header}" title="user_nm">이름</th>
				<td>
					${row['USER_NM@dec']}
				</td>
			</tr>
			<tr>
				<th class="${tpl_class_table_header}" title="user_nm">별명</th>
				<td>
					${row.nick_name}
				</td>
			</tr>
			<tr>
				<th class="${tpl_class_table_header}" title="mb_email">이메일</th>
				<td>
					<input type="hidden" id="mb_email"  name="mb_email"  value="${row['MB_EMAIL@dec'] }">
					${row['MB_EMAIL@dec']}
				</td>
			</tr>
			<tr>
				<th class="${tpl_class_table_header}" title="village">마을</th>
				<td>
					${row.village}
				</td>
			</tr>
			<tr>
				<th class="${tpl_class_table_header}" title="user_nm">유저구룹</th>
				<td>
					<tp:check name="user_group" groupId="user_group" checked="${row.user_group}"/> 
				</td>
			</tr>
			<tfoot id="change_pw">
			</tfoot>
		</table>
		</div>
	</form>
	<div style="clear: both;">
		<div id="pwd_btn" class="btn-l">비밀번호 초기화</div>
		<div id="cancel_btn" class="btn-r">닫기</div>
		<div id="save_btn" class="btn-r">저장</div>
	</div>
</div>
	