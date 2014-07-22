var isMobileView = true;

function win_load(param, title, options){
	//document.location.href = 'atm.sh?'+param;
	changePage('atm.sh?'+param);
}
function fwin_load(param, title, options){
	//document.location.href = 'atm.sh?'+param;
	changePage('atm.sh?'+_q+'&'+param);
}
function home(){
	changePage('at.sh?_ps=main_m');
}

function view(_q,param,ctl,t){
	//document.location.href = 'atm.sh?_t=view&_q='+_q+'&'+param;
	changePage('atm.sh?_t=view&_q='+_q+'&'+param);
}
var pageIdx = 1;
function changePage(url,data){
	if(data==null){
		data = {};
	}
	pageIdx++;
	data['pageIdx'] = pageIdx;
	
	$.mobile.navigate(url+'&pageIdx='+pageIdx,  data);

}

function historyBack(){
	
	var data = listParamData;
	
	for ( i in data ) {
		$.mobile.changePage('atm.sh', {
			type: "post",
			data: data,
			changeHash: true,
			//pageContainer: $('div[data-role=content]'),
			//role: 'collapsible-set',
			reloadPage: true
		});
		
		return;
	};	

	window.history.back();
	
}

function view_sub(q, param, ctl, isEdit){
	var url = 'atm.sh?_q='+q+'&'+param;
	var data = {};
	
	if(ctl){
		if(typeof ctl == 'string') title = ctl;
		else title = $(ctl).text().trim();
	}

	if(q!=null && q!='') {
		url += '&_t=edit';
	}else{
		url += '&_t=add';
	}
	changePage(url, data);
}

function submit_form(_t){
	var _ps_update = 'at/at_update';
	var form = $('form',$.mobile.activePage);
	if($(form).attr('isSubmit')==='true') return;
	//폼 정합성 체크
	var isSuccess = $.valedForm($('[valid]',form));
	if(!isSuccess) return;

	var type = _t=='add' ? '_params_insert' : '_params_update';
	var params = $('input[name='+type+']',form).val();

	var formData =$(form).serializeArray();
	if(params.indexOf('_ps=')<0) formData = addFormValue(formData, {_ps: _ps_update});
	var url = $(form).attr('action') + '?' + params;
	formData = removeFormValue(formData, url);

	if($(form).attr('isSubmit')==='true') return;
	$(form).attr('isSubmit',true);

	$.post(url, formData, function(response, textStatus, xhr){
		$(form).attr('isSubmit',false);

		var data = $.parseJSON(response);

		if(data.success){
			//페이지 새로고침
			historyBack();
		}else{
			alert(lang(data.error_id, [], data.error_message));
		}
	});
	return;
}

function del(param){
	var url = 'at.sh?_ps=at/at_update&'+param;
	
	if(confirm("정말로 삭제하시겠습니까?")){
		$.getJSON(url, function(data) {
			if(data.success){
				//페이지 새로고침
				historyBack();
			}else{
				alert(lang(data.error_id, [], data.error_message));
			}
		});
	}
}

var listParamData = {};

function goPage(pageNo){

	var data = {};
	
	var fields = $('form',$.mobile.activePage).serializeArray();
	$.each(fields, function(i, field){
		data[field.name] =field.value;
	});

	if(pageNo!=0){
		data['pageNo'] = pageNo;
	}
	//document.location.href = 'atm.sh?' + $.param(data, true);
	//$.mobile.navigate( 'atm.sh?' + $.param(data, true), {
	//	foo: 'bar'
	//});
	//$('div[data-role=content]').text('');
	//$.mobile.loadPage('at.sh?' + $.param(data, true),true);
	
	$.mobile.changePage('atm.sh', {
		type: "post",
		data: data
	});

	//$('div [data-role=content]', $.mobile.activePage).load('at.sh',data);
}

function keypress(e){
	return (e.keyCode!=13);
}

function enter_event(){
	goPage(1);
	return false;

}

$(function($){
	$(document).on( "pageshow", function( event ) {
		
		if($.mobile.activePage.attr('id')=='main_page'){
			listParamData = $.parseJSON($.mobile.activePage.attr('history'));
		}
	});

});
