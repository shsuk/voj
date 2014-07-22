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


<jsp:include page="../voj_layout${mobile}.jsp" >
	<jsp:param value="bd_list" name="inc"/>
</jsp:include>

<script type="text/javascript">

function findId(){
	$('#find_id').load('at.sh?_ps=voj/usr/find_id', {user_id: $('#user_id').val()},function(){
	});
}
function findPwd(){
	var server = document.URL;
	server = server.substring(0, server.lastIndexOf('at.sh'));


	$('#find_pwd').load('at.sh?_ps=voj/usr/find_pwd', {user_id: $('#user_id_pw').val(), server:server},function(){
	});
}

</script>

<div  id="body_main" style="display: none;">
<br>
	<div style="font-size: 24px;"><b>아이디/비밀번호 찾기</b></div><br>
	<table style="width: 100%"><tr><td>
			<b>아이디 찾기</b>
			<table class="${tpl_class_table}">
				<tr>
				<tr>
					<th class="${tpl_class_table_header}" width="150">사용자 이름<br>별명<br>이메일</th>
					<td>
						<input type="text" id="user_id" name="user_id" value=""   class="f_ㅣ" valid="[['notempty'],['maxlen:20']]">
						<div id="user_btn" class="cc_bt f_r" onclick="findId()">찾기</div>
					</td>
				</tr>
				<tr>
					<th class="${tpl_class_table_header}"  width="150">찾은 아이디</th>
					<td id="find_id">
					</td>
				</tr>
			</table><br>
			<b>비밀번호 찾기</b>
			<table class="${tpl_class_table}">
				<tr>
					<th class="${tpl_class_table_header}" width="150">사용자 아이디 <br>또는 이메일</th>
					<td>
						<input type="text" id="user_id_pw" name="user_id_pw" value="" valid="[['notempty'],['maxlen:30']]"> 
						이메일을 등록하지 않은 경우는 찾으실 수 없습니다. 아래 전화로 연락하여 수동으로 찾으세요.
						<div id="pwd_btn" class="cc_bt f_r" onclick="findPwd()">찾기</div>
						<div id="find_pwd"></div>
					</td>
				</tr>
			</table>		

	</td></tr></table>
</div>
