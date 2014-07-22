<%@page import="org.springframework.web.util.HtmlUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="net.ion.webapp.db.QueryInfo"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%
request.setAttribute("queryInfos", JSONArray.fromObject("[{ui:{}}]"));

String path = request.getParameter("_q");
if(StringUtils.isNotEmpty(path)){
	try{
		QueryInfo queryInfo = QueryInfo.getQuery(path);
		JSONArray ja = queryInfo.getQueryInfos();
		ja.add(JSONObject.fromObject("{ui:{}}"));
		request.setAttribute("queryInfos", ja);
	}catch(Exception e){}
}

String[][] groups = {
	{"뷰 그룹","group", "그룹아이디", "f1:f2, f3#3, f4:f5", "group=\"fields\""},
	{"검색조건","button_search", "콘트롤아이디", "placeholder=\"조건 명\""},
	{"버튼","buttons", "버튼아이디", "win_load('_ps=seller/cp/sub_del_form', 'del_member', {width:'200', height:'150', resizable: false},'checkbox')"},
	{"링크","link", "링크필드", "view('pm/media/reg_view','media_id=${row.media_id}', this)"},
	{"필드 속성 추가","value", "대상필드", "${row.mb_user_id}"}
};

request.setAttribute("groups", groups);
%>
<script type="text/javascript">

	$('.add_tr').button();
	$('.del_tr').button();
	
	$('form').on('click','.add_tr', function( event ) {
		var tr = $('span table tr', $(event.target).parent().parent());
		var nTr = tr.clone();
		
		var target = $('table[type=group]', $(event.target).parent().parent().parent());
		target.append(nTr);
	});
	$('form').on('click','.del_tr', function( event ) {
		$(event.target).parent().parent().parent().remove();
	});

</script>
<form id="col_form" action="">

<div id="tabs">
	<ul>
		<c:forEach var="queryInfo" items="${queryInfos}" varStatus="status">
			<li><a href="#tabs-${queryInfo.ui.id }">${queryInfo.ui.id==null ? 'new' : queryInfo.ui.id }</a></li>
		</c:forEach>
	</ul>
	
	<c:forEach var="queryInfo" items="${queryInfos}" varStatus="status">
		<div id="tabs-${queryInfo.ui.id }" class="guery_group">
		
			<div style="width: 100%; height: 400px;  margin: 0px 0; border: 1px solid #cccccc; overflow:auto; overflow-x:auto; overflow-y:auto">
			<table border="0" class="contents-contain">
				<colgroup>
					<col style="width:150px;"/>
					<col style="width:40%;"/>
					<col style="width:150px;"/>
					<col style="width:40%;"/>
					<col style="width:30px;"/>
				</colgroup>
				<tr>
					<th class="ui-widget-header"  style="margin: 1px; padding: 1px;">아이디</th>
					<td style="margin: 1px; padding: 1px;">
						<input type="text" id="ui_id" class="button-l" name="id" value="${queryInfo.ui.id }" style="width: 200px;margin: 1px; padding: 1px;">
						<input type="checkbox"  id="chk_${queryInfo.ui.id }" name="singleRow" value="true" ${queryInfo.ui.singleRow==null || queryInfo.ui.singleRow=='' ? '' : 'checked="checked"'}" class="button-l">
						<label for="chk_${queryInfo.ui.id }" class="button-l">단일레코드</label>
					</td>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">추가 페이지</th>
					<td colspan="2" style="margin: 1px; padding: 1px;">
						<input type="text"  name="__ps" value="${queryInfo.ui.__ps }" style="width: 99%;">
					</td>
				</tr>
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">TR 스타일</th>
					<td style="margin: 1px; padding: 1px;">
						<input type="text"  name="style" value="${queryInfo.ui.style}" style="width: 99%;" placeholder="ex) ${'$'}{row.sub_user=='N' ? 'background-color:#B2CCFF' : ''}">
					</td>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">폼 토큰 키</th>
					<td colspan="2" style="margin: 1px; padding: 1px;">
						<input type="text"  name="token_key" value="${queryInfo.ui.token_key }" style="width: 99%;">
					</td>
				</tr>
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">등록처리</th>
					<td style="margin: 1px; padding: 1px;">
						<input type="text"  name="params_insert" value="${queryInfo.ui.params_insert }" style="width: 99%;" placeholder="ex) _q=ac/grp/insert&param=val or _ps=p1/p2/name">
					</td>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">등록버튼</th>
					<td colspan="2" style="margin: 1px; padding: 1px;">
						<input type="text"  name="button_add" value="${queryInfo.ui.button_add }" style="width: 99%;" placeholder="ex) _q=ac/grp/edit&param=val">
					</td>
				</tr>
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">수정처리</th>
					<td style="margin: 1px; padding: 1px;">
						<input type="text"  name="params_update" value="${queryInfo.ui.params_update }" style="width: 99%;" placeholder="ex) _ps=seller/media/reg_audio_update_list&media_id=${'$'}{req.media_id}">
					</td>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">수정버튼</th>
					<td colspan="2" style="margin: 1px; padding: 1px;">
						<input type="text"  name="button_edit" value="${queryInfo.ui.button_edit }" style="width: 99%;" placeholder="ex) _q=pm/media/reg_edit&media_id=${'$'}{req.media_id}&_tab=n">
					</td>
				</tr>
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">삭제처리</th>
					<td colspan="4" style="margin: 1px; padding: 1px;">
						<input type="text"  name="params_delete" value="${queryInfo.ui.params_delete}" style="width: 99%;" placeholder="ex) _q=pm/board/board_delete&cm_board_seq=${'$'}{req.cm_board_seq}">
					</td>
				</tr>
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">정렬필드</th>
					<td style="margin: 1px; padding: 1px;">
						<input type="text"  name="sort" group="fields" value="${queryInfo.ui.sort }" style="width: 99%;">
					</td>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">숨김필드</th>
					<td colspan="2" style="margin: 1px; padding: 1px;">
						<input type="text"  name="hidden" group="fields" value="${queryInfo.ui.hidden }" style="width: 99%;">
					</td>
				</tr>
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">읽기(텍스트)</th>
					<td style="margin: 1px; padding: 1px;">
						<input type="text"  name="read_only" group="fields" value="${queryInfo.ui.read_only }" style="width: 99%;">
					</td>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">읽기(콘트롤)</th>
					<td colspan="2" style="margin: 1px; padding: 1px;">
						<input type="text"  name="read_only2" group="fields" value="${queryInfo.ui.read_only2 }" style="width: 99%;">
					</td>
				</tr>
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">첨부파일</th>
					<td style="margin: 1px; padding: 1px;">
						<input type="text"  name="file" group="fields" value="${queryInfo.ui.file }" style="width: 99%;">
					</td>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">이미지</th>
					<td colspan="2" style="margin: 1px; padding: 1px;">
						<input type="text"  name="img" group="fields" value="${queryInfo.ui.img }" style="width: 99%;">
					</td>
				</tr>
				
				<c:forEach var="group" items="${groups}">
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">
						${group[0] }
					</th>
					<td colspan="3" style="margin: 1px; padding: 1px;">
						<table class="contents-contain" type="group" style="margin: 0px;">
							<colgroup>
								<col style="width:150px;"/>
								<col style="width:*;"/>
								<col style="width:20px;"/>
							</colgroup>
							<c:forEach var="row" items="${queryInfo.ui[group[1]]}" varStatus="status">
								<tr type="">
									<th style="margin: 1px; padding: 1px;">
										<input type="text" propty="key"  name="${group[1] }" value="${row.key }" style="width: 99%;">
									</td>
									<td style="margin: 1px; padding: 1px;">
										<input type="text" propty="value" name="${group[1] }" value="${row.value }" ${group[2] } style="width: 99%;">
									</td>
									<td style="margin: 1px; padding: 1px;">
										<div class="del_tr">-</div>
									</td>
								</tr>
							</c:forEach>
						</table>
					</td>
					<td style="margin: 1px; padding: 1px;">
						<div class="add_tr" val="">+</div>
						<span style="display: none;">
							<table class="contents-contain">
								<tr type="">
									<td style="margin: 1px; padding: 1px;">
										<input type="text" propty="key"  name="${group[1] }" value="" style="width: 99%;" placeholder="${group[2] }">
									</td>
									<td style="margin: 1px; padding: 1px;">
										<input type="text" propty="value" name="${group[1] }" value="" ${group[4] } style="width: 99%;"  placeholder="ex) ${group[3]) }">
									</td>
									<td style="margin: 1px; padding: 1px;">
										<div class="del_tr">-</div>
									</td>
								</tr>
							</table>
						</span>
					</th>
				</tr>
				</c:forEach>
				<tr>
					<th class="ui-widget-header" style="margin: 1px; padding: 1px;">필드 리스트</th>
					<td colspan="4" style="margin: 1px; padding: 1px;">
						<div class="sel_flds_${queryInfo.ui.id }"></div>
					</td>
				</tr>
			</table>
			</div>
			
			<table border="0" class="contents-contain">
				<tr style="height: 20px">
					<th class="ui-widget-header" width="40%">쿼리</th>
					<th class="ui-widget-header" width="60%">소스</th>
				</tr>
				<tr >
					<td style="height: 300px;margin: 1px; padding: 1px;">
						<textarea name="query" style="width: 99%; height: 99%">${queryInfo.query }</textarea>
					</td>
					<td style="height: 300px;margin: 1px; padding: 1px;">
						<textarea name="source" style="width: 99%; height: 99%"></textarea>
					</td>
				</tr>
			</table>

		</div>
	</c:forEach>
	
</div>

</form>
