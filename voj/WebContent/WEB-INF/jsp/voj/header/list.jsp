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
		<job:db id="row" query="voj/header/delete"/>
	]</uf:organism>	
</c:if>

<uf:organism >
[
	<job:db id="rows" query="voj/header/list" singleRow="false" >
		defaultValues:{
		bd_cat: 'cafe',
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
				_ps: 'voj/header/list'
				
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
				_ps: 'voj/header/edit',
				id: $(div).attr('bd_id'),
				_layout: 'n'
		};

		show(target_layer, url, data);
	}
	<%//글수정 패스워드가 있는 글은 패스워드를 입력받는다.%>
	function edit(bd_id,isPw){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/header/edit', bd_id: bd_id,  _layout: 'n', pageNo: (bd_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};
		
		show(target_layer, url, data);
	}
	
	function del(bd_id,isPw){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/bd/list', bd_id: bd_id,action:'d', _layout: 'n', pageNo: (bd_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};

		show(target_layer, url, data);
	}
	
	function form_submit(){	
		var form = $('#content_form');
		if(form.attr('isSubmit')==='true') return false;

		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			
		
		var formData =$(form).serializeArray();
		
		
		if($(form).attr('isSubmit')==='true') return false;
		$(form).attr('isSubmit',true);

		var url = 'at.sh';
		$.post(url, formData, function(response, textStatus, xhr){
			$(form).attr('isSubmit',false);

			var data = $.parseJSON(response);
			//checkFunction(data);
			if(data.success){
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
			}
			goPage('${req.pageNo}');
		});
		return false;
	}

</script>

<div  id="body_main" style="display: none;">
	<br>
	<div style="width:100%;height:30px;">
		${HEADER }
	</div>
	<table class="${tpl_class_table}" style="margin-top: 0px;">
		<tr class="${tpl_class_table_header}">
			<th>제목</th>
		</tr>
		<c:forEach var="row" items="${rows }">
		<tr>
			<td>
				<div class="view_link" onclick="load_view(this)" bd_id="${row.id}" >
					${row['title'] }
				</div>
			</td>
		</tr>
		</c:forEach>
	</table>
	</div>
	<div style="width:100%;height:30px;">
		<c:if test="${cookie.bd_add.value > uf:addMinutes(uf:now(),-60).time }">
			<a class="cc_bt" style="float:right;" href="#" onclick="edit()">새 글</a>
		</c:if>
	</div>

	