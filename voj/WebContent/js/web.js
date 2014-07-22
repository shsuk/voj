var isMobileView = false;

$(function($){
	//로딩 아이콘 추가
	var win = $(this);	
	var windowHeight = win.innerHeight(); 
	var windowWidth = win.innerWidth();
	var loading = $('<div style="position:absolute;color:#0000ff;"><img alt="loading" src="' + ($['res_path'] ? $['res_path'] : '.') + '/jquery/icon/loading.gif" /><br><br>처리중...</div>').appendTo(document.body).hide();

	loading.css('left', (windowWidth/2) + 'px');
	loading.css('top', (windowHeight/2) + 'px');
	
	$(document).ajaxStart(function (e) {
		try{
			var form = findParent(e.target.activeElement, 'FORM');
			
			if(form!=null){
				var formName = form.attr('name');
				if(formName.indexOf('/edit.') < 0){
					goPage_formName = formName;
				}
			}
		}catch (e) {
			// TODO: handle exception
		}

		loading.show();
	});
	
	$(document).ajaxStop(function (e) {
		loading.hide();
	});

});

function hideImg(){
	$('#img_viewer').dialog( "close" );
}

function showImg(id, src){
	if(id=='' || id==null){
		return;
	}
	
	var img_viewer = $('#img_viewer');

	if(img_viewer.length<1){
		$('body').append($('<div id="img_viewer" style="padding: 5px;z-index: 999;cursor: pointer;display:none; border: 1px solid #aaaaaa;background-color: #B2CCFF;"><img id="viewer_img" width="100%" style=" border: 1px solid #ffffff;" src="" onclick="hideImg();"/></div>'));
		img_viewer = $('#img_viewer');
	}
	$('#viewer_img').attr('src', src);
	setTimeout(function(){
		$('#viewer_img').attr('src','at.sh?_ps=at/upload/dl&file_id='+id);
	}, 500);
	//var isOpen = false;
	try {
		isOpen = img_viewer.dialog( "isOpen" );
	} catch (e) {
		// TODO: handle exception
	}

	//if(isOpen===true) return;

	img_viewer.dialog({
		autoOpen: true,
		minHeight:100,
		height: 'auto',
		modal: false,
		show: "blind",
		hide: "explode"
	});
}
