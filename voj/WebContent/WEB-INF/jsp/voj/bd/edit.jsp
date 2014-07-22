<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 

<c:choose >
	<c:when test="${req.action=='i' }">
		<c:set var="JSON" scope="request" value="{\"success\":false,\"error_message\":\"다시 작성하세요.\"}"/>
		<c:if test="${cookie.bd_add.value > uf:addMinutes(uf:now(),-260).time }"><%//비정상적인 접근시 글을 저장하지 않는다. %>
			<tp:cookie name="save_nick" expiry="${24*60*30 }" value="${empty(req.save_nick) ? '' : req.reg_nickname }"/>
			<uf:organism noException="true">[
				<uf:job id="rtn" jobId="attachFile"/>
				<job:requestEnc id="reuestEnc" aes256="pw${req.security=='Y' ? ',ir1' : '' }" />
				<job:db id="row" query="voj/bd/insert"/>
			]</uf:organism>
		</c:if>
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='u' }">
		<tp:cookie name="save_nick" expiry="${24*60*30 }" value="${empty(req.save_nick) ? '' : req.reg_nickname }"/>
		<uf:organism noException="true">[
			<uf:job id="rtn" jobId="attachFile"/>
			<job:requestEnc id="reuestEnc" aes256="pw${req.security=='Y' ? ',ir1' : '' }" />
			<job:db id="row" query="voj/bd/update"/>
		]</uf:organism>
	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
</c:choose>

<uf:organism >
[
	<job:requestEnc id="reuestEnc" aes256="pw" />
	<job:db id="rset" query="voj/bd/edit" />
]
</uf:organism>

<c:set var="row" value="${rset.row }"/>

<script src="./se/js/HuskyEZCreator.js" type="text/javascript"  charset="utf-8"></script>
<script type="text/javascript">
	var oEditors = [];
	
	$(function() {
		<c:if test="${!empty(req.bd_id) && empty(row)}">
			alert('존재하지 않는 글이거나 패스워드가 불일치 합니다.');
			goPage(${req.pageNo});
			return;
		</c:if>
		
		initEditor();
		
	    init_load();
	});
	

	//에디터 소스 시작
	function initEditor() {
		// 추가 글꼴 목록
		//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
	
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "ir1",
			sSkinURI: "se/SmartEditor2Skin.html",	
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
				fOnBeforeUnload : function(){
					//alert("완료!");
				}
			}, //boolean
			fOnAppLoad : function(){
				//에디터 로딩이 완료된 후에 본문에 삽입
				oEditors.getById["ir1"].exec("PASTE_HTML", [$('#_contemts').html()]);
			},
			fCreator: "createSEditor2"
		});
	}

	//에디터 소스 끝
	
</script>
	<iframe id="uploadIFrame" name="uploadIFrame" style="display:none;visibility:hidden"></iframe>
	
	<form id="content_form" method="post" style="clear: both;" enctype="multipart/form-data">
		<input type="hidden" name="action" value="${empty(req.bd_id) ? 'i' : 'u' }">
		<input type="hidden" name="_ps" value="${req._ps }">
		<input type="hidden" name="bd_id" value="${req.bd_id }">
		<input type="hidden" name="bd_cat" value="${req.bd_cat }">
		<input type="hidden" id="bd_key" name="bd_key" value="${req.bd_key }">
		<table style="width: 100%">
			<tr >
				<td width="50"><b>제 목 : </b></td>
				<td><input type="text" name="title" id="title" title="제목" style="width: 95%;" value="${row.title }" valid="[['notempty'],['maxlen:50']]"></td>
				<c:if test="${session.myGroups[req.bd_cat] }">
					<td width="100" align="right"><input type="checkbox" name="notice" id="notice" value="Y"  ${row.notice=='Y' ? 'checked="checked"' : '' } style="margin-top:5px;">
					<label for="notice">공지여부</label></td>
				</c:if>
			</tr>
			<c:if test="${req.bd_cat=='ser' }">
				<tr>
					<th width="55">노출일:</th>
					<td><input type="text" name="disply_date" id="disply_date" class="datepicker" readonly="readonly" title="노출일" style="width: 95%;" value="${row['disply_date@yyyy-MM-dd'] }" valid="[['notempty'],['maxlen:50']]"></td>
				</tr>
			</c:if>
		</table>
		
		<textarea name="ir1" id="ir1" title="내용" rows="10" cols="100" style="width:100%; height:412px; display:none;" valid="[['notempty'],['maxlen:1900000']]"></textarea>
		
		<table class="bd" style="width:100%; clear:both;padding: 5px;;">
			<tr><td colspan="2"></td></tr>
			
			<tr><td width="60">
				첨부파일
			</td><td>
				<c:forEach var="item" items="${rset.attrows }">
					<span  id="${item.file_id }">
						<a style=" margin-left: 5px;" href="#" onclick="del_attach(${req.bd_id },'${item.file_id}')" style="margin-right: 10px;"><img title="삭제" border="0" src="images/icon/${session.user_id==item.reg_id ? 'Close-icon.png' : 'Actions-window-close-icon.png'}"></a>
						${uf:fileName(item.file_id) }
						<br>
					</span>
				</c:forEach>
				<input style="width: 250px;" type="file" name="file_id" title="첨부파일" >
			</td></tr>
			
			<c:if test="${session.user_id=='guest' }">
				<tr><td>
					별명
				</td><td>
					<input style="width: 250px;" type="text" name="reg_nickname" title="별명" value="${empty(row.reg_nickname) ? uf:urlDec(cookie.save_nick.value,'utf-8') : row.reg_nickname}" valid="[['notempty'],['maxlen:20']]">
					<input type="checkbox" name="save_nick" id="save_nick" value="Y" ${empty(cookie.save_nick.value) ? '' : 'checked="checked"'} >
					<label for="save_nick" style="vertical-align:middle;">:별명저장</label>
				</td></tr>
			</c:if>
			<c:if test="${session.user_id=='guest' || !empty(row.pw) }">
				<tr>
					<td>
						비밀번호
					</td>
					<td>
						<input style="width: 250px;" type="password" id="pw" name="pw" title="비밀번호" valid="[['notempty'],['maxlen:20']]">
					</td>
				</tr>
			</c:if>
			<c:if test="${req.bd_cat=='pst'}">
				<tr>
					<td colspan="2" align="right">					
						<input type="checkbox" name="security" id="security" value="Y" ${row.security=='Y' || empty(row.security) ? 'checked="checked"' : '' }>
						<label for="security" style="vertical-align:middle;">목사님만 읽어주세요.</label>
					</td>
				</tr>
			</c:if>
			<c:if test="${!empty(session.nick_name) }">
				<input type="hidden" name="reg_nickname" title="닉네임" value="${session.nick_name }">
			</c:if>

		</table>
	</form>
	<p>

	<table style="width: 100%">
		<tr>
			<td width="250"></td>
			<td></td>
			<td width="250">
				<a style="float:right;" class="cc_bt" href="#" onclick="goPage(${req.pageNo})">목 록</a>
				<a href="#" class="cc_bt" onclick="form_submit()" style="float: right;margin-right: 10px;">저 장</a>
			</td>
		</tr>
	</table>
	
	<div id="_contemts" style="display: none;">${row['CONTENTS@dec'] }</div>
	
	