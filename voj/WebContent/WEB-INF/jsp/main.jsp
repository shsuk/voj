<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu" noException="true">
[
	<uf:job id="rows" jobId="db" query="system/menu/menu_list" isCache="false" refreshTime="300" />
	<uf:job id="rows" jobId="list2Tree"  >
		data: 'rows',
		singleKey: true,
		upperIdField: 'upper_rid',
		idField: 'rid',
		title: 'menu_name',
		rootId: '1000'
	</uf:job>
]
</uf:organism>

<c:set var="target" scope="request" value="menu_tree"/>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<title>ISlim</title>
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />
	
	<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
	<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css"/>
	<link href="./css/contents.css" rel="stylesheet"  id="css" />
	
	<script src="./jquery/js/jquery-1.9.1.min.js"></script>
	<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
	<script src="./jquery/js/jquery.cookie.js"></script>
	<script src="./jquery/js/jquery.dynatree.js" type="text/javascript"></script>
	
	<script src="./js/commonUtil.js"></script>
	<script src="./js/main.js"></script>
	
	<script type="text/javascript">
			
		$(function() {
			<c:if test="${isMobileView }">
				$.ajax('at.sh?_ps=main&mb=N');
			</c:if>
			//트리생성 시작
			var data = ${JSON.rows};
			
			$('.${target}').dynatree({
				onActivate : function(node) {
					if(node.data.url==null){
						return;
					}
					
					if(${isMobile} || node.data.new_win=='Y'){
						window.open(node.data.url, "_blank");
					}else{
						open_tab_frame(node);
					}
				},
				minExpandLevel: 2,
				imagePath: "./jquery/dynatree/doc/skin-custom/",
				children : data
			});
			
			//처음선택되는 노드
			if('${req.select_key}'!='') $('.${target}').dynatree("getTree").activateKey('${req.select_key}');
			else  $('.${target}').dynatree('getTree').getRoot().childList[0].activate();
			//트리생성 끝 
			
		});
	
		function open_tab_frame(node){
			var url = node.data.url;
	
			if(url==null) return;
			
			var id = node.data.menu_id;
			addTab(id, node.data.menu_name.replace('-',''), url, '', 'iframe');
		}
		
	</script>

</head>
<body style="overflow-x:hidden; overflow-y:hidden;">

	<header id="header" style="background-color:#E6FFFF;">
		<img src="./voj/images/log.png" height="60" border="0"><span class="btn-r" style="margin-top: 30px;margin-right: 30px;">${session.user_name }</span>
	</header>

	<div id="body" style="padding: 4px">
		<div id="leftSection"  class="ui-widget ui-widget-content ui-corner-all" style="float: left; width: ${isMobile ? '100%' : '220px'}; margin-right:4px; overflow-y:auto; ">
			
			<div id="dev_menu" class="menu_group lnb"  style="padding: 4px;" >
				<div class="${target }" ></div>
			</div>
			
		</div>
		<c:if test="${!isMobile }">
			<div id="contSection"  style="float: left;" >
				<div id="tabs">
					<ul>
					</ul>
				</div>
			</div>
		</c:if>
	</div>

	<footer id="footer" style="padding-top: 15px;">
		<div style="float: left;padding-left: 15px;"><a href="at.sh?_ps=main_m&mb=Y">모바일보기</a></div><div style="text-align: right; padding-right: 15px;">Copyright (C) XXX. All right reserved.</div>
	</footer>

</body>
</html>

