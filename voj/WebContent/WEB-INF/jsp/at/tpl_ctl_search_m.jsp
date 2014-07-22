<%@ page contentType="text/html; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %>
<c:choose><c:when test="${code:codeInfo('root', item.key).edit_type=='month'}">
	<input type="hidden" id="${item.key}" name="${item.key}" value="${req[item.key] }"  class="monthpicker">
	<c:set var="temp_val" value="${uf:getDate('yyyy-MM')}" />
	<c:set var="temp_val" value="${(req[item.key]==null || req[item.key]=='') ? temp_val : req[item.key] }" />
	<c:set var="time_val" value="${fn:split(temp_val,'-') }" />
	<table style="margin: 0px;padding: 0px;border: 0px;"><tr><td style="margin: 0px;padding: 0px;border: 0px;">
			<input type="text" readonly="readonly" id="${item.key }_yy" value="${time_val[0]}" style="width: 60px;"  ${item.value} ${fn:replace(item.value,'placeholder','title')} ${fn:replace(item.value,'placeholder','alt')}>
		</td><td style="margin: 0px;padding: 0px;border: 0px;">
			<div id="${item.key}_up" style="cursor: pointer;">▲</div><div id="${item.key}_dn" style="cursor: pointer;">▼</div>
		</td><td style="margin: 0px;padding: 0px;border: 0px;" >
			&nbsp;<select id="${item.key }_mm" name="${item.key }_mm"  >
				<c:forEach var="idx"  begin="1"  end="12">
					<c:set var="val" value="${uf:leftPad(idx,2,'0') }" />
					<option value="${val}" ${val==time_val[1] ? 'selected=selected' : ''}">${val}</option>
				</c:forEach>
			</select>
	</td></tr></table>
	<script type="text/javascript">
	$(function() {
		$('#${item.key }_up').click(function(){
			var yy = $('#${item.key }_yy').val();
			if(yy=='') yy = '${uf:getDate("yyyy")}';
			yy++;
			$('#${item.key }_yy').val(yy);
			changeYYMM('#${item.key }');
		});
		$('#${item.key }_dn').click(function(){
			var yy = $('#${item.key }_yy').val();
			if(yy<'2010') yy = '2010';
			if(yy=='') yy = '${uf:getDate("yyyy")}';
			yy--;
			$('#${item.key }_yy').val(yy);
			changeYYMM('#${item.key }');
		});
		$('#${item.key }_yy').change(function(){
			changeYYMM('#${item.key }');
		});
		$('#${item.key }_mm').change(function(){
			changeYYMM('#${item.key }');
		});

		function changeYYMM(id){
			var dd = $( id +'_yy' ).val() + '-' + $(  id +'_mm'  ).val();
			$( "#${item.key}" ).val(dd);
		}
	});
	</script>
</c:when><c:when test="${code:codeInfo('root', item.key).edit_type=='date'}">
	<c:set var="temp_val" value="${uf:getDate('yyyy-MM-dd')}" />
	<c:set var="temp_val" value="${(req[item.key]==null || req[item.key]=='') ? temp_val : req[item.key] }" />
	<input type="text" id="${item.key}" name="${item.key}" readonly="readonly" value="${temp_val}" style="width: 80px;" ${item.value} ${fn:replace(item.value,'placeholder','title')} ${fn:replace(item.value,'placeholder','alt')} class="datepicker">
</c:when><c:when test="${code:codeInfo('root', item.key).edit_type=='desc'}">
	<div style="line-height: 27px;font-weight: lighter;">${item.value}</div>
</c:when><c:when test="${code:codeInfo('root', item.key).edit_type=='title'}">
	<label class="ui-dialog-title" style="color:#222222; font-size: 12px;">${item.value}</label>
</c:when><c:when test="${code:codeInfo('root', item.key).edit_type=='tree'}">
	<input type="hidden" name="${item.key }" value="${req[item.key] }">
	<input class="${item.key }" type="text" readonly="readonly" style="width: 150px;" value="${req[item.key] }" ${item.value} />
	<span id="dumy_${item.key}"></span>
	<div class="${item.key}_tree" style="position:absolute; z-index:1000000; width: 200px;height: 250px"></div>
	<script type="text/javascript">
	$(function() {
		$('#dumy_${item.key}').load('at.sh?_ps=at/tree_${code:codeInfo("root", item.key).reference_value}&fld_id=${item.key}', function(){});
	});
	</script>
</c:when><c:when test="${code:list(item.key)!=null}">
	<c:set var="cInfo" value="${code:codeInfo('root', item.key)}"/>
	<c:choose><c:when test="${cInfo.edit_type=='check'}">
		<tp:check name="${item.key}" groupId="${item.key}" checked="${param[item.key]}" valid="[${valid}]"/>
	</c:when><c:when test="${cInfo.edit_type=='radio'}">
		<fieldset data-role="controlgroup" data-type="horizontal">
			<c:set scope="request" var="group_id" value="${item.key}"/>
			<c:set scope="request" var="name" value="${item.key}"/>
			<c:set scope="request" var="selected" value="${param[item.key]}"/>
			<c:set scope="request" var="att" value=" data-inline=\"true\"  data-mini=\"true\" valid=\"[${valid}]\" "/>
			<jsp:include page="../system/tpl/radio_button_m.jsp"/>
		</fieldset>
	</c:when><c:otherwise>
		<tp:select name="${item.key}" groupId="${item.key}" selected="${param[item.key]}" emptyText="${code:lang(item.key, lang, '') } 선택" valid="[${valid}]" attr="data-native-menu=\"false\"  data-mini=\"true\" "/>
	</c:otherwise></c:choose>
</c:when><c:otherwise>
	<input type="text" data-inline="true" style="width: 80%" name="${item.key}" value="${req[item.key]}" ${item.value} ${fn:replace(item.value,'placeholder','title')} ${fn:replace(item.value,'placeholder','alt')} >
</c:otherwise></c:choose>