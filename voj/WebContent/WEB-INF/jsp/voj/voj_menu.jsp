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

        	var menu_img = $('img', t);
        	var src = menu_img.attr('value');
        	var url = 'voj/images/menu${mb }/' + src + '_1.png';
        	
        	menu_img.attr('src', url);
        	
    	   	$('.sub_menu_list').hide();

	        var submenu = t.attr('id');
    	   	$('.'+submenu).show({
        		effect: "slidedown",
        		duration: 300
        	});
	    },function(e){
	    	var t = $(e.currentTarget);
        	bef_over_menu = $('img', t);
	    });
	    
	    function menu_out(){
			if(bef_over_menu){
	           	var src = bef_over_menu.attr('value');
	        	
	        	if(bef_over_menu.attr('org')){
	        		;
	        	}else{
	            	var url = 'voj/images/menu${mb }/' + src + '.png';
	            	bef_over_menu.attr('src', url);
	        	}
			}
	    	
	    }
	    //old
	    $(".sub_menu_list div").hover(function(e){
	    	$(e.currentTarget).removeClass('m_out');
	    	$(e.currentTarget).addClass('m_over');
	    },function(e){
	    	$(e.currentTarget).addClass('m_out');
	    	$(e.currentTarget).removeClass('m_over');
	    });
		//new
	    $('.on', $('.sub_menu_list')).hide();
		
	    $(".sub_menu_list span").hover(function(e){
	    	$('.off', $(e.currentTarget)).hide();
	    	$('.on', $(e.currentTarget)).show();
	    	$(e.currentTarget).removeClass('m_out');
	    	$(e.currentTarget).addClass('m_over');
	    },function(e){
	    	$('.on', $(e.currentTarget)).hide();
	    	$('.off', $(e.currentTarget)).show();
	    	$(e.currentTarget).addClass('m_out');
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
     	var menu_img = $('img', $('#'+menuid));
    	var src = menu_img.attr('value');
    	var url = 'voj/images/menu/' + src + '_1.png';
    	menu_img.attr('src', url);
    	menu_img.attr('org', url);
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
	<table style="width: 100%; border: 0;" cellpadding="0" cellspacing="0" >
		<tr id="top_menu_body">
			<td class="top_menu" style="padding:0px; background: url('voj/images/menu/untitled-1.png') repeat-x  scroll 0 0 #F5F5F3;font: bold;color: white;">
				<div class="d_ib">
					<div id="m1" class="top_menu_item" onclick${mb }="openPage('voj/intro/show&id=bow')"  memo="교회안내">
						<img value="menu1" src="voj/images/menu/menu1.png" border="0">
					</div>
					<div class="sub_menu_list m1" value="m1">
						<span class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=bow" desc="인사말">
							<img class="off" src="voj/images/menu/m11.png"><img class="on" src="voj/images/menu/m11_1.png">
						</span>
						<span class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=church" desc="교회소개">
							<img class="off" src="voj/images/menu/m12.png"><img class="on" src="voj/images/menu/m12_1.png">
						</span>
						<span class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=pst" desc="담임목사소개">
							<img class="off" src="voj/images/menu/m13.png"><img class="on" src="voj/images/menu/m13_1.png">
						</span>
						<span class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=serve" desc="섬기는이">
							<img class="off" src="voj/images/menu/m14.png"><img class="on" src="voj/images/menu/m14_1.png">
						</span>
<c:if test="${viewAdminButton && session.myGroups['dev']}">
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=organize"> 교회조직 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=phil"> 목회철학 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=his"> 교회역사 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&id=trad"> 교회전통 </span>
</c:if>
						<span class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=rough" desc="오시는길">
							<img class="off" src="voj/images/menu/m15.png"><img class="on" src="voj/images/menu/m15_1.png">
						</span>
						<span class="sub_menu_item " value="at.sh?_ps=voj/intro/show&id=chtm" desc="예배시간">
							<img class="off" src="voj/images/menu/m16.png"><img class="on" src="voj/images/menu/m16_1.png">
						</span>
					</div>
				</div>
				<div class="d_ib">
					<div id="m2" class="top_menu_item" onclick${mb }="openPage('voj/vod/list&&bd_cat=sun')" memo="말씀과찬양">
						<img value="menu2" src="voj/images/menu/menu2.png" border="0">
					</div>
	
					<div class="sub_menu_list m2" value="m2">
						<span class="sub_menu_item" value="at.sh?_ps=voj/vod/list&&bd_cat=sun" bd_cat="sun" desc="주일예배">
							<img class="off" src="voj/images/menu/m21.png"><img class="on" src="voj/images/menu/m21_1.png">
						</span> 
<c:if test="${viewAdminButton && session.myGroups['dev']}">
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&bd_cat=praise" bd_cat="praise"> 경배와 찬양 </span>

						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/vod/list&bd_cat=hymn" bd_cat="hymn"> 성가대찬양 </span>
</c:if>
						<span class="sub_menu_item" value="at.sh?_ps=voj/mc/day_view" desc="성경읽기">
							<img class="off" src="voj/images/menu/m22.png"><img class="on" src="voj/images/menu/m22_1.png">
						</span> 
					</div>
				</div>
				<div class="d_ib">
					<c:if test="${rs.crow.cnt > 0 || rs.grow.cnt > 0 }" >
						<img style="position: absolute;margin-left: 35px;" src="images/icon/new_ico.gif">
						<c:set var="title0">title="${rs.crow.b_hour < rs.grow.b_hour ? rs.crow.b_hour+1 : rs.grow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
					</c:if>
					<div id="m4" class="top_menu_item" desc="커뮤니티">
						<img value="menu3" src="voj/images/menu/menu3.png" border="0"  ${title0 }>
					</div>
					<div class="sub_menu_list m4" value="m4" >
						<span class="sub_menu_item " value="at.sh?_ps=voj/bd/list&bd_cat=cafe" bd_cat="cafe" desc="이야기나눔/카페">
							<c:set scope="request" var="new_count">최근 등록된 글이 없습니다.</c:set>
							<c:if test="${rs.crow.cnt > 0}" >
								<img style="position: absolute;" src="images/icon/new_ico.gif">
								<c:set var="new_count" scope="request" >${rs.crow.b_hour+1}시간 내에 등록된<br>글이 있습니다.</c:set>
								<c:set var="title1">title="${rs.crow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
							</c:if>
							<img class="off" src="voj/images/menu/m41.png"><img class="on" src="voj/images/menu/m41_1.png" ${title1 }>
						</span>
						<span class="sub_menu_item " value="at.sh?_ps=voj/gal/list&bd_cat=voj" bd_cat="voj" desc="갤러리">
							<c:if test="${rs.grow.cnt > 0}" >
								<img style="position: absolute;" src="images/icon/new_ico.gif">
								<c:set var="title2">title="${rs.grow.b_hour+1}시간 내에 등록된 이미지나 댓글이 있습니다."</c:set>
							</c:if>
							<img class="off" src="voj/images/menu/m42.png"><img class="on" src="voj/images/menu/m42_1.png" ${title2 }>
						</span>
						<span class="sub_menu_item " value="at.sh?_ps=voj/well/well_list&bd_id=max" bd_cat="well" desc="우물가소식">
							<img class="off" src="voj/images/menu/m43.png"><img class="on" src="voj/images/menu/m43_1.png">
						</span>

						<span class="sub_menu_item " value="at.sh?_ps=voj/bd/list&bd_cat=pst" bd_cat="pst" desc="담임목사와 함께">
							<img class="off" src="voj/images/menu/m46.png"><img class="on" src="voj/images/menu/m46_1.png">
						</span>
						<span class="sub_menu_item " value="at.sh?_ps=voj/vod/list&&bd_cat=newfam" bd_cat="newfam" desc="새가족">
							<img class="off" src="voj/images/menu/m45.png"><img class="on" src="voj/images/menu/m45_1.png">
						</span>
						<span class="sub_menu_item " value="at.sh?_ps=voj/sch/show" bd_cat="sch"desc="교회일정">
							<img class="off" src="voj/images/menu/m44.png"><img class="on" src="voj/images/menu/m44_1.png">
						</span>
					</div>
				</div>
				<div class="d_ib" value="m5">
					<c:if test="${rs.vrow.cnt > 0 }" >
						<img style="position: absolute;margin-left: 35px;" src="images/icon/new_ico.gif" >
						<c:set var="title3">title="${rs.vrow.b_hour+1}시간 내에 등록된 글이 있습니다."</c:set>
					</c:if>
					<div id="m5" class="top_menu_item" bd_cat="vil" onclick${mb }="goVillage('')" memo="마을속회">
						<img value="menu4" src="voj/images/menu/menu4.png" border="0" ${title3 }>
					</div>
					<div class="sub_menu_list m5" value="m5" style="background: #ffffff url('voj/images/menu/bg${ uf:round(uf:floor(((uf:random()*100) % 5)))+1 }.jpg') no-repeat 20px 50px/90% 70%; cursor: default; ${isMobile ? 'left: 30px;' : '' }">
						<tp:village bd_key="${req.bd_key }"/>		
					</div>
				</div>
<c:if test="${viewAdminButton && session.myGroups['dev']}">			
				<div class="d_ib">
					<div id="m7" class="top_menu_item" onclick${mb }="openPage('voj/intro/show&mid=m7&id=agl')"  memo="교육훈련">
						<img value="menu5" src="voj/images/menu/menu5.png" border="0">
					</div>
					<div class="sub_menu_list m7" value="m7"  style=" ${isMobile ? 'left: 120px;' : '' }"">
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=agl" > 천사,꿈마당 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=jss" > 예수마당 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=frt" > 과일마당 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=ym" > 청년부 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=nbel"> 새신자교육 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m7&id=youth"> 꿈찾기 코칭 </span>
					</div>
				</div>
				<div class="d_ib">
 					<div id="m6" class="top_menu_item" onclick${mb }="openPage('voj/intro/show&mid=m6&id=ser1')"  memo="섬김과나눔">
 						<img value="menu6" src="voj/images/menu/menu6.png" border="0">
					</div>
	 				<div class="sub_menu_list m6" value="m6" style=" ${isMobile ? 'left: 170px;' : '' }">
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m6&id=ser1"> 장학 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m6&id=ser2"> 구제 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m6&id=ser3"> 나눔 </span>
						<span class="sub_menu_item m_out" value="at.sh?_ps=voj/intro/show&mid=m6&id=ser4"> 봉사 </span>
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
	