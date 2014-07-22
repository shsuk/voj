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
	<job:db id="rset" query="voj/mc/day_view" singleRow="false" >
		defaultValues:{
			mc_dt:${empty(req.mc_dt) ? uf:getDate('MM-dd') : req.mc_dt }
		}
	</job:db>]
</uf:organism>
<!DOCTYPE html>
<html>
<head>
<title>예수마을교회 :: 신실한 성도. 거룩한 교회. 행복한 공동체.</title>
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1">
<style>
   .bible {}
   .bible div{padding:8px;border-bottom: solid 1px #f6f6f6;line-height:180%; font-size: 18px;  }
   .bible_bg_s{background: #aaaaaa;color: #222222;}

	html, body, #carousel, #carousel ul, #carousel li {
		min-height: 100%;
		height: 100%;
		padding: 0;
		margin: 0;
		position: relative;
	}

	#carousel {
		background: #444444;
		color: #cccccc;
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

</style>
</head>


<!-- jQuery is just for the demo! Hammer.js works without jQuery :-) -->
<script src="./jquery/js/jquery-1.9.1.min.js"></script>
<script src="./js/modernizr.js"></script>
<script src="./js/hammer/hammer.min.2.0.1.js" type="text/javascript" ></script>

<script>
	$(function() {
		var carousel = new Carousel("#carousel", function(){
			setTitle(carousel.getIndex());
		});
		carousel.init();
		
		setTitle(0);
		
		function setTitle(idx){
			var html = $('.bible_title', $('.pane' + idx)).html();
			$('#bible_title').html(html);
			
		}
		
		$('#tip').show("slow");
		
		setTimeout(function(){
			$('#tip').hide("slow");
		},3000);
		
		//$('div',$('.bible')).click(function(e){
		//	$(e.currentTarget).toggleClass('bible_bg_s');
		//});
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
						if(Math.abs(ev.gesture.deltaX)<5 && Math.abs(ev.gesture.deltaY)<5){
							$(ev.gesture.target).toggleClass('bible_bg_s');
						}
					}
					break;
			}
		}

		new Hammer(element[0], { dragLockToAxis: true }).on("release dragleft dragright swipeleft swiperight", handleHammer);
	}

</script>

<body>
	<table style="position:fixed;left: 0px; z-index: 100;   background-color: #ffffff"><tr>
		<td>
			<div style="font-size: 20px;font-weight: bold;width: 100%">
				<a href="/"><img src="./voj/images/log.png" border="0" height="30" style="vertical-align: middle;"></a>
				<span style="color:#2fb9d1;"> 맥체인</span>&nbsp;
				<c:set var="day" value="_${rset.rows[0].mc_dt }일"/>
				<c:set var="day" value="${fn:replace(day,'_0','') }"/>
				<c:set var="day" value="${fn:replace(day,'_','') }"/>
				<c:set var="day" value="${fn:replace(day,'-0','-') }"/>
				<a href="at.sh?_ps=${req._ps }&mc_dt=${rset.rows[0].mc_dt }&nevi=b" style="font-size: 24px;"><img src="../images/icon/actions-go-previous-view-icon.png" border="0"></a>
				
				<span style="font-size: 16px;font-weight: bold;color:#f6a400;">${fn:replace(day,'-','월') }(<tp:week m_d="${rset.rows[0].mc_dt }"/>)</span>
				<a href="at.sh?_ps=${req._ps }&mc_dt=${rset.rows[0].mc_dt }&nevi=a" style="font-size: 24px;"><img src="../images/icon/actions-go-next-view-icon.png" border="0"></a>
				<div id="bible_title"></div>
			</div>
		</td>
	</tr></table>
	<div id="tip" style="position:fixed; bottom: 50px; z-index: 100; padding:20px; display: none; background-color: #B2CCFF">
		상하 스크롤이 잘 안될 때에는 클릭 후 잠시 멈추었다가 스크롤 해보세요.
	</div>

	<div id="carousel">
		<ul>
		<c:forEach var="row" items="${rset.rows }" varStatus="status">
			<li class="bible ${row.ca_name } pane${status.index }" style="overflow:auto;">
				<br/><br/><br/>	
			
			
				<div class="bible_title" style="display: none;"><b>${status.index+1 }. ${row.wr_subject }</b></div>
				${row.WR_CONTENT }
			</li>
		</c:forEach>
		</ul>
	</div>
 
</body>
</html>
