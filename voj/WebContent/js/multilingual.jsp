<%@page import="net.ion.webapp.db.Lang"%>
<%@page contentType="text/javascript; charset=utf-8"%>
<%@taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
//다국어 사전
__multilingual_dic=<%=Lang.getLangJson().getJSONObject((String)request.getAttribute("lang")).toString()%>;
//다국어 반환. 
function lang(id, opt1, opt2){
	var val = $.multilingual.dic[id];
	var params = [];
	var defaultValue = opt2;
	
	if($.isArray([opt1])){
		params = opt1;
	}else{
		defaultValue = opt1;
	}
	val = val ? val : (defaultValue ? defaultValue : id);
	
	if(val && params){
		$.each(params, function(idx, rep){
			val = val.replaceAll('{'+idx+'}', rep);
		});
	}
	return val;
};

(function($){
	$.multilingual = {
		//다국어 사전
		dic:__multilingual_dic,
		//다국어로 치환한다.
		render: function(){
			//class를 다국어 사전에 등록한다.(JSON클래스에서 class에 대한 처리문제로 따로 등록)
			$.multilingual.dic['class'] = "${code:lang('class', lang, '') }";
			
			var elements = $('[mlang]');
			
			$.each(elements, function(i, element){
				var el = $(element)
				var str = el.attr('mlang')
				var paramsList = str.split(',')
				$.each(paramsList, function(i, option){
					$.multilingual.renderEl(el,option)
				});
			});
		},
		renderEl: function(el, option){
			var params = option.split(':')
			
			var msg_id = $.trim(params[0]);
			var replMents = [];
			var fn = 'html';
			var pt = '';
			
			var lastParam = $.trim(params[params.length-1]);
			
			if(lastParam.indexOf('[')==0){
				replMents = $.parseJSON(lastParam);
				
				switch(params.length){
					case 4:
						pt = $.trim(params[2]);
					case 3:
						fn = $.trim(params[1]);				
				}
			}else{
				switch(params.length){
					case 3:
						pt = $.trim(params[2]);
					case 2:
						fn = $.trim(params[1]);				
				}
			}
			
			var val = lang(msg_id, replMents);
			if(val){
				if(fn=='attr'){
					el[fn](pt, val);
				}else{			
					el[fn](val);
				}
				el.removeAttr('mlang')
				//console.log("[multilingual] ", msg_id + ' : ' + val);
			}
		}
	};
})(jQuery);
