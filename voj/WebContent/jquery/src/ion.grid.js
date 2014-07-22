(function($){
	$.ionGrid = $.ionGrid || {};
	$.grid = {};
	$.gridColNames = ['name', 'id', 'member', 'group', 'tagging'];
	$.gridStructure = [
		{field:'name', formatter:"", classes:""},
		{field:'id', formatter:"", classes:""},
		{field:'memer', formatter:"", classes:""},
		{field:'group', formatter:"", classes:""},
		{field:'tagging', formatter:"", classes:""}
	];
	
	$.fn.ionGrid = function(pin){
		var table = this;
		$.extend($.grid,{html:table});
	
//		$.ionGrid.getType(pin.tid, $.ionGrid.getProperties);
//		$.ionGrid.getListData(pin.tid, $.ionGrid.createBodyHTML);
		$(this).getType(pin.tid, $.ionGrid.getProperties);
		$.ionGrid.getListData(pin.tid, $.ionGrid.createBodyHTML);
//		console.debug("--- ion grid store 222: ", type)
	};
	
	$.extend($.ionGrid, {
		getProperties: function(nodeType){
			var colName = ['name', 'id', 'member', 'group', 'tagging'];
			var property = [];
			var props = nodeType.propertytypes ;
			
			for(var i=0; i<= colName.length; i++){
				var pid = colName[i];
				if(props[pid]) property.push(props[pid]);
			}
			$.extend($.grid,{title:nodeType.name});
			$.ionGrid.createHeadHTML(property);
			return property ;
		},
		
		createHeadHTML: function(property){			
			var caption = $('<caption/>',{
						text:$.grid.title + ' 목록',
						css:{
								fontSize:'1.5em',fontWeight:'bold'
							}
					}); 
			var thead = $('<thead/>',{});
			
			$.grid.html.append(caption);
			$.grid.html.append(thead);	
			for(var i=0; i<property.length; i++){
				var prop = property[i] ;
				
				var th = $('<th/>',{
							text:prop.name,
							css:{
									height:'29px'
								}
				});
				thead.append(th);
			}
		},
		
		createBodyHTML: function(data){
			var tbody = $('<tbody/>',{});
			$.grid.html.append(tbody);
			var items = data['items'];
			console.debug("--- data :", data)
			for(var i=0; i<= items.length; i++){
				var tr = $('<tr/>',{
//				css: {
////						color:'#333333',
//						fontSize:'9pt',
//						background:'url("http://image.mnet.com/NewMnet/Music/v4/Chart/b_listtbl.gif") repeat-x scroll 0 0 #EEEEEE'
//						
//					}
				});
				tbody.append(tr);
				var rows = items[i];
				
					$.each($.gridColNames, function(idx, cell){
						if(rows){
							var name = $.ionGrid.getValue(rows[cell]);
							var tmpHTML, tmpTEXT = '';
							if(rows[cell].iconclass){								tmpHTML = '<span class="'+rows[cell].iconclass+'">&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;' + name;
							
							}else{
								tmpTEXT = name ;
							}								
	
							var td = $('<td/>',{
								text: tmpTEXT,
								html: tmpHTML,
								css:{
									borderTop:'1px solid #F5F5F5',
									height:'26px',
									lineHeight:'19px'
								}
							});
							tr.append(td);
						}
					});
			}
		},
		
		getListData: function(tid, callBack){
			var url = 'json.do';
//			var params = {count:20, labelid:'name', nid:0, reltype:'list', position:0, tid:tid, valueid:'nid', start:0, filters:'', handler:'default', pid:'',method:'select', uppernid:0};
			var params = {
//				codeid:'',	
//				count:	20,
//				filters:'',	
//				handler: 'default',
//				labelid	: 'name',
				method	:'select',
//				nid	:0,
//				pid	:'',
//				position	:0,
				reltype	:'list',
//				searchvalue	:'',
//				sorting	:'default',
//				start	:0,
				tid	:'test'
//				uppernid	:0,
//				valueid	:'nid'
			}
			$.post(url, params, function(data){
				callBack(data);
			});
		}
	});
	
	/*Utils*/
	$.extend($.ionGrid, {
		getValue: function(value){
			var val = value.display ? value.display: value?value:'' ;
			
			return val ;
		}
	});
	
	/* stores */
	$.extend($.ionGrid, {
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
			var _type = this.types[tid] ;
			
			if(!_type){				
				var params = {tid: tid} ;
				var self = this ;
				$.getJSON(this.url.TYPE, params, function(data){
					self.types[data.tid] = data ;					
					_type = self.types[data.tid] ;
					callback(_type);
					
				});
			}
			return _type ;
		}
	});
})(jQuery);