<%@tag import="net.ion.user.processor.SyncBillCodeProcessor"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="bd_key" type="java.lang.String" required="false"%>
<script type="text/javascript">
	function setVillage(name, val){
		$('#village').val(name);
		$('#village_lbl').text(name);
		$('#village_sel').hide();
	}
</script>
<c:set var="cName"/>
<div id="village_sel"  style="position: absolute;display: none;">
<table style="margin-bottom: 1px;text-align: left; "><tr>
	<td style="border:1px solid #B2CCFF;background: #ffffff;padding: 2px;">
		<table style="margin:0px;"><tr><td style="border:0;"><b>마을을 선택하세요.</b>
			<c:forEach var="row" items="${code:list('vil')}"> 
				<c:if test="${cName!=row.code_name }">
					</td></tr><tr><td style=" border-bottom :1px solid #C0C0C0;padding: 2px;">
					<span style="width: ${isMobile ? 60 : 70}px;padding:1px;margin: 1px;   display: inline-block;cursor: default;font-size:12px; font-weight: bold;">${row.code_name }</span>
					<c:set var="cName" value="${row.code_name }"/>
				</c:if>
				<span onclick="setVillage('${row.code_name }${row.reference_value}', '${row.code_value }')" style="cursor:pointer;color:#002266; width:10px; padding: 2px; display:inline-block; margin:1px; margin-right:2px;  ${bd_key==row.code_value ? 'background:#FFA2A2;' : ''}; border:1px solid #${bd_key==row.code_value ? 'DB3A00' : 'cccccc'};"><b>${ row.reference_value}</b></span>
			</c:forEach>
		</table>
		<div class="action_silver f_r" style="margin: 2px;" onclick="$('#village_sel').hide();">닫기</div>
	</td>
</tr></table>
</div>		
