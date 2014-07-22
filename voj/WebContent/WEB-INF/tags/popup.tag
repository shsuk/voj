<%@ tag language="java" pageEncoding="UTF-8" body-content="tagdependent"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="id" type="java.lang.String" required="true"%>
<%@ attribute name="title" type="java.lang.String" required="true"%>
<%@ attribute name="closeIcon" type="java.lang.Boolean" description="타이틀에 있는 닫기 아이콘 노출 여부"%>
<%@ attribute name="width" type="java.lang.Integer" %>
<%@ attribute name="height" type="java.lang.Integer" %>
<%@ attribute name="resizable" type="java.lang.Boolean"%>
<%@ attribute name="minHeight" type="java.lang.Integer"%>
<%@ attribute name="minWidth" type="java.lang.Integer"%>
<c:set var="height" value="${height!=0 ? height : 500 }"/>
<c:set var="resizable">${empty(resizable) ? true : resizable}</c:set>
<script type="text/javascript">
	$(function() {
	});
	
	//팝업 닫기 함수
	function close_popup(id){
		$( "#" + id).dialog( "close" );
	}

	function open_popup(id, url, data, callBack){
		$('#${id}').dialog({
			title: "${title}",
			autoOpen: false,
			height: '${height}',
			width: '${width}',
			resizable: ${resizable},
			modal: true,
			close: function( event, ui ) {
				$( "#" + id).hide();
			}
		});
		
		<c:if test="${!empty(closeIcon) && !closeIcon }">$('.ui-dialog-titlebar-close',$('div[aria-labelledby=ui-dialog-title-${id}]')).remove()</c:if>
		
		$( "#" + id).dialog( "open" );
		
		if(url){
			$('#'+id).load(url, data, function(){
				if(callBack){
					callBack();
				}				
			});		
		}
	}
</script>
<div id="${id }">
	<jsp:doBody/>
</div>
