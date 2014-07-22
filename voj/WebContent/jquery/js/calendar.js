$(document).ready(function(){
	$(".datepicker").datepicker({
		dateFormat: 'yy-mm-dd', 
		showMonthAfterYear: true,
		yearSuffix: '년',
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNames: ['일요일','월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
		dayNamesMin: ['일','월', '화', '수', '목', '금', '토'],
		showOn: "both", // focus, button, both
		buttonImage: 'jquery/images/btn_calender.gif',
		buttonImageOnly: true,
		buttonText: "달력",
		showAnim: "drop", // blind, clip, drop, explode, fold, puff, slide, scale, size, pulsate, bounce, highlight, shake, transfer
		showOptions: {direction: 'horizontal'},
		duration: 200
	});
 });

var defaltDate = function(inputName, inputDate){	
	if(inputDate == ""){
		$("#"+inputName).val($.datepicker.formatDate($.datepicker.ATOM, new Date()));
	} else {
		input_date = inputDate.split("-");
		$("#"+inputName).val($.datepicker.formatDate($.datepicker.ATOM, new Date(input_date[0], input_date[1]-1, input_date[2])));		
	}
};

var changeStartDate = function(changeMonth){
	var todayDate = new Date();

	var year = todayDate.getFullYear();
	var month = todayDate.getMonth();
	var day = todayDate.getDate();

	$("#end_date").val($.datepicker.formatDate($.datepicker.ATOM, new Date()));
	$("#start_date").val($.datepicker.formatDate($.datepicker.ATOM, new Date(year, month-changeMonth, day)));

};

/*
		$('.datepicker').datepicker({
			inline: true,
			//disabled: true,
			//appendText: '�낅젰 월2010/01/01',
			dateFormat: 'yy-mm-dd',
			monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
			dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'],
			//gotoCurrent: true,
			//navigationAsDateFormat: true,
			nextText: '다음달',
			prevText: '이전달',
			showButtonPanel: true,
			currentText: '오늘',
			closeText: '닫기',
			//changeMonth: true,
			//changeYear: true,
			showOn: "button",
			buttonImage: "../../kibot/images/kibot/btn_calender.gif",
			buttonImageOnly: true,
			//regional: 'ko',
			//buttonText: 'Choose'
			//showAnim: 'explode',
			autoSize: true
		});
	}); 
 */