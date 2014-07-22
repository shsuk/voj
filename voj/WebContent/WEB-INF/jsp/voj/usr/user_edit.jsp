
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
			<job:requestEnc id="reuestEnc" aes256="user_id,user_nm" />
			<job:db id="count" query="voj/usr/user_update"/>
		]</uf:organism>
	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
</c:choose>

<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu">[
	<uf:job id="row" jobId="db" query="voj/usr/user_edit" singleRow="true"/>
]</uf:organism>

<jsp:include page="../voj_layout.jsp" />

<script type="text/javascript">
	$(function() {
		$('#save_btn').button({icons: {primary: "ui-icon-file"}}).click(function(){
			form_submit();
		});
	});
	
	function noChangePw(){
		$('#no_change_pw').append($('.change_pw'));
		$('#btn_change_pw').show();
		$('#btn_no_change_pw').hide();
	}
	function changePw(){
		$('#change_pw').append($('.change_pw'));
		$('#btn_change_pw').hide();
		$('#btn_no_change_pw').show();
	}
	
	function form_submit(){
		var form = $('#main_form');
		if(form.attr('isSubmit')==='true') return false;
		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;
		
		var formData =$(form).serializeArray();

		var url = 'at.sh?action=u&_ps=${req._ps}';	
		
		if($(form).attr('isSubmit')==='true') return false;
		$(form).attr('isSubmit',true);
	
		$.post(url, formData, function(response, textStatus, xhr){
			$(form).attr('isSubmit',false);
	
			var data = $.parseJSON(response);
	
			if(data.success){
				if(data.count>0){
					alert("사용자 정보 수정이 완료되었습니다.");
					location.href="./";
				}else{
					alert("패스워드를 확인하세요.");
					return false;
				}
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
			}
		});
		return false;
	}
</script>

<div  id="body_main">
	<form id="main_form" name="main_form" action="" onsubmit="return form_submit()">
		<input type="hidden" id="user_no" name="user_no" value="${row['user_no']}"  >
		[사용자 정보 수정]
		<table class="${tpl_class_table}">
			<thead>
				<tr>
					<th class="${tpl_class_table_header}" title="user_id" width="150">사용자 아이디</th>
					<td>
						${row['USER_ID@dec@email'] }
					</td>
				</tr>
			
				<tr>
					<th class="${tpl_class_table_header}" title="user_nm">이름</th>
					<td>
						${row['USER_NM@dec']}
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="nick_name">별명</th>
					<td>
						${row['nick_name']}
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="village">마을이름</th>
					<td>
						<input type="hidden" id="village" name="village" value="${row.village }" valid="">
						<div onclick="$('#village_sel').show();" id="village_lbl" style="border:1px solid #B2CCFF;width: 130px;height: 18px;">${row.village }</div>
						<tp:village_sel bd_key=""/>		
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}" title="pwd">암호</th>
					<td>
						<input type="password" id="pwd" name="pwd" value=""  valid="[['notempty'],['maxlen:15']]">
					</td>
				</tr>
			</thead>
			<tbody  id="change_pw">
				<tr><td colspan="2" style="height: 1px;"></td></tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2" align="right" >
						<a id="btn_change_pw"  class="cc_bt f_r"  onclick="changePw()" href="#">암호변경</a>
						<a id="btn_no_change_pw"  class="cc_bt f_r" style="display: none"  onclick="noChangePw()" href="#">암호변경 안함</a>
					</td>
				</tr>
			</tfoot>
		</table>
	</form>
	<div id="save_btn" class="btn-r">저장</div>
	<table id="no_change_pw" style="display: none;">
		<tr class="change_pw">
			<th class="${tpl_class_table_header}" title="npwd">변경할 암호</th>
			<td>
				<input type="password" id="npwd" name="npwd" value=""  valid="[['notequals:pwd'],['maxlen:15'],['password']]">
			</td>
		</tr>
		<tr class="change_pw">
			<th class="${tpl_class_table_header}" title="ncpwd">별경할 암호 확인</th>
			<td>
				<input type="password" id="ncpwd" name="ncpwd" value=""  valid="[['equals:npwd'],['maxlen:15']]">
			</td>
		</tr>
	</table>
</div>
	