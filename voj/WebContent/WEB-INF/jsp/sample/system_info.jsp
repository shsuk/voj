<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>

<div style="margin: 5px;"><br>
	<h2>ISLIM 변수사용법 및 제공 정보.</h2>
	<table class="ui-widget ui-widget-content contents-contain" style="width: 100%">
			<td>정보</td>
			<td>값</td>
			<td>사용예</td>
		</tr>
		<tr>
			<td>session</td>
			<td>${session }</td>
			<td>
				@{session.user_id} : islim에서 사용<br>
				${'$'}{session.user_id} : JSTL에서 사용
			</td>
		</tr>
		<tr>
			<td>Request Psaram</td>
			<td>${req }</td>
			<td>
				@{param._ps} : islim에서 사용 (원본 데이타 그대로 반환한다.)<br>
				@{_ps} : islim에서 사용 (가공된 경우 가공된 대로 반환한다.)<br>
				${'$'}{req.user_id} : JSTL에서 사용 (HTML 인코딩 처리하여 반환한다.)
			</td>
		</tr>
	</table>
	<br>
	Request Param 참조<br>
	requestEnc프로세서로 sha256, aes256로 인코딩 또는 암호화 한경우<br>
	<uf:organism desc="사용방법은 다음 URL 참조 at.sh?_ps=admin/test_menu" noException="true">
	[
		<uf:job id="enc" jobId="requestEnc" >
			sha256: ['test']
		</uf:job>
		<uf:job id="test" jobId="set" >
			val:'@{test}'
		</uf:job>
		<uf:job id="param.test" jobId="set" >
			val:'@{param.test}'
		</uf:job>
		<uf:job id="req.test" jobId="set" >
			val:'${req.test}'
		</uf:job>
	]
	</uf:organism>${JSON }
	
	<br>
	<br>
	<font color="red">forEach 사용법 1) forEach에 선언된 한 변수만 반복 하여 반환 한다.</font>
		<br> 
		&lt;uf:job id="rset" jobId="db"  query="sl/app/cont_im_update" forEach="screenshot"  var="sshot" emptySkip="true" />
	<br><br>				
		INSERT INTO ST_CONTENTS_IMAGE (cid, img_id, img_type)
		<br>SELECT @{cid}, file_id, 'scr' 
		<br>FROM ATTACH_TBL 
		<br>WHERE file_id = @{sshot};
		
	<br><br><br>	
	<font color="red">forEach 사용법 2) req.xxx 와 같이 한 경우는 다른 배열도 같이 반복되어 반환 한다.</font>
	<br><br>
		&lt;uf:job id="rset" jobId="db"  query="sl/app/cont_im_main_update" forEach="req.img_type"  var="row" emptySkip="true" />
	<br><br>							
		INSERT INTO ST_CONTENTS_IMAGE (cid, img_id, img_type)
		<br>SELECT @{cid}, file_id, @{row.img_type} 
		<br>FROM ATTACH_TBL 
		<br>WHERE file_id = @{row.img_id};
		
<br><br>				
	<font color="red">여개의 레코드 셋 반환 방법</font>
	<br>				
		&lt;uf:job id="['ssrows','mrows']" jobId="db" query="sl/app/cont_im_list" />

</div>
				
 