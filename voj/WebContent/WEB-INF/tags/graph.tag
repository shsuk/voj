<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="id" type="java.lang.String" required="true"%>
<%@ attribute name="xaxe" type="java.lang.String" required="true"%>
<%@ attribute name="yaxes" type="java.lang.String" required="true" description="한개 이상의 컬럼을 콤마로 불리하여 설정 type=pie인 경우는 필드명만 지정한다. 예) 'price:가격, vat:부가세'"%>
<%@ attribute name="data" type="java.lang.String" required="true" description="그래프를 그릴 레코드셋을 JSON으로 설정한다. 예) ${JSON.rows}"%>
<%@ attribute name="xformat" type="java.lang.String" required="true" description="예) D:날짜, W:요일, T:시간, N:숫자, S:문자"%>
<%@ attribute name="xunit" type="java.lang.String" description="x축에 표시될 단위"%>
<%@ attribute name="yunit" type="java.lang.String" description="y축에 표시될 단위"%>
<%@ attribute name="type" type="java.lang.String" description="pie"%>
<%@ attribute name="subPie" type="java.lang.Boolean" description=""%>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="width" type="java.lang.Integer" required="true"%>
<%@ attribute name="height" type="java.lang.Integer" required="true" %>

<script type="text/javascript">								
	$(function($) {
		goGraph('#${id}', ${data},{xaxe:'${xaxe}',yaxes:'${yaxes}', xFormat:'${xformat}', xUnit:'${xunit}', yUnit:'${yunit}', type:'${type}'} );
	});
</script>
<div style="width: ${width }px;height: ${height}px;border: 1px solid #C5DBEC;">
	<table style="width: 100%"><tr>
		<td width="100"></td>
		<td><div style="background-color: #ffffff; padding-top: 13px;padding-right:40; font-weight: bold;text-align: center;">${title }</div></td>
		<td width="100" align="right">${empty(yunit) ? '' : '<b>단위</b> : '}${yunit }&nbsp;</td>
	</tr></table>
	
	<div id="${id}" style="float: left;width: ${width*(subPie ? 0.7 : 1) }px;height: ${height-50}px;margin: 10px;"></div>
	<c:if test="${subPie }">
		<div id="${id}_hover_pieGraph" style="float: left;margin-top: ${(height - width*0.3) * 0.3}px;width: ${width*0.3 - 40}px;height: ${width*0.3}px;">
			<div id="${id}_hover_title" style="text-align: center;"></div>
			<div id="${id}pieGraph" style="width: ${width*0.3 - 40}px;height: ${width*0.3 - 40}px;border: 1px solid #C5DBEC;"></div>
		</div>
	</c:if>
</div>