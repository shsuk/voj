<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="value" type="java.lang.String" required="true"%>
<%@ attribute name="valid" type="java.lang.String" %>
<c:set var="__path"><uf:tpl src="${code:ref('code_mapping', name)}"/></c:set>
<input type="text" id="${name }" name="${name }" value="${value }"  valid="${valid}" readonly="readonly" class="button-l"><div id="select_btn_${name}" class="button-l">선택</div>
<div id="path_${name }"  ></div>
<script type="text/javascript">								
	$(function() {
		
		$('#select_btn_${name}').button().click(path_${name }_click);
		$('#${name }').click(path_${name }_click);

		function path_${name }_click(){
			$('#path_${name }').load('${__path}', {_field: '${name}'}, function(){

				$(function() {
					 $( "#path_${name }" ).dialog({
						 resizable: true,
						 title: '${code:lang(name, lang, name) }',
						 autoHeight: true,
						 width: '80%',
						 modal: true,
						 buttons: {
							 '닫기': function() {
									$( this ).empty();
								 $( this ).dialog( "close" );
							 }
						 }
					});
				});

			});
		}
	});
</script>
