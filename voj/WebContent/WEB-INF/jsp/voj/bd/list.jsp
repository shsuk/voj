<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<jsp:include page="../voj_layout${mobile}.jsp" >
	<jsp:param value="bd_list" name="inc"/>
</jsp:include>

<uf:organism >
[
	<job:db id="nrows" query="voj/bd/list_notice" singleRow="false" />
	<job:db id="rows" query="voj/bd/list" singleRow="false" >
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
	var bd_cat = "${req.bd_cat}";
	var pageNo = "${empty(req.pageNo) ? 1 : req.pageNo}";
	
	$(function() {
		$('#search_btn').button({icons: {primary: "ui-icon-search" },text:false}).click(function(){
			search();
		});
		
	    $('.prev_item').hide();
	    $('.next_item').hide();
	    
	    init_load({duration:300,easing:'fade'});
	    
		<c:if test="${req.bd_cat=='vil' }">
			$('#vil_name').text("${empty(req.bd_key) ? '전체마을' : '' }${code:name('vil',req.bd_key,'')}${code:ref('vil',req.bd_key)}");
		</c:if>
		
	    if(!${empty(req.bd_id)}){
	    	view_bd('${req.bd_id}');
	    }
	}); 
	
	
	function view_bd(bd_id){
		var target_layer = $('.bd_body');
		
		
		var url = 'at.sh';
		var data = {
				_ps: 'voj/bd/view',
				bd_id: bd_id,
				_layout: 'n',
				pageNo:	$('#pageNo').val()
		};

		show(target_layer, url, data);
	
	}


	function goPrev(){
		load_view($('.prev_item')[0]);	
	}
	
	function goNext(){
		load_view($('.next_item')[0]);	
	}

	function form_submit(){	

		form_submit1(${session.user_id=='guest' });

	}
	
	
	function reReply(upper_rep_id){
		$('#action', $('#reply_form')).val('i');
		
		$('#re_mask').show();
		$('#re_reply').show();
		$('#re_tilte').text('댓글 달기');
		$('#re_reply_comtents').append($('#reply'));
		
		$('#upper_rep_id').val(upper_rep_id);
	}
	function colseReReply(){
		$('#action', $('#reply_form')).val('i');
		$('#re_mask').hide();
		$('#re_reply').hide();
		$('#reply_comtents').append($('#reply'));
	}
	function edit_reply(rep_id){
		$('#action', $('#reply_form')).val('u');
		$('#re_mask').show();
		$('#re_reply').show();
		$('#re_tilte').text('댓글 수정');
		$('#re_reply_comtents').append($('#reply'));
		
		$('#rep_id').val(rep_id);
		$('#rep_text').val($('#re_'+rep_id).text().trim());
		
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

<div  id="body_main"  class="bd_title" style="display: none;">
	
	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		${HEADER }
	</div>

	<div class="bd_body">
		<div style="width: 100%;min-height: 400px;">
		<table class="bd" >
			<tr>
				<th width="50" class="${mobile}">번호</th>
				<th>제목</th>
				<th width="80">작성자</th>
				<th width="100" class="${mobile}">작성일</th>
				<th width="50" class="${mobile}">조회</th>
				<c:if test="${req.bd_cat=='vil'}">
					<th width="70">마을</th>
				</c:if>
			</tr>
			<c:forEach var="row" items="${nrows }">
				<tr style="background-color: #E4EDD5;">
					<td style="text-align: center;" class="${mobile}">공지</td>
					<td>
						<div class="view_link" onclick="load_view(this)" style=" color:black;" bd_id="${row.bd_id}">${row['title'] }</div>
					</td>
					<td style="text-align: center; color:black;">운영자</td>
					<td style="text-align: center; color:black;" class="${mobile}">${row['reg_dt@yyyy-MM-dd'] }</td>
					<td style="text-align: center; color:black;" class="${mobile}">-</td>
				</tr>
			</c:forEach>
			<c:forEach var="row" items="${rows }">
				<tr>
					<td style=" text-align: center;" class="${mobile}">${row.bd_id }</td>
					<td>
						<c:set var="isLock" value="${true}" />
						<c:if test="${row.security!='Y' || session.user_id==row.reg_id || session.myGroups['rev']}">
							<c:set var="isLock" value="${false}" />
						</c:if>
						<div class="${isLock ? '' : 'view_link' }" ${isLock ? 'no' : 'onclick'}="load_view(this)" 
							bd_id="${row.bd_id}" 
							bd_key="${row.bd_key}"
							value="${row.security=='Y' && row.reg_id=='guest' ? row.security : ''}"
						>	
							<c:if test="${row.new_item == 1}" >
								<img src="images/icon/new_ico.gif">
							</c:if>
							${row['title'] }
							${row.security=='Y' ? '<img style="vertical-align:bottom;" width="10" src="images/icon/lock-icon.png">' : '' }
							${row.file_id==0 ? '' : '<img style="vertical-align:bottom;" src="images/icon/attach.png">' }
							<c:set var="re_count"> <font color="#6799FF">(${ row.re_new>0 ? '<img src="images/icon/new_ico.gif">' : ''}${row.re_count })</font></c:set>
							${ row.re_count>0 ? re_count : '' }
						</div>
					</td>
					<td style="text-align: center;" title="${row['USER_NM@dec@name'] }">${row.reg_nickname }</td>
					<td style="text-align: center;" class="${mobile}">${row['reg_dt@yyyy-MM-dd'] }</td>
					<td style="text-align: center;" class="${mobile}">${row.view_count }</td>
					<c:if test="${req.bd_cat=='vil'}">
						<td style="text-align: center;">${code:name('vil',row.bd_key,lang )}${code:ref('vil',row.bd_key)}</td>
					</c:if>
				</tr>
			</c:forEach>
		</table>
		</div>
		
		<div style="width: 100%;">
			<div style="margin: auto;"><tp:paging listCount="${rows[0].listCount }" pageNo="${rows[0].pageNo }" totCount="${rows[0].totCount }"/></div>
			<table style="width: 100%">
				<tr>
					<td width="100%">
						<c:if test="${session.user_id!='guest' || cookie.bd_add.value > uf:addMinutes(uf:now(),-160).time  }">
							<c:set var="edit" value="edit(null,null,'${req.bd_key }')"/>
							<a class="cc_bt" style="float:right;" href="#" onclick="${req.bd_cat!='vil' || !empty(req.bd_key) ? edit : "alert('마을을 선택한 후 글을 쓰세요.')" }">새 글</a>
						</c:if>
						<c:if test="${req.bd_cat=='vil' && session.myGroups['vil']}">
							<a href="/at.sh?_ps=voj/bd/list&bd_cat=ser"  class="cc_bt" style="float:right;margin-right: 5px;">공과</a>
						</c:if>
					</td>
				</tr>
				<c:if test="${!isMobile}">
					<tr>
						<td width="*" align="center">
							<div style="clear:both;">
								<form id="main_form" name="main_form" action="" onsubmit="return search()">
									<input type="text" id="search_val" name="search_val" value="${req.cearch_val}" title="제목">
									<span id="search_btn" class="ui-icon ui-icon-search" style="margin: 0px;">조회</span>
								</form>
							</div>
						</td>
					</tr>
				</c:if>
			</table>
		</div>
	</div>
</div>	