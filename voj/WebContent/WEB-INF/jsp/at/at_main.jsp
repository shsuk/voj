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
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<link href="./css/contents.css" rel="stylesheet" type="text/css" />
<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css"/>
<link href="./jquery/dynatree/doc/skin-custom/custom.css" rel="stylesheet" type="text/css" />

<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="./jquery/js/jquery.json-2.3.js"></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>
<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="./jquery/js/excanvas.min.js"></script><![endif]-->
<script src="./jquery/js/jquery.dynatree.js" type="text/javascript"></script>

<script src="./jquery/flot/jquery.flot.js"></script>
<script src="./jquery/flot/jquery.flot.pie.js"></script>

<script src="./at.sh?_ps=js/message" type="text/javascript" ></script>
<script src="./js/graph.js" type="text/javascript" ></script>
<script src="./js/commonUtil.js"></script>
<script src="./js/web.js"></script>
<script src="./js/formValid.js" type="text/javascript" ></script>
<style>
	h3 { margin: 0; padding: 0.2em;}
</style>
<script type="text/javascript">
var _ps = 'at/at';
var _q = '';
var _ps_update = 'at/at_update';

function test(a){
	var c=1;
}

function win_load(param, title, options, ctl, action){
	__win_load(param, title, options, ctl, action);
}

$(function($) {

	if(IE) $('body').addClass('ui-widget-content');

	//기본 팝업창 초기화
	detail_dialog();
	sub_detail_dialog();
	//문서가 로딩되면서 초기화되어야 할 내용 초기화 한다.
	ready_init();
	//팝업창 최대화 처리
	dialog_max_event();

	$(document).on('click','#checkboxAll',function( event ) {
		var isChecked = ($('#checkboxAll:checked').length>0) ? true : false;
		var ctls =  $('[name=checkbox]');
		for(var i=0; i<ctls.length; i++){
			var ctl = $(ctls[i]);
			ctl.val([isChecked ? ctl.attr('value') : '']);
		}
	});

	$(document).on('click','th[sort=true]',function( event ) {
		var t = $(event.target);
		sort(t.attr('value'), t.attr('opt'));
	});

	$(document).on('change','.datepicker[name=start_date]',function( event ) {
		var end_date = $('.datepicker[name=end_date]');

		if(end_date.length < 1) return;
		var start_date = $(event.target);
		if(start_date.val() > end_date.val()) {
			alert('시작일이 끝날짜 보다 클 수 없습니다.');
			start_date.val(end_date.val());
		};
	});

	$(document).on('change','.datepicker[name=end_date]',function( event ) {
		var start_date = $('.datepicker[name=start_date]');

		if(start_date.length < 1) return;
		var end_date = $(event.target);
		if(start_date.val() > end_date.val()) {
			alert('끝날짜가 시작일이 보다 작을 수 없습니다.');
			end_date.val(start_date.val());
			return false;
		};

		return true;
	});

});
//활성화된 탭을 초기화 한다.
function changeTab(target){	
	var form = getForm("#_detail");
	var _params_delete = $('input[name=_params_delete]',form).val();
	var _button_edit = $('input[name=_button_edit]',form).val();
	var _button_add = $('input[name=_button_add]',form).val();

	$('#btn_del').show();
	$('#btn_edit').show();
	$('#btn_add').show();

	if(_button_edit==''){
		$('#btn_edit').hide();
	}
	if(_params_delete==''){
		$('#btn_del').hide();
	}
	if(_button_add==''){
		$('#btn_add').hide();
	}

}

function win_load_button(param, title, options, ctl){
	win_load(param, title, options);
}
function fwin_load_button(param, title, options){
	fwin_load(param, title, options);
}
function enter_event(){
	$('.button_search' ).trigger('click');
	return false;

}
//문서가 로딩되면서 초기화되어야 할 내용을 기술한다.
function ready_init(){
	//$('div[onclick^="button("]').button();
	//$('div[onclick^="win_load_button("]').button();
	//$('div[onclick^="fwin_load_button("]').button();
	$( document ).tooltip();
	//윈도우와 다이얼로그 창 리싸이징 시 레이아웃 조정.
	$(window).trigger('resize');
	setTimeout(function(){resizeStopDialog();}, 300);

	$('.table_tabs' ).tabs();
	$('.table_tabs li' ).bind( "click", function(event, ui) {
		setTimeout(function(){changeTab(this);}, 100);
	});

	var button_searchs = $('.button_search' );
	$.each(button_searchs, function(i, button){
		var button_search = $(button);
		if(button_search.attr('isButton') != 'true'){
			button_search.button({icons: {primary: "ui-icon-search"}}).click(function( event ) {
				var form = findParent(this, 'FORM');
				goPage(1,form.attr('name'));
			});
			button_search.attr('isButton', 'true');
		}
	});

	var button_adds = $('.button_add' );
	$.each(button_adds, function(i, button){
		var button_add = $(button);
		if(button_add.attr('isButton') != 'true'){
			button_add.button({icons: {primary: "ui-icon-document"}}).click(function( event ) {
				add($('.button_add' ).attr('value') );
			});
			button_add.attr('isButton', 'true');
		}
	});

	var button_actions = $('.button_action' );
	$.each(button_actions, function(i, button){
		var button_action = $(button);
		if(button_action.attr('isButton') != 'true'){
			var icon = button_action.attr('icon');
			var opt = {icons: {primary: icon}};
	
			button_action.button(opt).click(function( event ) {
				eval($(this).attr('value'));
			});
			button_action.attr('isButton', 'true');
		}
	});
	//날짜필드 처리
	 var option = {
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월' ],
		dayNamesMin: ["일","월","화","수","목","금","토"],
		dateFormat: 'yy-mm-dd'
	};
	$('.datepicker').datepicker(option);
	//숫자 필드 처리
	$('.spinner').spinner({min: 0,});

	//리스트형 입력폼 항목 삭제버튼 생성
	$('.del_item' ).button({icons: {primary: "ui-icon-minus"},text: false}).click(function( event ) {
		if($(this).attr('type')=='+' || $(this).attr('type')==''){
			$(this).parent().parent().parent().remove();
			befData['_icnt'] = befData['_icnt'] - 1;
		}else{
			if(!confirm('삭제 정보가 반영됩니다.\n항목을 삭제할까요?')) return;
			var params = {
				__ISLIM_TOKEN__ : $('[name=__ISLIM_TOKEN__]',$('#_detail')).val(),
				_params_insert : $('[name=_params_insert]',$('#_detail')).val(),
				_params_update : $('[name=_params_update]',$('#_detail')).val(),
				_params_delete : $('[name=_params_delete]',$('#_detail')).val()
			};

			$.getJSON('at.sh?'+$(this).attr('param'), params, function(data) {
				if(data.success){
					addItem(0);
				}else{
					msg(lang(data.error_id, [], data.error_message));
				}
			});
		}
	});
	//리스트형 입력폼 항목 추가버튼 생성
	$('.add_item' ).button({icons: {primary: "ui-icon-plus"},text: false}).click(function( event ) {
		if(!confirm('정보가 초기화됩니다.\n변경된 자료가 있으면 저장하세요.\항목을 추가할까요?')) return;

		var delItem = $('.del_item' );
		if(delItem.length==1 && delItem.attr('type')==''){//빈 아이템이 하나인 경우
			addItem(2);
		}else{
			addItem(1);
		}
	});
}

function addItem(add){
	befData['_icnt'] = befData['_icnt'] ? befData['_icnt']+add : add;
	load(befData,befParam);
}

function sort(key, opt){
	$('[name=_sort_val]').val(' ORDER BY ' + key + (opt=='a' ? ' asc' : ' desc '));
	$('[name=_sort_key]').val(key);
	$('[name=_sort_opt]').val(opt);
	goPage(1,$(".button_search" ).attr('value'));
}

function file(id ){
	document.location.href = 'at.sh?_ps=at/upload/dl&file_id=' + id;
}

function detail_dialog(){
	var dialog = $( "#_detail" );
	dialog.dialog({
		autoOpen: false,
		minHeight : 500,
		minWidth : 700,
		height:'auto',
		width: '80%',
		modal: true,
		show: "blind",
		hide: "clip",
		open: function( event, ui ) {
			var wh = $(window).outerHeight();
			if($('#_detail' ).outerHeight() > wh){
				$( "#_detail" ).dialog( "option", "height", wh-40 );
			}
			setTimeout(function(){resizeStopDialog();}, 100);
		},
		resizeStop: function( event, ui ) {
			setTimeout(function(){resizeStopDialog();}, 100);
		},
		beforeClose: function( event, ui ) {
			$( "#_detail" ).empty();
		},
		buttons: [
			{id:'btn_del', text: "삭 제",click: function(e) {
				delete_form(this);
			}},
			{id:'btn_edit', text: "수 정",click: function(e) {
				edit(this);
			}},
			{id:'btn_add', text: "등 록",click: function(e) {
				var form = getForm(this);

				var params = $('input[name=_button_add]', form).val();
				view_sub('', params, '등록', true);
			}},
			{id:'btn_save',  text: "저 장", click: function(e) {
				submit_form(this, function(){
					//페이지 새로고침
					goPage(0, goPage_formName);

					$("#_detail").dialog('close');
				});
			}},
			{id:'btn_view',  text: "취 소", click: function(e) {
				view_back();
			}},
			{id:'btn_close',  text: "닫 기", click: function(e) {
				$( "#_detail" ).empty();
				$( this ).dialog( "close" );
			}}
		]
	});

}

function closeCtlWin(fld_name){
	var dialog = $( "#path_" + fld_name );
	dialog.empty();
	dialog.dialog( "close" );
	
}

function resizeCtlWin(fld_name,width){
	setTimeout(function(){
		$( "#path_" + fld_name).dialog({ width: width });	
	}, 100);

	
}

function sub_detail_dialog(){
	var dialog = $( "#_sub_detail" );
	dialog.dialog({
		autoOpen: false,
		minHeight : 500,
		minWidth : 700,
		height:'auto',
		width: '70%',
		modal: true,
		show: "blind",
		hide: "clip",
		open: function( event, ui ) {
			var wh = $(window).outerHeight();
			if($('#_sub_detail' ).outerHeight() > wh){
				$( "#_sub_detail" ).dialog( "option", "height", wh-40 );
			}
			setTimeout(function(){resizeStopDialog();}, 100);
		},
		resizeStop: function( event, ui ) {
			setTimeout(function(){resizeStopDialog();}, 100);
		},
		beforeClose: function( event, ui ) {
			$( "#_sub_detail" ).empty();
		},
		buttons: [
			{id:'btn_del_sub_detail', text: "삭 제",click: function(e) {
				delete_form(this);
			}},
			{id:'btn_save_sub_detail',  text: "저 장", click: function(e) {
				submit_form(this, function(){
					//페이지 새로고침
					goPage(0, goPage_formName);

					$( "#_sub_detail").dialog('close');
				});
			}},
			{id:'btn_close_sub_detail',  text: "닫 기", click: function(e) {
				$( "#_sub_detail" ).empty();
				$( this ).dialog( "close" );
			}}
		]
	});

}

//삭제
function delete_form(target){
	var form = getForm(target);
	var params = $('input[name=_params_delete]',form).val();

	if(!confirm('자료를 삭제하시겠습니까?')) return false;

	var formData =$(form).serializeArray();
	if(params.indexOf('_ps=')<0) formData = addFormValue(formData, {_ps: _ps_update});
	var url = $(form).attr('action') + '?' + params;
	formData = removeFormValue(formData, url);

	$.post(url, formData, function(response, textStatus, xhr){
		var data = $.parseJSON(response);

		if(data.success){
			//페이지 새로고침
			goPage(0, goPage_formName);
			$("#_detail").dialog('close');
		}else{
			msg(lang(data.error_id, [], data.error_message));
		}
	});
	return false;
}


//데이타 읽기
var befData = '';
var befParam = '';
var befTitle = '상세정보';
function load(data, param, collback, target){
	befData = data;
	befParam = param;
	var target_id = target ? target : "#_detail";
	var win = $(target_id);

	win.load('at.sh?'+param, data, function() {

		win.dialog('open');
		var height = win.dialog('option', 'height');
		if(height==='auto') height = win.outerHeight();
		height = height > $(document).outerHeight() ? $(document).outerHeight() : height;
		win.dialog('option', 'height', height);

		//활성화된 탭을 초기화 한다.
		if(data['_t']!='add' && data['_t']!='edit') setTimeout(function(){changeTab(win);}, 100);

		if(collback) collback();
	});
}

function getForm(target){
	var select_tab_body = '';
	var tabs = $('.table_tabs', target);
	
	if(tabs.length>0){
		var selected = tabs.tabs( 'option', 'active' );
		select_tab_body = $($('.table_tabs>div',target)[selected]);
	}else{
		select_tab_body = $(target);
	}

	return $('form', select_tab_body);
}

//신규 입력폼
function add(formName){
	var form = $('form[name="'+formName+'"]');

	var data = {
		_t: 'add',
		_ps: _ps
	};
	var params = $('input[name=_button_add]', form).val().split(',');
	//if(params) addObject(data, params);
	var title = params.length>1 ? params[1] : befTitle;
	befTitle = title;

	$("#_detail").dialog('option', 'title', title);

	load(data, params[0].trim(), function(){
		$('#btn_del').hide();
		$('#btn_edit').hide();
		$('#btn_add').hide();
		$('#btn_view').hide();
		$('#btn_close').show();
		$('#btn_save').show();
	});

}
//수정폼
function edit(target){
	var form = getForm(target);

	var data = {
		_t: 'edit',
		_ps: _ps
	};
	var params = $('input[name=_button_edit]', form).val();
	//if(params) addObject(data, params);

	load(data, params, function(){
		$('#btn_del').hide();
		$('#btn_edit').hide();
		$('#btn_add').hide();
		$('#btn_view').show();
		$('#btn_close').hide();
		$('#btn_save').show();
	});

}

//조회폼
function button(q, param, ctl, isEdit){
	view(q, param, ctl, isEdit);
}

function view_back(){
	view(view_history['q'], view_history['param'], view_history['isEdit'], view_history['callBack']);
}
var view_history = {};

function view(q, param, ctl, isEdit, callBack){
	view_history['q'] = q;
	view_history['param'] = param;
	view_history['ctl'] = ctl;
	view_history['isEdit'] = isEdit;
	view_history['callBack'] = callBack;

	var title = befTitle;

	if(ctl){
		if(typeof ctl == 'string') title = ctl;
		else title = $(ctl).text().trim();
	}

	if(title==''){
		title = befTitle;
	}
	
	befTitle = title;

	$("#_detail").dialog('option', 'title', title);

	_q = q;
	var data = {_t: 'view', _ps: _ps, _q:q};

	load(data, param, callBack);

	if(isEdit===false){
		$('#btn_edit').hide();
	}else{
		$('#btn_edit').show();
	}
	$('#btn_del').hide();
	$('#btn_add').hide();
	$('#btn_save').hide();
	$('#btn_close').show();
	$('#btn_view').hide();
}

function view_sub(q, param, ctl, isEdit){

	if(ctl){
		if(typeof ctl == 'string') title = ctl;
		else title = $(ctl).text().trim();
	}

	if(title==''){
		title = 'xxx';
	}
	
	$("#_sub_detail").dialog('option', 'title', title);

	var data = {};

	if(q!=null && q!='') {
		data['_t'] = 'edit';
		data['_q'] = q;
	}else{
		data['_t'] = 'add';
	}
	
	load(data, param, function(){
		//수정삭제 버튼 처리
		var form = getForm("#_sub_detail");
		var _params_delete = $('input[name=_params_delete]',form).val();
		var _button_edit = $('input[name=_button_edit]',form).val();

		$('#btn_del_sub_detail').show();
		$('#btn_edit_sub_detail').show();

		if(_button_edit==''){
			$('#btn_edit_sub_detail').hide();
		}
		if(_params_delete==''){
			$('#btn_del_sub_detail').hide();
		}
	}, "#_sub_detail");
}

function selectTab(id){
	if(id=='') return;

	setTimeout(function(){
		try {
			$(".table_tabs" ).tabs('select', id);
		} catch (e) {
			
		}
	}, 300);

}

function valedForm(from){
	var form = $('form', from);

	if($(form).attr('isSubmit')==='true') return false;
	//폼 정합성 체크
	var isSuccess = $.valedForm($('[valid]',form));
	if(!isSuccess){
		return false;
	}else{
		return true;
	}
}
//페이지 변경
var goPage_formName = '';

function goPage(pageNo, formName){
	var target_layer = '';
	var at_tops =  $('.at_top');
	for(var i=0; i<at_tops.length; i++){
		var at_top = at_tops[i];
		if($('form[name="'+formName+'"]', at_top).length>0){
			target_layer = $(at_top).parent();
			break;
		}
	}

	if($(target_layer).attr('id')=='_detail'){
		view_back();
		return;
	}
	goPage_formName = formName;
	var data = {};
	
	var fields = $('form[name="'+formName+'"]').serializeArray();
	$.each(fields, function(i, field){
		data[field.name] =field.value;
	});

	if(pageNo!=0){
		data['pageNo'] = pageNo;
	}

	$(target_layer).load('at.sh', data);
}

//폼 전송이벤트를 ajax post로 전송
function submit_form(target, callback){
	var form = getForm(target);

	if($(form).attr('isSubmit')==='true') return false;
	//폼 정합성 체크
	var isSuccess = $.valedForm($('[valid]',form));
	if(!isSuccess) return false;

	var _t = $('[name=_t]', form).val();
	//등록 수정 여부를 판단한다.
	var type = _t=='add' ? '_params_insert' : '_params_update';
	var params = $('input[name='+type+']',form).val();

	var formData =$(form).serializeArray();
	if(params.indexOf('_ps=')<0) formData = addFormValue(formData, {_ps: _ps_update});
	
	var url = $(form).attr('action') + '?' + params;
	formData = removeFormValue(formData, url);

	if($(form).attr('isSubmit')==='true') return false;
	$(form).attr('isSubmit',true);

	$.post(url, formData, function(response, textStatus, xhr){
		$(form).attr('isSubmit',false);

		var data = $.parseJSON(response);

		if(data.success){
			if(callback) {
				callback();
			}
		}else{
			msg(lang(data.error_id, [], data.error_message));
		}
	});
	return false;
}

function default_submit(action, form, callback){

	if($(form).attr('isSubmit')==='true') return false;
	//폼 정합성 체크
	var isSuccess = $.valedForm($('[valid]',form));
	if(!isSuccess) return false;

	var type = action=='c' ? '_params_insert' : (action=='d' ? '_params_delete' : '_params_update');
	var params = $('input[name='+type+']',form).val();

	var formData =$(form).serializeArray();
	if(params.indexOf('_ps=')<0) formData = addFormValue(formData, {_ps: _ps_update});
	var url = $(form).attr('action') + '?' + params;
	formData = removeFormValue(formData, url);

	if($(form).attr('isSubmit')==='true') return false;
	$(form).attr('isSubmit',true);

	$.post(url, formData, function(response, textStatus, xhr){
		$(form).attr('isSubmit',false);

		var data = $.parseJSON(response);

		if(data.success){
			//페이지 새로고침
			goPage(0, goPage_formName);
		}else{
			msg(lang(data.error_id, [], data.error_message));
		}

		if(callback) callback(data.success);
	});
	return false;
}

</script>
</head>
<body style="border:0px; overflow: auto;margin: 0 0 0 0;padding: 0 0 0 0;">
<div style="position: absolute;"><a href="atm.sh?<%=request.getQueryString() %>" target="_new">새창</a></div>
<div id="_content_main_">
	<div id="_list" style="" desc="기본적으로 로딩되는 정보">
		<c:if test="${req._q!='' && req._q!=null}">
			<jsp:include page="at.jsp"  />
		</c:if>
		<c:if test="${req._q=='' || req._q==null}">
			<c:if test="${req._ps!='' && req._ps != null}">
				<jsp:include page="../${req._ps }.jsp"  />
			</c:if>
		</c:if>
	</div>
	<div id="_detail" title="상세정보" desc="팝업창으로 보여지는 정보"></div>
	<div id="_sub_detail" title="상세정보" desc="팝업창으로 보여지는 정보"></div>
</div>
<div id="_win_detail" title="상세정보" desc="비정규적인 팝업창"></div>
</body>
</html>