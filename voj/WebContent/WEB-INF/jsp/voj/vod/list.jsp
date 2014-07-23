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
		<job:db id="row" query="voj/vod/delete"/>
	]</uf:organism>	
</c:if>

<uf:organism >
[
	<job:db id="rows" query="voj/vod/list" singleRow="false" >
		defaultValues:{
		listCount:${req.bd_cat=='newfam' ? 10 : 6 },
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
	    init_load();
	    if(!${req.bd_cat=='newfam' || empty(req.vod_id)}){
	    	load_view('${req.vod_id}');
	    }
	});
		
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
				_ps: 'voj/vod/list'
				
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
	
	function load_view(vod_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {
			_ps: 'voj/vod/view',
			vod_id: vod_id,
			bd_cat: '${req.bd_cat}',
			_layout: 'n',
			pageNo:	'${empty(req.pageNo) ? 1 : req.pageNo}'
		};

		
		show(target_layer, url, data);
	}
	function view_img(vod_id){
		
	}
	<%//글수정 패스워드가 있는 글은 패스워드를 입력받는다.%>
	function edit(vod_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/vod/edit', vod_id: vod_id,  bd_cat:'${req.bd_cat}', _layout: 'n', pageNo: (vod_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};
		
		show(target_layer, url, data);		
	}
	function del(vod_id){
		var url = 'at.sh';
		var data = {
				_ps:'voj/vod/edit_action', 
				action: 'd',
				vod_id: vod_id,
				bd_cat: '${req.bd_cat}'
		};
		$.getJSON( url, data, function( data ) {
			goPage(1);
		});		
		
	}
	
	function readPw(target_layer,url,data){
		var box = $('#dialog-message');

		if(box.length<1){
			$('body').append($('<div id="dialog-message"><b>비밀번호를 입력하세요.</b><br><br><input type="password" id="bd_pw" name="bd_pw" value=""></div>'));
			box = $('#dialog-message');
		}

		box.dialog({
			modal: true,
			title:'비밀번호',
			buttons: {
				Ok: function() {
					var bd_pw = $('#bd_pw');
					var pw = bd_pw.val().trim();
					
					if(pw==""){
						alert('패스워드를 입력하세요.');
						return;
					}
					data['pw'] = pw;
					bd_pw.val('');
					show(target_layer, url, data);
					$( this ).dialog( "close" );
				}, Cancel: function() {
					$( this ).dialog( "close" );
				}
			}
		});
	}
	
	
	function form_submit(){	
		var form = $('#content_form');

		//폼 정합성 체크
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
		var ir = $('#ir1');
		var val = ir.val();
		var isSuccess = $.valedForm($('[valid]',form));
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
	
	function del_reply(vod_id, rep_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {
				action: 'd',
				_ps: 'voj/vod/view',
				vod_id: vod_id,
				rep_id: rep_id,
				_layout: 'n',
				pageNo:	'${empty(req.pageNo) ? 1 : req.pageNo}'
		};

		show(target_layer, url, data);
	}

	function hideImg(){
		$('#img_viewer').dialog( "close" );
	}
	
	function showImg(id, src){
		if(id=='' || id==null){
			return;
		}
		
		var img_viewer = $('#img_viewer');
		
		if(img_viewer.length<1){
			$('body').append($('<div id="img_viewer" style="padding: 5px;z-index: 999;cursor: pointer;display:none; border: 1px solid #aaaaaa;background-color: #B2CCFF;"><img id="viewer_img" width="${isMobile ? 400 : 700}" style=" border: 1px solid #ffffff;" src="" onclick="hideImg();"/></div>'));
			img_viewer = $('#img_viewer');
		}
		$('#viewer_img').attr('src', src);
		setTimeout(function(){
			$('#viewer_img').attr('src',"at.sh?_ps=at/upload/dl${isMobile ? '&thum=500' : ''}&file_id="+id);
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
			minHeight:300,
			height: 'auto',
			width: 'auto',
			modal: false,
			show: "blind",
			hide: "explode"
		});
	}

</script>

<div  id="body_main" style="display: none;">
	
	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		${HEADER }
	</div>

	<div class="bd_body" style="${isMobile ? '' : 'margin-left: 80px;' }">
		<c:forEach var="row" items="${rows }">
			<div style=" ${row.bd_cat=='sun' ? 'width:48%;' : '' } display:inline-block; margin: 5px;font-size: 12px;vertical-align: top;float: left; ">
				<c:set var="img_link">showImg('${row.file_id }', this.src);</c:set>
				<c:set var="vod_link">load_view(${row.vod_id })</c:set>
				<div style="float: left; display:inline-block;font-size: 14px ;width:160px; margin: 0px;">
					<div onclick="${row.bd_cat=='newfam' ? img_link : vod_link }" style="vertical-align: bottom; width:150px;height:119px;border:1px solid #B6B5DB;margin-bottom:5px; text-align:center; overflow: hidden;cursor: pointer;" >
						<tp:img file_id="${row.file_id}" thum="150" style="width:150px;${row.bd_cat=='sun' ? 'height:119px;' : '' }" />
					</div>
					<c:if test="${req.bd_cat!='sun' && req.bd_cat!='newfam' }">
						<div style=" width:150px; font-size: 12px;"><b>제목 : </b>${row.preacher }</div>
						<div style=" width:150px; font-size: 12px;"><b>날짜 : </b>${row['wk_dt@yyyy-MM-dd'] }</div>
					</c:if>
					<c:if test="${req.bd_cat=='newfam' }">
						<div style=" height:70px; overflow: hidden;">
							<div style=" width:150px; font-size: 12px;">
								<b>${row.title }</b>
								<c:if test="${session.myGroups[req.bd_cat] && viewAdminButton}">
									<div style=" position:absolute;background: #ffffff;  "  >
										<a class="cc_bt" style="float:right;" href="#" onclick="del(${row.vod_id })">삭제</a>
										<a class="cc_bt" style="float:right;" href="#" onclick="edit(${row.vod_id })">수정</a>
									</div>
								</c:if>&nbsp;
							</div>
							<div style=" width:150px; font-size: 12px;">인도자 : ${row.preacher }</div>
							<div style=" width:150px; font-size: 12px;">등록일 : ${row['wk_dt@yyyy-MM-dd'] }</div>
						</div>
					</c:if>
				</div>
	
				<c:if test="${row.bd_cat=='sun' }">
					<table class="bd" style=" display:inline-block;margin:${isMobile ? '0' : '0' }px 5px 5px 5px;width: 200px;vertical-align: top;float: left; ">
						<tr><td width="60"><b>제목</b></td><td width="140" ><div style=" width: 135px;overflow: hidden; text-overflow : ellipsis;"><nobr>${row.title }</nobr></div></td></tr>
						<tr><td width="60"><b>설교자</b></td><td width="140">${row.preacher }</td></tr>
						<tr><td><b>설교일</b></td><td>${row['wk_dt@yyyy-MM-dd'] }</td></tr>
						<tr><td><b>본문</b></td><td><div style=" width: 135px;overflow: hidden; text-overflow : ellipsis;"><nobr>${row.bible }</nobr></div></td></tr>
					</table>
				</c:if>
			</div>
		</c:forEach>
	
		<div style="width: 100%;clear:both;">
			<div style="margin: auto;"><tp:paging listCount="${rows[0].listCount }" pageNo="${rows[0].pageNo }" totCount="${rows[0].totCount }"/></div>
			<table style="width: 100%">
				<tr>
					<td width="100">
						<c:if test="${session.myGroups[req.bd_cat]}">
							<a class="cc_bt" style="float:right;" href="#" onclick="edit()">등 록</a>
						</c:if>&nbsp;
					</td>
				</tr>
				<c:if test="${!isMobile}">
					<tr>
						<td width="*" align="center">
							<div style="clear:both;">
								<form id="main_form" name="main_form" action="" onsubmit="return search()">
									<input type="text" id="search_val" name="search_val" value="${req.cearch_val}" title="검색어">
									<span id="search_btn"  class="ui-icon ui-icon-search" style="margin: 0px;"></span>
								</form>
							</div>
						</td>
					</tr>
				</c:if>
			</table>
		</div>
	</div>
</div>
	