<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="ptu"  tagdir="/WEB-INF/tags/user" %> 
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>ISlim</title>
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />

<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css"/>
<link href="./css/contents.css" rel="stylesheet"  id="css" />

<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="./jquery/js/jquery.cookie.js"></script>
<script src="./jquery/js/jquery.dynatree.js" type="text/javascript"></script>

<script src="./js/formValid.js" type="text/javascript" ></script>
<script src="./js/commonUtil.js"></script>
<script type="text/javascript">
	String.prototype.formatNumber=function(){
		return this.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
	};
	
	$(function() {

		$('#send_mail').button({icons: {primary: "ui-icon-disk"}}).click(function(){
			form_submit('at.sh', false);
		});
		$( '#act_data' ).on( 'keyup', 'input[name=price]', function() {
			sumPrice();
		});
	});
	function addRow(){
		$('#act_data').append($('#act_tpl').html());
	}
	function delRow(ctl){
		$(ctl).parent().parent().remove();
		sumPrice();
	}
	function sumPrice(){
		var sumPrice = 0;
		var priceCtl = $('input[name=price]', '#act_data');
		
		for(var i=0; i<priceCtl.length;i++){
			var val = parseInt($(priceCtl[i]).val(),10);
			if(val){
				sumPrice += val;
			}
		}
		$('#sumPrice').text((''+sumPrice).formatNumber()+'원');
	}

	function form_submit(url, noCheck){

		var form = $('form');
		if(form.attr('isSubmit')==='true') return false;
		//폼 정합성 체크
		if(! noCheck){
			var isSuccess = $.valedForm($('[valid]',form));
			if(!isSuccess) return false;						
		}
		
		var formData =$(form).serializeArray();
		
		
		if($(form).attr('isSubmit')==='true') return false;
		$(form).attr('isSubmit',true);
		mask();
	
		$.post(url, formData, function(response, textStatus, xhr){
			$(form).attr('isSubmit',false);
	
			var data = $.parseJSON(response);
	
			if(data.success){
				alert('처리되었습니다.\n재전송되는 것을 방지하기 위해 폼을 막았습니다.\n새로고침 하세요.');
			}else{
				alert('처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n' + data.error_message);
			}
			//mask_off();
		});
		return false;
	}
</script>
</head>
<body>
<div style="text-align: center;margin:auto;width: 350px;">
	<br><br><br>
	<form method="post" action="at.sh">
		<b>메일보내기</b><br><br>
		<input type="hidden" name="_ps" value="test/mail">
		<table  style="width: 100%;" class="ui-widget ui-widget-content contents-contain">
			<tr><th class="ui-state-default">제목 : </th><td><input type="text" name="subject" title="제목" valid="[['notempty']]" style="width: 100%;" ></td></tr>
			<tr><th class="ui-state-default">합계 : </th><td id="sumPrice"></td></tr>
		</table>
		<table style="width: 100%;"  class="ui-widget ui-widget-content contents-contain">
			<thead>
				<tr class="ui-state-default"><th>금액</th><th>내용</th><th><a href="#" onclick="addRow()" title="행추가"><img src="images/icon/document-add-icon.png"></a></th></tr>
			</thead>
			<tbody id="act_data">
				<tr><td><input type="text" title="금액" name="price" valid="[['notempty'],['numeric']]"></td><td><input type="text" name="message" title="내용" valid="[['notempty']]"></td><td></td></tr>
			</tbody>
		</table>
		(도움말,프로젝트,계정,청구목록,회사주소)
		
	</form>
	<button id="send_mail">전송</button>
	<table style="display: none;">
		<tbody id="act_tpl">
			<tr><td><input type="text" title="금액" name="price" valid="[['notempty'],['numeric']]"></td><td><input type="text" name="message" title="내용" valid="[['notempty']]"></td><td><a href="#" onclick="delRow(this)" title="행삭제"><img src="images/icon/Close-2-icon.png"></td></tr>
		</tbody>
	</table>
</div>
</body>
</html>