<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Html에티터를 이용한 문서작성</title>
<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="./js/commonUtil.js"></script>
<script src="./js/formValid.js" type="text/javascript" ></script>
<style type="text/css">
.ui-datepicker {
    font-size: 12px;
}

</style>
<script type="text/javascript">
$(function() {
	//속성창 변경시 콘트롤 속성변경
	$('.ctl_val').change(function(e,e2){
		var ctl = $(this);
		$('.tpl_colum').attr(ctl.attr('name'), ctl.val());
		setAttr($('.tpl_colum[type=text]'));
	});
	var option = {
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월' ],
		dayNamesMin: ["일","월","화","수","목","금","토"],
		dateFormat: 'yy-mm-dd',
		changeYear: true,
		changeMonth: false
	};
	$('.datepicker').datepicker(option);
	$('#save_btn').button({icons: {primary: "ui-icon-disk"}}).click(function(){
		form_submit();
	});
});
function form_submit(){	
	var form = $('#content_form');
	if(form.attr('isSubmit')==='true') return false;

	//폼 정합성 체크
	var isSuccess = $.valedForm($('[valid]',form));
	if(!isSuccess) return false;			

	
	var formData =$(form).serializeArray();
	
	
	if($(form).attr('isSubmit')==='true') return false;
	$(form).attr('isSubmit',true);

	var url = 'saveSrc.sh';
	$.post(url, formData, function(response, textStatus, xhr){
		$(form).attr('isSubmit',false);

		var data = $.parseJSON(response);

		if(data.success){

		}else{
			alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
		}
	});
	return false;
}
</script>
</head>
<body id="body">
<center>
<form id="content_form">
<src>
$BODY$
</src>
</form>
<div id="save_btn">저장</div>
</center>
</body>
</html>