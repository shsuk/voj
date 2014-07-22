<%@ page contentType="text/html; charset=utf-8"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<uf:organism >
[
	<job:requestEnc id="reuestEnc" aes256="pw" />
	<job:db id="rset" query="voj/gal/view" />
]
</uf:organism>
<c:set var="row" value="${rset.row }"/>

<!DOCTYPE html>
<html>
<head>
<title>예수마을교회 :: 신실한 성도. 거룩한 교회. 행복한 공동체.</title>
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1">
<style>
   .bible {}
   .bible div{padding:8px;border-bottom: solid 1px #f6f6f6;line-height:180%; font-size: 18px;  }
   .bible_bg_s{background: #aaaaaa;color: #222222;}

	html, body, #carousel ul, #carousel li {
		min-height: 100%;
		height: 100%;
		padding: 0;
		margin: 0;
		position: relative;
	}
	#carousel {
		min-height: 100%;
		height: 100%;
		padding: 0;
		margin: 0;
		position: relative;
	}

	#carousel {
		background: #888888;
		overflow: hidden;
		width: 100%;
		-webkit-backface-visibility: hidden;
		-webkit-transform: translate3d(0,0,0) scale3d(1,1,1);
		-webkit-transform-style: preserve-3d;
	}

	#carousel ul.animate {
		-webkit-transition: all .3s;
		-moz-transition: all .3s;
		-o-transition: all .3s;
		transition: all .3s;
	}

	#carousel ul {
		-webkit-transform: translate3d(0%,0,0) scale3d(1,1,1);
		-moz-transform: translate3d(0%,0,0) scale3d(1,1,1);
		-ms-transform: translate3d(0%,0,0) scale3d(1,1,1);
		-o-transform: translate3d(0%,0,0) scale3d(1,1,1);
		transform: translate3d(0%,0,0) scale3d(1,1,1);
		overflow: hidden;
		-webkit-backface-visibility: hidden;
		-webkit-transform-style: preserve-3d;
	}

	#carousel ul {
		-webkit-box-shadow: 0 0 20px rgba(0,0,0,.2);
		box-shadow: 0 0 20px rgba(0,0,0,.2);
		position: relative;
	}

	#carousel li {
		float: left;
		vertical-align:middle;
		overflow: hidden;
		-webkit-transform-style: preserve-3d;
		-webkit-transform: translate3d(0,0,0);
	}

	#carousel li h2 {
		color: #fff;
		font-size: 30px;
		text-align: center;
		position: absolute;
		top: 40%;
		left: 0;
		width: 100%;
		text-shadow: -1px -1px 0 rgba(0,0,0,.2);
	}

	#carousel li.pane01 { background: #cd74e6; }
	#carousel li.pane11 { background: #42d692; }
	#carousel li.pane21 { background: #4986e7; }
	#carousel li.pane31 { background: #d06b64; }
	.cc_bt {
	    border: 1px solid #cccccc;
	    border-radius: 3px;
	    box-sizing: border-box;
	    color: #555555;
	    cursor: pointer;
	    display: inline-block;
	    font-size: 12px;
	    line-height: 25px;
	    text-align: center;
	    min-width: 60px;
	}
	table.rep td{border-bottom : 1px solid #cccccc;}
</style>
</head>


<!-- jQuery is just for the demo! Hammer.js works without jQuery :-) -->
<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./js/modernizr.js"></script>
<script src="./js/hammer/hammer.min.2.0.1.js" type="text/javascript" ></script>
<script src="./js/formValid.js" type="text/javascript" ></script>
<script src="./js/commonUtil.js"></script>

<script>
	$(function() {
		var carousel = new Carousel("#carousel", function(){
			changeImg(carousel.getIndex());
		});
		carousel.init();
		
		changeImg(0);
		
		function changeImg(idx){
			var view_img = $('#img'+idx);
			var url = 'at.sh?_ps=at/upload/dl&thum=800&file_id=' + view_img.attr('value');
			view_img.attr('src', url);
			var html = (idx+1) + '/' + $('.images').length;
			$('#gal_info').html(html);
			
		}

		$('div',$('.bible')).click(function(e){
			$(e.currentTarget).toggleClass('bible_bg_s');
		});
		
		changeEmoticon();
	});
	
	/**
	* super simple carousel
	* animation between panes happens with css transitions
	*/
	function Carousel(element, callback)
	{
		var self = this;
		element = $(element);

		var container = $(">ul", element);
		var panes = $(">ul>li", element);

		var pane_width = 0;
		var pane_count = panes.length;

		var current_pane = 0;


		/**
		 * initial
		 */
		this.init = function() {
			setPaneDimensions();

			$(window).on("load resize orientationchange", function() {
				setPaneDimensions();
			});
		};

		this.getIndex = function(){
			return current_pane;
		};
		/**
		 * set the pane dimensions and scale the container
		 */
		function setPaneDimensions() {
			pane_width = element.width();
			panes.each(function() {
				$(this).width(pane_width);
			});
			container.width(pane_width*pane_count);
		};


		/**
		 * show pane by index
		 */
		this.showPane = function(index, animate) {
			// between the bounds
			index = Math.max(0, Math.min(index, pane_count-1));
			current_pane = index;

			var offset = -((100/pane_count)*current_pane);
			setContainerOffset(offset, animate);
			
			if(callback){
				callback();
			}
		};


		function setContainerOffset(percent, animate) {
			container.removeClass("animate");

			if(animate) {
				container.addClass("animate");
			}

			if(Modernizr.csstransforms3d) {
				container.css("transform", "translate3d("+ percent +"%,0,0) scale3d(1,1,1)");
			}
			else if(Modernizr.csstransforms) {
				container.css("transform", "translate("+ percent +"%,0)");
			}
			else {
				var px = ((pane_width*pane_count) / 100) * percent;
				container.css("left", px+"px");
			}
		}

		this.next = function() { 
			this.showPane(current_pane+1, true); 
			//setTimeout(function(){self.showPane(current_pane, true);}, 50);
		};
		this.prev = function() { 
			this.showPane(current_pane-1, true); 
			//setTimeout(function(){self.showPane(current_pane, true);}, 50);
		};


		function handleHammer(ev) {
			// disable browser scrolling
			//ev.gesture.preventDefault();

			switch(ev.type) {
				case 'dragright':
				case 'dragleft':
					// stick to the finger
					var pane_offset = -(100/pane_count)*current_pane;
					var drag_offset = ((100/pane_width)*ev.gesture.deltaX) / pane_count;

					// slow down at the first and last pane
					if((current_pane == 0 && ev.gesture.direction == "right") ||
						(current_pane == pane_count-1 && ev.gesture.direction == "left")) {
						drag_offset *= .4;
					}

					setContainerOffset(drag_offset + pane_offset);
					break;

				case 'swipeleft':
					self.next();
					//ev.gesture.stopDetect();
					break;

				case 'swiperight':
					self.prev();
					//ev.gesture.stopDetect();
					break;

				case 'release':
					// more then 50% moved, navigate
					if(Math.abs(ev.gesture.deltaX) > pane_width/2) {
						if(ev.gesture.direction == 'right') {
							self.prev();
						} else {
							self.next();
						}
					}
					else {
						self.showPane(current_pane, true);
					}
					break;
			}
		}

		new Hammer(element[0], { dragLockToAxis: true }).on("release dragleft dragright swipeleft swiperight", handleHammer);
	}
	function loadRepList(){
		var url = 'at.sh?_ps=voj/gal/viewm_re&gal_id=${req.gal_id}';
		
		$('#rep_list').load(url);
		$('#rep_list').show();
	}
	function save_reply(){	
		var form = $('#reply_form');

		//폼 정합성 체크
		var isSuccess = $.valedForm($('[valid]',form));
		if(!isSuccess) return false;			

		var url = 'at.sh';
		var formData =$(form).serializeArray();
		
		
		$('#rep_list').load(url, formData, function(ee){
			
		});
	}
	
	function del_reply(gal_id, gal_rep_id){
		var target_layer = $('#body_main').parent();
		
		var url = 'at.sh';
		var data = {
				action: 'd',
				_ps: 'voj/gal/viewm_re',
				gal_id: gal_id,
				gal_rep_id: gal_rep_id,
				_layout: 'n',
				pageNo:	'${empty(req.pageNo) ? 1 : req.pageNo}'
		};

		$('#rep_list').load(url, data, function(ee){
			
		});
	}
	function changeEmoticon(){
		var rep_conts = $('.rep_cont');
		var emoticons = $('.emoticon');
		for(var i=0; i<rep_conts.length; i++){
			var item = $(rep_conts[i]);
			var html = item.html();
			
			for(var j=0;j<emoticons.length; j++){
				var em = $(emoticons[j]);
				html = html.replaceAll(em.attr('value'), '<img height="28" style="vertical-align: middle;" src="'+em.attr('src')+'">');
			}
			item.html(html);
		}
	}

</script>

<body>
	<table style="position:fixed;bottom:0; left: 0px; z-index: 100;   background-color: #ffffff;opacity: .35;filter: Alpha(Opacity=35);"><tr>
		<td>
			<div style="font-size: 20px;font-weight: bold;width: 100%">
				<div>
					${row.title } (<span id="gal_info" style="font-size: 14px;"></span>)
					
				</div>
				<a href="/"><img src="./voj/images/log.png" border="0" height="30" style="vertical-align: middle;"></a>
				<span style="color:#2fb9d1;"> 갤러리</span>&nbsp;
				<span class="cc_bt" onclick="loadRepList();"> 댓글(${fn:length(rset.reprows)})</span>
				
			</div>
		</td>
	</tr></table>

	<div id="carousel">
		<ul>
		<c:forEach var="rowl" items="${rset.rows }" varStatus="status">
			<li class="images ${row.ca_name } pane${status.index }" style="overflow:auto;">
				<tp:img id="img${status.index }" file_id="${rowl.file_id}" thum="200"  style="width: 100%;vertical-align:middle;"/>
			</li>
		</c:forEach>
		</ul>
	</div>
 	
 	<div id="rep_list" style="position:absolute; top:0px; padding:5px; display:none; left:0px; width: 90%; height: 90%;overflow: auto;; z-index:1100; background-color: #ffffff;opacity:.85;filter: Alpha(Opacity=85);">
 	</div>
</body>
</html>
