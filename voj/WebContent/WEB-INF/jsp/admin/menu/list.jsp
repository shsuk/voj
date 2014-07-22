<%@page import="net.ion.webapp.process.ProcessInitialization"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>

<script type="text/javascript">
	var active_key;

	$(function() {
		//저장버튼
		$('#form_save').button({icons: {primary: "ui-icon-disk"}}).click(function( event ) {
			submit_form('#menu_form', function(){
				reloadTree();
			});
		});
		//메뉴추가
		$('#new_form').button({icons: {primary: "ui-icon-arrowthickstop-1-w"}}).click(function( event ) {
			var upper_rid = $('input[name=upper_rid]').val();
			$('#menu_form').load('at.sh?_q=system/menu/edit&_t=edit', {rid : 0}, function(){
				$('input[name=_t]').val('add');
				$('input#upper_rid').val(upper_rid);
				$('div[name=upper_rid]').text(upper_rid + ' (메뉴추가)');
			});

			$('#new_form').hide();
			$('#new_sub_form').hide();
		});
		//하위메뉴추가
		$('#new_sub_form').button({icons: {primary: "ui-icon-arrowthickstop-1-s"}}).click(function( event ) {
			var upper_rid = $('input[name=rid]').val();
			$('#menu_form').load('at.sh?_q=system/menu/edit&_t=edit', {rid : 0}, function(){
				$('input[name=_t]').val('add');
				$('input#upper_rid').val(upper_rid);
				$('div[name=upper_rid]').text(upper_rid + ' (하위메뉴추가)');
			});
			
			$('#new_form').hide();
			$('#new_sub_form').hide();
		});
		

	});
	
	function load_form(node){
		active_key = node.data.key;
		
		var rid = node.data.rid;
		$('#menu_form').load('at.sh?_q=system/menu/edit&_t=edit',{rid : rid});
		$('#new_form').show();
		$('#new_sub_form').show();
	}

	function reloadTree(){
		var url = 'at.sh?_ps=admin/menu/tree'+'&time='+(new Date()).getTime();
		$('#menu_tree').load(url, function(){});
	}

</script>

<div>
	<table style="width: 100%;height: 330px;">
		<tr>
			<td id="menu_tree" style="width: 250px;vertical-align: top;">
				<jsp:include page="tree.jsp"/>
			</td>
			<td id="menu_form" style="vertical-align: top;"></td>
		</tr>
	</table>
	<div id="new_form" class="button-l">메뉴추가</div>
	<div id="new_sub_form" class="button-l">하위메뉴추가</div>
	<div id="form_save" class="button-r">저장</div>
</div>

