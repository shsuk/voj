<%@tag import="net.ion.user.processor.SyncBillCodeProcessor"%>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ attribute name="bd_key" type="java.lang.String" required="false"%>
<c:set var="cName"/>
<table style=" border:0px solid #C0C0C0;margin-bottom: 1px;text-align: left; ">
	<tr><td style=" border-bottom :1px solid #C0C0C0;">
		<img src="voj/images/menu/vil_tit.jpg" align="middle"> 
		<a href="#" class="cc_bt" style="padding: 0px;cursor: pointer;line-height: 20px;margin: 2px;" onclick="goVillage('')">모두보기</a>
		<c:if test="${session.myGroups['vil']}">
			<a href="/at.sh?_ps=voj/bd/list&bd_cat=ser"  class="cc_bt" style="padding: 0px;cursor: pointer;line-height: 20px;min-width:40px; margin: 2px;">공과</a>
		</c:if>
	</td></tr>
	<tr><td style="filter:alpha(opacity=50);opacity:.5; background: #ffffff">
		<table >
			<c:forEach var="row" items="${code:list('vil')}"> 
				<c:if test="${cName!=row.code_name }">
					</td></tr><tr><td style=" border-bottom :1px solid #C0C0C0;">
					<span style="width: ${isMobile ? 60 : 70}px;padding:1px;margin: 1px;   display: inline-block;cursor: default;font-size:12px; font-weight: bold;">${row.code_name }</span>
					<c:set var="cName" value="${row.code_name }"/>
				</c:if>
				<span onclick="goVillage('${row.code_value }')" style="cursor:pointer;color:#333333; width:10px; padding: 4px; display:inline-block; margin:1px; margin-right:2px;  ${bd_key==row.code_value ? 'background:#FFA2A2;' : ''}; border:1px solid #${bd_key==row.code_value ? 'DB3A00' : 'cccccc'};"><b>${ row.reference_value}</b></span>
			</c:forEach>
		</table>
	</td></tr>
</table>			
