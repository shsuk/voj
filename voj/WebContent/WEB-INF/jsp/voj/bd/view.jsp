<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<c:choose >
	<c:when test="${req.action=='dd'}">
		<uf:organism noException="true">[
			<job:requestEnc id="reuestEnc" aes256="pw" />
			<job:db id="row" query="voj/bd/delete"/>
		]</uf:organism>	
		<c:set var="JSON" scope="request" value="${JSON }"/>
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='ad'}">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/bd/delete_attach"/>
		]</uf:organism>	
		
		<jsp:forward page="../action_return.jsp"  />
	</c:when>
	<c:when test="${req.action=='i' && session.user_id!='guest'}">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/bd/insert_rep"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='u' && session.user_id!='guest'}">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/bd/update_rep"/>
		]</uf:organism>
	</c:when>
	<c:when test="${req.action=='d' }">
		<uf:organism noException="true">[
			<job:db id="row" query="voj/bd/delete_rep"/>
		]</uf:organism>	
	</c:when>
</c:choose>

<uf:organism >
[
	<job:requestEnc id="reuestEnc" aes256="pw" />
	<job:db id="rset" query="voj/bd/view" />
]
</uf:organism>
<c:set var="row" value="${rset.row }"/>
<script type="text/javascript">
	
	$(function() {
		<c:if test="${empty(row)}">
			alert('존재하지 않는 글이거나 패스워드가 불일치 합니다.');
			goPage(${req.pageNo});
			return;
		</c:if>
		
		<c:if test="${row.bd_cat== 'cafe'}">
	    	$('.prev_item').show();
	    	$('.next_item').show();
	    	
		    if('${rset.prev.bd_id }'==''){
		    	$('.prev_item').hide();
		    }
		    if('${rset.next.bd_id }'==''){
		    	$('.next_item').hide();
		    }
		   
		    $('.prev_item').attr('bd_id', '${rset.prev.bd_id }');
		    $('.next_item').attr('bd_id', '${rset.next.bd_id }');
	    </c:if>
	    
	    showAutoItemNevi();
			    
		init_load();
		
		changeEmoticon();
	    
	});
	
	function body_print(){
		alert('인쇄후 페이지를 새로고침 하세요.');
		var bd_contents = $('#bd_contents');
		$('body').html('');
		$('body').append(bd_contents);
		
		window.print();
	}
	//----------------------------------------
	function del(bd_id,bd_cat,isPw){
		if(!confirm("정말로 삭제하시겠습니까?")){
			return;
		}
		var target_layer = $('.bd_body');
		
		var url = 'at.sh';
		var data = {
				_ps:'voj/bd/view', 
				bd_id: bd_id,
				bd_cat: bd_cat,
				action:'dd', 
				_layout: 'n', 
				pageNo: $('#pageNo').val()
			};
		
		if(isPw && '${session.myGroups[row.bd_cat]}'!='true'){
			readPw(target_layer,url,data, function (){
				goPage(1);
			});
		}else{
			show(target_layer, url, data, true, function (){
				goPage(1);
			});
		}
		
	}
	function hideImg(){
		$('#img_viewer').dialog( "close" );
	}
	function showImg(id, src){
		if(id=='' || id==null){
			return;
		}
		
		var img_viewer = $('#img_viewer');
		
		if(img_viewer.length<1){
			$('body').append($('<div id="img_viewer" style="padding: 5px;z-index: 999;cursor: pointer;display:none; border: 1px solid #aaaaaa;background-color: #B2CCFF;"><img id="viewer_img" width="${isMobile ? 400 : 700}" style=" border: 1px solid #ffffff;" src="" onclick="hideImg();"/></div>'));
			img_viewer = $('#img_viewer');
		}
		$('#viewer_img').attr('src', src);
		setTimeout(function(){
			$('#viewer_img').attr('src',"at.sh?_ps=at/upload/dl${isMobile ? '&thum=500' : ''}&file_id="+id);
		}, 500);
		//var isOpen = false;
		try {
			isOpen = img_viewer.dialog( "isOpen" );
		} catch (e) {
			// TODO: handle exception
		}

		//if(isOpen===true) return;

		img_viewer.dialog({
			autoOpen: true,
			minHeight:300,
			height: 'auto',
			width: 'auto',
			modal: false,
			show: "blind",
			hide: "explode"
		});
	}
	
</script>

<div style="${row.bd_cat=='ser' && !isMobile ? 'width:700px;margin-left:120px;' : 'width:100%;'}">
	<table style="width:100%"><tr ><td>
		<div style="float:left;"><b>제목 : <font color="#0000C9">${row.title }</font></b></div>
		<div style="float:right;">
			<c:forEach var="item" items="${rset.attrows }">
				<a href="at.sh?_ps=at/upload/dl&file_id=${item.file_id }" target="_blank"><img  src="../voj/images/attach.png">${uf:fileName(item.file_id) }</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</c:forEach>
			${isMobile ? '<br>' : ''}
			<b>작성자 :</b> ${row.reg_nickname }(${row['USER_NM@dec@name'] })&nbsp;&nbsp;&nbsp;&nbsp;
			${isMobile ? '<br>' : ''}
			<b>작성일 :</b> ${row['reg_dt@yyyy-MM-dd HH:mm:ss'] }&nbsp;&nbsp;&nbsp;&nbsp;
			${isMobile ? '<br>' : ''}
			<b>조회수 :</b> ${row.view_count }
		</div>
	</td></tr></table>
	<%//본문 %>
	<div id="bd_contents" style="${row.bd_cat=='ser' && !isMobile ? 'width:700px;' : 'width:100%;'} clear:both;border:1px solid #B6B5DB; min-height: 500px;margin-bottom: 5px;overflow: auto;">
		<div style="padding: 5px;">
			<c:if test="${ row.bd_cat!='ser' }">
				<c:forEach var="item" items="${rset.attrows }">
					<c:set var="file_ext" value="${ item.file_ext }"/>
					<c:if test="${ file_ext=='jpg' || file_ext=='jpeg' }">
						<tp:img file_id="${item.file_id}" thum="180" style="cursor:pointer; float: left;margin-bottom:: 5px;margin-right :10px;" attr="onclick=\"showImg('${item.file_id }', this.src);\"" />
					</c:if>
				</c:forEach>
			</c:if>
			${row['CONTENTS@dec'] }
		</div>
	</div>
	<div id="bd_bt">
		<%//답글목록 %>
		<c:forEach var="item" items="${rset.reprows }">
			<c:set var="re"></c:set>
			<c:set var="re_style"></c:set>
			<c:if test="${item.rep_id != item.upper_rep_id }">
				<c:set var="re">&nbsp;<b>re)</b></c:set>
				<c:set var="re_style">style="background:#F6F6F6;"</c:set>
			</c:if>
			<table class="bd">
				<tr  ${re_style }>
					<td>
						${re }
						<div class="rep_cont" style="vertical-align: middle;" id="re_${item.rep_id}">
							<c:if test="${!fn:endsWith(item.rep_text, 'png') }">
								${item.rep_text }
							</c:if>
							<c:if test="${fn:endsWith(item.rep_text, 'png') }">
								<img class="emoticon" height="28"  src="voj/images/re/${item.rep_text }">
							</c:if>
						</div>
					</td><td width="${isMobile ? '80' : '160' }" >
						<c:set var="user_nm">(${item['USER_NM@dec@name'] })</c:set>
						<b>${item.nick_name }${isMobile ? '' : user_nm }</b><br>
						${item['reg_dt@yyyy-MM-dd'] }
					</td><td width="40">
						<c:if test="${session.user_id==item.reg_id || session.myGroups[item.bd_cat]}">
							<img title="수정" onclick="edit_reply(${item.rep_id})" class="link" border="0" src="images/icon/edit-file-icon.png">
							<img title="삭제" onclick="del_reply(${req.bd_id },${item.rep_id})" class="link" border="0" src="images/icon/Close-icon.png">
						</c:if>
						<c:if test="${item.rep_id == item.upper_rep_id && session.user_id != 'guest'}">
							<img title="댓글 달기" onclick="reReply(${item.rep_id})" class="link" border="0" src="images/icon/reply-icon.png">
						</c:if>
					</td>
				</tr>
			</table>
		</c:forEach>
		<%//답글 작성 %>
		<c:if test="${session.user_id=='guest' }">
			<table  class="bd"><tr class="ui-state-default">
					<td width="60" align="right"><a href="at.sh?_ps=voj/login/login_form">로그인</a> 후 글을 작성하세요.</td>
			</tr></table>
		</c:if>
		
		<div id="reply_comtents" style=" ${session.user_id=='guest' ? 'display:none;' : ''}">
			<table id="reply" class="bd">
				<tr>
					<td>
						<form id="reply_form" action="sample.php" method="post" onsubmit="return false;">
							<input type="hidden" name="_ps" value="${req._ps }">
							<input type="hidden" name="bd_id" value="${req.bd_id }">
							<input type="hidden" id="rep_id" name="rep_id" value="0">
							<input type="hidden" id="upper_rep_id" name="upper_rep_id" value="0">
							<input type="hidden" id="action" name="action" value="i">
							<tp:emoticon/>
							<textarea name="rep_text" id="rep_text" style="width: 100%;" title="이곳에 글을 남겨 주세요."   value="" valid="[['notempty']]"></textarea>
						</form>
					</td>
					<td width="60"><a style="float:right;margin-left: 5px;" class="cc_bt"  href="#" onclick="save_reply()" style="margin-right: 10px;">댓글 저장</a></td>
				</tr>
			</table>
		</div>
		
		<%//버튼 %>
		<a style="float:right;margin-left: 5px;"  class="cc_bt" href="#" onclick="goPage(${req.pageNo})">목 록</a>
		<c:if test="${(row.reg_id!='guest' && row.reg_id==session.user_id) || row.reg_id=='guest' }">
			<a style="float:right;margin-left: 5px;" class="cc_bt"  href="#" onclick="edit(${req.bd_id},${row.reg_id=='guest' })" style="margin-right: 10px;">수 정</a>
		</c:if>
		<c:if test="${(row.reg_id!='guest' && row.reg_id==session.user_id) || row.reg_id=='guest' || session.myGroups[row.bd_cat]}">
			<a style="float:right;margin-left: 5px;" class="${session.myGroups[row.bd_cat] && viewAdminButton ? 'cc_bt' : 'cc_bt'}" href="#" onclick="del(${req.bd_id },'${row.bd_cat}',${row.reg_id=='guest' })" style="margin-right: 10px;" >삭 제</a>
		</c:if>
		<c:if test="${row.bd_cat=='ser'}">
			<a style="float:right;margin-left: 5px;" class="cc_bt" href="#" onclick="body_print()">본문인쇄</a>
		</c:if>
		<br><br>
	</div>
	<div id="re_mask" style="position: fixed; z-index:1000; top:0px; left:0px; width:100%; height:100%; background: #eeeeee;border:1px solid #C0C0C0;display: none; opacity: .3;filter: Alpha(Opacity=30);">
	</div>
	<div id="re_reply" style="position: fixed; z-index:1100; top:100px; left:${isMobile ? '0' : '100'}px; background: #eeeeee;border:1px solid #C0C0C0;display: none;">
		<span style="float: left; ;margin:4px;font-size: 14px;"><b id="re_tilte"></b></span>
		<img class="link" onclick="colseReReply()" style="float:right;margin:4px;" src="images/icon/Close-2-icon.png">
		<div id="re_reply_comtents" style="clear: both;"></div>
	</div>
</div>
