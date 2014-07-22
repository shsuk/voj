var new_tab = 0;

function addTab(tabId, tab_title, url, params, type){
	if(tabId==''){
		new_tab++;
		tabId = 'new_tab' + new_tab;
	}
	
	if(!findTab(tabId)){
		$.m_tabs.addTab(tabId, tab_title, url, params, type);
		var a=1;
	}
}

function findTab(tabId){
	if(tabId=='') return false;
	var tabPanels = $.m_tabs.find('.ui-tabs-panel');

	for(var i=0; i<tabPanels.length; i++){
		if($(tabPanels[i]).attr('tabId')==tabId){
			$.m_tabs.tabs('option', 'active', i);
			return true;
		}
	}

	return false;
}

/**********************************************************
*                                                         *
*                        초  기  화                       *
*                                                         *
**********************************************************/
$(function() {	
	
	//┌───────────────   TAB  START   ───────────────┐
	$.m_tabs = $("#tabs");
	$.m_tabs.tabs();
	$.m_tabs.tab_index = 0;
	//resizeContent() ie7무한루프 처리용
	var befWindowHeight = 0;
	var befWindowWidth = 0;
	var befResizeCount = 0;
	var ieFooterHeight = $("footer").height()+10;
	
	var tabTemplate = "<li><a href='#{href}'>#{label}</a><span class='ui-icon ui-icon-close' role='presentation'>Remove Tab</span></li>";
	
	function  makeTab( tabId, tab_title ) {
		var contentsDivId = 'contents-list-' + $.m_tabs.tab_index;
		var url = $.m_tabs.userData[tabId].url;
		var params = $.m_tabs.userData[tabId].params;
		//var height = $("#contents").height() - $("#tab-nevi").height() - 20;

		
		li = $( tabTemplate.replace( /#\{href\}/g, "#" + tabId ).replace( /#\{label\}/g, tab_title ) );
		$.m_tabs.find( ".ui-tabs-nav" ).append( li );

		if($.m_tabs.userData[tabId].type=='iframe'){
			$.m_tabs.append( $('<div id="' + tabId + '" ><iframe  frameborder="0" marginwidth="0" marginheight="0" src="' + url + '"/></div>'));
		}else{
			$.m_tabs.append( $('<div id="' + tabId + '" ><div id="' + contentsDivId + '" class="contents-contain" ></div></div>'));
			params['_target'] = contentsDivId;
			$.renderPage(contentsDivId, url, params);
		}
		$.m_tabs.tabs( "refresh" );
		resizeContent();
	}


	 // close icon: removing the tab on click
	$.m_tabs.tabs().delegate( "span.ui-icon-close", "click", function() {
		var panelId = $( this ).closest( "li" ).remove().attr( "aria-controls" );
		$( "#" + panelId ).remove();
		$.m_tabs.tabs().tabs( "refresh" );
	});
	

	
	$.m_tabs.userData = {};
	
	$.m_tabs.addTab = function(tabIdx, tab_title, url, params, type) {
		befResizeCount = 0; //resizeContent() ie7무한루프 처리용
		if($.m_tabs.find('.ui-tabs-panel').length>6){
			msg('더 이상 탭을 열수 없습니다. 다른 탭을 닫고 열어주세요.');
			return;
		};
		$.m_tabs.tab_index++;
		var tabId = "tabs-" + $.m_tabs.tab_index;
		var data = $.getUrlData(params);
		data['rid'] = data['rid'] ? data['rid'] : '';
		$.m_tabs.userData[tabId] = {};
		$.m_tabs.userData[tabId].params = data;
		$.m_tabs.userData[tabId].url = url;
		$.m_tabs.userData[tabId].type = type;
		$.m_tabs.userData[tabId].paramData = params ? params : '';
		
		makeTab( tabId, tab_title );
		
		$.m_tabs.find( ".ui-tabs-nav" ).sortable({ axis: "x" });

		var taPanels = $.m_tabs.find('.ui-tabs-panel');
		var selected = taPanels.length-1;
		$(taPanels[selected]).attr('tabId', tabIdx);
		$.m_tabs.tabs('option', 'active', selected);	
	};
	//└───────────────   TAB  END   ───────────────┘


	resizeContent();
	
	
	function resizeContent( ){   
		var tabPanels = $.m_tabs.find('.ui-tabs-panel');
		var win = $(this);
		
		var windowHeight = win.outerHeight();
		var windowWidth = win.outerWidth();
		//resizeContent() ie7무한루프 처리
		if(windowHeight==befWindowHeight && windowWidth==befWindowWidth){
			if(befResizeCount>tabPanels.length){
				befResizeCount = 0; //탭추가시에도 초기화
				return;
			}
			befResizeCount += 1;
		}else{
			befResizeCount = 0;
		}

		befWindowHeight = windowHeight;
		befWindowWidth = windowWidth;		
		
		var headerHeight = $("#header").height();
		var footerHeight = (IE) ? ieFooterHeight : $("footer").height();
		var menuWidth = $("#leftSection").width();
		windowHeight = windowHeight<1 ? document.body.clientHeight+10 : windowHeight;
		
		windowWidth = windowWidth<1 ? document.body.clientWidth-20 : windowWidth;
		
		var contentHeight = windowHeight - headerHeight - footerHeight - 30; 
		var contentWidth = windowWidth - menuWidth - 15;
		
		$("#body").css( "height", contentHeight);
		$("#contSection").css( "height", contentHeight);
		$("#leftSection").css( "height", contentHeight+4);

		$("#contSection").css( "width", contentWidth);
		//각 탭의 높이를 조절한다.
		var tabHeight = contentHeight + 12 - $("#tab-nevi").height() - 55;
		var tabWidth = contentWidth - 15;
		
		for(var i=0; i<tabPanels.length; i++){
			$(tabPanels[i].firstChild).css( "height", tabHeight );
			$(tabPanels[i].firstChild).css( "width", tabWidth);
		}
		
		return;
	}
	
	$(window).resize( function(){
		resizeContent();
	});
	
	$('.left_menu').button({
		icons: {
			primary: "ui-icon-battery-2"
		}
	});

	$('.left_menu_win').button({
		icons: {
			primary: "ui-icon-newwin"
		}
	});
});

