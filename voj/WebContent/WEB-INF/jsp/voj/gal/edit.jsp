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
	<job:db id="rset" query="voj/gal/view" />
]
</uf:organism>

<c:set var="row" value="${rset.row }"/>

<script src="./se/js/HuskyEZCreator.js" type="text/javascript"  charset="utf-8"></script>
<script type="text/javascript">
	
	$(function() {
		//$('#img_file_list').show();
		//var dropzone1 = document.getElementById('img_file');
		//setDnDhandler(dropzone1);

	});
	var idx = 0;
	
    function setDnDhandler(obj) {
        obj.addEventListener("dragover", function(event) {
        	$('#img_file_ctl').hide();
        	$('#img_file_list').css('height','300px');
	    	$( obj ).css('background-color', '#cccccc');
        	event.preventDefault();
        }, true);
        obj.addEventListener("dragleave", function(event) {
	    	$( obj ).css('background-color', '#ffffff');
        	event.preventDefault();
        }, true);
        obj.addEventListener("drop", function(event) {
	    	$( obj ).css('background-color', '#ffffff');
            event.preventDefault();
            var allTheFiles = event.dataTransfer.files;
            for (var i=0; i<allTheFiles.length; i++) {
                var element = document.createElement('div');
                element.id = 'f' + idx;
                document.getElementById('img_file_list').appendChild(element);
                sendFile(allTheFiles[i], element.id);
                idx++;
            }
        }, true);
    }
    function sendFile(file, fileId) {
        var xhr = new XMLHttpRequest();
         
        xhr.upload.addEventListener("progress", function(e) {
               if (e.lengthComputable) {
                    var percentage = Math.round((e.loaded * 100) / e.total);
                    document.getElementById(fileId).innerHTML = file.name + ' - ' + percentage + '%';
                }
            }, false);
        xhr.onreadystatechange = function() { 
            if (xhr.readyState == 4 && xhr.status == 200) {
                //alert(xhr.responseText);
            }
        };
        xhr.upload.addEventListener("load", function(e){
                document.getElementById(fileId).innerHTML = file.name + ' - 전송완료';
            }, false);
     xhr.open("POST", "test_upload.jsp");
        var fd = new FormData();
        fd.append(guid(), file);
        xhr.send(fd);
    }
    var guid = (function() {
    	  function s4() {
    	    return Math.floor((1 + Math.random()) * 0x10000)
    	               .toString(16)
    	               .substring(1);
    	  }
    	  return function() {
    	    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
    	           s4() + '-' + s4() + s4() + s4();
    	  };
	})();
</script>

<div  id="body_main">
	
	<div style="width:100%;margin-top: 40px;margin-bottom: 40px;">
		${HEADER }
	</div>

	<div class="bd_body">
		사진을 zip으로 묶어 한번에 올릴 수 있습니다.
		<form id="content_form" action="at.sh" method="post" enctype="multipart/form-data" style="clear: both;">
			<input type="hidden" name="action" value="${empty(req.gal_id) ? 'i' : 'u' }">
			<input type="hidden" name="_ps" value="voj/gal/edit_action">
			<input type="hidden" name="gal_id" value="${req.gal_id }">
			<input type="hidden" name="bd_cat" value="${req.bd_cat }">
			<input type="hidden" name="pageNo" value="${req.pageNo }">
			<table style="width: 100%;border:1px solid #B6B5DB;color:#002266;margin-bottom: 5px;">
				<tr>
					<th width="55">제 목 : </th>
					<td>
						<input type="text" name="title" id="title" title="제목" style="width: 95%;" value="${row.title }" valid="[['notempty'],['maxlen:50']]">
					</td>
				</tr>
				<c:set var="end_idx" value="15"/>
				<c:if test="${req.bd_cat=='img'}">
					<c:set var="end_idx" value="1"/>
					<tr>
						<th width="200">링크URL:</th>
						<td><input type="text" name="link_url" id="link_url" title="링크URL" style="width: 95%;" value="${row.link_url }" valid="[]"></td>
					</tr>
					<c:if test="${empty(req.gal_id)}">
						<tr>
							<th width="200">이미지 아이디:</th>
							<td><input type="text" name="img_id" id="img_id" title="이미지 아이디" style="width: 95%;" value="${row.img_id }" valid="[['notempty']]"></td>
						</tr>
						<tr>
							<th width="200">게시기간:</th>
							<td>
								<input type="text" name="start_date" id="start_date" value="${row.start_date }"  class="datepicker" readonly="readonly" title="시작일" style="width: 100px;" valid="[['notempty'],['maxlen:50']]"> ~
								<input type="text" name="end_date" id="end_date" value="${row.end_date }"  class="datepicker" readonly="readonly" title="만료일" style="width: 100px;" valid="[['notempty'],['maxlen:50']]">
							</td>
						</tr>
					</c:if>
				</c:if>
			</table>
			<c:if test="${empty(req.gal_id)}">
				<div id="img_file">
					<div id="img_file_ctl">
						<c:forEach begin="1" end="${end_idx }" >
							<input type="file" class="pic_file" name="pic_file" valid="[['ext:jpg,jpeg,gif,zip']]" style="width: 300px;margin: 2px;">
						</c:forEach>
					
					</div>
					<div id="img_file_list" " style="display: none;">
						<font color="#0000ff">사진을 파일을 끌어 놓으세요.</font> 
					</div>
				</div>
			</c:if>
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
</div>
	