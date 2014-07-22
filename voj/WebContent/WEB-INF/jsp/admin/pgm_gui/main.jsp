<%@page import="net.ion.webapp.utils.IslimUtils"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Html에티터를 이용한 문서작성</title>
<link href="./css/contents.css" rel="stylesheet" type="text/css" />
<link href="./jquery/development-bundle/themes/redmond/jquery.ui.all.css" rel="stylesheet"  id="css" />
<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./jquery/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="./se/js/HuskyEZCreator.js" type="text/javascript"  charset="utf-8"></script>
<script src="./js/commonUtil.js"></script>
<script src="./js/formValid.js" type="text/javascript" ></script>
<style type="text/css">
.ui-datepicker {
    font-size: 12px;
}

</style>
<script type="text/javascript">

var oEditors = [];

$(function() {
	initEditor();
	$('#table_list').load('./devTL.sh?_ps=admin/pgm_gui/table_list');
});


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
			//예제 코드
			//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
		},
		fCreator: "createSEditor2"
	});
}
function loadSource(){
	oEditors.getById["ir1"].setContents('');
	
	var data = {
		type:'jsp',
		src_name:$('#src_name').val()
	};
	//jsp소스 읽기
	$('#jsp_div').load('./loadSrc.sh', data, function(){
		//alert(1);
		var val = $('#jsp_div').html().replaceAll('tpl','onclick');
		pasteHTML(val);		
		$('#jsp_div').html('');
		setPreViewUrl();
	});
	
	loadSql('#sql1_div','#sql1',$('#src_name').val()+'_list');
	loadSql('#sql2_div','#sql2',$('#src_name').val()+'_view');
	loadSql('#sql3_div','#sql3',$('#src_name').val()+'_update');
}
function loadSql(target,ctl,src_name){
	var data = {
		type:'sql',
		src_name:src_name
	};
	//sql소스 읽기
	$(target).load('./loadSrc.sh', data, function(){
		var val = $(target).html();
		$(ctl).text(val);
		//$(target).html('');
	});
}
function setPreViewUrl(){
	$('#pre_view_url').attr('href','at.sh?_ps=doc/'+$('#src_name').val());
}
function getColumns(tabeName){
	$('#table_columns').load('./devTCols.sh?table_name=' + tabeName);
	
}
function insert_column(id){
	pasteHTML($(id).html());
}
function pasteHTML(sHTML) {
	oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
}

function showHTML() {
	var sHTML = oEditors.getById["ir1"].getIR();
	alert(sHTML);
}
	

function setDefaultFont() {
	var sDefaultFont = '궁서';
	var nFontSize = 24;
	oEditors.getById["ir1"].setDefaultFont(sDefaultFont, nFontSize);
}

function form_submit(){	
	var form = $('#content_form');
	if(form.attr('isSubmit')==='true') return false;

	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
	var ed = $('#ir1');
	var val = ed.val().replaceAll('hasDatepicker', '').replaceAll('onclick', 'tpl');
	if(val.length>1900000){
		alert("1900000byte 이상은 저장할 수 없습니다. 현재byte:"+val.length);

		return false;
	}
	ed.val(val);
	//폼 정합성 체크
	var isSuccess = $.valedForm($('[valid]',form));
	if(!isSuccess) return false;			

	
	var formData =$(form).serializeArray();
	
	
	if($(form).attr('isSubmit')==='true') return false;
	$(form).attr('isSubmit',true);

	var url = 'saveSrc.sh';
	$.post(url, formData, function(response, textStatus, xhr){
		$(form).attr('isSubmit',false);

		var data = $.parseJSON(response);

		if(data.success){
			alert("저장되었습니다.");
		}else{
			alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
		}
	});
	return false;
}

//----------------------------------------------
//	이미지 바디에 넣기 시작
//----------------------------------------------
var oReq = new XMLHttpRequest();
oReq.open("GET", "images/log.png", true);
oReq.responseType = "arraybuffer";

oReq.onreadystatechange = function (oEvent) {

	var arrayBuffer = oReq.response; // Note: not oReq.responseText
	if (arrayBuffer) {
	    var string_with_bas64_image = _arrayBufferToBase64(arrayBuffer);
	    document.getElementById("img").src = "data:image/png;base64," + string_with_bas64_image;
	}
};

oReq.send(null);

function _arrayBufferToBase64( buffer ) {
  var binary = '';

  var bytes = new Uint8Array( buffer );
  var len = bytes.byteLength;
  for (var i = 0; i < len; i++) {
      binary += String.fromCharCode( bytes[ i ] );
  }
  return window.btoa( binary );
}

//----------------------------------------------
//이미지 바디에 넣기 끝
//----------------------------------------------
function fnsSet(pThis, pPos)
{
  var lThis;
  lThis = pThis;
  if(typeof pThis == "string") {
    lThis = document.getElementById(pThis);
  }
  if(lThis.setSelectionRange) {
    lThis.focus();
    lThis.setSelectionRange(pPos,pPos);
  } else if (lThis.createTextRange) {
    var range = lThis.createTextRange(); 
    range.collapse(true);
    range.moveEnd('character', pPos);
    range.moveStart('character', pPos); 
    range.select();
  }
}
/*   
$.fn.selectRange = function( start , end )
{
  return this.each(function(){

       if( this.setSelectionRange )
       {
           this.focus() ;
           this.setSelectionRange( start , end ) ;
       }
       else if(this.createTextRange)
       {
           var range = this.createTextRange() ;
           range.collapse( true ) ;
           range.moveEnd( '''character' , end ) ;
           range.moveStart( '''character' , start ) ;
           range.select() ;
       }
   }) ;
} ;
*/
//----------------------------------------------
//----------------------------------------------
$(function() {
	//속성창 변경시 콘트롤 속성변경
	$('.ctl_val').change(function(e,e2){
		var ctl = $(this);
		$('.tpl_colum').attr(ctl.attr('name'), ctl.val());
		setAttr($('.tpl_colum[type=text]'));
	});
	var option = {
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월' ],
		dayNamesMin: ["일","월","화","수","목","금","토"],
		dateFormat: 'yy-mm-dd',
		changeYear: true,
		changeMonth: false
	};
	$('.datepicker').datepicker(option);
	
	
	var opt = '';
	$.each($.valedFunction, function(key, value){
		var fnc = value + '';
		var val = fnc.substring(fnc.indexOf('//[')+2, fnc.indexOf(']')+1);
		val = val.indexOf('[')==0 ? val : "['" + key + "']";
		opt += '<option value="' + val + '">' + key + '</option>';
		//$('#_detail').append('<div class="func" id="' + key + '" style="display: none;"><pre>'+value+'</pre></div>');
	});
	
	$('#function').append(opt).click(function(event) {
		//$('.func' ).hide();
		var opt = $(event.target);
		var key = opt.text();
		var val = opt.val();
		$('textarea[name=valid]').val('['+$(this).val()+']');
		
		//$('#key').text(key);
		//$('#value').text(val);
		//$('#'+key).show();
	});
});
//컬럼 선택시 콘트롤과 속성창을 선택된 컬럼으로 설정한다.
function setColumn(clolName){
	var cName = clolName.toLowerCase();
	setColumnAttr(cName,clolName,clolName,'');
}
function setColumnAttr(name, title, placeholder,valid){
	//콘트롤 속성변경
	var col = $('.tpl_colum');
	col.attr('name', name);
	col.attr('title', title);
	col.attr('placeholder', placeholder);
	col.attr('valid', valid);
	//속성창 값 변경
	$('.ctl_val[name=name]').val(name);
	$('.ctl_val[name=valid]').val(valid);
	$('.ctl_val[name=title]').val(title);
	$('.ctl_val[name=placeholder]').val(placeholder);
	//콘트롤 로드
	$('.tpl_code').load('at.sh',{_ps:'admin/pgm_gui/tpl_ctl_code',name:name,group_id:name,title:title,attr:"onclick='window.top.setAttr(this);'"});
}
//콘트롤 클릭시 호출됨
function setAttr(ctl){
	ctl = $(ctl);
	setColumnAttr(ctl.attr('name'),ctl.attr('title'),ctl.attr('placeholder'), ctl.attr('valid'));
	
}
</script>
</head>
<body id="body"style="padding: 3px;">

<div>
	<table>
		<tr>
			<td>
				<img id="img" width="100"/>
			</td>
			<td>
				<div style="padding-left: 10px;">
					<b>IE11에서 최적화 됨</b>
					<div style="height : 30px;">JSP소스경로 : <%=IslimUtils.processInitialization.getViewResolverFullPath()%></div>
					<div style="clear: both;float: left;">소스 아이디 : doc/</div>
					<input type="text" id="src_name" name="src_name" value=""  valid="['notempty']" onchange="loadSource()"  style="float: left;"/>
					<input type="text" id="view_name1" name="view_name1" value="" style="float: left;display: none;"/>
					<a id="pre_view_url" href="#" target="_blank"  style="float: left;">미리보기</a>
				</div>
			</td>
		</tr>
	</table>
</div>
	
<div style="clear: both;float: left;width: 800px;">
	<table style="height: 800px;margin-top: 2px;" class="ui-widget ui-widget-content contents-contain">
		<tr style="height: 400px;">
			<td valign="top" style="border: 1px solid #cccccc;">
				<div class="ui-state-default" style="padding: 3px;">테이블</div>
				<div id="table_list" style="height: 150px;font-size: 10px;margin-top:2px; overflow-y: auto;; overflow-x:hidden; auto;border: 1px solid #cccccc;"></div>
				<div class="ui-state-default" style="padding: 3px;margin-top:4px;">컬럼</div>
				<div id="table_columns" style="height: 300px;font-size: 10px;margin-top:2px; overflow: auto;border: 1px solid #cccccc;"></div>
			</td>
			<td valign="top" style="border: 1px solid #cccccc;">
				<table class="ui-widget ui-widget-content contents-contain" style="margin: 0;">
					<tr class="ui-state-default">
						<th colspan="2" style="padding: 3px;">콘트롤</th>
					</tr>
					<tr class="ui-state-default">
						<th width="40%" style="padding: 3px;">속성</th>
						<th width="60%" style="padding: 3px;">값</th>
					</tr>
					<tr><td style="padding: 3px;">
							<input type="text" class="ctl_attr" value="name" readonly="readonly" style="width: 97%;" />
						</td><td style="padding: 3px;">
							<input type="text" class="ctl_val" name="name"  value=""  style="width: 97%;"/>
					</td></tr>
					<tr><td style="padding: 3px;">
							<input type="text" class="ctl_attr" value="valid" readonly="readonly"  style="width: 97%;"/>
						</td><td style="padding: 3px;">
							<textarea class="ctl_val" name="valid"  value="" style="width: 97%;height: 50px;" ></textarea>
						</td></tr>
					<tr><td style="padding: 3px;">
							<input type="text" class="ctl_attr" value="title" readonly="readonly"  style="width: 97%;"/>
						</td><td style="padding: 3px;">
							<input type="text" class="ctl_val" name="title"  value=""  style="width: 97%;"/>
					</td></tr>
					<tr><td style="padding: 3px;">
							<input type="text" class="ctl_attr" value="placeholder" readonly="readonly"  style="width: 97%;" />
						</td><td style="padding: 3px;">
							<input type="text" class="ctl_val" name="placeholder"  value=""  style="width: 97%;" />
					</td></tr>
				</table>
				
				<select  id="function" multiple="multiple" style="height: 200px; width: 100%" ></select>
			</td>
			<td valign="top"  style="border: 1px solid #cccccc;">
				<table class="ui-widget ui-widget-content contents-contain" style="margin: 0;">
					<tr class="ui-state-default">
						<th style="padding: 3px;">콘트롤</th>
						<th style="padding: 3px;">추가</th>
					</tr>
					<tr>
						<td style="padding: 3px;">
							<span id="input_text"><input type="text" class="tpl_colum" onclick="window.top.setAttr(this);" /></span>
						</td><td width="50px;" style="padding: 3px;text-align: center;">
							<a href="#" onclick="insert_column('#input_text')"><img src="images/icon/actions-go-next-view-icon.png" border="0"></a>
						</td>
					</tr>
					<tr>
						<td style="padding: 3px;">
							<span id="textarea"><textarea class="tpl_colum" onclick="window.top.setAttr(this);" ></textarea></span>
						</td><td style="padding: 3px;text-align: center;">
							<a href="#" onclick="insert_column('#textarea')"><img src="images/icon/actions-go-next-view-icon.png" border="0"></a>
						</td>
					</tr>
					<tr>
						<td style="padding: 3px;">
							<span id="input_date"><input type="text" class="tpl_colum datepicker" onclick="window.top.setAttr(this);"/></span>
						</td><td style="padding: 3px;text-align: center;">
							<a href="#" onclick="insert_column('#input_date')"><img src="images/icon/actions-go-next-view-icon.png" border="0"></a>
						</td>
					</tr>
					<tr>
						<td style="padding: 3px;">
							<span id="select" class="tpl_code"></span>
						</td><td style="padding: 3px;text-align: center;">
							<a href="#" onclick="insert_column('#select')"><img src="images/icon/actions-go-next-view-icon.png" border="0"></a>
						</td>
					</tr>
				</table>
			
			</td>
		</tr>
		<tr style="height: 400px;vertical-align: top;">
			<td colspan="3" style="border: 1px solid #cccccc;">
				<%//=IslimUtils.processInitialization.getQueryFullPath()%>
				<table class="ui-widget ui-widget-content contents-contain" style="margin: 0;">
					<tr>
						<th width="30px;" class="ui-state-default">목록</th>
						<td style="padding: 3px;">
							<textarea id="sql1" name="sql1" style="width: 99%;height: 60px;" ></textarea>
						</td>
					</tr>
					<tr>
						<th class="ui-state-default">조회</th>
						<td style="padding: 3px;">
							<textarea id="sql2" name="sql2" style="width: 99%;height: 60px;" ></textarea>
						</td>
					</tr>
					<tr>
						<th class="ui-state-default">수정</th>
						<td style="padding: 3px;">
							<textarea id="sql3" name="sql3" style="width: 99%;height: 130px;" ></textarea>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>

<div style="float: left; width:800px;margin:3px;">
	<form id="content_form" action="sample.php" method="post">
		<textarea name="ir1" id="ir1" rows="10" cols="100" style="width:796px; height:412px; display:none;"></textarea>
	</form>
	<p>
		<button onclick="form_submit();" style="float: right;">저 장</button>
		<!-- <input type="button" onclick="pasteHTML();" value="본문에 내용 넣기" />
		<input type="button" onclick="showHTML();" value="본문 내용 가져오기" /> 
		<input type="button" onclick="setDefaultFont();" value="기본 폰트 지정하기 (궁서_24)" />-->
	</p>
</div>

<div id="jsp_div" style="display: none;"></div>
<div id="sql1_div" style="display: none;"></div>
<div id="sql2_div" style="display: none;"></div>
<div id="sql3_div" style="display: none;"></div>

</body>
</html>