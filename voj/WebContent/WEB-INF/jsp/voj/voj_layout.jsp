<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<uf:organism noException="true">[
	<job:db id="hRow" query="voj/header"   isCache="false" refreshTime="5" singleRow="true" >
		defaultValues:{
			bd_cat: "${empty(req.bd_cat) ? param.bd_cat : req.bd_cat}"
		}
	</job:db>
]</uf:organism>
<c:set scope="session" var="HEADER">
	${empty(hRow.HEADER) ? header_edit : hRow.HEADER }
</c:set>

<c:set scope="request" var="tpl_class_title" value="ui-widget ui-widget-content contents-contain ui-state-default title"/>
<c:set scope="request" var="tpl_class_search" value=""/>
<c:set scope="request" var="tpl_class_table" value="ui-widget ui-widget-content contents-contain"/>
<c:set scope="request" var="tpl_class_table_header" value="ui-state-default"/>

<c:if test="${ req._layout!='n'}">
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<title>예수마을교회 :: 신실한 성도. 거룩한 교회. 행복한 공동체.</title>
<link href="./voj/css/contents_w.css" rel="stylesheet" type="text/css" />
<link href="./voj/css/contents.css" rel="stylesheet" type="text/css" />
<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css"/>
<link href="./jquery/dynatree/doc/skin-custom/custom.css" rel="stylesheet" type="text/css" />

<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="./jquery/js/jquery.json-2.3.js"></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>

<script src="./at.sh?_ps=js/message" type="text/javascript" ></script>
<script src="./js/formValid.js" type="text/javascript" ></script>

<script src="./js/commonUtil.js"></script>
<c:if test="${!empty(param.inc) }">
	<script src="./voj/js/${param.inc }.js"></script>
</c:if>
<script type="text/javascript">
	var isMobileView = false;
	

	$(function($){
	    $('#body_main_contents').append($('#body_main'));
	    $('.prev_item').click(function(){
	    	if(goPrev){
	    		goPrev();
	    	}
	    });
	    $('.next_item').click(function(){
	    	if(goNext){
	    		goNext();
	    	}
	    });
		
	    init_load();
	    
 	});
	
	var bible_bg=true;
	function rev(){
		bible_bg = $.cookie('bible_bg')=='bible_bg_b';
		$('.bible').toggleClass('bible_bg_w',bible_bg);
		$('.bible').toggleClass('bible_bg_b',!bible_bg);
		bible_bg = !bible_bg;
		$.cookie('bible_bg', (bible_bg ? 'bible_bg_w' : 'bible_bg_b'),{expires:30});
	}
	
	function init_load(option){
	    $('#body_main').hide();
	    $('#body_main').show(option);
	    
	}
	
	
	function checkFunction(a, b){
		alert(1);
	}
	function show(layer, ur, data, noHide, callBack){
		if(noHide){
		}else{
			layer.hide();
		}
		layer.html('');
		layer.load(ur, data, function(){
			//layer.show({duration:700,easing:'fade'});
			layer.show();
			if(callBack) callBack();
		});
	}
	
	function callUrl( url, data){
		document.location.href = url + '?' + $.param(data); 
	}

	function showAutoItemNevi(){
		showItemNevi();
		hideItemNevi();
	}
	function showItemNevi(){
		$('.content_nevi').css({opacity: .35,filter: 'Alpha(Opacity=35)'});
	}
	function hideItemNevi(){
		//setTimeout(function(){
		//	$('.content_nevi').css({opacity: 0,filter: 'Alpha(Opacity=0)'});
		//},5000);
	}
</script>

</head>

<body>

		<div style="margin: 0 auto; width:1000px;border: 1px solid #ffffff;" id="main_body">
			<header id="header" >
				<div style="width:100%;">
					<table style="width:1000px;">
						<tr><td valign="top">
							<a href="/"><img src="./voj/images/log.png" border="0" height="60" style="vertical-align: middle;"></a>
						</td><td align="right" valign="top">
							<c:if test="${session.user_id!='guest'}">
								<div class="btn-r" style="margin-top:10px;margin-right: 20px;">
									<a href="at.sh?_ps=voj/usr/user_edit"><b>${session.nick_name }</b></a>님 안녕하세요.
									<a href="at.sh?_ps=login/logout"><img src="./voj/images/btn_gnb_logout.gif" style="vertical-align: bottom;;" border="0"></a>
								</div>
							</c:if>
							<c:if test="${session.user_id=='guest' }">
								<div class="btn-r" style="margin-top: 10px;margin-right: 20px;">
									<a href="at.sh?_ps=login/login_form"><img src="./voj/images/btn_gnb_login.gif" style="vertical-align: bottom;" border="0"></a>
								</div>
							</c:if>
						</td></tr>
					</table>
				</div>
		
			</header>
			
			<jsp:include page="voj_menu.jsp" />
			
			<footer class="footer" style="text-align: center;clear: both;width:100%;" >
				<div style="font-size: 12px;text-align: center;width:100%;">
					<table style="margin-bottom: 10px;   border-bottom:1px solid #eeeeee; width: 100%;"><tr><td height="1" ></td></tr></table>
					예수마을교회 | (132-834) 서울 도봉구 시루봉로5길 38 - (방학3동496번지)<br>
					TEL : 0707-124-0000, 02-954-0254 | E-MAIL : info@vojesus.org<br>
					Copyright(c) 2014 www.vojesus.org All right reserved
				</div><br>
			</footer>
		</div>
		
		<div id="prev_layer" onmousemove="showItemNevi()" onmouseout="hideItemNevi()" style="position: fixed; bottom: 50px;right: 0px;">
			<div class="next_item content_nevi" title="최신 자료" style="width:100px; opacity: .3;filter: Alpha(Opacity=30); display: none; cursor: pointer;text-align: center;">다음글<br><img src="./voj/images/up-icon.png"></div>
			<div class="prev_item content_nevi" title="이전 자료" style="width:100px; opacity: .3;filter: Alpha(Opacity=30); display: none; cursor: pointer;text-align: center; margin-top:20px;"><img src="./voj/images/down-icon.png"><br>이전글</div>
		</div>
</body>
</html>
</c:if>