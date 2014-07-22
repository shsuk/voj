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
		<uf:organism>[
			<job:requestEnc id="reuestEnc" aes256="user_id,user_nm,mb_email" />
			<job:db id="row" query="voj/usr/user_insert"/>
			<job:db id="rows" query="voj/usr/user_mng" />
		]</uf:organism>
		<c:set var="JSON" scope="request" value="${JSON }"/>
		
		<uf:organism test="${!empty(param.email) }" noException="true">[
			<job:mail id="send" to="${param.email }" template="reg_user"  />
		]</uf:organism>
		
		<c:forEach var="admin" items="${rows }">
			<uf:organism test="${row==1 }"  noException="true">[
				<job:mail id="send" to="${empty(admin.mb_email) ? admin['USER_ID@dec'] : admin['MB_EMAIL@dec']}"  template="reg_noti"/>
			]</uf:organism>
		</c:forEach>
	
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
</c:choose>

<jsp:include page="../voj_layout${mobile}.jsp" >
	<jsp:param value="bd_list" name="inc"/>
</jsp:include>

<script type="text/javascript">



	$(function($){
		$('#save_btn').click(function(){
			form_submit();
		});
	});
	
	function dupNick(){
		$('#nick_dup_check').load('at.sh?_ps=voj/usr/dup_nick', {nick_name: $('#nick_name').val()},function(){
		});
	}

	function isEmail(){
		var isMail = $.valedFunction.mail($('#user_id'));

		$('#id_dup_check').load('at.sh?_ps=voj/usr/dup_id', {user_id: $('#user_id').val()},function(){
			
		});
		var mail = $('#user_id').val();
		if(isMail && mail != ''){
			$('#mb_email_info').hide();
			$('#mb_email').val('');
			
		}else{
			$('#mb_email_info').show();
			$('#mb_email').val('');
		}
	}
	
	function form_submit(){
		var form = $('#main_form');
		if(form.attr('isSubmit')==='true') return false;
		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;
		
		var formData =$(form).serializeArray();

		var url = 'at.sh?_ps=${req._ps}&action=i';
		
		if($(form).attr('isSubmit')==='true') return false;

		var mail = $('#user_id').val();
		
		if(mail != '' && $.valedFunction.mail($('#user_id'))){
			mail = $('#user_id').val();			
		}
		var mb_email = $('#mb_email').val();
		if(mail == '' && mb_email != '' && $.valedFunction.mail($('#mb_email'))){
			mail = mb_email;			
		}

		$('#email').val(mail);
		
		$(form).attr('isSubmit',true);
		$('#save_btn').hide();
		
		$.post(url, formData, function(response, textStatus, xhr){
			$(form).attr('isSubmit',false);
			$('#save_btn').show();
	
			var data = $.parseJSON(response);
	
			if(data.success){
				alert("회원가입 신청이 완료되었습니다. 회원승인 후 정상적으로 이용하 실 수 있습니다.");
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
	<div style="font-size: 24px;"><b>회 원 가 입</b></div>
	<table style="width: 100%"><tr><td>
		<form id="main_form" name="main_form" action="" onsubmit="return form_submit()">
			<input type="hidden" id="email" name="email" value="">

			<table class="${tpl_class_table}">
				<tr>
					<th class="${tpl_class_table_header}" title="user_id" width="150"><font color="red">*</font>사용자 아이디</th>
					<td>
						<input type="text" id="user_id" name="user_id" value="" valid="[['notempty'],['maxlen:30'],['minlen:3']]" onchange="isEmail()"> 
						아이디를 메일주소를 사용하셔도 됩니다.
						<div id="id_dup_check"></div>
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="user_nm"><font color="red">*</font>사용자 이름</th>
					<td>
						<input type="text" id="user_nm" name="user_nm" value="" valid="[['notempty'],['maxlen:20']]">
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="nick_name"><font color="red">*</font>별명</th>
					<td>
						<input type="text" id="nick_name" name="nick_name" value="" valid="[['notempty'],['maxlen:20']]" onchange="dupNick()">
						<br>별명은 공개되는 이름으로 다른 사람과 구별지어주는 이름입니다. <br>한번 지정되면 변경할 수 없습니다.<br>
						더불어 개인 정보는 법적으로 노출할 수 없어 별명을 사용하는데, 본인이 원하시는 경우는 가능합니다. <br>실명 노출이 괜찮다 생각되시는 분들은 별명란에 이름을 넣으시면 됩니다.
						<div id="nick_dup_check"></div>
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="pwd"><font color="red">*</font>패스워드</th>
					<td>
						<input type="password" id="pwd" name="pwd" value="" valid="[['notempty'],['maxlen:15'],['password']]">
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="pwdchk"><font color="red">*</font>패스워드 확인</th>
					<td>
						<input type="password" id="pwdchk" name="pwdchk" value="" valid="[['notempty'],['equals:pwd']]">
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="village">마을이름</th>
					<td>
						<input type="hidden" id="village" name="village" value="" valid="">
						<div onclick="$('#village_sel').show();" id="village_lbl" style="border:1px solid #B2CCFF;width: 130px;height: 18px;"></div>
						<tp:village_sel bd_key=""/>		
					</td>
				</tr>
				<tr id="mb_email_info">
					<th class="${tpl_class_table_header}" title="mb_email" width="150">이메일</th>
					<td>
						<input type="text" id="mb_email" name="mb_email" value="" valid="[['email']]"> 예) gdh@gamil.com
					</td>
				</tr>
			</table>		
		</form>
		<div id="save_btn" class="cc_bt f_r">회원가입</div>

	</td></tr></table>
</div>
