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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>ISlim</title>
<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
<link href="./jquery/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css"/>
<link href="./css/contents.css" rel="stylesheet"  id="css" />
<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script type="text/javascript">
	$(function($) {
		$('#creat_table' ).button({icons: {primary: "ui-icon-gear"},text: true}).click(function( event ) {
			creat_table();
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
</head>
<body>
<div style="padding: 10px;">
	<form action="devTC.sh" method="post">
		<table class="ui-widget ui-widget-content contents-contain"  style="width: 100%;">
			<tr>
				<th class="ui-state-default">소스생성경로</th>
				<td><input type="text" name="path" value="c:/temp/table/"  style="width: 100%;"></td>
			</tr>
		</table>
	</form>
	<button id="creat_table" class="button-r" >쿼리 소스 생성</button>
	<br>아래 테이블에 대한 소스를 자동으로 생성합니다.
	<br>소스 생성 후 생성된 소스를 쿼리패스에 복사해야 적용됩니다. 소스생성을 자유로이 해도 시스템에 문제가 발생하지 않습니다.
	<table class="ui-widget ui-widget-content contents-contain"  style="width: 100%;">
		<tr class="ui-state-default">
			<th>테이블명</th>
		</tr>
	</table>
	
	<c:forEach var="row" items="${rows}">
		<div class="button-l" style=" border: 1px solid #cccccc;width: 30%;padding: 5px;">${row.table_name }</div>
	</c:forEach>
</div>
</body>
</html>

	