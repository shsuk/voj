<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="net.ion.webapp.utils.DbUtils"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<script type="text/javascript">
	$(function($) {
		$(document).on('change', "#path", function( event ) {
			var path = $('#path').val();
			if(path.indexOf('.sql')>0){
				path = path.substring(1,path.length-4);
				$('[name=qyery_id]').val(path);
				return;
			}else{
				$('[name=qyery_id]').val(path.substring(1));
			}
			
			$('.path').load('at.sh?_ps=admin/valid/dir',{path:path});
		});
		
		

		$('#col_edit').button({text: true}).click(function( event ) {
			var ctls = $('input.radio[value=E]');
			
			for(var i=0; i<ctls.length; i++){
				ctl = ctls[i];
				ctl.checked = true;
				//$(ctl).attr('checked','checked');
			}
			return false;
		});

		
		$('#col_read').button({text: true}).click(function( event ) {
			var ctls = $('input.radio[value=R]');
			
			for(var i=0; i<ctls.length; i++){
				ctl = ctls[i];
				ctl.checked = true;
				//$(ctl).attr('checked','checked');
			}
			return false;
		});

		$('#col_hidden').button({text: true}).click(function( event ) {
			var ctls = $('input.radio[value=H]');
			
			for(var i=0; i<ctls.length; i++){
				ctl = ctls[i];
				ctl.checked = true;
				//$(ctl).attr('checked','checked');
			}
			return false;
		});

		
		$('#load_info_btn' ).button({icons: {primary: "ui-icon-gear"},text: true}).click(function( event ) {
			var data = {};
			
			var fields = $('form').serializeArray();
			$.each(fields, function(i, field){
				data[field.name] =field.value;
			});
			$('#col_info').load("loadInfo.sh", data);
			return false;
		});
		$('#load_tpl_btn' ).button({icons: {primary: "ui-icon-gear"},text: true}).click(function( event ) {
			var tpl_name = $('select[name=tpl_name]').val();
			win_load('tpl_name='+tpl_name, $('select[name=tpl_name] option:selected').text() + "(" + tpl_name + ')', {height:'780',width: '95%'},null, 'loadTpl.sh');
			
			
			return false;
		});
		
		$('#view_btn' ).button({icons: {primary: "ui-icon-gear"},text: true}).click(function( event ) {
			var data = {};
			
			var fields = $('form').serializeArray();
			$.each(fields, function(i, field){
				data[field.name] =field.value;
			});
			$('#pre_view').text('');
			$('#pre_view').load("viewPgm.sh", data);
			return false;
		});
		
		$('#creat_table_btn' ).button({icons: {primary: "ui-icon-gear"},text: true}).click(function( event ) {
			creat_table();
			return false;
		});
	});
	
	function creat_table(){
		var form = $('form');

		if(!confirm('소스를 생성하시겠습니까?')) return false;

		var formData =$(form).serializeArray();
		var url = $(form).attr('action') ;

		$.post(url, formData, function(response, textStatus, xhr){

			var data = $.parseJSON(response);

			if(data.success){
				alert("소스가 생성되었습니다. \n입력한 패스에 생성된 소스를 쿼리 패스에 넣고 테스트 하세요.");
			}else{
				alert('소스 생성에 실패 하였습니다.\n' + data.error_message);
			}
		});
		return false;
	}

</script>

<div style="padding: 10px;">
	<form action="crtPgm.sh" method="post">
		<table class="ui-widget ui-widget-content contents-contain"  style="width: 100%;">
			<tr>
				<th class="ui-state-default" width="15%">소스생성경로</th>
				<td width="35%"><input type="text" name="path" value="c:/temp/pgm/"  style="width: 100%;"></td>
				<th class="ui-state-default" width="15%">쿼리경로</th>
				<td width="35%">
					<input type="text" name="qyery_id" value=""  class="button-l" style="width: 200px;">
					<div class="path button-r"  style="width: 200px;"><jsp:include page="../valid/dir.jsp"/></div>
				</td>
			</tr>
			<tr>
				<th class="ui-state-default">템플릿 파일명</th>
				<td>
					<tp:select name="tpl_name" groupId="pgm_tpl" selected="tpl_edit_ctl.xml" emptyText="템플릿을 선택하세요." />
				<td colspan="2">
					<button id="load_tpl_btn"class="button-r">템플릿 보기</button>
				</td>
			</tr>
		</table>
		<br>&nbsp;소스 생성 후 생성된 소스를 소스경로에 복사해야 적용됩니다. 소스생성을 자유로이 해도 시스템에 문제가 발생하지 않습니다.
		<button id="creat_table_btn"class="button-r">JSP 소스 생성</button>
		<table class="ui-widget ui-widget-content contents-contain"  style="width: 100%;">
			<tr>
				<th class="ui-state-default" style="width: 250px;">
					<button id="load_info_btn" >컬럼정보 읽기</button>
				</th>
				<th class="ui-state-default">
					<button id="view_btn" >JSP 소스  미리보기</button>
				</th>
			</tr>
			<tr>
				<td valign="top">
					<table>
						<tr>
							<th>컬럼명</th>
							<th><div id="col_edit" title="콘트롤">E</div></th>
							<th><div id="col_read" title="텍스트">R</div></th>
							<th><div id="col_hidden" title="숨김">H</div></th>
						</tr>
						<tbody id="col_info"></tbody>
					</table>
				</td>
				<td><div id="pre_view"></div></td>
			</tr>
		</table>
	</form>
	
</div>
	