<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="db" uri="/WEB-INF/tlds/db.tld"%>
<%@ taglib prefix="t"  tagdir="/WEB-INF/tags/test" %> 

<htm>
<head>
<script src="../jquery/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript">
	
	$(function() {
		$('tr[img_id]').click(function(e){
			document.location.href = $(e.currentTarget).attr('link_url');
		});
	});
</script> 
</head>
<body >

<db:db queryPath="test/crud" actionFild="act" processorList="db" exception="true">
	{
		act:'${empty(param.bd_id) ? "i" : "u" }',
		bd_id: '${req.bd_id }'
	}
</db:db> 

${JSON }
<table style="" border="1">
<t:view src="${db.row }">
	<tr>
		<th>@{key}</th>
		<td>@{value}</td>
	</tr>
</t:view>
</table>
<br>

</body>
</htm>