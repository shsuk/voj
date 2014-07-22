<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<jsp:include page="../voj_layout${mobile}.jsp" />
<style>
<!--
.bible {padding:0px; border: solid 1px #cccccc;display: none;width: 100%;}
.bible div{padding:8px 0 8px 0;margin:6px; border-bottom: solid 1px #f6f6f6;line-height:180%;  }

-->
</style>
<uf:organism >
[
	<job:db id="rset" query="voj/mc/day_view" singleRow="false" >
		defaultValues:{
			mc_dt:${empty(req.mc_dt) ? uf:getDate('MM-dd') : req.mc_dt }
		}
	</job:db>]
</uf:organism>

<script type="text/javascript">
	
	$(function() {
		var menuid = "m2";
    	setCurrentMenu(menuid);

		$('.b1').css({display: 'block'});
		$('.tit_b1').addClass('action_blue');

		$('.title').click(function(){
			var cat = $(this).attr('value');

			$('.bible').css({display: 'none'});
			$('.cat').removeClass('action_blue');

			$('.'+cat).css({display: 'block'});
			$('.tit_'+cat).addClass('action_blue');
			
			window.scrollTo(0, 1);
		});

		$('div',$('.bible')).click(function(e){
			$(e.currentTarget).toggleClass('bible_bg_s');
		});
	
	});
	


</script>
 
<div  id="body_main" style="display: none;">

	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		<div style="font-size: 20px;font-weight: bold;color:#2fb9d1;"><span  style="color:#a39c97;">예수마을교회</span> 
		<span> 맥체인 성경읽기</span><hr size="1" color="#a29c97" noshade></div>	
	</div>

	<div class="bd_body">
		<table ><tr>
			<td>
				<c:set var="day" value="_${rset.rows[0].mc_dt }일"/>
				<c:set var="day" value="${fn:replace(day,'_0','') }"/>
				<c:set var="day" value="${fn:replace(day,'_','') }"/>
				<c:set var="day" value="${fn:replace(day,'-0','-') }"/>
				<a href="at.sh?_ps=voj/mc/day_view&mc_dt=${rset.rows[0].mc_dt }&nevi=b" style="font-size: 24px;"><img src="../images/icon/actions-go-previous-view-icon.png" border="0"></a>
				
				<span style="font-size: 16px;font-weight: bold;color:#f6a400;">${fn:replace(day,'-','월') }(<tp:week m_d="${rset.rows[0].mc_dt }"/>)</span>
				<a href="at.sh?_ps=voj/mc/day_view&mc_dt=${rset.rows[0].mc_dt }&nevi=a" style="font-size: 24px;"><img src="../images/icon/actions-go-next-view-icon.png" border="0"></a>
			</td>
			<td width="20" ></td>
		</tr></table>
		<table>
			<tr>
				<c:forEach var="row" items="${rset.rows }">
					<td class="title " value="${row.ca_name }">
						<div class="cat cc_bt tit_${row.ca_name }"  style="padding: 2px;" >${row.wr_subject }</div>
					</td>
				</c:forEach>		
			</tr>
		</table>
	
		<c:forEach var="row" items="${rset.rows }">
			<div class="bible  ${row.ca_name }">
				<div><b>${row.wr_subject }</b></div>
				${row.WR_CONTENT }
			</div>
		</c:forEach>
		
		<table>
			<tr>
				<c:forEach var="row" items="${rset.rows }">
					<td class="title " value="${row.ca_name }">
						<div class="cat cc_bt tit_${row.ca_name }"  style="padding: 2px;" >${row.wr_subject }</div>
					</td>
				</c:forEach>		
			</tr>
		</table>
	</div>
</div>
	