<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<jsp:include page="../voj_layout${mobile}.jsp" />
<c:if test="${req.action=='d' }">
	<uf:organism noException="true">[
		<job:db id="row" query="voj/bd/delete"/>
	]</uf:organism>	
</c:if>

<uf:organism >
[
	<job:db id="rows" query="voj/gal/list" singleRow="false" >
		defaultValues:{
		bd_cat: 'cafe',
		listCount:${isMobile ? 10 : 15 },
		pageNo:1,
		_sort_val: "${empty(req._sort_opt) ? '' : fn:replace(fn:replace(' ORDER BY @key @opt ','@key', req._sort_key), '@opt',  (req._sort_opt=='d' ? ' desc ' : ' asc '))}"
	}
	</job:db>
]
</uf:organism>

<script type="text/javascript">
	
	$(function() {
		$('#search_btn').button({icons: {primary: "ui-icon-search" },text:false}).click(function(){
			search();
		});

	    $('.prev_item').hide();
	    $('.next_item').hide();
	    		
		init_load({duration:300,easing:'fade'});
	    
	    if(!${empty(req.gal_id)}){
	    	load_view('${req.gal_id}');
	    }

	});
		
	function goPrev(){
		load_view($($('.prev_item')[0]).attr('gal_id'));	
	}
	
	function goNext(){
		load_view($($('.next_item')[0]).attr('gal_id'));	
	}

	function search(){
		//폼 정합성 체크
		
		goPage(0);
		
		return false;
	}
	
	function goPage(pageNo){
		var form = $('form[name=main_form]');
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {
				_layout:'n', 
				bd_cat: '${req.bd_cat}',
				_ps: 'voj/gal/list'
		};
		
		var fields = form.serializeArray();
		$.each(fields, function(i, field){
			data[field.name] =field.value;
		});
	
		if(pageNo!=0){
			data['pageNo'] = pageNo;
		}
		
		show(target_layer, url, data);
	}
	
	function load_view(gal_id){
		
		var url = 'at.sh';
		var data = {
			gal_id: gal_id,
			bd_cat: '${req.bd_cat}',
			_layout: 'n',
			pageNo:	'${empty(req.pageNo) ? 1 : req.pageNo}'
		};
		if(${isMobile}){
			data['_ps'] = 'voj/gal/viewm';
			document.location.href = url + '?' + $.param(data);
		}else{
			var target_layer = $('#body_main').parent();
			data['_ps'] = 'voj/gal/view';
			show(target_layer, url, data);			
		}
	}
	
	
	function goPrevImg(){
		var idx = find_current();
		if(0 < idx){
			idx--;
		}
		
		change_img($('.img_list')[idx]);
	}
	
	function goNextImg(){
    	var len = $('.img_list').length-1;
		var idx = find_current();
		if(idx < len){
			idx++;
		}
		
		change_img($('.img_list')[idx]);
	}
		
	function find_current(){
		var img_list = $('.img_list');
		
		for(var i=0; i<img_list.length; i++){
			var curent = $(img_list[i]).attr('curent');
			if(curent == 'y'){
				return i;
			}
		}
		
		return 0;
	}

	function showNevi(){
		$('.img_nevi').css({opacity: .35,filter: 'Alpha(Opacity=35)'});
		setTimeout(function(){
			$('.img_nevi').css({opacity: 0,filter: 'Alpha(Opacity=0)'});
		},3000);
	}

	function change_img(e){
		showNevi();
		var file_id = $(e).attr('file_id');
		
		$('.img_list').css({background:''});
		$('.img_list').attr('curent', '');
		//$('.img_list_item').css({background:'',width: '82px', height:'52px'});

		var src = $('img',e);
		var lImg = $(e);
		
		var url = 'at.sh?_ps=at/upload/dl&thum=1000&file_id=' + file_id;
		var view_img = $('#view_img');
		view_img.attr('src', src.attr('src'));

		var rat = src[0].naturalHeight / src[0].naturalWidth;
		
		if(${!isMobile}){
			view_img.css({width :'632px', height:(632*rat)+'px'});
		}
		
		view_img.attr('src', url);
		view_img.attr('value', file_id);

		$(e).css({background: '#2478FF'});
		$(e).attr('curent', 'y');
		
		var len = $('.img_list').length-1;
		var idx = find_current();
    	$('#prev_img_item').show();
    	$('#next_img_item').show();

		if(idx == 0){
	    	$('#prev_img_item').hide();
		}
		if(idx == len){
	    	$('#next_img_item').hide();
		}


	}

	function edit(gal_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/gal/edit', gal_id: gal_id, bd_cat:'${req.bd_cat}', _layout: 'n', pageNo: (gal_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};

		show(target_layer, url, data);
	}
	function del(gal_id){
		if(!confirm("정말로 삭제하시겠습니까?")){
			return;
		}
		
		var url = 'at.sh';
		var data = {
				_ps:'voj/gal/edit_action', 
				gal_id: gal_id, 
				file_id: $('#view_img').attr('value'), 
				bd_cat:'${req.bd_cat}', 
				_layout: 'n', 
				action:'d', 
				pageNo:'${req.pageNo}'
		};
		$.getJSON( url, data, function( data ) {

			if(data.row[2]==0){
				load_view(gal_id);
			}else{
				goPage(1);
			}
		});		
	}

	function form_submit(){	
		var form = $('#content_form');

		//폼 정합성 체크
		var isSuccess = true;
		var imgs = $('.pic_file');
		for(var i=0; i<imgs.length;i++){
			isSuccess = false;
			if($(imgs[i]).val()){
				isSuccess = true;
				break;
			}
		}
		if(!isSuccess){
			alert('사진이 없습니다.');
			return false;			
		}
		
		isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			

		
		form.submit();
		return false;
	}
	function change_date_submit(){	
		var form = $('#content_form');
		$('#action', form).val('ut');
		$('.pic_file', form).attr('valid', '[]');
		var file_id = $('#view_img').attr('value')
		$('#file_id', form).val(file_id);
		//폼 정합성 체크
		var isSuccess = false;
	
		isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			

		
		form.submit();
		return false;
	}
	
	function save_reply(){	
		var form = $('#reply_form');

		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			
		
		
		var target_layer = $('#body_main').parent();
		var url = 'at.sh';
		var formData =$(form).serializeArray();
		
		show(target_layer, url, formData);
	}
	
	function del_reply(gal_id, gal_rep_id){
		if(!confirm("정말로 삭제하시겠습니까?")){
			return;
		}
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {
				action: 'd',
				_ps: 'voj/gal/view',
				gal_id: gal_id,
				gal_rep_id: gal_rep_id,
				_layout: 'n',
				pageNo:	'${empty(req.pageNo) ? 1 : req.pageNo}'
		};

		show(target_layer, url, data);
	}
	function loadImg(img){
		var IE = /*@cc_on!@*/false;
		$.browser = {};
		$.browser.msie = IE;
		
	    //ie7에서 hidden문제 처리
		if ( $.browser.msie && navigator.appVersion.indexOf('MSIE 7')>0 ){
			var img = $('.ie7_img_list');
			img.removeClass('ie7_img_list');
			img.css({height:img.parent().height()+'px', width: img.parent().width()+'px'});
		}else{
			var $img = $(img);
			$img.css({top: (100-$img.height())/2 + 'px'});
			//$img.css({top: (100-$img.height())/2 + 'px', left:(160-$img.width())/2 + 'px'});
		}
	}

	function changeEmoticon(){
		var rep_conts = $('.rep_cont');
		var emoticons = $('.emoticon');
		for(var i=0; i<rep_conts.length; i++){
			var item = $(rep_conts[i]);
			var html = item.html();
			
			for(var j=0;j<emoticons.length; j++){
				var em = $(emoticons[j]);
				html = html.replaceAll(em.attr('value'), '<img height="28" style="vertical-align: middle;" src="'+em.attr('src')+'">');
			}
			item.html(html);
		}
	}

</script>

<div  id="body_main" style="display: none;">
	
	<div style="width:100%;margin-top: 40px;margin-bottom: 40px; ">
		${HEADER }
	</div>

	<div class="bd_body" style="${isMobile ? '' : 'padding-left:20px;'} ">
	
		<c:forEach var="row" items="${rows }">
			<div style="display:inline-block; margin: 5px;font-size: 12px; float: left;">
				<div style=" margin: 5px; overflow: hidden;text-align: center;vertical-align: middle;cursor: pointer;height:100px; width: ${isMobile ? '150' : '160'}px;border:1px solid #B6B5DB;" onclick="load_view(${row.gal_id })">
					<tp:img file_id="${row.file_id}" thum="160" attr="onload=\"loadImg(this)\"" className="ie7_img_list" style=" border: 1px solid #cccccc; height:100px;"/>
				</div>
				<div style=" width: ${isMobile ? '150' : '160'}px;overflow: hidden; text-overflow : ellipsis;"><nobr><b>
					<c:if test="${row.new_item == 1}" >
						<img src="images/icon/new_ico.gif">
					</c:if>
					${row.title }
				</b></nobr></div>
				<c:if test="${!empty(row.img_id)}"><div>${row.img_id }</div></c:if>
				<div title="${row['USER_NM@dec@name'] }">${row.reg_nickname }</div>
				<div>
					${row['REG_DT@yyyy-MM-dd'] }
					<c:set var="re_count"> <font color="#6799FF">(${ row.re_new>0 ? '<img src="images/icon/new_ico.gif">' : ''}${row.re_count })</font></c:set>
					${ row.re_count>0 ? re_count : '' }
				</div>
			</div>
		</c:forEach>
		<div style="width: 100%;clear: both;">
			<div style="margin: auto;"><tp:paging listCount="${rows[0].listCount }" pageNo="${rows[0].pageNo }" totCount="${rows[0].totCount }"/></div>
			<table style="width: 100%">
				<tr>
					<td width="100%">
						<c:if test="${session.user_id!='guest'}">
							<a class="cc_bt" style="float:right;" href="#" onclick="edit()">사진올리기</a>
						</c:if>&nbsp;
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
	
