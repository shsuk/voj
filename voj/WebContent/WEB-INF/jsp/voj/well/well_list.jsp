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
		<job:db id="row" query="voj/well/delete"/>
	]</uf:organism>	
</c:if>

<uf:organism >
[
	<job:db id="rows" query="voj/well/list" singleRow="false" >
		defaultValues:{
			listCount:${isMobile ? 10 : 10 },
			pageNo:1,
			_sort_val: "${empty(req._sort_opt) ? '' : fn:replace(fn:replace(' ORDER BY @key @opt ','@key', req._sort_key), '@opt',  (req._sort_opt=='d' ? ' desc ' : ' asc '))}"
	}
	</job:db>
]
</uf:organism>

<script type="text/javascript">
	
	$(function() {

		if(!${empty(req.bd_id)}){
	    	load_view1('${req.bd_id == "max" ? '' : req.bd_id}');
	    }
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
				bd_cat:'well', 
				_ps: 'voj/well/well_list'
				
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
	function load_view1(bd_id){
		var target_layer = $('#well_content');
		
		var url = 'at.sh';
		var data = {
				_ps: 'voj/well/well_show',
				bd_id: bd_id,
				_layout: 'n',
				pageNo:	'${empty(req.pageNo) ? 1 : req.pageNo}'
		};

		show(target_layer, url, data);
	}
	
	function load_view(div){
		load_view1($(div).attr('bd_id'));
	}

	function edit(bd_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/well/well_edit', bd_id: bd_id,  _layout: 'n', pageNo: (bd_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};
		
		show(target_layer, url, data);
	}
	
	function del(bd_id,isPw){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/bd/list', bd_id: bd_id,action:'d', _layout: 'n', pageNo: (bd_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};

		show(target_layer, url, data);
	}

</script>

<div  id="body_main" style="display: none;">

	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		<div style="font-size: 20px;font-weight: bold;color:#2fb9d1;"><span  style="color:#a39c97;">예수마을교회</span> 
		<span> 우물가 소식</span><hr size="1" color="#a29c97" noshade></div>	
	</div>

	<div class="bd_body bd_title">
	
		<div id="well_content"></div>
		<table  class="bd" >
			<tr>
				<th>지난 소식</th>
			</tr>
			<c:forEach var="row" items="${rows }">
				<tr>
					<td>
						<div class="view_link" style="padding-left: 30px;" onclick="load_view(this)" bd_id="${row.bd_id}" >
							${row.disply=='N' ? '(미노출) ' : '' }${row.title }
						</div>
					</td>
				</tr>
			</c:forEach>
		</table>
	
		<div style="width: 100%;clear:both;">
			<div style="margin: auto;"><tp:paging listCount="${rows[0].listCount }" pageNo="${rows[0].pageNo }" totCount="${rows[0].totCount }"/></div>
			<table style="width: 100%">
				<tr>
					<td width="100">
						<c:if test="${session.myGroups['well']}">
							<a class="cc_bt" style="float:right;" href="#" onclick="edit()">등 록</a>
						</c:if>&nbsp;
					</td>
				</tr>
			</table>
		</div>
	</div>

</div>
	