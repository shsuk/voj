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
	<c:when test="${req.action=='i' }">
		<uf:organism  noException="true">[
			<job:requestEnc id="reuestEnc" aes256="user_id,user_nm,mb_email" />
			<job:db id="row" query="voj/usr/chg_update"/>
		]</uf:organism>
		<c:set var="JSON" scope="request" value="${JSON }"/>
		
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
</c:choose>

<uf:organism  noException="true">[
	<job:db id="row" query="voj/usr/chg" />
]</uf:organism>


<jsp:include page="../voj_layout${mobile}.jsp" >
	<jsp:param value="bd_list" name="inc"/>
</jsp:include>

<script type="text/javascript">

$(function($){
	if('${empty(row)}'=='true'){
		alert('만료된 페이지입니다.');
		location.href = '/';
	}
	$('#save_btn').click(function(){
		form_submit();
	});
});

function form_submit(){
	var form = $('#main_form');
	if(form.attr('isSubmit')==='true') return false;
	//폼 정합성 체크
	var isSuccess = $.valedForm($('[valid]',form));
	if(!isSuccess) return false;
	
	var formData =$(form).serializeArray();

	var url = 'at.sh?_ps=${req._ps}&action=i';
	
	if($(form).attr('isSubmit')==='true') return false;

	
	$(form).attr('isSubmit',true);
	$('#save_btn').hide();
	
	$.post(url, formData, function(response, textStatus, xhr){
		$(form).attr('isSubmit',false);
		$('#save_btn').show();

		var data = $.parseJSON(response);

		if(data.success){
			alert("패스워드 변경이 완료되었습니다. 로그인 하세요.");
			location.href = '/';
		}else{
			alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
		}
	});
	return false;
}

</script>

<div  id="body_main" style="display: none;">
<br>
	<div style="font-size: 24px;"><b>비밀번호 찾기</b></div><br>
	<table style="width: 100%"><tr><td>
		<form id="main_form" name="main_form" action="" onsubmit="return form_submit()">
			<input type="hidden" id="id" name="id" value="${req.id }" >

			<table class="${tpl_class_table}">
				<tr>
					<th class="${tpl_class_table_header}" title="패스워드" width="150"><font color="red">*</font>패스워드</th>
					<td>
						<input type="password" id="pwd" name="pwd" value="" valid="[['notempty'],['maxlen:15'],['password']]">
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="패스워드 확인"><font color="red">*</font>패스워드 확인</th>
					<td>
						<input type="password" id="pwdchk" name="pwdchk" value="" valid="[['notempty'],['equals:pwd']]">
					</td>
				</tr>
			</table>
		</form>		
		<div id="save_btn" class="cc_bt f_r">패스워드 변경</div>

	</td></tr></table>
</div>
