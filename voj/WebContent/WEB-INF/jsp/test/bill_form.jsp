<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="ptu"  tagdir="/WEB-INF/tags/user" %> 
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
	
	<script src="./js/formValid.js" type="text/javascript" ></script>
	<script src="./js/commonUtil.js"></script>
	<script type="text/javascript">
			
		$(function() {
			$('#bill_code').load('at.sh',{_ps:'test/bill_code'});
		});
		
		function searchBillCode(){
			var data = {
				_ps:'test/bill_code',
				searchProject:$('#searchProject').val(),
				searchAccount:$('#searchAccount').val(),
				project:$('#project').val(),
				account:$('#account').val()
			};
			$('#bill_code').load('at.sh',data);
		}
	</script>
</head>
<body>

<div id="bill_code"></div>
</div>
</body>
</html>