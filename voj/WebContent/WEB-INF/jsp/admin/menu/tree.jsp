<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu">
[
	<uf:job id="rows" jobId="db" query="system/menu/list" />
	<uf:job id="rows" jobId="list2Tree">
		data: 'rows',
		singleKey: true,
		upperIdField: 'upper_rid',
		idField: 'rid',
		title: 'menu_name',
		rootId: '1000'
	</uf:job>
]
</uf:organism>


<script type="text/javascript">
	
	$(function() {
		//트리생성 시작
		var data = ${JSON.rows};
	
		$('#menu_tree_div').dynatree({
			onActivate : function(node) {
				load_form(node);
			},
			minExpandLevel: 2,
			imagePath: "./jquery/dynatree/doc/skin-custom/",
			children : data
		});
		//트리생성 끝 		
		if(active_key){
			$('#menu_tree_div').dynatree("getTree").activateKey(active_key);
		}else{
			$('#menu_tree_div').dynatree('getTree').getRoot().childList[0].activate();
		}
	});
	

</script>

<div id="menu_tree_div"></div>

