<%@ page contentType="text/html; charset=utf-8"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<uf:organism >
[
	<job:db id="rs" query="voj/new" />
]
</uf:organism>
<c:set var="mb" value="${mobile=='m' ? 'm' : ''}"/>
<script type="text/javascript">

	var isMobileView = false;
	

	$(function($){
	    var bef_over_menu='';
	    $("#main_body").hover(function(e){
	    	;
	    },function(e){
	    	menu_out();
		    $('.sub_menu_list').hide();
	    });
	    
	    $(".top_menu div.top_menu_item").hover(function(e){
	    	menu_out();
	    	var t = $(e.currentTarget);

	     	t.css('background', "url('voj/images/menu/untitled-2.jpg') repeat-x  scroll 0 0 #F5F5F3")
        	
    	   	$('.sub_menu_list').hide();

	        var submenu = t.attr('id');
    	   	$('.'+submenu).show({
        		effect: "fade",
        		duration: 300
        	});
	    },function(e){
	    	bef_over_menu = $(e.currentTarget);
	    });
	    
	    function menu_out(){
			if(bef_over_menu){
				bef_over_menu.css('background', "url('voj/images/menu/untitled-1.jpg') repeat-x  scroll 0 0 #F5F5F3")
			}
	    	
	    }
	    
	    $(".sub_menu_list div").hover(function(e){
	    	$(e.currentTarget).addClass('m_over');
	    },function(e){
	    	$(e.currentTarget).removeClass('m_over');
	    });
	    
	    $('#body_main_contents').click(function(){
	    	$('.sub_menu_list').hide();
	    });
	    $('header').click(function(){
	    	$('.sub_menu_list').hide();
	    });
	    
	    $('.sub_menu_item').click(function(e){
			document.location.href=$(e.currentTarget).attr('value');
	    });

    	var submenu = $('div[bd_cat=${req.bd_cat}]').parent();
    	
    	setCurrentMenu(submenu.attr('value'));
    	
		var font_size = $.cookie('F_S');
		if(font_size){
			$('.bible').css('font-size', font_size+'px');
		}
    	
		$('.font_size').click(function(tar){
			var font_size = $.cookie('F_S');
			var step = -2;
			
			if($(tar.currentTarget).attr('value')=='+'){				
				step = 2;	
			}
			
			if(font_size){
				font_size = Number(font_size) + step;
			}else{
				font_size = 14;					
			}
			
			if(font_size > 20){
				font_size = 20;
			}else if(font_size < 14){
				font_size = 14;
			}

			$.cookie('F_S', font_size,{expires:30});
			$('.bible').css('font-size', font_size+'px');
		});

	});
	
	function setCurrentMenu(menuid){    
     	$('#'+menuid).css('background', "url('voj/images/menu/untitled-2.jpg') repeat-x  scroll 0 0 #F5F5F3");
     	$('#'+menuid).css('border-bottom', "2px solid #ff0000");
	}
	function goVillage(vil_id){
		
		document.location.href='at.sh?_ps=voj/bd/list&bd_cat=vil&bd_key=' + vil_id;
	}
	function openPage(param){
		
		document.location.href='at.sh?_ps=' + param;
	}
	function showBtn(){
		$('#admin_btn').load('at.sh?_ps=voj/admin_view',function(){
			document.location.reload();
		});
		
	}
</script>
	<table style="width: 100%">
		<tr>
			<td class="top_menu" style="padding:0px; padding-left:10px; background: url('voj/images/menu/untitled-1.jpg') repeat-x  scroll 0 0 #F5F5F3;font: bold;color: white;">
				<div class="d_ib">
					<div id="m1" class="top_menu_item" onclick${mb }="openPage('voj/intro/show&id=bow')"  title="교회안내">
						교회안내
					</div>
					<div class="sub_menu_list m1" value="m1">
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_bow">인사말</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_church">교회소개</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_pst">담임목사소개</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_serve">섬기는이</div>
<c:if test="${viewAdminButton && session.myGroups['dev']}">
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_organize">교회조직</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_phil">목회철학</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_his">교회역사</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_trad">교회전통</div>
</c:if>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_rough">오시는길</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=m_chtm">예배시간</div>
					</div>
				</div>
				<div class="d_ib">
					<div id="m2" class="top_menu_item" onclick${mb }="openPage('voj/vod/list&&bd_cat=sun')" title="말씀과찬양">
						말씀과찬양
					</div>
	
					<div class="sub_menu_list m2" value="m2">
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&&bd_cat=sun" bd_cat="sun">주일예배</div> 
<c:if test="${viewAdminButton && session.myGroups['dev']}">
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&bd_cat=praise" bd_cat="praise">경배와 찬양</div>

						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&bd_cat=hymn" bd_cat="hymn">성가대찬양</div>
</c:if>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/mc/day_viewm">성경읽기</div> 
					</div>
				</div>
				<div class="d_ib" style="position: relative; ">
					<c:if test="${rs.crow.cnt > 0 || rs.grow.cnt > 0 }" >
						<img style="position: absolute;" src="images/icon/new_ico.gif">
					</c:if>
					<div id="m4" class="top_menu_item" onclick${mb }="openPage('voj/bd/list&bd_cat=cafe')" title="커뮤니티">
						커뮤니티
					</div>
					<div class="sub_menu_list m4" value="m4" >
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=cafe" bd_cat="cafe">
							<c:set scope="request" var="new_count">최근 등록된 글이 없습니다.</c:set>
							<c:if test="${rs.crow.cnt > 0}" >
								<img style="position: absolute;" src="images/icon/new_ico.gif">
								<c:set var="new_count" scope="request" >${rs.crow.b_hour+1}시간 내에 등록된<br>글이 있습니다.</c:set>
								<c:set var="title1">title="${rs.crow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
							</c:if>
							이야기나눔/카페
						</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/gal/list&bd_cat=voj" bd_cat="voj">
							<c:if test="${rs.grow.cnt > 0}" >
								<img style="position: absolute;" src="images/icon/new_ico.gif">
							</c:if>
							갤러리
						</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/well/well_list&bd_id=max" bd_cat="well">우물가소식</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/sch/show" bd_cat="sch">교회일정</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&&bd_cat=newfam" bd_cat="newfam">새가족</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=pst" bd_cat="pst">담임목사와 함께</div>
					</div>
				</div>
				<div class="d_ib" value="m5">
					<c:if test="${rs.vrow.cnt > 0}" >
						<img style="position: absolute;" src="images/icon/new_ico.gif">
					</c:if>
					<div id="m5" class="top_menu_item" bd_cat="vil" onclick${mb }="goVillage('')" title="마을속회">
						마을속회
					</div>
					<div class="sub_menu_list m5" value="m5" style="background: #ffffff url('voj/images/menu/bg${ uf:round(uf:floor(((uf:random()*100) % 5)))+1 }.jpg') no-repeat 20px 50px/90% 70%; cursor: default; ${isMobile ? 'left: 30px;' : '' }">
						<tp:village bd_key="${req.bd_key }"/>		
					</div>
				</div>
<c:if test="${viewAdminButton && session.myGroups['dev']}">
				<div class="d_ib">
					<div id="m7" class="top_menu_item"  onclick${mb }="openPage('voj/intro/show&mid=m7&id=agl')"  title="교육훈련">
						교육훈련
					</div>
					<div class="sub_menu_list m7" value="m7"  style=" ${isMobile ? 'left: 160px;' : '' }"">
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=agl" >천사,꿈마당</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=jss" >예수마당</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=frt" >과일마당</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=ym" >청년부</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=nbel">새신자교육</div>
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=youth">꿈찾기 코칭</div>
					</div>
				</div>
				<div class="d_ib">
 					<div id="m6" class="top_menu_item" onclick${mb }="openPage('voj/intro/show&mid=m6&id=ser1')"  title="섬김과나눔">
 						섬김과나눔
					</div>
	 				<div class="sub_menu_list m6" value="m6" style=" ${isMobile ? 'left: 170px;' : '' }">
						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m6&id=ser1">장학</div>

						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m6&id=ser2">구제</div>

						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m6&id=ser3">나눔</div>

						<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m6&id=ser4">봉사</div>
					</div>
				</div>
</c:if>				
				<c:if test="${session.myGroups['mj']}">
					<div class="d_ib">
						<div id="m10"  class="top_menu_item" style="margin-top: 3px;" onclick="openPage('voj/bd/list&bd_cat=mj')">
							<a class="cc_bt" href="#">예당</a>
						</div>
					</div>
				</c:if>		
				<c:if test="${session.myGroups['admin']}">
					<div class="d_ib">
						<div id="m8"  class="top_menu_item" style="margin-top: 3px;">
							<a class="cc_bt" href="#">관리자</a>
						</div>
		 				<div class="sub_menu_list m8" value="m8" >
							<div id="admin_btn" onclick="showBtn()">관리버튼 ${viewAdminButton ? '숨김' : '보기' }</div>
							<div class="sub_menu_item m_out" value="at.sh?_ps=voj/usr/user_list">회원관리</div>
							<div class="sub_menu_item m_out" value="atm.sh?_t=list&_q=voj/header/list">게시판 제목 관리</div>
							<div class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/list">홈페이지 내용 관리</div>
							<div class="sub_menu_item m_out" value="at.sh?_ps=voj/gal/list&bd_cat=img">메인 이미지 관리</div>
							<div class="sub_menu_item m_out" value="at.sh?_ps=voj/bd/list&bd_cat=sch">일정 관리</div>
							<div class="sub_menu_item m_out" value="at.sh?_ps=main">시스템 관리</div>
						</div>
					</div>
				</c:if>		
			</td>
		</tr>
		<tr>
			<td>
				<div id="body_main_contents" >
				</div>
			</td>
		</tr>		
	</table>
	