<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="net.ion.webapp.db.QueryInfo"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>키봇2 오픈에코</title>

<link href="./css/contents.css" rel="stylesheet" type="text/css" />
<link href="./jquery/development-bundle/themes/cupertino/jquery.ui.all.css" rel="stylesheet"  id="css" >
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css">
<link href="./jquery/dynatree/doc/skin-custom/custom.css" rel="stylesheet" type="text/css" >

<script src="./jquery/js/jquery-1.7.2.min.js"></script>
<script src="./jquery/js/jquery-ui-1.8.20.custom.js"></script>
<script src="./jquery/js/jquery.json-2.3.js"></script>
<script src="./jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="./jquery/js/jsl.format.js" type="text/javascript"></script>

<script src="./jquery/js/jquery.dynatree.js" type="text/javascript"></script>
<script src="./js/commonUtil.js"></script>
<script src="./js/formValid.js" type="text/javascript" ></script>
<style>
	h3 { margin: 0; padding: 0.2em;}
</style>
<script type="text/javascript">


$(function() {
	$.cur_ctl = null;
	
	$(document).on('change', "#path", function( event ) {
		var path = $('#path').val();
		if(path.indexOf('.sql')>0){
			path = path.substring(1,path.length-4);
			$('[name=path]').val(path);
			return;
		}else{
			$('[name=path]').val(path.substring(1));
		}
		
		$('.path').load('at.sh?_ps=admin/valid/dir',{path:path});
	});

	$(document).on('click', "[type=text]", function( event ) {
		var ctl = $(event.target);

		if($.cur_ctl!=null) $.cur_ctl.removeClass('cur_ctl');
		
		if(ctl.attr('group')==='fields'){
			$.cur_ctl = ctl;
			$.cur_ctl.addClass('cur_ctl');
		}else{
			$.cur_ctl = null;
		};
	});
	
	$(document).on('click', "[group=field_set]", function( event ) {

		if($.cur_ctl!=null){
			var fld_name = $(event.target).attr('val');
			var val = $.cur_ctl.val();

			if(val.indexOf(fld_name) < 0){
				if(val.length>1) val += ', ';
				val += fld_name;
			}else{
				if(confirm('존재하는 필드입니다. 삭제할까요?')) val = val.replace(fld_name+', ', '').replace(', '+fld_name, '').replace(fld_name, '');
			}
			$.cur_ctl.val(val);
		}
	});

	
	$('.button_load').button().click(function( event ) {
		var path = $('[name=path]').val();
		
		$('#query_form').load('at.sh?_ps=admin/pgm/load_query&_q=' + path, function( event ) {
			$( "#tabs" ).tabs();

			if($('.guery_group').length<2) return;
			
			$('#select_fields').load('at.sh?_ps=admin/pgm/sel_cols&_q=' + path, function( event ) {
				var fldSetList = $('#select_fields').children();

				for(var i=0; i<fldSetList.length; i++){
					var flds = $(fldSetList[i]);
					var id = flds.attr('id');
					$('.'+id).append(flds);
				}

				$('[group=fields]').parent().css('background-color', '#CEFBC9');
			
			});
		});
	});
	
	$('.button_save').button().click(function( event ) {
		var __ps = '';
		var $__ps = $('[name=__ps]');
		
		for(var i=0; i<$__ps.length; i++){
			var v = $($__ps[i]).val();

			if(v != ''){
				__ps = v;
				break;
			}
		}
		/* 
		var params = {
			_ps: 'admin/pgm/save',
			__ps: __ps,
			path: $('[name=path]').val(),
			source : getSource()
		};
		*/
		var src = $('textarea[name=source]');
		var source = getSource();
		
		for(var i=0;i<src.length;i++){
			$(src[i]).val(source);
		}
		
	});

	function getSource(){
		var uiInfos = [];
		var uiInfo = {};
		var ctls = $('input');
		var key = '';

		for (var i=0; i<ctls.length; i++) {
			var ctl = $(ctls[i]);
			var val = ctl.val().trim();
			var type = ctl.attr('type');
			var cName = ctl.attr('name');
			var propty = ctl.attr('propty');
			
			if(cName=='id') {
				if(val=='') break;

				ctl.attr('val', val);
				
				uiInfo = {};
				uiInfos[uiInfos.length] = uiInfo;
			}
			
			if(propty=='key'){
				key = val;
			}else if(propty=='value'){
				if(key!=''){
					var grpVal = uiInfo[cName];
					if(grpVal==null){
						grpVal = {};
						uiInfo[cName] = grpVal;
					}
					grpVal[key] = val;
				}
				key = '';
			}else{
				if(type=='checkbox' || type=='radio'){
					var chkCtl = $('input:checked[name='+ cName +']', ctl.parent().parent().parent());

					if(chkCtl.length > 0){
						
						uiInfo[cName] = true;
						
					}
				}else{
					if(val!=''){
						uiInfo[cName] = val;
					}
				}
			}
		}

		var src = '';

		for(var i=0; i<uiInfos.length; i++){
			var id = uiInfos[i].id;

			var query = $('[name=query]',$('#ui_id[val='+id+']').parent().parent().parent().parent().parent().parent()).val().trim();

			query = query + (query.endsWith(';') ? '' : ';') + '\n\n';

			var json = JSON.stringify(uiInfos[i]);
			json = jsl.format.formatJson(json);
			json = '/*\n' + json + '\n*/\n';

			var pos = query.indexOf(':=');

			if(pos>0){
				src += query.substring(0,pos+2) + '\n'+ json + query.substring(pos+2);
			}else{
				src += json + query;
			}
		}
		
		return src;
	};
	
});


</script>
</head>
<body style="margin: 0 0 0 0;padding: 0 0 0 0;overflow:auto;"">

<table style="width:99%; style="margin: 3px 3px 3px 3px;padding: 3px 3px 3px 3px;"">
	<tr>
		<td>
			<form action="at.sh?_ps=admin/pgm/maker" method="post">
			<table>
				<tr>
					<td>
						<div class="path"  style="width: 200px;"><jsp:include page="../valid/dir.jsp"/></div>
					</td>
					<td>
						<input type="text" name="path" value="${req.path }">
					</td>
					<td>
						<div class="button_load"  class="left">읽기</div>
					</td>
				</tr>
			</table>
			</form>
		</td>
		<td align="right">
			<div class="button_save"  class="left">소스 보기</div>
		</td>
	</tr>
	<tr>
		<td valign="top" colspan="2">
			<div id="query_form"></div>
		</td>
	</tr>
</table>
<div id="select_fields"></div>
</body>
</html>