<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="value" type="java.lang.String" required="true"%>
<%@ attribute name="valid" type="java.lang.String" %>
<script type="text/javascript">
	$(function() {
		$('#${row.meta_id }').change(function(){
			changeDate('#${name}');
		});
		$('#${name}_day').change(function(){
			changeDate('#${name}');
		});
		$('#${name}_hh').change(function(){
			changeDate('#${name}');
		});
		$('#${name}_mm').change(function(){
			changeDate('#${name}');
		});
		$('#${name}_ss').change(function(){
			changeDate('#${name}');
		});

		function changeDate(id){
			$(id).val($(id+'_day').val() + ' ' + $(id+'_hh').val() + ':' + $(id+'_mm').val() + ':' + $(id+'_ss').val());
		}
	});
</script>
<c:set var="datetime"><fmt:formatDate value="${value}" pattern="yyyy-MM-dd HH:mm:ss" /></c:set>
<input type="hidden" id="${name}" name="${name}" value="${datetime }">
<table  style="width: 200px"><tr>
	<c:set var="day_time" value="${datetime}" />
	<c:set var="tim" value="${fn:split(fn:substringAfter(day_time,' '),':')}" />
	<c:set var="day" value="${fn:split(value,' ') }" />
	<td style="border:0px;"><input type="text" id="${name}_day" name="${name}_day" value="${day[0]}" ${isReadOnlys } valid="${valid}" class="datepicker"></td>
	<td style="border:0px;padding:0 0 0 0;">
		<select id="${name}_hh" name="${name}_hh"  >
		<c:forEach var="idx"  begin="0"  end="24">
			<c:set var="val" value="${uf:leftPad(idx,2,'0') }" />
			<option value="${val}" ${val==tim[0] ? 'selected=selected' : ''}">${val}</option>
		</c:forEach>
		</select>
	</td>
	<td style="border:0px;padding:0 0 0 0;">시</td>
	<td style="border:0px;padding:0 0 0 0;">
		<select id="${name}_mm" name="${name}_mm"  >
		<c:forEach var="idx"  begin="0"  end="59">
			<c:set var="val" value="${uf:leftPad(idx,2,'0') }" />
			<option value="${val}" ${val==tim[1] ? 'selected=selected' : ''}">${val}</option>
		</c:forEach>
		</select>
	</td>
	<td style="border:0px;padding:0 0 0 0;">분</td>
	<td style="border:0px;padding:0 0 0 0;">
		<select id="${name}_ss" name="${name}_ss"  >
		<c:forEach var="idx"  begin="0"  end="59">
			<c:set var="val" value="${uf:leftPad(idx,2,'0') }" />
			<option value="${val }" ${val==tim[2] ? 'selected=selected' : ''}">${val }</option>
		</c:forEach>
		</select>
	</td>
	<td style="border:0px;padding:0 0 0 0;">초</td> ${sec }
</tr></table>
