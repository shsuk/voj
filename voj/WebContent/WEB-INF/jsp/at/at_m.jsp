<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<c:set var="_q" value="${req._q!='' && req._q!=null ? req._q : _q}" scope="request"/>
<c:set var="_t" value="${req._t!='' && req._t!=null ? req._t : _t}" scope="request"/>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu">
[
	<uf:job id="rset" jobId="db" ds="${req._ds==null || req._ds=='' ? '' : req._ds }" query="${_q}" isReturnColumInfo="true">
		defaultValues:{
			listCount:15,
			pageNo:1,
			_sort_val: "${empty(req._sort_opt) ? '' : fn:replace(fn:replace(' ORDER BY @key @opt ','@key', req._sort_key), '@opt',  (req._sort_opt=='d' ? ' desc ' : ' asc '))}"
		}
	</uf:job>
	<uf:job id="rows" jobId="db" query="system/at/valid_list" isCache="true" refreshTime="60">
		defaultValues:{query_id:'${_q}'}
	</uf:job>
	<uf:job id="colMap" jobId="list2Map" src="rows" key="col_id" />
]
</uf:organism>

<uf:split2map var="system" value="rnum,tot_count,totcount,listcount,pageno"/>
<div data-role="collapsible-set" data-inset="false"  style="margin-top: 0px;margin-bottom: 0px;">
<c:forEach var="rows" items="${rset.data }" varStatus="status">
	<c:set scope="request" var="noLink" value="${false}"/>
	<c:set var="meta" value="${rset.meta[rows.key]}"/>
	<c:set var="metaMap" value="${rset.metaMap[rows.key]}"/>
	<c:set var="ui" value="${rset.ui[rows.key]}"/>
	<c:set var="row" value="${rows.value[0] }"/>

	<form name="${_q}.${rows.key }" action="at.sh" method="post" class="${ui.token_key }">
		<div data-role="collapsible" data-collapsed="false" data-theme="b" data-content-theme="d">
			<h3>${code:lang(rows.key, lang, rows.key) }</h3>
			<uf:split2map var="sort" value="${ui.sort }"/>
			<uf:split2map var="hiddens" value="${ui.hidden }"/>
			<uf:split2map var="read_onlys" value="${ui.read_only }"/>
			<uf:split2map var="read_onlys2" value="${ui.read_only2 }"/>
			<uf:split2map var="values" value="${ui.value }"/>
			<uf:split2map var="images" value="${ui.img }"/>
			<uf:split2map var="files" value="${ui.file }"/>
			<uf:split2map var="pk" value="${ui.pk }"/>
			<c:set var="params_insert"><uf:tpl src="${ui.params_insert}"/></c:set>
			<c:set var="params_update"><uf:tpl src="${ui.params_update}"/></c:set>
			<c:set var="params_delete"><uf:tpl src="${ui.params_delete}"/></c:set>
			<c:set var="button_edit"><uf:tpl src="${ui.button_edit}"/></c:set>
			<c:set var="button_add"><uf:tpl src="${ui.button_add}"/></c:set>
			<input type="hidden" name="_params_insert" value="${params_insert }">
			<input type="hidden" name="_params_update" value="${params_update }">
			<input type="hidden" name="_params_delete" value="${params_delete }">
			<input type="hidden" name="_button_edit" value="${button_edit }">
			<input type="hidden" name="_button_add" value="${button_add }">
			<input type="hidden" name="_sort_key" value="${req._sort_key}">
			<input type="hidden" name="_sort_val" value="${req._sort_val}">
			<input type="hidden" name="_sort_opt" value="${req._sort_opt}">
			<input type="hidden" name="listCount" value="${req.listCount}">
			<input type="hidden" name="pageNo" value="${req.pageNo}">
			<input type="hidden" name="_q" value="${_q}">
			<input type="hidden" name="_t" value="${_t}">

			<uf:hiddens args="_tab,_ds"/>
			<%//<!-- 폼 토큰 생성 -->%>
			<c:set var="token" value="${params_insert }:${params_update }.${params_delete }"/>
			<c:set var="token" value="${ui.token=='' || ui.token_key==null ? token : ui.token_key }"/>
			<uf:token name="${token}"/>

			<%//<!-- 상세형 시작 -->%>
			<c:if test="${ui.singleRow}">
				<div class="contents-detail ${rows.key }" style="overflow: auto;"  desc="dep4 singleRow=false">
				<%//<!-- 그룹 항목 출력 -->%>
				<c:forEach var="group" items="${ui.group }">
					<div class="ui-widget-content" >
						<c:set var="uigroup"><uf:tpl src="${group.value }" /></c:set>
						<c:set var="colls" value="${fn:split(uigroup,',') }"/>
						
						<ul data-role="listview" data-inset="true" >

							<c:forEach var="coll" items="${colls}">
								<c:set var="attr" value="${metaMap[fn:trim(coll) ] }"/>
								<c:choose><c:when test="${hiddens[attr.name]!=null}">
									<input name="${attr.name }" value="${row[attr.name]}" type="hidden" />
								</c:when><c:otherwise>
									<c:set var="cols" value="${fn:split(coll,':') }"/>
									
									<c:forEach var="col" items="${cols}" varStatus="status">
										<c:set var="colInfo" value="${fn:split(col,'#') }"/>
										<c:set var="attr" value="${metaMap[fn:trim(colInfo[0]) ] }"/>
										<c:set var="view_type">${(_t=='list' || _t=='view' || read_onlys[attr.name]!=null || (pk[attr.name]!=null && row[attr.name]!=null)) ? 'view_m' : 'edit_m' }</c:set>
										
										<li data-role="fieldcontain" >
											<fieldset data-role="controlgroup" data-type="horizontal"  data-mini="true" >
												<legend>${_t!='view' && fn:contains(colMap[attr.name].valid,'notempty') ? notempty_style : ''}${code:lang(attr.name, lang, attr.name) } : </legend>
												<uf:tpl src="tpl_ctl_${view_type }.jsp" data="row,attr,ui,colMap"/>									
											</fieldset>
										</li>
									</c:forEach>
									
								</c:otherwise></c:choose>
							</c:forEach>
						
						</ul>

						<c:choose><c:when test="${_t!='add' && _t!='edit'}">
							<div data-role="controlgroup" data-type="horizontal" data-mini="false" style="text-align: center;">
								<c:if test="${params_delete!='' }"><a href="javascript:del('${params_delete }')" data-role="button" data-icon="delete" data-theme="b">삭제</a></c:if>
								<c:if test="${button_edit!='' }"><a href="javascript:changePage('atm.sh?_t=edit&${button_edit }')" data-role="button" data-icon="edit">수정</a></c:if>
								<a href="javascript:historyBack()" data-role="button" data-icon="back">이전</a>
							</div>
						</c:when><c:otherwise>
							<div data-role="controlgroup" data-type="horizontal" data-mini="false" style="text-align: center;">
								<a href="javascript:submit_form('${_t }')" data-role="button" data-icon="check" data-theme="b">저장</a>
								<a href="javascript:historyBack()" data-role="button" data-icon="back">취소</a>
							</div>
						</c:otherwise></c:choose>
					</div>
				</c:forEach>
				</div>
			</c:if>
			<%//<!-- 상세형 끝 -->%>
			
			<%//<!-- 리스트형 시작 -->%>
			<c:if test="${!ui.singleRow}">
				<ul data-role="listview" data-theme="c" >
					<li> 
						<c:if test="${fn:length(ui.button_search)>0 }">
							<c:forEach var="item" items="${ui.button_search }">
								<uf:tpl src="tpl_ctl_search_m.jsp" data="item"/>
							</c:forEach>
						</c:if>
						<fieldset data-role="controlgroup" data-type="horizontal">
							<%//<!-- 검색 버튼 -->%>
							<c:if test="${ui.button_search!=null && ui.button_search!=''}"><a href="javascript:goPage(1)" data-role="button" data-inline="true" data-icon="search" >조회</a></c:if>
							<%//<!-- 등록 버튼 -->%>
							<c:if test="${button_add!=null && button_add!=''}"><a href= "javascript:changePage('atm.sh?_t=add&${button_add}')" data-role="button" data-icon="plus" data-inline="true" value="${_q}.${rows.key}">등록</a></c:if>
							<%//<!-- 기타 버튼 -->%>
							<c:forEach var="item" items="${ui.buttons }">
								<a data-role="button" data-inline="true" value="<uf:tpl src="${item.value}"/>">${code:lang(item.key, lang, item.key) }</a>
							</c:forEach>
						</fieldset>
					</li>

					<c:forEach var="row" items="${rows.value }">
						<c:set var="item_data" value=""/>
						<c:set var="style"><uf:tpl src="${ui.style }" /></c:set>
						<li style="${style}">
							<c:set var="link1" value=""/>
							<c:set var="link2" value=""/>
							<c:set var="item_value" value=""/>
							<c:forEach var="attr" items="${meta}" varStatus="status">
								<c:set var="item_value"><uf:tpl src="tpl_ctl_view_m.jsp" data="row,attr,ui,colMap"/></c:set>
								<c:choose><c:when test="${ui.link[attr.name]!=null && link1==''}">
									<c:set var="link1"><uf:tpl src="${ui.link[attr.name]}"/></c:set>
									<c:set var="linkVal1" value="${item_value}"/>
								</c:when><c:when test="${ui.link[attr.name]!=null && link2==''}">
									<c:set var="link2"><uf:tpl src="${ui.link[attr.name]}"/></c:set>
									<c:set var="linkVal2" value="${item_value}"/>
								</c:when><c:when test="${images[attr.name]!=null}">
									<c:if test="${row[attr.name]!=null }">
										<c:set var="img_path">at.sh?_ps=at/upload/dl&thum=100&file_id=${row[attr.name]}</c:set>
										<c:set var="item_data">${item_data }<img style="height:80px;" src="${img_path }"  class1="ui-li-icon ui-corner-none"/></c:set>
									</c:if>
								</c:when><c:otherwise>
									<c:set var="item_data">${item_data }${fn:trim(item_value) },</c:set>
								</c:otherwise></c:choose>
							</c:forEach>
							<c:if test="${link1!=''}"><a href="javascript:${link1 }" ><h3  style="${style}">${linkVal1 }</h3></c:if>
							${fn:substring(item_data,(fn:startsWith(item_data,',') ? 1 : 0),fn:length(item_data)-1) }
							<c:if test="${link1!=''}"></a></c:if>
							<c:if test="${link2!=''}"><a href="javascript:${link2 }">${linkVal2 }</a></c:if>
						</li>
					</c:forEach>
				</ul>

				<c:if test="${_t=='list'}">
					<br>
					<c:set scope="request" var="pageInfo" value="${rows.key }"/>
					<jsp:include page="simple_paging_m.jsp"/>
				</c:if>
			</c:if>
			<%//<!-- 리스트형 끝 -->%>

	
			<c:set var="form_comment"><uf:tpl src="${ui.form_comment}"/></c:set>
			${form_comment }
			<c:if test="${ui.javascript != null}">
			<c:set var="javascript"><uf:tpl src="${ui.javascript}"/></c:set>
				<script type="text/javascript">
				
						${javascript};
						
				</script>
			</c:if>
		</div>
	</form>
</c:forEach>
</div>