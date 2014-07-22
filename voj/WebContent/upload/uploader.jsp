<%@page import="net.ion.webapp.utils.ParamUtils"%>
<%@page import="net.ion.webapp.fleupload.FileInfo"%>
<%@page import="net.ion.webapp.fleupload.Upload"%>
<%@page import="net.ion.webapp.utils.Aes"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%
	FileInfo fi = Upload.getFile(request, response);
	
	//out.println(fi==null ? request.getAttribute("error") : fi.clientFileName);
	request.setAttribute("fileId", Upload.getfileId());

	request.setAttribute("req", ParamUtils.getReqMap(request.getParameterMap()));
%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<script src="../jquery/js/jquery-1.9.1.min.js"></script>
<script src="../jquery/js/jquery.json-2.3.js"></script>

<script src="../js/formValid.js" type="text/javascript" ></script>
<script src="../js/commonUtil.js" type="text/javascript" ></script>
<script>
	$['res_path']='..';
	
	$(function($){		
		var title = $('#${req.cId}',parent.document).attr('title');
		//alert(title);
		if(title){
			$('.buton_title').html('<b>'+title+'</b>');
		}
		$('input[type=file]').change(function(e){
			var val = $(e.target).val();
			if(val!='') {
				upload();
			}
		});
	});

	function upload(){

		var isSuccess = $.valedForm($('[valid]'));

		if(!isSuccess) return false;

		$(parent)[0].$.attachment.startUpload('${req.cId}','${fileId}');

		$('#fileForm').submit();
	}

</script>
<style type="text/css">
	.fileButton{background:url('${req.button}') 0 0 no-repeat;overflow:hidden;}
	.button_div {background-color:#E5FFFF;}
	.button_on {background-color:#7ED2FF;}
</style>
</head>
<body style="padding: 0px;margin: 0px;" scroll="no">
<form id="fileForm" action="./uploader.jsp?cId=${req.cId}&ref_tbl=${req.ref_tbl }&button=${req.button}&width=${req.width}&height=${req.height}&valid=${req.valid}" method="post" enctype="multipart/form-data" >
	<div class="${req.button=='' ? '' : 'fileButton'}" style="overflow:hidden; width: ${req.width}; height: ${req.height};cursor:pointer;border: 0px solid #B2CCFF;">
		<c:if test="${req.button=='' }">
			<div class='buton_title' style="position:absolute; text-align: center;font-size: 12px; width: ${req.width}; height: ${req.height};line-height: ${req.height};">첨부</div>
		</c:if>
		<input type="file" name="${fileId}" value=''  valid="${req.valid}" style="float: right; filter:alpha(opacity:0);-moz-opacity: 0; opacity: 0;cursor:pointer;width: width: ${req.width}; height: ${req.height}; font-size: 100px">
	</div>
</form>
</body>
</html>