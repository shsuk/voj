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
		<c:if test="${cookie.bd_add.value > uf:addMinutes(uf:now(),-60).time }"><%//비정상적인 접근시 글을 저장하지 않는다. %>
			<uf:organism noException="true">[
				<job:db id="row" query="voj/well/insert"/>
			]</uf:organism>
		</c:if>
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='u' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/well/update"/>
		]</uf:organism>
	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='d'}">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/well/delete"/>
		]</uf:organism>	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
</c:choose>

<uf:organism >
[
	<job:db id="row" query="voj/well/edit" singleRow="true"/>
]
</uf:organism>

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
	function del(bd_id){
		var target_layer = $('.bd_body');
		
		var url = 'at.sh';
		var data = {
				_ps:'voj/well/well_edit', 
				bd_id: bd_id,
				action:'d'
		}
	
	
		show(target_layer, url, data, true, function (){
			document.location.href = 'at.sh?_ps=voj/well/well_list&bd_id=max';
		});
	}
	
	function form_submit(){	
		var form = $('#content_form');
		if(form.attr('isSubmit')==='true') return false;

		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
		var ir = $('#ir1');
		var val = ir.val();
		

		if(val=='<br>'){
			ir.val('');
		};
		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			

		<c:if test="${session.user_id=='guest' }">
			if($('#security:checked').length>0 && $('#pw').val()==''){
				alert('로그인 없이 비밀글을 작성할 때에는 비밀번호가 필요합니다.');
				return false;
			}
		</c:if>
		
		var formData =$(form).serializeArray();
		
		
		if($(form).attr('isSubmit')==='true') return false;
		$(form).attr('isSubmit',true);

		var url = 'at.sh';
		$.post(url, formData, function(response, textStatus, xhr){
			$(form).attr('isSubmit',false);

			var data = $.parseJSON(response);
			//checkFunction(data);
			if(data.success){
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
			}
			document.location.href = 'at.sh?_ps=voj/well/well_list&bd_id=${req.bd_id}';
		});
		return false;
	}
	
</script>

<div  id="body_main">

	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		<div style="font-size: 20px;font-weight: bold;color:#2fb9d1;"><span  style="color:#a39c97;">예수마을교회</span> 
		<span> 우물가 소식</span><hr size="1" color="#a29c97" noshade><br></div>	
	</div>

	<div class="bd_body">
		
		<form id="content_form" action="sample.php" method="post" style="clear: both;">
			<input type="hidden" name="action" value="${empty(req.bd_id) ? 'i' : 'u' }">
			<input type="hidden" name="_ps" value="${req._ps }">
			<input type="hidden" name="bd_id" value="${req.bd_id }">
			<input type="hidden" name="bd_cat" value="${req.bd_cat }">
			<table style="width: 100%;border:1px solid #B6B5DB;color:#002266;margin-bottom: 5px;">
				<tr>
					<th width="55">제목:</th>
					<td><input type="text" name="title" id="title" title="제목" style="width: 95%;" value="${row.title }" valid="[['notempty'],['maxlen:50']]"></td>
				</tr>
				<tr>
					<th width="55">노출일:</th>
					<td><input type="text" name="disply_date" id="disply_date" class="datepicker" readonly="readonly" title="노출일" style="width: 95%;" value="${row['disply_date@yyyy-MM-dd']}" valid="[['notempty'],['maxlen:50']]"></td>
				</tr>
			</table>
			
			<textarea name="ir1" id="ir1" title="내용" rows="10" cols="100" style="width:100%; height:412px; display:none;" valid="[['notempty'],['maxlen:1900000']]"></textarea>
			
		</form>
		<p>
	
		<table style="width: 100%">
			<tr>
				<td width="250"></td>
				<td></td>
				<td width="250">
					<a style="float:right;margin-left: 5px;" class="cc_bt" href="at.sh?_ps=voj/well/well_list&bd_id=max" >목 록</a>
					<a href="#" class="cc_bt" onclick="form_submit();" style="float: right;margin-left: 5px;">저 장</a>
					<a href="#" class="cc_bt" onclick="del(${req.bd_id });" style="float: right;margin-left: 5px;">삭 제</a>
				</td>
			</tr>
		</table>
		
		<div id="_contemts" style="display: none;">${row['CONTENTS@dec'] }</div>
	</div>	
</div>
	