<%@ page contentType="text/html; charset=utf-8"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 

<uf:organism >
[
	<job:db id="row" query="voj/vod/edit" singleRow="true"/>
]
</uf:organism>

<script src="./se/js/HuskyEZCreator.js" type="text/javascript"  charset="utf-8"></script>
<script type="text/javascript">
var oEditors = [];
	
	$(function() {

	    init_load();
		initEditor();
	});
	
	//에디터 소스 시작
	function initEditor() {
		// 추가 글꼴 목록
		//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
	
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "ir1",
			sSkinURI: "se/SmartEditor2Skin.html",	
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
				fOnBeforeUnload : function(){
					//alert("완료!");
				}
			}, //boolean
			fOnAppLoad : function(){
				//에디터 로딩이 완료된 후에 본문에 삽입
				oEditors.getById["ir1"].exec("PASTE_HTML", [$('#_contemts').html()]);
			},
			fCreator: "createSEditor2"
		});
	}

	//에디터 소스 끝
	
</script>

<div  id="body_main">
	
	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		${HEADER }
	</div>

	<form id="content_form" action="at.sh"  method="post" enctype="multipart/form-data"  style="clear: both;">
		<input type="hidden" name="action" value="${empty(req.vod_id) ? 'i' : 'u' }">
		<input type="hidden" name="_ps" value="voj/vod/edit_action">
		<input type="hidden" name="vod_id" value="${req.vod_id }">
		<input type="hidden" name="bd_cat" value="${req.bd_cat }">
		<table class="bd" style="width: 100%;border:1px solid #B6B5DB;color:#002266;margin-bottom: 5px;">
			<c:if test="${req.bd_cat=='sun' }">
				<tr>
					<th width="130" >제 목 :</th>
					<td><input type="text" name="title" id="title" title="제목" style="width: 95%;" value="${row.title }" valid="[['notempty'],['maxlen:50']]"></td>
				</tr>
				<tr>
					<th >설교자 :</th>
					<td><input type="text" name="preacher" id="preacher" title="설교자" style="width: 100px;" value="${row.preacher }" valid="[['maxlen:30']]"></td>
				</tr>
				<tr>
					<th >선포일 :</th>
					<td><input type="text" class="datepicker" name="wk_dt" id="wk_dt" title="날 짜" style="width: 100px;" readonly="readonly" value="${row['wk_dt@yyyy-MM-dd'] }" valid="[['maxlen:10']]"></td>
				</tr>
				<tr>
					<th>영상 아이디 :</th>
					<td><input type="text" name="contents_id" id="contents_id" title="영상아이디" style="width: 300px;" value="${row.contents_id }" valid="[['notempty'],['maxlen:20']]"></td>
				</tr>
				<tr>
					<th>영상 이미지 :</th>
					<td>
						<input type="file" name="file_id" title="영상 이미지" style="width: 300px;"  valid="[${empty(req.vod_id) ? "['notempty']," : '' }['ext:gif,gpg,jpg,jpeg,png']]">
					</td>
				</tr>
				<tr>
					<th>성경본문 :</th>
					<td><input type="text"  name="bible" id="bible" title="말 씀" style="width: 95%;" value="${row.bible }" valid="[['maxlen:100']]"></td>
				</tr>
			</c:if>
			<c:if test="${req.bd_cat!='sun' && req.bd_cat!='newfam' }">
				<tr>
					<th width="130" >제 목 :</th>
					<td><input type="text" name="title" id="title" title="제목" style="width: 95%;" value="${row.title }" valid="[['notempty'],['maxlen:50']]"></td>
				</tr>
				<tr>
					<th >날 짜 :</th>
					<td><input type="text" class="datepicker" name="wk_dt" id="wk_dt" title="날 짜" style="width: 100px;" readonly="readonly" value="${row['wk_dt@yyyy-MM-dd'] }" valid="[['maxlen:10']]"></td>
				</tr>
				<tr>
					<th>영상 아이디 :</th>
					<td><input type="text" name="contents_id" id="contents_id" title="영상아이디" style="width: 300px;" value="${row.contents_id }" valid="[['notempty'],['maxlen:20']]"></td>
				</tr>
				<tr>
					<th>영상 이미지 :</th>
					<td>
						<input type="file" name="file_id" title="영상 이미지" style="width: 300px;"  valid="[${empty(req.vod_id) ? "['notempty']," : '' }['ext:gif,gpg,jpg,jpeg,png']]">
					</td>
				</tr>
			</c:if>
			<c:if test="${req.bd_cat=='newfam' }">
				<tr>
					<th width="130" >새신자 :</th>
					<td><input type="text" name="title" id="title" title="제목" style="width: 95%;" value="${row.title }" valid="[['notempty'],['maxlen:50']]"></td>
				</tr>
				<tr>
					<th >등록일 :</th>
					<td><input type="text" class="datepicker" name="wk_dt" id="wk_dt" title="등록일" style="width: 100px;" readonly="readonly" value="${row['wk_dt@yyyy-MM-dd'] }" valid="[['maxlen:10']]"></td>
				</tr>
				<tr>
					<th >인도자 :</th>
					<td><input type="text" name="preacher" id="preacher" title="인도자" style="width: 100px;" value="${row.preacher }" valid="[['maxlen:30']]"></td>
				</tr>
				<tr>
					<th>사 진 :</th>
					<td>
						<input type="file" name="file_id" title="영상 이미지" style="width: 300px;"  valid="[['ext:gif,jpg,jpeg,png']]">
					</td>
				</tr>
			</c:if>
			<tr>
				<th >내 용 :</th>
				<td>		
					<textarea name="ir1" id="ir1" title="내용" rows="10" cols="100" style="width:100%; height:300px; display:none;" valid="[['notempty'],['maxlen:1900000']]"></textarea>
				</td>
			</tr>
		</table>
	</form>
	<p>

	<table style="width: 100%">
		<tr>
			<td width="250"></td>
			<td></td>
			<td width="250">
				<a href="#" class="cc_bt" onclick="goPage(${req.pageNo})" style="float: right;margin-left: 10px;">목 록</a>
				<a href="#" class="cc_bt" onclick="form_submit();" style="float: right;">저 장</a>
			</td>
		</tr>
	</table>
	
	<div id="_contemts" style="display: none;">${row['CONTENTS@dec'] }</div>
	
</div>
	