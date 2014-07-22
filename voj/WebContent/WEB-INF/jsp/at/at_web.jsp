<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="utp"  tagdir="/WEB-INF/tags/user" %> 
<c:set var="_q" value="${req._q!='' && req._q!=null ? req._q : _q}" scope="request"/>
<c:set var="_t" value="${req._t!='' && req._t!=null ? req._t : _t}" scope="request"/>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu">
[
	<uf:job id="rset" jobId="db" ds="${req._ds==null || req._ds=='' ? '' : req._ds }" query="${_q}" isReturnColumInfo="true">
		defaultValues:{
			listCount:${isMobile ? 10 : 15 },
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
<script type="text/javascript">
$(function() {
	try {
		selectTab('${req._tab_id}');
	} catch (e) { }
});
</script>
<c:set var="tab" value="${req._tab=='y' ? true : (req._tab=='n') ? false : (fn:length(rset.data)>1 ? true : false)}"/>
<div class="table_tabs${tab ? '' : '_no'} at_top" desc="dep1">
<c:if test="${tab}">
	<ul class="tab_title">
		<c:forEach var="rows" items="${rset.data }" varStatus="status">
			<li><a href="#${rows.key }">${code:lang(rows.key, lang, rows.key) }</a></li>
		</c:forEach>
	</ul>
</c:if>

<uf:split2map var="system" value="rnum,tot_count,totcount,listcount,pageno,rrnum"/>
<c:set var="notempty_style"><font color="blue">*</font></c:set>

<c:forEach var="rows" items="${rset.data }" varStatus="status">
	<c:set var="meta" value="${rset.meta[rows.key]}"/>
	<c:set var="metaMap" value="${rset.metaMap[rows.key]}"/>
	<c:set var="ui" value="${rset.ui[rows.key]}"/>
	<c:set var="row" value="${rows.value[0] }"/>

	<div id="${rows.key }" class="tab_body " style="padding:0px;" desc="dep2">
		<div class="contents-contain" desc="dep3">
		<form name="${_q}.${rows.key }"  action="at.sh" class="${ui.token_key }" onsubmit="return enter_event();">
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

			<c:if test="${ui.singleRow}">
			<%//<!-- 상세형 시작 -->%>
				<div class="contents-detail ${rows.key }" style="overflow: auto;"  desc="dep4 singleRow=false">
				<%//<!-- 그룹 항목 출력 -->%>
				<c:forEach var="group" items="${ui.group }">
					<div class="ui-widget-content"  style="padding: 2px;margin: 2px;">
						<c:if test="${fn:length( ui.group)>1 }">
							<h3 onclick="$('div[name=${group.key }]').slideToggle('slow');" class="ui-widget-header">${code:lang(group.key, lang, group.key) }</h3>
						</c:if>
						<div name="${group.key }">
							<table  class="ui-widget ui-widget-content contents-contain" style="margin-top: 2px;margin-bottom: 2px;">
							<tbody>
							<c:set var="uigroup"><uf:tpl src="${group.value }" /></c:set>
							<c:set var="colls" value="${fn:split(uigroup,',') }"/>
							<c:forEach var="coll" items="${colls}">
								<c:set var="attr" value="${metaMap[fn:trim(coll) ] }"/>
								<c:choose><c:when test="${hiddens[attr.name]!=null}">
									<input name="${attr.name }" value="${row[attr.name]}" type="hidden" />
								</c:when><c:otherwise>
									<c:set var="cols" value="${fn:split(coll,':') }"/>
									<c:if test="${!isMobile }"><tr></c:if>
										<c:forEach var="col" items="${cols}" varStatus="status">
											<c:set var="colInfo" value="${fn:split(col,'#') }"/>
											<c:set var="attr" value="${metaMap[fn:trim(colInfo[0]) ] }"/>
											<c:if test="${isMobile }"><tr></c:if>
											<th ${isMobile ? '' : 'width="150"'} class="ui-state-default" style="text-align:  right;" title="${attr.name }">
												<c:set var ="colName" value="${files[attr.name]==null || files[attr.name] ? attr.name : files[attr.name]}"/>
												${_t!='view' && fn:contains(colMap[attr.name].valid,'notempty') ? notempty_style : ''}${code:lang(colName, lang, colName) }
											</th>
											<td colspan="${fn:length(colInfo)==1 ? '1' : colInfo[1] }">
												<uf:tpl src="tpl_ctl_${(_t=='list' || _t=='view' || read_onlys[attr.name]!=null || (pk[attr.name]!=null && row[attr.name]!=null)) ? 'view' : 'edit'}.jsp" data="row,attr,ui,colMap"/>
											</td>
											<c:if test="${isMobile }"></tr></c:if>
										</c:forEach>
									<c:if test="${!isMobile }"></tr></c:if>
								</c:otherwise></c:choose>
							</c:forEach>
							</tbody>
							</table>
							</div>
					</div>
				</c:forEach>
				</div>
			<%//<!-- 상세형 끝 -->%>
			</c:if>

			<c:if test="${!ui.singleRow}">
			<%//<!-- 리스트형 시작 -->%>
				<c:if test="${_t=='list'}">
					<table class="search_form contents-contain" style="margin-top: 5px;margin-bottom: 0px;">
						<tr class="ui-state-default ui-state-active" role="tab" >
						<td style="vertical-align: bottom;">
							<%//<!-- 검색 조건 입력 -->%>
							<c:if test="${fn:length(ui.button_search)>0 }">
								<c:forEach var="item" items="${ui.button_search }">
									<div class="search-param" style="margin-top: 3px"><uf:tpl src="tpl_ctl_search.jsp" data="item"/></div>
								</c:forEach>
								<script type="text/javascript">
								$(function() {
									$('[name="${_q}.${rows.key }"]').keypress(function(e){
										if(e.keyCode==13) enter_event();
									});
								});
								</script>
							</c:if>
							<%//<!-- 검색 버튼 -->%>
							<c:if test="${ui.button_search!=null && ui.button_search!=''}"><div id="button_search_${ui.id}" class="search-param button_search${ui.id=='dual' ? ui.id : '' } button_search_${ui.id}" style="margin-left :7px" value="${_q}.${rows.key}">조회</div></c:if>
							<%//<!-- 등록 버튼 -->%>
							<c:if test="${ui.button_add!=null && ui.button_add!=''}"><div class="search-button button_add  button_add_${ui.id}" value="${_q}.${rows.key}">등록</div></c:if>
							<%//<!-- 기타 버튼 -->%>
							<c:forEach var="item" items="${ui.buttons }">
								<div class="search-button button_action button_action_${item.key}" value="<uf:tpl src="${item.value}"/>">${code:lang(item.key, lang, item.key) }</div>
							</c:forEach>
						</td>
						</tr>
					</table>
				</c:if>
				<c:if test="${ui.graph!=null}">
					<script type="text/javascript">
						$(function() {
							goGraph('#graph_${ui.id}',${JSON.rset.data[ui.id]}, ${ui.graph});
						});
					</script>
					<center>
						<table style="width:95%;"><tr>
							<td height="*">
								<div id="graph_${ui.id}" style="width:100%;height:300px;"></div>
							</td><td height="300"  style="width:250px;height:300px;">
								<div id="pieGraph" style="width:250px;height:250px;"></div>
								<div id="pieGraph_title" style="width:250px;height:25px;text-align: center;font-weight:bold; "></div>
							</td></tr>
						</table>
					</center>
					<div id="graph_${ui.id}_hover" style="position:absolute; z-index:1000000;display:none; background-color: #ffffff;border:1px solid #e0e1e3;padding: 3px 3px 3px 3px ;"></div>
				</c:if>
				<c:if test="${ui.id!='dual' }">

					<div class="contents-list" style="overflow: auto; " desc="dep4 singleRow">
						<table class="ui-widget ui-widget-content contents-contain" style="padding: 2px;margin-top: 2px;margin-bottom: 2px;">
							<c:set var="width_sum" value="${0}"/><!-- 컬럼폭 계산 -->
							<c:forEach var="attr" items="${meta}" varStatus="status">
								<c:if test="${system[attr.name]==null && hiddens[attr.name]==null}">
									<c:set var="width_sum" value="${width_sum + (colMap[attr.name].width==null ? 0 : colMap[attr.name].width) }"/>
					 			</c:if>
							</c:forEach>
							<c:if test="${width_sum > 0 }"><!-- 컬럼폭 설정 -->
								<colgroup>
									<c:forEach var="attr" items="${meta}" varStatus="status">
										<c:if test="${system[attr.name]==null && hiddens[attr.name]==null}">
											<col style="width: ${uf:ceil(colMap[attr.name].width==null ? 0 : colMap[attr.name].width) / uf:ceil(width_sum) }%;"/>
							 			</c:if>
									</c:forEach>
								</colgroup>
							</c:if>
							<thead><!-- 컬럼명 -->
							<tr class="ui-state-default"">
								<c:forEach var="attr" items="${meta}" varStatus="status">
									<c:choose><c:when test="${attr.name == 'checkbox'}">
										<th><center><input type="checkbox" id="checkboxAll" name="checkboxAll" value="all"/></center></th>
									</c:when><c:when test="${attr.name == 'action_button'}">
										<th><div class="add_item">항목추가</div></th>
									</c:when><c:when test="${system[attr.name]==null && hiddens[attr.name]==null}">
								 		<th title="${attr.name}" sort="${sort[attr.name]!=null }" opt="${req._sort_opt=='a' ? 'd' : 'a' }" value="${attr.name}" style=" min-width:${isMobile ? fn:length(attr.name)*10 : '20'}px; ${sort[attr.name]!=null ? 'cursor: pointer; color:#050099;' : 'color:#222222;' } ">
								 			${fn:contains(colMap[attr.name].valid,'notempty') ? notempty_style : ''}
								 			<c:set var ="colName" value="${files[attr.name]==null || files[attr.name] ? attr.name : files[attr.name]}"/>
								 			${code:lang(colName, lang, colName) }
								 			${sort[attr.name]!=null && req._sort_key == attr.name ? (req._sort_opt=='d' ? '(▼)' : '(▲)') : ''}
								 		</th>
					 				</c:when></c:choose>
								</c:forEach>
							</tr>
							</thead>
							<tbody><!-- 데이타 -->
							<c:set scope="request" var="pageInfo" value="${rows.key }"/>
							<c:set scope="request" var="temp_value" value=""/>

							<c:forEach var="row" items="${rows.value }">
								<c:set scope="request" var="curr_value"><uf:tpl src="${ui.curr_value }"/></c:set>
								<tr class="ui-widget-content over" >
									<c:set var="style"><uf:tpl src="${ui.style }" /></c:set>
									<c:forEach var="attr" items="${meta}" varStatus="status">
										<c:if test="${system[attr.name]==null }">
											<c:choose><c:when test="${hiddens[attr.name]==null}">
												<td  style=" ${style}">
													<c:set scope="request" var="hss_row" value="${hss_row }${row[attr.name] }"/>${row_str }
													<uf:tpl src="tpl_ctl_${(_t=='list' || _t=='view' || read_onlys[attr.name]!=null || (pk[attr.name]!=null && row[attr.name]!=null)) ? 'view' : 'edit' }.jsp" data="row,attr,ui,colMap"/>
												</td>
											</c:when><c:otherwise>
	
											</c:otherwise></c:choose>
							 			</c:if>
									</c:forEach>
								</tr>
								<c:set scope="request" var="before_value"><uf:tpl src="${ui.before_value }"/></c:set>
							</c:forEach>
							</tbody>
						</table>
					</div desc="dep4 singleRow">
					<c:if test="${_t=='list'}">
						<br>
						<tp:paging listCount="${rset.data[rows.key][0].listCount }" 
							pageNo="${rset.data[rows.key][0].pageNo }" 
							totCount="${rset.data[rows.key][0].totCount }"
							loadingLayerSelector="${_q}.${rows.key}"/>
						<script type="text/javascript">
							goPage_formName = '${_q}.${rows.key}';
						</script>
					</c:if>
				</c:if>

			<%//<!-- 리스트형 끝 -->%>
			</c:if>
		</form>
		</div  desc="contents-contain dep3">
		<c:set var="form_comment"><uf:tpl src="${ui.form_comment}"/></c:set>
		${form_comment }
		<c:if test="${ui.javascript != null}">
		<c:set var="javascript"><uf:tpl src="${ui.javascript}"/></c:set>
			<script type="text/javascript">
			
					${javascript};
					
			</script>
		</c:if>
	</div  desc="dep2">
</c:forEach>
</div  desc="dep1">
