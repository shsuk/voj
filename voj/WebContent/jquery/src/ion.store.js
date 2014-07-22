(function($){
	$.ionStore = $.ionStore || {};
	$.ionStore = {
		types: {},
		
		url : {
			READ : 'json.do?method=read',		
			NODE : 'json.do?method=node',
			TYPE : 'json.do?method=type',
			SUBTYPE : 'json.do?method=subtype',
			RELTYPE : 'json.do?method=reltype',
			WIDGET : 'json.do?method=widget',
			LINKS : 'json.do?method=links',
			NID : 'json.do?method=nid',		
			USER : 'json.do?method=user',
			ID : 'json.do?method=id',
			LABEL:'json.do?method=label'
		},
		
		getType: function(tid, callback){
			var _type = $.ionStore.types[tid] ;
			
			if(!_type){				
				var params = {tid: tid} ;
				
				$.getJSON($.ionStore.url.TYPE, params, function(data){
					$.ionStore.types[data.tid] = data ;					
					_type = $.ionStore.types[data.tid] ;
					callback(_type);
					
				});
			}
			return _type ;
		}
	};//end function
	
	$.fn.getType = $.ionStore.getType ;
})(jQuery);