<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="groupId" type="java.lang.String" required="true"%>
<%@ attribute name="checked" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<%@ attribute name="attr" type="java.lang.String" %>
<uf:split2map var="select_val" value="${checked}"/>
<input type="hidden"  id="${name}" name="${name}" ${att } valid="${valid }"   value="${checked}">
<c:forEach var="row" items="${code:list(groupId)}"> 
	<div style="float: left;"><input type="checkbox"  style="float: left;" id="${name}_${row.code_value }" name="${name}_check" ${att } value="${row.code_value }" ${!empty(select_val[row.code_value]) ? 'checked' : ''}>
	<label  style="float: left; line-height: 20px;" for="${name}_${row.code_value }">${row.code_name}&nbsp;&nbsp;</label>
	</div>
</c:forEach>
<script type="text/javascript">
$(function() {
	$('[name=${name}_check]').change(function(){
		change${name}_check();
	});

	function change${name}_check(){
		var val = '';
		var box = $('[name=${name}_check]:checked');
		for(var i=0; i<box.length; i++){
			val += ',' + $(box[i]).val();
		}
		$('#${name}').val(val.substring(1));
	}

	change${name}_check();
});
</script>
