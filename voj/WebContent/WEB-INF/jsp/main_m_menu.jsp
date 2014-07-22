<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu" noException="true">
[
	<uf:job id="rows" jobId="db" query="system/menu/menu_list" isCache="false" refreshTime="300" />
	<uf:job id="tree" jobId="list2Tree"  >
		data: 'rows',
		singleKey: true,
		upperIdField: 'upper_rid',
		idField: 'rid',
		title: 'menu_name',
		rootId: '1000'
	</uf:job>
]
</uf:organism>

<div data-role="collapsible-set" >

	<c:forEach var="node1" items="${tree }" varStatus="idx1">
		<c:if test="${node1.mobile_yn == 'Y' }">
			<div data-role="collapsible" data-collapsed="${idx1.index!=req._midx1 }" data-theme="f" data-content-theme="d">
				<h3>${node1.menu_name }</h3>
	
				<div data-role="collapsible-set" data-inset="false">
				
				<c:forEach var="node2" items="${node1.children }" varStatus="idx2">
					<c:if test="${node2.mobile_yn == 'Y' }">
						<div data-role="collapsible" data-collapsed="${idx2.index!=req._midx2 }" data-theme="b" data-content-theme="d" >
							<h3>${node2.menu_name }</h3>
							<ul data-role="listview" data-theme="c">
							
							<c:forEach var="row" items="${node2.children }">
								<c:if test="${row.mobile_yn == 'Y' }">
								<li><a href="${row.url }&_midx1=${idx1.index }&_midx2=${idx2.index }">
									<c:if test="${row.menu_img_id != null }"><img src="at.sh?_ps=at/upload/dl&thum=16&file_id=${row.menu_img_id }" class="ui-li-icon"/></c:if>
									${row.menu_name }
								</a></li>
								</c:if>
							</c:forEach>
							
							</ul>
						</div>
					</c:if>
				</c:forEach>
				
				</div>
			</div>
		</c:if>
	</c:forEach>
	
</div>
