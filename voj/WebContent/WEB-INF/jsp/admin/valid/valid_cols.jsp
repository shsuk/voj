<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu" 
	processInfo="[
	{
		id:'rset', jobId:'db', query:'${req._q }', isReturnColumInfo:true
	},{
		id:'rows', jobId:'db', query:'system/at/valid_list',defaultValues:{query_id:'${req._q }'}
	},{
		id:'colMap', jobId:'list2Map', src:'rows', key:'col_id'
	}
]"/>

<div class="contents-contain" >
	<table  class="ui-widget ui-widget-content contents-contain" style="height: 100%;">
		<tr class="ui-widget-header">
			<th style="width: 20px;"><input type="checkbox" id="all_cols" name="all_cols"></th>
			<th style="width: 100px;">ID</th>
			<th style="width: 100px;">Name</th>
			<th style="width: 70px;">type_name</th>
			<th style="width: 40px;">type</th>
			<th style="width: 50px;">precision</th>
			<th style="width: 40px;">scale</th>
			<th>valid</th>
			<th style="width: 40px;">td width</th>
		</tr>
		<tbody>
		<c:forEach var="rows" items="${rset.data }">
			<c:set var="meta" value="${rset.meta[rows.key]}"/>
	
			<c:forEach var="attr" items="${meta}">
				<tr>
			 		<td><input type="checkbox" id="cols_${attr.name }" name="cols" class="cols" value="${attr.name }"></td>
			 		<td><label style="cursor: pointer;" for="cols_${attr.name }">${attr.name }</label></td>
			 		<td><label style="cursor: pointer;" for="cols_${attr.name }">${code:lang(attr.name, 'kr', attr.name) }</label></td>
			 		<td>${attr.type_name }</td>
			 		<td style="text-align: center;;">${attr.type }</td>
			 		<td style="text-align: right;">${attr.precision }</td>
			 		<td style="text-align: right;">${attr.scale }</td>
			 		<td>
			 			<input type="hidden" name="col_id" value="${attr.name}">
						<input type="text" name="valid" col="${attr.name }" value="${colMap[attr.name].valid}" style="width: 100%;">
					</td>
			 		<td><input type="text" name="width" value="${colMap[attr.name].width}"  style="width: 40px;"></td>
				</tr>
			</c:forEach>
		</c:forEach>
	</tbody>
	</table>
</div>