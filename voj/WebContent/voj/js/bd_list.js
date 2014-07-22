	var bd_cat = '';
	var bd_key = '';
	var PAGENO = 1;
	
	function search(){
		//폼 정합성 체크
		
		goPage(0);
		
		return false;
	}
	
	function goPage(pageNo){
		PAGENO = pageNo;
		
		var form = $('form[name=main_form]');
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {
				_layout:'n', 
				bd_cat: bd_cat,
				bd_key: bd_key,
				_ps: 'voj/bd/list'
				
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
		var target_layer = $('.bd_body');
		
		bd_key1 = $(div).attr('bd_key');
		
		if(bd_key1 != ''){
			bd_key = bd_key1;
		}
		var url = 'at.sh';
		var data = {
				_ps: 'voj/bd/view',
				bd_id: $(div).attr('bd_id'),
				bd_key: bd_key,  
				_layout: 'n',
				pageNo:	$('#pageNo').val()
		};

		if($(div).attr('value')=='Y'){
			readPw(target_layer,url,data);
		}else{
			show(target_layer, url, data);
		}
	}

	function edit(bd_id,isPw, bd_key){
		var target_layer = $('.bd_body');
		
		var url = 'at.sh';
		var data = {
			_ps:'voj/bd/edit', 
			bd_id: bd_id,  
			bd_cat:bd_cat, 
			bd_key: bd_key,  
			_layout: 'n', 
			pageNo: $('#pageNo').val()
		};
		
		if(isPw){
			readPw(target_layer,url,data);
		}else{
			show(target_layer, url, data);
		}
		
	}
	
	function readPw(target_layer,url,data, calback){
		var box = $('#dialog-message');

		if(box.length<1){
			$('body').append($('<div id="dialog-message"><b>비밀번호를 입력하세요.</b><br><br><input type="password" id="bd_pw" name="bd_pw" value=""></div>'));
			box = $('#dialog-message');
		}

		box.dialog({
			modal: true,
			title:'비밀번호',
			buttons: {
				Ok: function() {
					var bd_pw = $('#bd_pw');
					var pw = bd_pw.val().trim();
					
					if(pw==""){
						alert('패스워드를 입력하세요.');
						return;
					}
					data['pw'] = pw;
					bd_pw.val('');
					show(target_layer, url, data, true, calback);
					$( this ).dialog( "close" );
				}, Cancel: function() {
					$( this ).dialog( "close" );
				}
			}
		});
	}
	function save_reply(){	
		var form = $('#reply_form');

		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			
		
		
		var target_layer = $('.bd_body');
		var url = 'at.sh';
		var formData =$(form).serializeArray();
		
		show(target_layer, url, formData);
	}
	
	function del_reply(bd_id, rep_id){
		if(!confirm("연결된 댓글이 있는 경우 같이 삭제됩니다.\n정말로 삭제하시겠습니까?")){
			return;
		}
		var target_layer = $('.bd_body');
		
		var url = 'at.sh';
		var data = {
				action: 'd',
				_ps: 'voj/bd/view',
				bd_id: bd_id,
				rep_id: rep_id,
				_layout: 'n',
				pageNo:	$('#pageNo').val()
		};

		show(target_layer, url, data);
	}
	function del_attach(bd_id, file_id){
		if(!confirm("첨부파일이 삭제됩니다.\n정말로 삭제하시겠습니까?")){
			return;
		}
		var url = 'at.sh';
		var data = {
				action: 'ad',
				_ps: 'voj/bd/view',
				bd_id: bd_id,
				file_id: file_id
		};

		$('#'+file_id).load(url, data);
	}
	
	function form_submit2(isGuest){	
		var form = $('#content_form');
		if(form.attr('isSubmit')==='true') return false;

		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
		var ir = $('#ir1');
		var val = ir.val();
		
		
		if(val=='<br>'){
			ir.val('');
		}else{
			val = val.replaceAll(' lang="EN-US"', '')
					.replaceAll('style="font-family:함초롬바탕;mso-font-width:100%;letter-spacing:0pt;mso-text-raise:0pt;"', '')
					.replaceAll('mso-fareast-font-family:함초롬바탕;', '')
					.replaceAll('font-family:함초롬바탕;','');
			ir.val(val);
		};
		
		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			

		if(isGuest){
			if($('#security:checked').length>0 && $('#pw').val()==''){
				alert('로그인 없이 비밀글을 작성할 때에는 비밀번호가 필요합니다.');
				return false;
			}
		}
		
		if(bd_key){
			$('#bd_key').val(bd_key);
		}
		var formData =$(form).serializeArray();
		
		
		if($(form).attr('isSubmit')==='true') return false;
		$(form).attr('isSubmit',true);

		var url = 'at.sh';
		$.post(url, formData, function(response, textStatus, xhr){
			$(form).attr('isSubmit',false);

			var data = $.parseJSON(response);
			//checkFunction(data);
			if(data.success){
				if(data.row[0]==0){
					alert("비밀번호가 틀리거나 본인의 글이 아닙니다.");
					return false;
				}
			}else{
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
			}
			goPage(PAGENO);
		});
		return false;
	}
	
	
	
	function form_submit1(isGuest){

		var form = $('#content_form');
		if(form.attr('isSubmit')==='true') return false;

		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
		var ir = $('#ir1');
		var val = ir.val();
		

		if(val=='<br>'){
			ir.val('');
		}else{
			val = val.replaceAll(' lang="EN-US"', '')
					.replaceAll('style="font-family:함초롬바탕;mso-font-width:100%;letter-spacing:0pt;mso-text-raise:0pt;"', '')
					.replaceAll('mso-fareast-font-family:함초롬바탕;', '')
					.replaceAll('font-family:함초롬바탕;','');
			ir.val(val);
		};
		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			

		if(isGuest){
			if($('#security:checked').length>0 && $('#pw').val()==''){
				alert('로그인 없이 비밀글을 작성할 때에는 비밀번호가 필요합니다.');
				return false;
			}
		}
		
		if(bd_key){
			$('#bd_key').val(bd_key);
		}
		
		if($(form).attr('isSubmit')==='true') return false;
		$(form).attr('isSubmit',true);

		var url = 'at.sh';
		form.attr('action' ,url);
		form.attr('target' , "uploadIFrame");

		document.getElementById("uploadIFrame").onload = function() {
			document.location.reload();
		};

		var hasFormData = true;
		
		try{
			new FormData($(form)[0]);
		}catch(e){
			hasFormData = false;
		}
		
		if(!hasFormData){
			form.submit();
			
			return false;
		}
		
        $.ajax({
            url: url,
            type: "POST",
            contentType: false,
            processData: false,
            data: function() {
                return new FormData($(form)[0]);
            }(),
            error: function(_, textStatus, errorThrown) {
				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
    			goPage(PAGENO);
            },
            success: function(response, textStatus) {
    			var data = $.parseJSON(response);
    			//checkFunction(data);
    			if(data.success){
    				if(data.row[0]==0){
    					alert("비밀번호가 틀리거나 본인의 글이 아닙니다.");
    					return false;
    				}
    			}else{
    				alert("처리하는 중 오류가 발생하였습니다. \n문제가 지속되면 관리자에게 문의 하세요.\n" + data.error_message);
    			}
    			goPage(PAGENO);
            }
        });		
		

		return false;
	}
