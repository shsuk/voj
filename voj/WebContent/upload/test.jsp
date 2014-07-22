<%@page import="net.ion.webapp.fleupload.Upload"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("fileId", Upload.getfileId());
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>파일업로드</title>
<script src="../jquery/js/jquery-1.9.1.min.js"></script>
</head>

<script type="text/javascript">
	$(function($){		
	    var dropzone1 = document.getElementById('upload_file');
	    setDnDhandler(dropzone1);
	});
	
     
    function setDnDhandler(obj) {
        obj.addEventListener("dragover", function(event) {
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
                element.id = 'f' + i;
                document.body.appendChild(element);
                sendFile(allTheFiles[i], element.id);
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
<body>
	<div id="upload_file" style="width: 100%;height: 200px; border:1px solid #B6B5DB;  ">
	이곳에 파일을 끌어 놓으세요.
	</div>
 
</body>
</html>