var IE = /*@cc_on!@*/false;

$(function($){
	$.browser = {};
	$.browser.msie = IE;
});

String.prototype.replaceAll = function( searchStr, replaceStr )
{
	return this.split( searchStr ).join( replaceStr );
};

String.prototype.trim = function()
{
	return this.replace(/^\s+|\s+$/g,"");
};

function autoResizePopup(width,height) {	//팝업 자동 리사이즈
	var winW, winH, sizeToW, sizeToH;

	if ( parseInt(navigator.appVersion) > 3 ) {
		 if ( navigator.appName=="Netscape" ) {
			  winW = window.innerWidth;
			  winH = window.innerHeight;
		 }
		 if ( navigator.appName.indexOf("Microsoft") != -1 ) {
			  winW = document.body.scrollWidth;
			  winH = document.body.scrollHeight;
		 }
	}

	sizeToW = 0;
	sizeToH = 0;

	if ( winW > width ) { // 제한하고자 하는 가로크기
		 sizeToW = width - document.body.clientWidth;
	} else if ( Math.abs(document.body.clientWidth - winW ) > 3 ) {
		 sizeToW = winW - document.body.clientWidth;
	}

	if ( winH > height ) {  // 제한하고자 하는 세로크기
		 szeToH = height - document.body.clientHeight;
	} else if ( Math.abs(document.body.clientHeight - winH) > 4 ) {
		 sizeToH = winH - document.body.clientHeight;
	}

	if ( sizeToW != 0 || sizeToH != 0 ) {
		 window.resizeBy(sizeToW, sizeToH);
	}
}

function addFormValue(formValue, source){
	$.each(source, function(key, value){
		formValue[formValue.length] = {name:key, value:value};
	});

	return formValue;

}

function removeFormValue(formValue, source){
	var queryData = $.getUrlData(source);
	var newFormValue = [];
	
	$.each(formValue, function(idx, data){
		var val = queryData[data.name];
		if(val==null || data.name=='url'){
			newFormValue[newFormValue.length] = data;
		}
	});

	return newFormValue;

}

function addObject(target, source){

	if(source) {
		$.each(source, function(key, value){
			target[key] = value;
		});
	}

	return target;
}


function findParent(el, tagName){
	try{
		var parents =  $(el).parents();
		for(var i=0; i<parents.length; i++){
			var parent = parents[i];
			if(parent.tagName==tagName){
				return $(parent);
			}
		}
	}catch(e){};
	return null;
}

function msg(message, callback){
	var box = $('#dialog-message');

	if(box.length<1){
		$('body').append($('<div id="dialog-message"></div>'));
		box = $('#dialog-message');
	}
	box.html(message);
	box.dialog({
		modal: true,
		buttons: {
			Ok: function() {
				if(callback) callback();
				$( this ).dialog( "close" );
			}
		}
	});
}

function fwin_load(url, title, options){
	//link:{ds_cd:"win_load('_t=edit&_ps=at/at&_q=pm/code/edit&ds_pcd=${row.ds_pcd}&ds_cd=${row.ds_cd}','ds_cd')"}
	var div = $('<div></div>');
	var frame = $('<iframe   frameborder="0" marginwidth="0" marginheight="0"  ></iframe>');
	$(div).append(frame);
	$('body').append(div);
	var dialog_options = {
		autoOpen: true,
		minHeight : 300,
		minWidth : 500,
		title: lang(title),
		height:'auto',
		width: '80%',
		modal: true,
		show: "blind",
		hide: "explode",
		open: function( event, ui ) {
			frame.attr('src',url);
			setTimeout(function(){resizeStopDialog_win_load(frame);}, 500);
		},
		resizeStop: function( event, ui ) {
			setTimeout(function(){resizeStopDialog_win_load(frame);}, 100);
		},
		beforeClose: function( event, ui ) {
			$(this).remove();
		}
	};
	addObject(dialog_options, options);
	$(div).dialog(dialog_options);
}
//iframe 다이얼로그 리사이즈 처리
function resizeStopDialog_win_load(frame){
	if(frame){
		frame.css('height', frame.parent().outerHeight()-25);
		frame.css('width', frame.parent().outerWidth()-25);
	}
}
//다이얼로그 리사이즈 처리
function resizeStopDialog(){
	//dep4
	if(!IE){
		var _detail = $('#_detail');
		var tt = $('.tab_title',  _detail);
		var th = tt.length>0 ? tt.outerHeight() : 0;
		var ah = $('.add_item',  _detail).outerHeight();

		var h = _detail.outerHeight() - th -20 -(ah ? ah : 0);

		$('.contents-detail', _detail).css('height', h);
		$('.contents-list', _detail).css('height', h-4);
	}
}
//다이얼로그창 최대화 처리
function dialog_max_event(){
	$('body').on('dblclick' ,'.ui-dialog-titlebar', function( event ) {
		var target = $(event.target);
		var dialogToggle = target.attr('dialogToggle');
		var dialog = $('.ui-dialog-content', $(target.parent()));
		var resizable = dialog.dialog( "option", "resizable" );

		if(!resizable) return;

		if(dialogToggle=='false'){
			dialog.dialog({ height: target.attr('dialogHeight'),  width: target.attr('dialogWidth')});
			dialog.dialog("option", "position", target.attr('dialogPosition'));
		}else{
			target.attr('dialogHeight', dialog.dialog( "option", "height" ));
			target.attr('dialogWidth', dialog.dialog( "option", "width" ));
			target.attr('dialogPosition', dialog.dialog( "option", "position" ));

			var windowHeight = $(frames, top).outerHeight()-35;
			var windowWidth = $(frames, top).outerWidth()-10;

			dialog.dialog({ height: windowHeight,  width: windowWidth });
			dialog.dialog("option", "position", { my: "left top", at: "left top", of: 'button' });
		}

		target.attr('dialogToggle', dialogToggle=='false' ? 'true' : 'false');

		resizeStopDialog_win_load($('iframe', $(target.parent())));
		resizeStopDialog();
	});

}
function win_load_close(id){
	var win = $('#'+id);
	win.dialog( "close" );
	win.remove();

}
var win_id_idx = 0;
function __win_load(param, title, options, ctl, action){
	var win_id = 'win_load_'+win_id_idx;
	win_id_idx++;
	var data = {win_id: win_id};

	if(ctl){
		if(typeof ctl == 'string'){
			var ctls =  $('[name='+ctl+']');

			ctls =  $(':checked[name='+ctl+']');
			var vals = '';

			for(var i=0; i<ctls.length; i++){
				vals += ",'" + ctls[i].value + "'";
			}

			if(vals == '') {
				alert('선택된 항목이 없습니다.\n 항목을 선택하세요.');
				return;
			}
			data[ctl] = vals.substring(1);

		}else{
			title = $(ctl).text();
		}
	}

	var div = $('<div id="'+win_id+'"></div>');
	$('body').append(div);
	var dialog_options = {
		autoOpen: true,
		title: lang(title),
		minHeight : 300,
		minWidth : 500,
		height:'auto',
		width: '80%',
		modal: true,
		show: "blind",
		hide: "explode",
		beforeClose: function( event, ui ) {
			$(this).remove();
		}
	};
	addObject(dialog_options, options);
	$(div).dialog(dialog_options);
	action = action ? action : 'at.sh';
	div.load(action+'?'+param, data, function() {});
}
function debug(msg){

	var debug_msg = $('#debug_msg');

	if(debug_msg.length<1){
		$('body').append($('<div style="position: absolute;" id="debug_msg"></div>'));
		debug_msg = $('#debug_msg');
	}
	debug_msg.css({'width':400,'height':100});

}
function mask(focusId){
	//Get the screen height and width
	var maskHeight = $(document).height();
	var maskWidth = $(window).width();
	//Set height and width to mask to fill up the whole screen
	var mask = $('#mask');

	if(mask.length<1){
		$('body').append($('<div style="background: #cccccc;position: absolute;top: 0px;left: 0px;z-index: 9999;" id="mask"></div>'));
		mask = $('#mask');
	}
	mask.css({'width':maskWidth,'height':maskHeight});
	var w = $(focusId).width();
	w = w<10 ? 300 : w;
	$(focusId).css({'left':maskWidth/2 - w/2});
	//transition effect

	$('#mask').fadeIn(300);	//여기가 중요해요!!!1초동안 검은 화면이나오고

	$('#mask').fadeTo("slow",0.5);   //80%의 불투명도로 유지한다 입니다. ㅋ

	if(focusId){
		$('#mask').click(function() {
			if(focusId.closed){
				$('#mask').off('click');
				$('#mask').hide();
			}else{
				focusId.focus();
			}
		});
	}
}
function mask_off(){
	$('#mask').off('click');
	$('#mask').hide();
}
function uploadDefaultStart(id,fid,result){
	var ctl = $('#'+id);
	var img = $('.'+ctl.attr('value')+'_info', ctl.parent());
	img.text(result.fileName);
}

function uploadDefaultEnd(id, fId, result){
	var ctl = $('#'+id);
	$('#attch_id_'+id).val(fId);
	var img = $('.'+ctl.attr('name')+'_info', ctl.parent());
	//img.attr('value',fId);
	img.attr('src', 'at.sh?_ps=at/upload/dl&file_id='+fId);
	img.val(result.fileName);
	img.text(result.fileName);
	
	if(this['uploadCallback']){
		eval('uploadCallback')(id, fId, result);
	}

}

function win_close(){
	$("#win_pop_main").dialog( "close" );
}
function win_open(title, url,opts){

	var win_position = 50;
	var position = [win_position, win_position];
	var options = {
		autoOpen: false,
		position: position,
		height: 'auto',
		width: 'auto',
		modal: false,
		title: title,
		close: function() {
		}
	};

	for (var key in opts) {
		options[key] = opts[key];
	}

	var win_pop_main = $('#win_pop_main');
	if(win_pop_main.length<1){
		win_pop_main = $('<div id="win_pop_main"><div id="win_pop_body"></div></div>');
		$("body").append(win_pop_main);
	}

	win_pop_main.attr('title', title);
	win_pop_main.dialog(options).dialog("open");

	$.renderPage('win_pop_body',url, null, null);

}


$(function($){

	$.getUrlData = function (query) {
		if ( typeof query == "object") return query;
		
		var data = {};
		var url = '', param = '';
		var qs = query.indexOf('?');
		var eq = query.indexOf('=');
		var am = query.indexOf('&');
		var min = (eq == -1)? am : ((am == -1)? eq : Math.min(eq,am));

		if (qs == -1) {
			if (eq == -1 && am == -1) url = query;
			else param = query;
		}else if (min == -1 || qs < min) {
			url = query.substring(0,qs);
			param = query.substr(qs + 1);
		}else{
			param = query;
		}
		data['url'] = url;
		var a = param.split('&'), b;
		
		for (var i=0,n=a.length; i<n; i++) if (a[i] !== '') {
			b = a[i].split('=');
			if (b[0] !== '') data[b[0]] = b[1] || '';
		}
		
		return data;
	};

	$.ajax$ = [];

	$.attachment={
		info: {},
		current_id: 1,
		create : function (filter){
			var fileCtls = $(filter);

			for(var i=0; i<fileCtls.length; i++){
				var cId = 'attachment_' + $.attachment.current_id++;
				var fileCtl = $(fileCtls[i]);

				if(fileCtl.attr('attachment_status')==='END') continue;

				var _w = fileCtl.innerWidth();
				var _h = fileCtl.innerHeight();
				fileCtl.attr('id', cId);
				var cName = fileCtl.attr('name');
				var cValue = fileCtl.attr('value');
				var button = fileCtl.attr('button');
				var valid = fileCtl.attr('_valid');
				var ref_tbl = fileCtl.attr('ref_tbl');
				
				button = button ? button : '';
				_w = _w<500 ? _w : '200';
				_h = _h!=0 ? _h : '22';
				var tmp1 = '<div id="'+cId+'_upload_progress" style="border: 0px solid #B2CCFF;background-color:#B2CCFF;width: 0px;height: 100%;top:0px;left:0px;z-index: 999;"></div>';
				tmp1 ='<div id="'+cId+'_upload_progress_body" style="position:absolute;width:' + _w + 'px;height:' + _h + 'px;border: 0px solid #B2CCFF;z-index: 999;">' + tmp1 + '</div>';

				fileCtlChild = $(tmp1);
				fileCtl.append(fileCtlChild);
				fileCtlChild.hide();

				var tmp2 = '<iframe   frameborder="0" marginwidth="0" marginheight="0" fileupload="Y" button="' + (button=='' ? '' : 'img' ) + '" src="./upload/uploader' + (isMobileView ? '_m' : '') + '.jsp?cId='+ cId +'&button='+ button +'&width=' + _w + 'px&height=' + _h + 'px&valid='+ valid + '&ref_tbl=' + ref_tbl +'" style="border: ' + (button=='' ? '1' : '0' ) + 'px solid ' + (isMobileView ? '#' : '#B2CCff') + ';overflow:hidden;width:' + _w + 'px;height:' + _h + 'px;" scrolling="no"></iframe>' +
							'<input type="hidden" id="attch_id_'+cId+'" name="'+cName+'" value="'+cValue+'">';
				var fileCtlChild = $(tmp2);
				fileCtl.append(fileCtlChild);

				fileCtl.attr('attachment_status','END');
			}
			
			//var img_btn = $('iframe[button!=img]');
			var img_btn = $('iframe[fileupload=Y]');
			try {
				if(!isMobileView && img_btn.length>0) img_btn.button();
			} catch (e) {

			}
		},
		startUpload : function(cId,fId){
			$('#'+cId+'_upload_progress_body').show();

			$.attachment.info[cId] = setInterval(function () {
				$.getJSON('at.sh?_ps=at/upload/monitor', {file_id:fId}, function(data){
					var result = data['result'];

					if(result){
						var callback = $('#'+cId).attr('start');
						if(callback) eval(callback)(cId, fId, result);

						var percent = result.percent;

						var percentStr = percent+'%';
						var interval = (percent>=100 ? 0 : 1000);
						$('#'+cId+'_upload_progress').animate({
							width: percentStr,
							opacity: 0.4
						},interval);

						if(percent>=100 || !result.success){
							$.attachment.endUpload(cId, fId, result);
						}
						$('#'+cId+'_upload_progress').attr('_width', percent);
					}
				});
			}, 1000);
		},
		endUpload : function(cId, fId, result){
			clearInterval($.attachment.info[cId]);

			$.attachment.info[cId] = setInterval(function () {
				$('#'+cId+'_upload_progress_body').hide();
				clearInterval($.attachment.info[cId]);
			}, 100);

			var callback = $('#'+cId).attr('end');
			if(callback) eval(callback)(cId, fId, result);
		}
	};

});

var option = {
	monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월' ],
	dayNamesMin: ["일","월","화","수","목","금","토"],
	//showOn: "button",
	//buttonImage: './images/calendar.gif',
	//buttonImageOnly: true,
	dateFormat: 'yy-mm-dd',
	changeYear: true,
	changeMonth: false

};
//문서 로딩시 초기화 처리 함수
function document_ready_init(){
	//첨부파일 처리
	$.attachment.create('.attachment');
	try{
		$('.datepicker').datepicker(option);		
		$('.spinner').spinner({min: 0,step:$(this).attr('step')});		
	}catch(e){}
	
	//콘트롤 제목 처리
	var inputs = $('input[title]');
	
	for(var i=0; i<inputs.length;i++){
		var ctl = $(inputs[i]);
		ctl.attr('placeholder',ctl.attr('title'));
	}
	try {
		if(ready_init){
			ready_init();
		}
	} catch (e) {

	}
}

$(function($){
	document_ready_init();
	
	$(document).ajaxComplete(function() {
		document_ready_init();
	});
	$(document).ajaxError(function(e) {
		alert('처리중 시스템에 오류가 발생하였습니다. 네트웍 상태를 확인한 후 다시 시도하여 주세요.');
	});
	//ajax 더미 파라메터 추가
	$.ajaxPrefilter(function( options, originalOptions, jqXHR ) {
		if(options.url.indexOf('?')>0){
			options.url += '&_dumy=' + (new Date()).getTime();
		}else{
			options.url += '?_dumy=' + (new Date()).getTime();
		}
	});
});


function reLoadImg(ctl, thum, file_id){
	var img = $(ctl);
	
	if(img.attr('loading') == 'y'){
		return;
	}
	img.attr('src', 'at.sh?_ps=at/upload/dl&thum=' + thum + '&file_id=' + file_id);
	img.attr('loading','y');
}
