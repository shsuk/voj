function defaultStore(){
	var types = {};
	var url = {
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
	};
	
	getType = function(tid){
		console.debug("--- getType:", tid)
		var _type = stores.types[tid] ;
		if(!_type){
			var params = {tid: tid} ;
			this.getJson(this.url.TYPE, params, this.addType) ;
			_type = stores.types[tid] ;
		}
		console.debug("--- getType 2222:", tid)
		return _type ;
	};
	addType = function(_type){
		if(! _type) return ;
		stores.types[_type.tid] = _type ;

	};
	getJson = function(url, params, callBack){
		
		$.getJSON(url, params , callBack);
		
//		var d = dojo.xhrPost({
//			url: url,
//			content: params,
//			preventCache:true,
//			handleAs: 'json',
//			contentType: "application/x-www-form-urlencoded; charset=utf-8",
//			sync:true
//		});
//		d.addCallbacks(callBack) ;
	};
};


//utils = window.utils = ion.utils = new icafe.Utils();
//manager = window.manager = ion.manager = new icafe.DefaultManager();
