String.prototype.replaceAll = function( searchStr, replaceStr )
{
    return this.split( searchStr ).join( replaceStr );
};

var defDateFormat = 'yy-mm-dd';
var xFormat = defDateFormat;
var _hUnit = '';
var _GRAPH_DATA = '';
var _GRAPH_OPT = '';
var tickSize = 'day';
var _xUnit = '';
var _yUnit = '';

var defXFormat = { mode: 'time', minTickSize: [1, tickSize], tickFormatter: dateFormatter};
//예 goGraph('#graph2', source : ${JSON.rows}, opt : {xaxe:'reg_date',yaxes:'app_cnt:앱, etc_cnt:영상', xFormat:'D'})
//xaxe: x축 필드명 
//yaxes: 필드명:라벨 콤마로 분리하여 여러 항목을 표현할 수 있다.
//xFormat : D=날짜, W=요일, T=시간, 기타=단위
function goGraph(selecter, source, opt){
	init();
	var data = opt.type=='pie' ? getPieData(source, opt)  : getData(source, opt);
	_GRAPH_DATA = data;
	_GRAPH_OPT = opt;
	
	if(opt){
		if(opt.type=='pie') graphPie(selecter, data, opt);
		else graphLine(selecter, data, opt);
	}else{
		graphLine(selecter, data, opt);
	}
}

function init(){
	xFormat = defDateFormat;
	_hUnit = '';
	_GRAPH_DATA = '';
	_GRAPH_OPT = '';
	tickSize = 'day';
	_xUnit = '';
	_yUnit = '';
}
function xCntFormatter(v, axis) {
	return v +_xUnit;
	//return v.toFixed(axis.tickDecimals) +_vUnit;
}
function yCntFormatter(v, axis) {
	return v +_xUnit;
	//return v.toFixed(axis.tickDecimals) +_vUnit;
}
var week = ['일','월','화','수','목','금','토','일'];
function weekFormatter(v, axis) {
	if((v%1) > 0) return "";
	return week[v];
}
function timeFormatter(v, axis) {
	return v + '시';
}
function dateFormatter(v, axis) {
	return $.datepicker.formatDate(xFormat ,new Date(v));;
}
function graphLine(selecter,data, opt){
		
	$.plot($(selecter), data,{
		series: {
			lines: {
				show: opt['type'] ? (opt['type']=='stick' ? false : true) : true
			},
			bars: { show: opt['type'] ? (opt['type']=='stick' ? true : false) : false, 
					barWidth: 0.5, 
					fill: 0.9 
			},
			points: { show: true }
		},
		xaxes: [defXFormat ],
		yaxes: [
				{ 
					min: 0 ,
					tickFormatter: yCntFormatter
				}
			],
		legend: { position: 'ne' },
		grid: { hoverable: true }
	});
	$(selecter).bind("plothover", lineHover);
}

function graphPie(selecter, data, opt){
	var graphId = $(selecter);
	if(graphId.length<1) return;
	$(selecter+'_title').text(opt.title);
	$.plot(graphId, data,{
		series: {
			pie: {
				innerRadius: 0.3,
				show: true
			}
		},
		legend: {
			show: false
		},
		grid: {
			hoverable: true
		}
	});
	graphId.bind("plothover", pieHover);
}
function goPie(selecter, idx, title){
	//init();
	var data = [];
	
	for(var i=0;i<_GRAPH_DATA.length; i++){
		var row = _GRAPH_DATA[i];
		data[i] = {data:[row.data[idx]], label:row.label, fld:row.fld};
	}
	_GRAPH_OPT['title'] = title;
	graphPie(selecter, data, _GRAPH_OPT);
}
function pieHover(event, pos, obj) {
	if (!obj) return;
	var percent = parseFloat(obj.series.percent).toFixed(2);
	var div = $('#' + $(event.target).attr('id') + '_hover');
	if(div.length==0){
		div = $('body').append('<div id="' + $(event.target).attr('id') + '_hover" style="position:absolute; z-index:1000000;display:none; background-color: #8C8C8C;border:1px solid #e0e1e3;text-align: left;padding: 3px 3px 3px 3px ;"></div>');
		div = $('#' + $(event.target).attr('id') + '_hover');
	}
	var txt = '<span style="color: '+obj.series.color+'"><b>'+obj.series.label+'</b> : '+obj.series.data[0][1] + ' ' +' ('+percent+'%)</span>';
	div.html(txt);
	div.css('top', pos.pageY-50);
	div.css('left', pos.pageX);
	div.show();
	//$("#hover").html();
}
function lineHover(event, pos, obj) {
	if (!obj) return;
	var idx = obj.dataIndex;
	var data = obj.series.data;
	var date = new Date(data[idx][0]);
	var dt = $.datepicker.formatDate((xFormat=='mm-dd' ? defDateFormat : xFormat), date);
	var div = $('#' + $(event.target).attr('id') + '_hover');
	if(div.length==0){
		div = $('body').append('<div id="' + $(event.target).attr('id') + '_hover" style="position:absolute; z-index:1000000;display:none; background-color: #8C8C8C;border:1px solid #e0e1e3;text-align: left;padding: 3px 3px 3px 3px ;"></div>');
		div = $('#' + $(event.target).attr('id') + '_hover');
	}
	div.html('<span style="color: '+obj.series.color+'"><b>'+obj.series.label+ '</b><br> x : '+ dt + '<br> y : ' +data[idx][1] + '</span>');
	div.css('top', pos.pageY-10);
	div.css('left', pos.pageX+10);
	div.show();
	$('#' + $(event.target).attr('id') + '_hover_title').html('<b>'+dt+'</b>');
	goPie('#' + $(event.target).attr('id') + 'pieGraph', idx, dt);
}
function getData(source, opt){
	var data = [];
	
	var xaxe = opt.xaxe;
	var yaxes = opt.yaxes.split(',');
	_xUnit = opt.xUnit ? opt.xUnit : '';
	_yUnit = opt.yUnit ? opt.yUnit : '';
	
	for (var i=0; i<yaxes.length; i++) {
		if(yaxes[i].trim()=='') continue;
		var yaxesInfo = (yaxes[i]+':').split(':');
		
		data[data.length] = {data:[],label:yaxesInfo[1], fld:yaxesInfo[0].trim()};
	}
	
	for (var n=0; n<source.length; n++) {		
		var row = source[n];
		var x = row[xaxe];
		if(opt.xFormat=='D' && typeof x==='string'){
			var day = x.replaceAll("/", "-").split("-");
			x=new Date();

			if(day.length==1){
				xFormat = 'yy년';
				tickSize = 'year';
				x=new Date(day[0],0,1,9,0,0);
			}else if(day.length==2){
				xFormat = 'yy년mm월';
				tickSize = 'month';
				x=new Date(day[0],day[1]-1,1,9,0,0);
			}else if(day.length==3){
				x=new Date(day[0],day[1]-1,day[2],9,0,0);
				xFormat = 'mm-dd';
				tickSize = 'day';
			}
			x = x.getTime();
		}else if(n>0){
			;
		}else if(opt.xFormat=='T'){
			defXFormat = { 
					min: 0 ,
					max: 24 ,
					tickSize:2,
					tickFormatter: timeFormatter
			};
		}else 	if(opt.xFormat=='W'){
			defXFormat = { 
					min: 0.5 ,
					tickSize:0.5,
					tickFormatter: weekFormatter
				};
		}else{
			defXFormat = { 
				min: 0 ,
				tickSize:1,
				tickFormatter: xCntFormatter
			};
		}

		
		var k = 0;
		for (var i=0; i<yaxes.length; i++) {
			if(yaxes[i].trim()=='') continue;
			var lines = data[k].data;
			var fld = data[k].fld;
			var y = row[fld];
			
			if(y==null) y=0;
			
			lines[lines.length] = [x,y];
			k++;
		}
	}
	
	return data;
}
function getPieData(source, opt){
	var data = [];
	
	var xaxe = opt.xaxe;
	var yaxes = opt.yaxes;
	
	for (var n=0; n<source.length; n++) {		
		var row = source[n];
		data[data.length] = {data:row[yaxes],label: row[xaxe].trim()};
	}

	
	return data;
}