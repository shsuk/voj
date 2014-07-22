<%@page import="net.ion.webapp.db.Lang"%>
<%@page import="net.ion.webapp.db.CodeUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="net.ion.webapp.utils.CookieUtils"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<jsp:include page="../voj/voj_layout${mobile}.jsp" />

<script>
$(function() {
	$('#login').click(function(){
		login();
	});
});

function login(){
	//if(!$.formValed('loginMainForm')) return false;

	var data ={
			_ps : 'login/login',
			uid : $('#uid').val().trim(),
			pwd : $('#pwd').val(),
			svuid : $('#svuid').val()
	};
	
	$.getJSON('at.sh', data, function(data){
		if(data.success){
			document.location.href="/";
		}else if(data.isMessage){
			alert(data.message);
		}else{
			alert( '아이디 또는 패스워드가 잘못되었거나 회원승인상태가 아닙니다. \n확인 후 다시 로그인 하세요.' );
		}
	});
	
	return false;
}

function keydown(event){
	if(event.keyCode==13){
		login();
	}
}

</script>

<div  id="body_main" style="display: none;">
<br><br>
<form action="at.sh" method="post" name="login_form" onkeydown="keydown(event)" onsubmit="return login();">
<table style="height: 90%;width: 100%; ">
	<tr>
		<td valign="middle" align="center"><br>
			<div class="login_main">
			<img src="./voj/images/idlogingo.gif" ><br><br>
			<table>
				<tr>
					<td align="center">
						<table>
							<tr>
								<th align="right">아이디</th>
								<td><input id="uid" name="uid" type="text" value="${fn:replace(cookie.uid.value,'%40','@') }" size="15" maxlength="50" placeholder="아이디"></td>
							</tr>
							<tr>
								<th align="right">패스워드</th>
								<td><input id="pwd" name="pwd" type="password"  value="" size="15" maxlength="20" placeholder="패스워드"></td>
							</tr>
							<tr>
								<th align="right"><input type="checkbox" style="border: 0px;" id="svuid" name="svuid" value="Y" ${empty(cookie.uid.value) ? '' : 'checked="checked"' }></th>
								<td align="left"><label for="svuid">아이디 저장</label></td>
							</tr>
						</table>
						
					</td>
					<td valign="top">
						<img src="./voj/images/loginbt.gif" style="cursor: pointer;" onclick="login()">
					</td>
				</tr>
			</table>
			
			<br>
			<a href="at.sh?_ps=voj/usr/user_add"><img src="./voj/images/member_in.gif" border="0"></a>
			<a href="at.sh?_ps=voj/usr/user_find"><img src="./voj/images/idpw_search.gif" border="0"></a>
		</div><br><br>
		</td>
	</tr>
</table>
</form>
</div>
