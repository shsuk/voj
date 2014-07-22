<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<script type="text/javascript">

	$('#__ok_period').button({icons: {primary: "ui-icon-disk"}}).click(function( event ) {
		setPeriodVal();
		try {
			closeCtlWin('${req._field}');//창닫기
		} catch (e) { }
	});
	
	function setPeriodVal(){
		var val = $('input:checked[name=__period_type]').val();

		if(val=='#__period1'){
			$('input#scd_period').val($('#__period1_val').val());
		}else{
			var v3 = $('#__period2_val3').val();
			
			var v = $('#__period2_val1').val() + ',' + $('#__period2_val2').val() + (v3=='' ? '' : ',') + v3;
			$('input#scd_period').val(v);
		}
		
	}
	
	$(function($) {
		try {
			resizeCtlWin('${req._field}',550);//윈도우 사이즈 조절
		} catch (e) { }
		//초기값 설정
		var scd_period = $('input#scd_period').val();
		if(scd_period=='') scd_period = '1';
		var scd_periods = (scd_period+',0,0,').split(',');
		$('#__period1_val').val(scd_periods[0]);
		$('#__period2_val1').val(scd_periods[0]);
		$('#__period2_val2').val(scd_periods[1]);
		$('#__period2_val3').val(scd_periods[2]);
		
		
		$(document).on('change','input[name=__period_type]',function( event ) {
			$('.__period').hide();
			var val = $('input:checked[name=__period_type]').val();
			$(val).show();
		});

		
		if(scd_period.indexOf(',')>0) {
			$('input#__period_type2').trigger('click');
		}else{
			$('input#__period_type1').trigger('click');
		}

	});
</script>
<c:set var="scd_period" value="${fn:split(req.scd_period,',') }"/>
<div>
<table>
	<tr height="100">
		<td>주기 : </td>
		<td></td>
		<td><input type="radio" id="__period_type1" name="__period_type" value="#__period1" ></td>
		<td><label for="__period_type1">시간</label></td>
		<td><input type="radio" id="__period_type2" name="__period_type" value="#__period2" ></td>
		<td><label for="__period_type2">일</label></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
			<div id="__period1" class="__period">
				<input type="text" id="__period1_val" name="__period1_val" value="${scd_period[0] }" style="width: 30px;" class="spinner">분 마다
			</div>
			<div id="__period2" class="__period">
				<select id="__period2_val3" name="__period2_val3" >
					<option value="">매일</option>
					<option value="1">일요일</option>
					<option value="2">월요일</option>
					<option value="3">화요일</option>
					<option value="4">수요일</option>
					<option value="5">목요일</option>
					<option value="6">금요일</option>
					<option value="7">토요일</option>
				</select>
				<input type="text" id="__period2_val1" name="__period2_val1" value="" style="width: 30px;"   class="spinner">시
				<input type="text" id="__period2_val2" name="__period2_val2" value="" style="width: 30px;"   class="spinner">분
			</div>
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td><a id="__ok_period">설정</a></td>
	</tr>
</table>

</div>