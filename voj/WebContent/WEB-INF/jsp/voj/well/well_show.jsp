<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<uf:organism >
[
	<job:db id="row" query="voj/well/view_week"  singleRow="true">
		defaultValues:{
			bd_cat: 'well'
		}
	
	</job:db>
]
</uf:organism>

<script type="text/javascript">
	
	function edit(bd_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {_ps:'voj/well/well_edit', bd_id: bd_id,  _layout: 'n', pageNo: (bd_id ? '${empty(req.pageNo) ? 1 : req.pageNo}' : '1')};
		
		show(target_layer, url, data);
	}

</script>


		<div style="width:100%;clear:both; min-height: 300px;margin-bottom: 5px;overflow: auto;">
			<div style="padding: 5px;font-weight: bold;font-size: 15px;">${row['title'] }</div>
			<div style="padding: 5px;">${fn:replace(fn:replace(row['CONTENTS'],'<!--[if !supportEmptyParas]-->', ''), '<!--[endif]-->', '') }</div>
		</div>

		<c:if test="${session.myGroups['well']}">
			<a style="float:right;margin-left: 5px;" class="cc_bt"  href="#" onclick="edit(${row.bd_id})" style="margin-right: 10px;">수 정</a>
		</c:if>

	