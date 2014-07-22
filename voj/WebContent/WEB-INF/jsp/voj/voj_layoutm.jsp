<%@ page contentType="text/html; charset=utf-8"%>
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
<c:set scope="session" var="HEADER" value="${empty(hRow.HEADER) ? header_edit : hRow.HEADER }"/>

<c:set scope="request" var="tpl_class_title" value="ui-widget ui-widget-content contents-contain ui-state-default title"/>
<c:set scope="request" var="tpl_class_search" value=""/>
<c:set scope="request" var="tpl_class_table" value="ui-widget ui-widget-content contents-contain"/>
<c:set scope="request" var="tpl_class_table_header" value="ui-state-default"/>

<c:if test="${ req._layout!='n'}">
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<head>
<title>예수마을교회 :: 신실한 성도. 거룩한 교회. 행복한 공동체.</title>
<meta name="viewport" content="user-scalable=${req._ps=='voj/intro/show' ? 'yes' : 'no'}, width=device-width, initial-scale=1, maximum-scale=2">
<link href="./voj/css/contents_m.css" rel="stylesheet" type="text/css" />
<link href="./voj/css/contents.css" rel="stylesheet" type="text/css" />
<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css"/>
<link href="./jquery/dynatree/doc/skin-custom/custom.css" rel="stylesheet" type="text/css" />

<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="./jquery/js/jquery.json-2.3.js"></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>
<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="./jquery/js/excanvas.min.js"></script><![endif]-->
<script src="./jquery/js/jquery.dynatree.js" type="text/javascript"></script>

<script src="./jquery/flot/jquery.flot.js"></script>
<script src="./jquery/flot/jquery.flot.pie.js"></script>

<script src="./at.sh?_ps=js/message" type="text/javascript" ></script>
<script src="./js/graph.js" type="text/javascript" ></script>
<script src="./js/formValid.js" type="text/javascript" ></script>

<script src="./js/commonUtil.js"></script>

<c:if test="${!empty(param.inc) }">
	<script src="./voj/js/${param.inc }.js"></script>
</c:if>
<script type="text/javascript">
	var isMobileView = false;
	

	$(function($){
	    $('#body_main_contents').append($('#body_main'));	    	

	    init_load();
	    
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
		
		bible_bg_b = $.cookie('bible_bg_b')=='bible_bg_b';
		
		$('.bible').addClass(bible_bg_b ? 'bible_bg_b' : 'bible_bg_w');
	});
	
	var bible_bg_b=true;

	function toggleBG(){
		bible_bg_b = !bible_bg_b;
		$('.bible').toggleClass('bible_bg_w',!bible_bg_b);
		$('.bible').toggleClass('bible_bg_b',bible_bg_b);
		$.cookie('bible_bg_b', (bible_bg_b ? 'bible_bg_b' : 'bible_bg_w'),{expires:30});
	}

	function init_load(){
	    $('#body_main').show();
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
	
	function showAutoItemNevi(){
		showItemNevi();
		hideItemNevi();
	}
	function showItemNevi(){
		$('.content_nevi').css({opacity: .15,filter: 'Alpha(Opacity=15)'});
	}
	function hideItemNevi(){
		//setTimeout(function(){
		//	$('.content_nevi').css({opacity: 0,filter: 'Alpha(Opacity=0)'});
		//},5000);
	}

</script>

</head>

<body style="padding: 2px;">
<div style="margin: 0 auto; width: 100%;">
	<header id="header" style="border:0; ">
		<div style="width:100%;">
			<table style=width:100%;">
				<tr><td valign="top">
					<a href="/"><img src="./voj/images/log.png" border="0" height="30" style="vertical-align: middle;"></a>
				</td><td align="right" valign="top">
					<c:if test="${session.user_id!='guest'}">
						<div class="btn-r" style="margin-top:3px;margin-right: 20px;">
							<a href="at.sh?_ps=voj/usr/user_edit"><b>${session.nick_name }</b></a>님 안녕하세요.
							<a href="at.sh?_ps=login/logout"><img src="./voj/images/btn_gnb_logout.gif" style="vertical-align: bottom;;" border="0"></a>
						</div>
					</c:if>
					<c:if test="${session.user_id=='guest' }">
						<div class="btn-r" style="margin-top: 0px;margin-right: 10px;">
							<a href="at.sh?_ps=login/login_form"><img src="./voj/images/btn_gnb_login.gif" style="vertical-align: bottom;" border="0"></a>
						</div>
					</c:if>
				</td></tr>
			</table>
		</div>
	</header>
	
	<jsp:include page="voj_menum.jsp" />

	<div style="width: 100%;margin: 5px;font-size: 12px;">
		<c:if test="${req._ps=='voj/mc/day_view' }">
			<div class="cc_bt l" onclick="toggleBG()" style="width: 45px;;display: inline-block;text-align: left;;">
				<img  src="images/energy-icon.png" height="18" border="0" align="top">절전
			</div>
			<div class="f_r"  style=" display: inline-block;text-align: right;;margin-right: 10px;">
				<span class="font_size cc_bt" style="padding: 1px; min-width: 40px; " value="-">가-</span> 
				<span class="font_size cc_bt" style="padding: 1px; min-width: 40px; font-weight:bold;" value="+">가+</span>
			</div>
			<div class="f_r" style=" display: inline-block;text-align: right;line-height: 25px;">글자크기&nbsp;</div>
		</c:if>
	</div>
	<footer class="footer" style="height: 50px;text-align: center;clear: both;" >
		<table style="margin-bottom: 10px;  border-bottom:1px solid #050099; width: 100%;"><tr><td height="1" ></td></tr></table>
		<div style="font-size: 12px;">132-834 서울 도봉구 시루봉로 5길 38 (방학3동 496) | TEL: 02-954-0254 또는 070-7124-0000 | info@vojesus.org </div>
	</footer>
</div>

<div id="prev_layer" onmousemove="showItemNevi()" onmouseout="hideItemNevi()" style="position: fixed; bottom: 50px;right: 0px;">
	<div class="next_item content_nevi" title="최신 자료" style="width:100px; opacity: .1;filter: Alpha(Opacity=10); display: none; cursor: pointer;text-align: center;"><img src="./voj/images/up-icon.png"></div>
	<div class="prev_item content_nevi" title="이전 자료" style="width:100px; opacity: .1;filter: Alpha(Opacity=10); display: none; cursor: pointer;text-align: center;"><img src="./voj/images/down-icon.png"></div>
</div>

</body>
</html>
</c:if>