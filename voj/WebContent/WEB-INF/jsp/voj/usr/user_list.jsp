<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<%@ taglib prefix="jobu"  tagdir="/WEB-INF/tags/job/user" %> 
<%@ taglib prefix="tpu"  tagdir="/WEB-INF/tags/user" %> 

<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu">[
	<job:requestEnc id="reuestEnc"  aes256="search_val" />
	<uf:job id="rows" jobId="db" query="voj/usr/user_list" singleRow="false">
			defaultValues:{
			listCount:100,
			pageNo:1,
			_sort_val: "${empty(req._sort_opt) ? '' : fn:replace(fn:replace(' ORDER BY @key @opt ','@key', req._sort_key), '@opt',  (req._sort_opt=='d' ? ' desc ' : ' asc '))}"
		}
	</uf:job>	
]</uf:organism>

<jsp:include page="../voj_layout.jsp" />

<script type="text/javascript">
	<c:if test="${!session.myGroups['user']}">
		alert('회원관리 권한이 없습니다.');
		document.location.href = '/';
	</c:if>
	$(function() {
		<%-- 리스트에서 사용자 검색 --%>
		$('#search_btn').button({icons: {primary: "ui-icon-search"}}).click(function(){
			search();
		});
		
	});
	function user_view(user_no){
		open_popup('pop_user_status','at.sh',{_ps:'voj/usr/user_group',user_no:user_no, _layout:'n'});
	}
	
	function user_status(user_no, status){
		open_popup('pop_user_status','at.sh',{_ps:'voj/usr/user_status',user_no:user_no, _layout:'n'});
	}
	function search(){		
		//폼 정합성 체크
		
		goPage(0);
		
		return false;
	}
	
	function goPage(pageNo){
		var form = $('form[name=main_form]');
		var target_layer = $('#body_main').parent();
		
		var data = {_layout:'n', _ps: '${req._ps}'};
		
		var fields = form.serializeArray();
		$.each(fields, function(i, field){
			data[field.name] =field.value.trim();
		});
	
		if(pageNo!=0){
			data['pageNo'] = pageNo;
		}
	
		target_layer.hide("fade");
		target_layer.show( "fade");
		target_layer.load('at.sh', data);
	}
	
	
</script>
<tp:popup title="회원 관리" id="pop_user_status" height="400" width="800"/>
<div id="body_main">
	<div class="${tpl_class_title}">회원 관리</div>

	<table  style="width: 100%; "><tr>
		<td valign="top">
			<form id="main_form" name="main_form" action="" onsubmit="return search()">
				<div class="${tpl_class_search}">
					<tp:select className="btn-l" name="user_sts" groupId="user_status" selected="${req.user_sts }" emptyText="회원상태를 선택하세요."/>
					<input type="text" class="btn-l" id="search_val" name="search_val" value="${req.search_val }" placeholder="아이디,이름,별명"/><div class="btn-l" style="padding-top: 3px;">별명은 부분검색 가능함</div>
					<div id="search_btn" class="btn-r">조회</div>
				</div>
			</form>
			<table class="${tpl_class_table}" >
				<tr class="${tpl_class_table_header}">
					<th width="40">번호</th>
					<th width="100">아이디</th>
					<th width="100">이름</th>
					<th width="100">별명</th>
					<th width="40">상태</th>
					<th>유저구룹</th>
				</tr>
				<c:forEach var="row" items="${rows }" varStatus="status">
					<tr>
						<td style="text-align: center;">
							${ row['USER_NO'] }
						</td>
						<td style="text-align: center;">
							<div class="view_link" onclick="user_view(${ row['USER_NO'] })" >${row['USER_ID@dec@email']}</div>
						</td>
						<td style="text-align: center;">
							${row['USER_NM@dec@name']}
						</td>
						<td style="text-align: center;">
							${row.nick_name}
						</td>
						<td style="text-align: center;">
							<div class="view_link" onclick="user_status(${ row['USER_NO'] },'${row.user_status}' )" >${code:name('user_status', row.user_status,'')}</div>
						</td>
						<td>
							${code:name('user_group', row['user_group'],'')}
						</td>
					</tr>
				</c:forEach>
			</table>
			
			<tp:paging listCount="${rows[0].listCount }" pageNo="${rows[0].pageNo }" totCount="${rows[0].totCount }"/>
		</td>
	</tr></table>	
</div>	