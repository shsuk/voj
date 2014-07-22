<%@tag import="net.ion.user.processor.SyncBillCodeProcessor"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<script type="text/javascript">
	
	$(function() {
	    $('.emoticon').click(function() {
	    	var rep_text = $('#rep_text');
	    	rep_text.hide();
	    	var rep_emoticon = $('#rep_emoticon');
	    	rep_emoticon.show();
	    	$('#rep_emoticon_img').attr('src', $(this).attr('src'));
	    	rep_text.val($(this).attr('value'));
	    });
		
	});
	
	function hideEmoticon(){
		$('#rep_emoticon').hide();
    	var rep_text = $('#rep_text');
    	rep_text.val('');
    	rep_text.show();		
	}
	
</script>
<div>
	<img class="emoticon" height="32" value="re01.png" src="voj/images/re/re01.png">
	<img class="emoticon" height="32" value="re02.png" src="voj/images/re/re02.png">
	<img class="emoticon" height="32" value="re03.png" src="voj/images/re/re03.png">
	<img class="emoticon" height="32" value="re04.png" src="voj/images/re/re04.png">
	<img class="emoticon" height="32" value="re05.png" src="voj/images/re/re05.png">
	<img class="emoticon" height="32" value="re11.png" src="voj/images/re/re11.png">
	<img class="emoticon" height="32" value="re12.png" src="voj/images/re/re12.png"> 선택하여 마음을 전하세요.
</div>
<div id="rep_emoticon" style="width: 100%;display: none;border: 1px solid #aaaaaa;">
	<img id="rep_emoticon_img" src="#" style="vertical-align: middle;" height="60">
	<img style="margin-left: 5px;cursor: pointer;vertical-align: middle;" href="#" onclick="hideEmoticon()" style="margin-right: 10px;" title="지우기" border="0" src="images/icon/Close-icon.png">
</div>
