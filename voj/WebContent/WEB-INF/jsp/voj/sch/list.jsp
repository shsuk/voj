<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<jsp:include page="../voj_layout${mobile}.jsp" />
<c:if test="${req.action=='d' }">
	<uf:organism noException="true">[
		<job:db id="row" query="voj/sch/delete"/>
	]</uf:organism>	
</c:if>

<uf:organism >
[
	<job:db id="rows" query="voj/sch/list1" singleRow="false" >
		defaultValues:{
			listCount:${isMobile ? 10 : 15 },
			pageNo:1,
			_sort_val: "${empty(req._sort_opt) ? '' : fn:replace(fn:replace(' ORDER BY @key @opt ','@key', req._sort_key), '@opt',  (req._sort_opt=='d' ? ' desc ' : ' asc '))}"
		}
	</job:db>
]
</uf:organism>

<script type="text/javascript">
	
	$(function() {
		$('#search_btn').button({icons: {primary: "ui-icon-search" },text:false}).click(function(){
			search();
		});
	    init_load();
	});
		
	function search(){
		//폼 정합성 체크
		
		goPage(0);
		
		return false;
	}
	
	function goPage(pageNo){
		var form = $('form[name=main_form]');
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {
				_layout:'n', 
				_ps: 'voj/sch/list'
				
		};
		
		var fields = form.serializeArray();
		$.each(fields, function(i, field){
			data[field.name] =field.value;
		});
	
		if(pageNo!=0){
			data['pageNo'] = pageNo;
		}
		
		show(target_layer, url, data);
	}
	
	function load_view(div){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {
				_ps: 'voj/sch/view',
				bd_id: $(div).attr('bd_id'),
				_layout: 'n',
				pageNo:	'${empty(req.pageNo) ? 1 : req.pageNo}'
		};

		show(target_layer, url, data);
	}
	<%//글수정 패스워드가 있는 글은 패스워드를 입력받는다.%>
	function edit(bd_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/sch/edit', bd_id: bd_id,  _layout: 'n', pageNo: (bd_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};
		
		show(target_layer, url, data);
	}
	
	function del(bd_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/sch/list', bd_id: bd_id,action:'d', _layout: 'n', pageNo: (bd_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};

		show(target_layer, url, data);
	}
	

</script>

<div  id="body_main" style="display: none;">

	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		<div style="font-size: 20px;font-weight: bold;color:#2fb9d1;"><span  style="color:#a39c97;">예수마을교회</span> 
		<span> 교회일정</span><hr size="1" color="#a29c97" noshade></div>	
	</div>

	<table class="${tpl_class_table}" style="margin-top: 0px;">
		<tr class="${tpl_class_table_header}">
			<th width="50" class="${mobile}">글번호</th>
			<th width="100" class="${mobile}">일자</th>
			<th>제목</th>
			<th width="80">작성자</th>
			<th width="100" class="${mobile}">작성일</th>
			<th width="50" class="${mobile}">조회</th>
		</tr>
		<c:forEach var="row" items="${rows }">
		<tr>
			<td style=" text-align: center;" class="${mobile}">${row.bd_id }</td>
			<td style=" text-align: center;" class="${mobile}">${row.bd_key }</td>
			<td>
				<div class="view_link" onclick="load_view(this)" bd_id="${row.bd_id}" >
					${row['title'] }
				</div>
			</td>
			<td style="text-align: center;">${row.reg_nickname }</td>
			<td style="text-align: center;" class="${mobile}">${row['reg_dt@yyyy-MM-dd'] }</td>
			<td style="text-align: center;" class="${mobile}">${row.view_count }</td>
		</tr>
		</c:forEach>
	</table>
	<div style="width: 100%">
		<div style="margin: auto;"><tp:paging listCount="${rows[0].listCount }" pageNo="${rows[0].pageNo }" totCount="${rows[0].totCount }"/></div>
		<c:if test="${!isMobile}">
			<div style="float:right;">
				<form id="main_form" name="main_form" action="" onsubmit="return search()">
					<div id="search_btn" class="btn-r"  style="margin: 0px;">조회</div>
					<input type="text" class="btn-r" id="search_val" name="search_val" value="${req.cearch_val}" title="제목">
				</form>
			</div>
		</c:if>
		<c:if test="${session.myGroups['sch']}">
			<a class="cc_bt" style="float:right;" href="#" onclick="edit()">새 글</a>
		</c:if>
	</div>
</div>
	