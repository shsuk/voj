<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title></title>

<link href="./css/contents.css" rel="stylesheet" type="text/css" />
<link href="./jquery/development-bundle/themes/cupertino/jquery.ui.all.css" rel="stylesheet"  id="css" >
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css">
<link href="./jquery/dynatree/doc/skin-custom/custom.css" rel="stylesheet" type="text/css" >

<script src="./jquery/js/jquery-1.7.2.min.js"></script>
<script src="./jquery/js/jquery-ui-1.8.20.custom.js"></script>
<script src="./jquery/js/jquery.json-2.3.js"></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>

<script src="./jquery/js/jquery.dynatree.js" type="text/javascript"></script>
<script src="./js/commonUtil.js"></script>
<script src="./js/formValid.js" type="text/javascript" ></script>
<style>
	h3 { margin: 0; padding: 0.2em;}
</style>
<script type="text/javascript">


$(function() {
	$(".button_load" ).button().click(function( event ) {
		$('#cols').load('at.sh?_t=edit&_ps=admin/valid/valid_cols&_q='+$('#_q').val(),function(){
			$('#all_cols').click(function( event ) {
				var sel = $('#all_cols:checked').length>0 ? true : false;
				
				var cols = $('.cols');
				$.each(cols, function(idx, ctl){
					$(ctl).attr('checked', sel);
				});
			});

		});
	});
	
	$(".button_valid" ).button().click(function( event ) {
		var valid_val = $('#val_list').val().trim();
		if(valid_val=='') return;

		var cols = $('.cols:checked');
		$.each(cols, function(idx, ctl){
			var nm = $(ctl).attr('value');
			$('[col='+nm+']').val(valid_val);
		});
	});
	
	$(".button_valid_add" ).button().click(function( event ) {
		var valid_val = $('#val_list').val().trim();
		if(valid_val=='') return;
		
		var cols = $('.cols:checked');
		$.each(cols, function(idx, ctl){
			var nm = $(ctl).attr('value');
			var tar = $('[col='+nm+']');
			var val = tar.val();
			val = val=='' ? '' : val + ',';
			tar.val(val + valid_val);
		});
	});
	
	$(".button_uq" ).button().click(function( event ) {
		var query = 'UPDATE xxx <br>SET';
		var cols = $('.cols:checked');
		$.each(cols, function(idx, ctl){
			var nm = $(ctl).attr('value');
			query += '<br> ' + nm + ' = @{'+nm+'},';
		});
		query = query.substring(0,query.length-1) + '<br>WHERE ';
		query = '<div style="height:400px;overflow:auto;">' + query + '</div>';
		msg(query);
	});
	
	$(document).on('change', "#path", function( event ) {
		var path = $('#path').val();
		if(path.indexOf('.sql')>0){
			var _q = path.substring(1,path.length-4);
			$('#_q').val(_q);
			var url = 'at.sh?_ps=at/at_main&_t=list&_q='+_q;
			$('#url_path').html('<a target="_new" href="'+url+'">'+url+'</a>');
			return;
		}
		$('.path').load('at.sh?_ps=admin/valid/dir',{path:path});
	});
	
	$(".button_iq" ).button().click(function( event ) {
		var query = 'INSERT INTO xxxx(';
		var values = 'VALUES(';
		var cols = $('.cols:checked');
		$.each(cols, function(idx, ctl){
			var nm = $(ctl).attr('value');
			query += '<br> ' + nm+',';
			values += '<br> @{'+nm+'},';
		});
		query = query.substring(0,query.length-1) + '<br>)' + values.substring(0,values.length-1) + '<br>)';
		
		query = '<div style="height:400px;overflow:auto;">' + query + '</div>';
		msg(query);
	});

	$(".button_save" ).button().click(function( event ) {
		var formData = $('#col_form').serializeArray();
		var url = 'at.sh?_q='+$('#_q').val();
		
		$.post(url, formData, function(response, textStatus, xhr){			
			try{
				var data = $.parseJSON(response);
				
				if(data.success){
					$(".button_load").trigger('click');
					msg('처리가 완료되었습니다.');
				}else{
					msg('처리중 오류가 발생하였습니다.');
				}
			}catch(e){
				msg('처리중 오류가 발생하였습니다.');
			};
		});

	});
	
	
	var opt = '';
	$.each($.valedFunction, function(key, value){
		var fnc = value + '';
		var val = fnc.substring(fnc.indexOf('//[')+2, fnc.indexOf(']')+1);
		val = val.indexOf('[')==0 ? val : "['" + key + "']";
		opt += '<option value="' + val + '">' + key + '</option>';
		$('#_detail').append('<div class="func" id="' + key + '" style="display: none;"><pre>'+value+'</pre></div>');
	});
	
	$('#function').append(opt).click(function(event) {
		$('.func' ).hide();
		var opt = $(event.target);
		var key = opt.text();
		var val = opt.val();
		$('#val_list').val($(this).val());
		//$('#key').text(key);
		//$('#value').text(val);
		$('#'+key).show();
	});
});


</script>
</head>
<body style="margin: 0 0 0 0;padding: 0 0 0 0;overflow:auto;"">
<div id="url_path"></div>
<table style="width:99%; height:90%;style="margin: 3px 3px 3px 3px;padding: 3px 3px 3px 3px;"">
	<tr>
		<td valign="top">
			<table border="0" style="width:100%; height: 100%">
				<tr style="width:100%; height: 30px">
					<td colspan="3">
						<div class="path button-l" style="width:200px; padding-top: 7px; "><jsp:include page="dir.jsp"/></div>
						<div class="button-l"  style="padding-top: 7px; "><input type="text" name="_q" id="_q" class="path left" value=""></div>
						<button class="button_load button-l">조회</button>
						<button class="button_iq button-l">Insert</button> 
						<button class="button_uq button-l">Update</button>
						<div class="button-l"  style="width:20px;"></div>
						<button class="button_save button-l" >저장</button>

						<div class="button-r" ><button class="button_valid">수정</button></div>
						<div class="button-r" ><button class="button_valid_add">추가</button></div>
						<div class="button-r"  style="padding-top: 7px; "><input type="text" id="val_list" style="width:163px;"></div>
						<div class="button-r" style="padding-top: 10px; " >정합성 체크 :</div>
					</td>
				</tr>
				<tr>
					<td valign="top">
						<form id="col_form" action="">
							<input type="hidden" name="_ps" value="admin/valid/valid_save">
							<div id="cols"  style="width:100%; height:600px;border: 1px solid #d4d4d4; overflow:auto;"></div>
						</form><br>
					</td>
					<td width="5">
					</td>
					<td valign="top" width="300">
						<table style="width:300px; height: 100%">
							<tr  style="height: 250px;">
								<td colspan="5"  valign="top">
									<select  id="function" multiple="multiple" size="100" style="height: 250px; width: 100%" ></select>
								</td>
							</tr>
							<tr>
								<td colspan="5"  valign="top">
									<div id="_detail"  style="width:300px;height:350px;border: 1px solid #d4d4d4; overflow:auto;" title="상세정보" ></div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</body>
</html>