<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<c:choose >
	<c:when test="${req.action=='i' && session.user_id!='guest'}">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/gal/insert_rep"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='d' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/gal/delete_rep"/>
		]</uf:organism>	
	</c:when>
</c:choose>

<uf:organism >
[
	<job:requestEnc id="reuestEnc" aes256="pw" />
	<job:db id="rset" query="voj/gal/view" />
]
</uf:organism>
<c:set var="row" value="${rset.row }"/>
<script type="text/javascript">
	
	$(function() {
	
		change_img($('.img_list')[0]);

		showAutoItemNevi();
		showNevi();
	    
    	$('.prev_item').show();
    	$('.next_item').show();
    	
	    if('${rset.prev.gal_id }'==''){
	    	$('.prev_item').hide();
	    }
	    if('${rset.next.gal_id }'==''){
	    	$('.next_item').hide();
	    }
	   
	    $('.prev_item').attr('gal_id', '${rset.prev.gal_id }');
	    $('.next_item').attr('gal_id', '${rset.next.gal_id }');

	    init_load();
	    
	    changeEmoticon();
	});
	

	
	function activeImg(rid){
		$('#body_main').load('at.sh?_ps=voj/gal/edit_action', {action:'act', bd_cat:'${req.bd_cat}', rid:rid});
	}
</script>

<div  id="body_main">
	
	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		${HEADER }
	</div>

	<div class="bd_body">
		
		<table style="width:100%; clear:both;border:1px solid #B6B5DB; padding: 5px;margin-bottom: 5px;"><tr><td>
			<div style="float:left;"><b>제목 : <font color="#0000C9">${row.title }</font></b></div>
			<div style="float:right;">
				${isMobile ? '<br>' : ''}
				<b>작성자 :</b> ${row.reg_nickname }&nbsp;&nbsp;&nbsp;&nbsp;
				${isMobile ? '<br>' : ''}
				<b>작성일 :</b> ${row['reg_dt@yyyy-MM-dd HH:mm:ss'] }&nbsp;&nbsp;&nbsp;&nbsp;
				${isMobile ? '<br>' : ''}
				<b>조회수 :</b> ${row.view_count }
			</div>
		</td></tr></table>
		<%//목록 %>
		<table  style="clear:both; border:1px solid #B6B5DB; padding: 0px;margin-bottom:5px; margin-top:5px; width: 100%;"><tr><td style="padding-left: 7px;">
			<%//이미지 %>
			<div onmouseover="showNevi()" style="position: relative; float:left;padding:5px; margin-bottom:5px; border:1px solid #B6B5DB;text-align: center; width: 632px; overflow: hidden;">
				<div id="prev_img_item" title="이전 사진" class="img_nevi" onclick="goPrevImg()" style="position: absolute; left:0px;  height: 100%; width: 50px; cursor: pointer;opacity: .35;filter: Alpha(Opacity=35); background: #cccccc url('./voj/images/Arrow-previous-icon.png') no-repeat  center center;text-align: center; vertical-align: middle;"></div>
				<div id="next_img_item" title="다음 사진" class="img_nevi" onclick="goNextImg()" style="position: absolute; left:590px; height: 100%; width: 50px; cursor: pointer;opacity: .35;filter: Alpha(Opacity=35); background: #cccccc url('./voj/images/Arrow-next-icon.png') no-repeat  center center;text-align: center; vertical-align: middle;"></div>
				<tp:img id="view_img" file_id="${rset.rows[0].file_id}" thum="1000" style="max-width: 100%; width: 100%;" />
			</div>
			<c:forEach var="rowl" items="${rset.rows }" varStatus="status">
				<div class="img_list" onclick="change_img(this)" file_id="${rowl.file_id }" style="float:left; vertical-align:middle; margin: 2px;overflow: hidden; border:1px solid #B6B5DB; width: 82px; height:${row.bd_cat=='img' ? '75' : '52'}px; text-align: center;   padding:2px; cursor: pointer; background: ${status.index==0 ? '#2478FF' : ''};">
					<c:if test="${row.bd_cat=='img'}"><%//메인 이미지 %>
						<div onclick="activeImg(${rowl.rid})" style="position: absolute;background: #cccccc;min-width:20px; width: 20px;line-height: 12px;" class="cc_bt" title="${rowl.active=='Y' ? '사용중' : '미사용'  }">${rowl.active=='Y' ? 'A' : 'D'  }</div>
					</c:if>
					<tp:img file_id="${rowl.file_id}" thum="160" attr="height=\"50\"" />
					<c:if test="${row.bd_cat=='img'}"><%//메인 이미지 %>
						<div style="font-size:8px; ">${rowl['start_date@yy-MM-dd']}<br>${rowl['end_date@yy-MM-dd']}</div>
					</c:if>
				</div>
			</c:forEach>
		</td></tr></table>
		<%//버튼 %>
		<div style="clear:both; ">
			<a style="float:right; margin-left: 5px; " class="cc_bt" href="#" onclick="goPage(${req.pageNo})">목 록</a>
			<c:if test="${(row.reg_id!='guest' && row.reg_id==session.user_id) || row.reg_id=='guest' }">
				<a style="float:right; margin-left: 5px; " class="cc_bt"  href="#" onclick="edit(${req.gal_id},${row.reg_id=='guest' })" >제목수정</a>
			</c:if>
			<c:if test="${(row.reg_id!='guest' && row.reg_id==session.user_id) || row.reg_id=='guest' || session.myGroups[row.bd_cat] }">
				<a style="float:right;margin-left: 5px;" class="cc_bt" href="#" onclick="del(${req.gal_id })" >${session.myGroups[row.bd_cat] ? '관리자' : ''} 현재사진삭제</a>
				<form id="content_form" action="at.sh" method="post" enctype="multipart/form-data" style="float: left;">
					<input type="hidden" name="action" id="action" value="a">
					<input type="hidden" name="_ps" value="voj/gal/edit_action">
					<input type="hidden" name="file_id" id="file_id" value="">
					
					<input type="hidden" name="gal_id" value="${req.gal_id }">
					<input type="hidden" name="bd_cat" value="${req.bd_cat }">
					<input type="hidden" name="pageNo" value="${req.pageNo }">
					<c:if test="${req.bd_cat=='img'}">
						게시기간:
								<input type="text" name="start_date" id="start_date" class="datepicker" readonly="readonly" title="시작일" style="width: 80px;" valid="[['notempty'],['maxlen:50']]"> ~
								<input type="text" name="end_date" id="end_date" class="datepicker" readonly="readonly" title="만료일" style="width: 80px;" valid="[['notempty'],['maxlen:50']]">
						
					</c:if>
					<input type="file" name="pic_file"  class="pic_file" valid="[['notempty'],['ext:jpg,jpeg,gif,zip']]">
				</form>
				<a href="#" class="cc_bt" onclick="form_submit();" style="float: left; margin-left: 5px;">사진 추가</a>
				<c:if test="${req.bd_cat=='img'}">
					<a href="#" class="cc_bt" onclick="change_date_submit();" style="float: left; margin-left: 5px;">현재 이미지 게시기간 변경</a>
				</c:if>
			</c:if>
		</div>
		<br><br><br>
		<%//답글 작성 %>
		<c:if test="${session.user_id=='guest' }">
			<table style="width: 100%;;clear:both; margin-bottom: 5px;">
				<tr>
					<td width="60" align="right"><a href="at.sh?_ps=voj/login/login_form">로그인</a> 후 글을 작성하세요.</td>
				</tr>
			</table>
			<hr color="#cccccc" />
		</c:if>
		
		<form id="reply_form" action="sample.php" method="post"  style=" ${session.user_id=='guest' ? 'display:none;' : ''}">
			<input type="hidden" name="_ps" value="${req._ps }">
			<input type="hidden" name="gal_id" value="${req.gal_id }">
			<input type="hidden" name="action" value="i">
			<input type="hidden" name="_layout" value="n">
			<table style="width: 100%;border:1px solid #B6B5DB;clear:both; margin-bottom: 5px;">
				<tr>
					<td>
						<tp:emoticon/>
						<input type="text" name="rep_text" id="rep_text" title="이곳에 글을 입력하여 주세요." style="width: 99%;" value="" valid="[['notempty'],['maxlen:300']]">
					</td>
					<td width="60"><a style="float:right;margin-left: 5px;" class="cc_bt"  href="#" onclick="save_reply()" style="margin-right: 10px;">저 장</a></td>
				</tr>
			</table>
		</form>
		
		
		<%//답글목록 %>
		<c:forEach var="row" items="${rset.reprows }">
			<table style="width: 100%;">
				<tr>
					<td width="130" >
						<b>${row.nick_name }(${row['USER_NM@dec@name'] })</b><br>
						${row['reg_dt@yyyy-MM-dd'] }
					</td><td class="rep_cont">
						<c:if test="${!fn:endsWith(row.rep_text, 'png') }">
							${row.rep_text }
						</c:if>
						<c:if test="${fn:endsWith(row.rep_text, 'png') }">
							<img class="emoticon" height="28" src="voj/images/re/${row.rep_text }">
						</c:if>
					</td><td width="20">
						<c:if test="${session.user_id==row.reg_id || session.myGroups[row.bd_cat]}">
							<a style="float:right;margin-left: 5px;" href="#" onclick="del_reply(${req.gal_id }, ${row.gal_rep_id })" style="margin-right: 10px;"><img title="삭제" src="images/icon/${session.user_id==row.reg_id ? 'Close-icon.png' : 'Actions-window-close-icon.png'}"></a>
						</c:if>
					</td>
				</tr>
			</table>
			<hr color="#cccccc" />
		</c:forEach>
	</div>
</div>
	