$(function(){
	$("#gridList").ionGrid({
		url:'list.do',
		tid:'test'		
	});
	
	stores = window.stores = defaultStore();
	
//	console.debug("----- store 333:", $("body").types());
});