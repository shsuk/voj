var CURRENT_FORM = "";

(function($){
	$.valedFunction = {};
	if(this['__multilingual_dic']){
		$._DEFAULT_MESSAGE = __multilingual_dic;
	}else{
		$._DEFAULT_MESSAGE = {};
	}
	$._ERROR_MESSAGE = "입력된 데이타가 잘못 되었습니다.";
	var DEFAULT_ERROR_MESSAGE = "{title}에 '{value}'값을 입력할 수 없습니다.";
	//폼의 정합성 체크 메인
	$.formValed = function(form, noCheckField, noCheckEmpty){
		var selecter = (form!=null && form!='') ? '#' + form + ' ' : '';
		selecter = selecter + '[valid]';
		return $.valedForm(selecter, noCheckField, noCheckEmpty);
	};

	$.valedForm = function(selecter, noCheckField, noCheckEmpty){
		var isError = false;
		var ctls = $(selecter);
		var ctl = null;
		noCheckEmpty = noCheckEmpty === true ? true : false;

		if(ctls.length>0){
			CURRENT_FORM = findParent(ctls[0], 'FORM');
		}

		for(var i=0; i<ctls.length; i++){
			ctl = $(ctls[i]);

			if(noCheckField){//체크 제외 대상 처리
				if(noCheckField[ctl.attr('name')]) continue;
			}


			if(!valedCtl(ctl, noCheckEmpty)){
				isError = true;
				break;
			}
			//ctl.parent().css('border','');
			//ctl.css('border',ctl.attr('_border'));
			var error = ctl.attr('error');
			if(error) $(error).css('border','');

			ctl.css('border','');
		}

		if(isError){
			ctl.focus();
			//ctl.parent().css('border','1px solid #cc0000');
			var error = ctl.attr('error');
			if(error) $(error).css('border','1px solid #cc0000');

			ctl.css('border','1px solid #cc0000');
			alert($._ERROR_MESSAGE);
		}
		return !isError;
	};
	//특정 콘트롤의 정합성 체크
	$.isValedCtl = function(ctl){
		if(!valedCtl(ctl)){
			alert($._ERROR_MESSAGE);
			return false;
		}
		return true;
	};
	//콘트롤의 정합성을 체크한다.
	function valedCtl(ctl, noCheckEmpty){

		ctl = $(ctl);

		var valids;


		try{
			var valid = ctl.attr('valid');
			if(valid == "undefined" || valid == '') return true;
			valid = valid.replaceAll("'", '"');
			valids = $.parseJSON(valid);
		}catch (e) {
			alert(ctl.attr('name') + '의 값이 잘못되었습니다.' + ctl.attr('valid'));
			return false;
		}

		for(var j=0; j<valids.length; j++){
			if(typeof valids[0] === 'string'){

				if(!callFunction(valids, ctl, noCheckEmpty)){
					return false;
				}
				break;
			}else{
				if(!callFunction(valids[j], ctl, noCheckEmpty)){
					return false;
				}
			}
		}

		return true;
	}
	//정합성체크 함수를 호출한다.
	function callFunction(valids, ctl, noCheckEmpty){

		var opt = valids[0].split(':');
		var id = opt[0];

		if(noCheckEmpty){
			if(id.toLowerCase()=='notempty') return true;
		}
		//메세지 처리
		$._ERROR_MESSAGE = (valids.length>1) ? valids[1] : '';
		if($._ERROR_MESSAGE==''){
			$._ERROR_MESSAGE = $._DEFAULT_MESSAGE['valid_'+id.toLowerCase()];
		}else if($._ERROR_MESSAGE.indexOf('@')==0){
			$._ERROR_MESSAGE = ctl.attr($._ERROR_MESSAGE.substring(1));
		}

		$._ERROR_MESSAGE = $._ERROR_MESSAGE ? $._ERROR_MESSAGE : DEFAULT_ERROR_MESSAGE;
		//{title}를 대치할 이름을 찾는다.
		replaceTitle(ctl);
		//{value}를 값으로 치환한다.
		replaceValue(ctl);

		var fnc = $.valedFunction[id.toLowerCase()];
		if(fnc==null) {
			alert(id + ' 합수가 정의 되지 안았습니다.');
			return false;
		}
		return fnc(ctl,opt);
	}
	//{value}를 대치할 이름을 찾는다.
	function replaceValue(ctl){
		if($._ERROR_MESSAGE.indexOf('{value}') < 0) return;

		var value = ctlVal(ctl);

		$._ERROR_MESSAGE = $._ERROR_MESSAGE.replaceAll('{value}',value);
	}
	//{title}를 대치할 이름을 찾는다.
	function replaceTitle(ctl){
		if($._ERROR_MESSAGE.indexOf('{title}') < 0) return;


		$._ERROR_MESSAGE = $._ERROR_MESSAGE.replaceAll('{title}',findTitle(ctl));
	}

})(jQuery);

String.prototype.replaceAll = function( searchStr, replaceStr )
{
    return this.split( searchStr ).join( replaceStr );
};

String.prototype.trim = function()
{
    return this.replace(/^\s+|\s+$/g,"");
};

function findTitle(ctl){

	var tName = ctl.attr('name');
	var rep = ctl.attr('title');//현재 콘트롤의 title속성을 찾는다.

	if(rep==null){//현재 콘트롤의 title속성이 없는 경우
		var tCtls =  $('[title="'+tName+'"]', CURRENT_FORM);//모든 title속성을 가지고 온다.
		if(tCtls.length>0) rep = $.trim( tCtls.text() );
	}
	if(rep==null){//없는 경우 사전에서 찾는다.
		rep = $._DEFAULT_MESSAGE[tName];
	}
	if(rep==null){//없는 경우 콘트롤명으로 대치한다.
		rep = tName;
	}
	
	return rep;
}

//=========================================================================
// 정합성 합수 정의 시작
//=========================================================================
$.valedFunction['notempty'] = function(ctl, opt){//
	if(ctl.attr('type')==='checkbox' || ctl.attr('type')==='radio' ){
		if($("input[name="+ctl[0].name+"]:checked ").length<1){
			return false;
		}
	}else if(ctl.get(0).tagName.toUpperCase()=="IMG" ){
		if(ctl.attr('src') ==  "images/bg_img.png"){
			return false;
		}
	}else if(ctl.attr("name")=='file_path' ){
			var content = ctl.html().trim().toUpperCase();
	        if (content.match(/NAME="FILE_PATH" VALUE=""/)){
	        	return false;
	        }
	}else{
		var val = ctlVal(ctl);
		if(val.trim()==''){
			return false;
		}
	}
	return true;
};

$.valedFunction['equals'] = function(ctl, opt){//['equals:other name']

	if(ctlVal(ctl)!=ctlVal($('input[name="' + opt[1] + '"]'))){
		var title = findTitle($('#' + opt[1]));
		$._ERROR_MESSAGE = $._ERROR_MESSAGE.replaceAll('{0}', title);
		return false;
	}

	return true;
};

$.valedFunction['notequals'] = function(ctl, opt){//['notequals:other name']

	if(ctlVal(ctl)==ctlVal($('input[name="' + opt[1] + '"]'))){
		return false;
	}

	return true;
};

$.valedFunction['maxlen'] = function(ctl, opt){//['maxlen:${attr.precision }']
	var maxlen = parseInt(opt[1],10);
	if(maxlen<1) return true;
	var len = getStringLength(ctlVal(ctl));

	if(len > maxlen){
		$._ERROR_MESSAGE = $._ERROR_MESSAGE.replaceAll('{1}',len).replaceAll('{0}',opt[1]);
		return false;
	}

	return true;
};


$.valedFunction['minlen'] = function(ctl, opt){

	if(getStringLength(ctlVal(ctl)) < parseInt(opt[1],10)){
		$._ERROR_MESSAGE = $._ERROR_MESSAGE.replaceAll('{0}',opt[1]);
		return false;
	}

	return true;
};

$.valedFunction['minval'] = function(ctl, opt){
	var min = parseInt(opt[1],10);
	var val = ctlVal(ctl);
	if(val < min){
		$._ERROR_MESSAGE = $._ERROR_MESSAGE.replaceAll('{1}',val).replaceAll('{0}',opt[1]);
		return false;
	}

	return true;
};

function charByteSize(ch) {
	if (ch == null || ch.length == 0) {
	  return 0;
	}

	var charCode = ch.charCodeAt(0);

	if (charCode <= 0x00007F) {
	  return 1;
	} else if (charCode <= 0x0007FF) {
	  return 2;
	} else if (charCode <= 0x00FFFF) {
	  return 3;
	} else {
	  return 4;
	}
}

function ctlVal(ctl){
	if(ctl.attr('type')==='radio'){
		return $('input:radio:checked', ctl.parent()).val();
	}else if(ctl.attr('type')==='checkbox'){
		return $('input:checkbox:checked', ctl.parent()).val();
	}else{
		var val = ctl.val();
		
		if(ctl[0].tagName.toLowerCase() != 'select' && (val==null || val=='')){
			 val = ctl.text();
		}
		
		return val;
	}
}

//문자열의 갯수를 리턴한다.
function getStringLength(str) {
	return str.length;
}
// 문자열을 UTF-8로 변환했을 경우 차지하게 되는 byte 수를 리턴한다.
function getStringByte(str) {
	if (str == null || str.length == 0) {
	  return 0;
	}
	var size = 0;
	
	for (var i = 0; i < str.length; i++) {
	  size += charByteSize(str.charAt(i));
	}
	return size;
}

$.valedFunction['val'] = function(ctl, opt){

	if(ctlVal(ctl)!=opt[1]){
		return false;
	}

	return true;
};

$.valedFunction['domain'] = function(ctl, opt){

	var reg = /((\w|[\-\.])+)\.([A-Za-z]+)$/;
	return reg.test(ctl.val());
};

$.valedFunction['mail'] = function(ctl, opt){
	if(ctl.val()==''){
		return true;
	}
	var reg = /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/;
	return reg.test(ctl.val());
};

$.valedFunction['email'] = $.valedFunction['mail'];


$.valedFunction['ext'] = function(ctl, opt){//['ext:gif,gpg,jpeg,png']
	var name = ctlVal(ctl);
	if(name==null || name == '') return true;

	var ext = name.substring( name.lastIndexOf('.')+1).toLowerCase();
	var exts = opt[1].toLowerCase();
	if(exts.indexOf(ext)<0){
		$._ERROR_MESSAGE = $._ERROR_MESSAGE.replaceAll('{0}',opt[1]);
		return false;
	}

	return true;
};
$.valedFunction['size'] = function(ctl, opt){
	var size = 0;
	var name = ctlVal(ctl);

	if(name==null || name == '') return true;

	if(navigator.userAgent.indexOf('MSIE')>0){
		//var img = new Image();

		//img.dynsrc = name;

		//size = img.fileSize;
	}else{
		var files = ctl[0].files;
		if(files.length<1) return true;

		size = files[0].size;
	}


	if(size > parseInt(opt[1],10)){
		return false;
	}

	return true;
};
$.valedFunction['businessnumber'] = function(ctl, opt){//사업자등록번호 체크
	var bizID = ctl.val();

	el = bizID.replace(/-/gi,'');

	if(el.length!=10) return false;

	var a = new Array;
	var b = new Array(1,3,7,1,3,7,1,3,5);
	var sum = 0;

	for (var i = 0; i < 10; i++) a[i] = el.substr(i,1);
	for (var i = 0; i < 9;  i++) sum = sum + (a[i] * b[i]);

	sum = sum + ((a[8] * 5) / 10);
	y = (sum - (sum % 1)) % 10;

	if (y == 0) z = 0;
	else z = 10 - y;

	if (z != a[9]) return false;

	return true;
};
$.valedFunction['numeric'] = function(ctl, opt){

	var num = '1234567890';
	var val = ctl.val();
	for (var i=0; i < val.length; i++ ) {
		// 숫자가 한글자라도 쓰였는지 확인.
		if( num.indexOf(val.substring(i,i+1)) < 0) return false;
	}

	return true;
};
$.valedFunction['alphanumeric'] = function(ctl, opt){

	var len = ctl.val().length;
	var byte = getStringByte(ctl.val());

	if(len != byte) return false;

	return true;
};
$.valedFunction['number'] = function(ctl, opt){
	var num = '-.1234567890';
	var val = ctl.val();
	for (var i=0; i < val.length; i++ ) {
		// 숫자가 한글자라도 쓰였는지 확인.
		if( num.indexOf(val.substring(i,i+1)) < 0) return false;
	}

	if( val.indexOf('-') > 0) return false;

	if( val.split('.').length>2) return false;

	return true;
};

$.valedFunction['ip'] = function(ctl, opt){
	var expUrl = /^(1|2)?\d?\d([.](1|2)?\d?\d){3}$/;
	return expUrl.test(ctl.val());
};
//************************************************************************************************
// 업무별로 다를 수 있는 함수
//************************************************************************************************
$.valedFunction['password'] = function(ctl, opt){

	var pwd = ctl.val();
	// 비밀번호 - 자리수 체크 (6~16)
	if (pwd.length < 6 || pwd.length > 16) {
		$._ERROR_MESSAGE = '비밀번호는 6~16자리로 영문소문자와 숫자를 반드시 포함해 조합해야 합니다.'; // 비밀번호는 6~16자리의 영문소문자와 숫자만 입력 가능합니다.
		return false;
	}
	var alpaSmall = 'abcdefghijklmnopqrstuvwxyz';
	var num = '1234567890';
	var numcheck = false;
	var alphacheck = false;
	// 비밀번호 - 소문자 또는 숫자
	for (var i=0; i < pwd.length; i++ ) {
		// 숫자가 한글자라도 쓰였는지 확인.
		if( num.indexOf(pwd.substring(i,i+1))>= 0){
			numcheck = true;
		}
		// 영문 소문자가 한글자라도 쓰였는지 확인.
		if( alpaSmall.indexOf(pwd.substring(i,i+1))>= 0){
			alphacheck = true;
		}
	}
	// 비밀번호 - 영문소문자와 숫자가 혼합하여 쓰였는지 확인.
	if(numcheck == false || alphacheck == false){
		$._ERROR_MESSAGE = '비밀번호는 6~16자리로 영문소문자와 숫자를 반드시 포함해 조합해야 합니다.'; // 비밀번호는 6~16자리의 영문소문자와 숫자만 입력 가능합니다.
		return false;
	}

	return true;
};
$.valedFunction['pstimg'] = function(ctl, opt){
	var len = $('option:selected[value=IMT_000]').length;

	return len<=1;


};


//=========================================================================
//정합성 합수 정의 끝
//=========================================================================
