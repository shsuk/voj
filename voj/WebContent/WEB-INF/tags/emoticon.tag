<%@tag import="net.ion.user.processor.SyncBillCodeProcessor"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<script type="text/javascript">
	
	$(function() {
	    $('.emoticon').click(function() {
	    	var rep_text = $('#rep_text');
	    	rep_text.focus();
	        if( document.selection ){
	           sel = document.selection.createRange();
	           sel.text =  $(this).attr('value');
	        }else{
		    	rep_text.val(rep_text.val()+$(this).attr('value'));
	        }
	    });
		
	});
	
</script>
<div>
	<img class="emoticon" height="32" value="[좋아요]" src="voj/images/re/re01.png">
	<img class="emoticon" height="32" value="[감사해요]" src="voj/images/re/re02.png">
	<img class="emoticon" height="32" value="[기뻐요]" src="voj/images/re/re03.png">
	<img class="emoticon" height="32" value="[사랑해요]" src="voj/images/re/re04.png">
	<img class="emoticon" height="32" value="[감동이예요]" src="voj/images/re/re05.png">
	<img class="emoticon" height="32" value="[힘내세요]" src="voj/images/re/re11.png">
	<img class="emoticon" height="32" value="[기도할께요]" src="voj/images/re/re12.png"> 선택하여 마음을 전하세요.
</div>
