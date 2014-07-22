<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<jsp:include page="voj_layout${mobile}.jsp" />

<uf:organism >[
	<job:db id="rset" query="voj/mc/day_view" singleRow="false" >
		defaultValues:{
			mc_dt:${empty(req.mc_dt) ? uf:getDate('MM-dd') : req.mc_dt }
		}
	</job:db>
	<job:db id="imgRows" query="voj/image"  isCache="true" refreshTime="1"  >
		defaultValues:{
			img_id: 'top_img'
		}
	</job:db>
	<job:db id="pops" query="voj/image" isCache="true" refreshTime="1"  >
		defaultValues:{
			img_id: 'pop'
		}
	</job:db>
]</uf:organism>

<link href="./js/coin-slider/coin-slider-styles.css" rel="stylesheet" type="text/css" />
<script src="./js/coin-slider/coin-slider.min.js"></script>

<script type="text/javascript">
	var isMobile = false;
	
	$(function() {
		$.cookie("bd_add", "${uf:now().time}");
		
		isMobile = ${isMobile};
		
		if(isMobile){
			for(var i=1;i<10; i++){
				var cube = $('.mob_'+i);
				cube.css('margin-bottom','3px');
				$('#body_main').append(cube);
			}

			
			$('.main_body').remove();
		}
		
		if($.cookie("NO_POPUP")){
			
		}else{
			setTimeout(function(){open_popup('popup_win');}, 500);
		}
		
		
		$('div.well p').css({margin:0,padding:0});
		
		var main_img = $('.main_img');
		var main_img_count = main_img.length;
		var main_img_current = 0;

		if(isMobile){
			showMainImage();
			
			setInterval(function () {
				showMainImage();
			}, 8000);
			
		}else{
			$('#coin-slider').coinslider({
				height: 230,
				width: 1000,
				delay: 10000,
				navigation:false
			});

		}
		
		function showMainImage(){
			main_img.hide();
			if(!isMobile) {
				$(main_img[main_img_current]).effect( 'slide', {}, 2000 );
			}
			$(main_img[main_img_current]).show();
			main_img_current = (++main_img_current) % main_img_count; 
		};

		
	});
	
	function main_show(id, trg){
		$('.main_bd').hide();
		$('#'+id).show();
		$('.main_bd_menu').css('color','#cccccc');
		$('b', $(trg)).css('color','#050099');			
	}

	function open_popup(id){
		
		$('#'+id).dialog({
			title: '공지사항',
			autoOpen: false,
			width: isMobile ? '325' : '625',
			resizable:false,
			modal: false,
			close: function( event, ui ) {
				$( "#" + id).hide();
			}
		});

		$( "#" + id).dialog( "open" );
		
	}
	
	function notOpenPopup(){
		var time = new Date();
		var h = time.getHours();
		
		$.cookie("NO_POPUP", "YES",{expires:1});
		$( "#popup_win").dialog( "close" );
	}
</script>

<div id="body_main" style="display: none;">
	
	<c:forEach var="pop" items="${pops }">
		<div id="popup_win" style="display: none;position: relative;" title="${pop.title }">
			<a href="${pop.link_url }">
				<tp:img file_id="${pop.file_id }" thum="${isMobile ? 300 : 600}"/>
			</a>
			<div style="position: absolute;; top:7px;right:10px; z-index: 1000;cursor: pointer;background: #efefef;" onclick="notOpenPopup()">오늘하루 열지않음<input type="checkbox"></div>
		</div>
	</c:forEach>


	<table class="main_body w_100">
		<tr>
			<td colspan="3" valign="top">
				<c:if test="${!isMobile }">
					<div id="coin-slider">
						<c:forEach var="imgRow" items="${imgRows }">
							<tp:img className="main_img" file_id="${imgRow.file_id }" thum="1000"/>
						</c:forEach>
					</div>
				</c:if>
				<c:if test="${isMobile }">
					<div class="main_cube mob_1" style="overflow: hidden;  width: 100%;">
						<c:forEach var="imgRow" items="${imgRows }">
							<tp:img className="main_img" file_id="${imgRow.file_id }" thum="928" style="width:100%; display: none;"/>
						</c:forEach>
					</div>
				</c:if>
				
 			</td>
		</tr>
		<tr>
			<td width="215" valign="top">
				<%//외쪽 시작 %>
			
				<table cellpadding="0" cellspacing="0" align="center" border="0" width="220">
					<tbody><tr>
				     	<td>
							<%//=== 표어 === %>
							<table class="sub_cube mob_2" style="height: 110px;" cellpadding="0" cellspacing="0"  border="0" ><tr>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_left.png') repeat-x"></div></td>
								<td><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_center.png') repeat-x">
						     		<a href="at.sh?_ps=voj/intro/show&id=bow">
										<img style="margin-top:13px;" src="voj/images/layout/bc11.png"  border="0"><br>
										<img style="margin-top:5px;" src="voj/images/layout/bc12.png"  border="0">
									</a>
								</div></td>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_right.png') repeat-x"></div></td>
							</tr></table>
						</td>
					</tr>
					<tr>
				   		<td height="8"></td>
					</tr>
					<tr>
				    	<td>
							<%//=== 예배안내 === %>
							<table class="sub_cube mob_9" style="height: 110px;" cellpadding="0" cellspacing="0"  border="0" ><tr>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_left.png') repeat-x"></div></td>
								<td><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_center.png') repeat-x">
						     		<a href="at.sh?_ps=voj/intro/show&id=chtm">
										<img style="margin-top:20px;" src="voj/images/layout/bc21.png"  border="0"><br>
										<img style="margin-top:10px;" src="voj/images/layout/bc22.png"  border="0">
									</a>
								</div></td>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_right.png') repeat-x"></div></td>
							</tr></table>
						</td>
					</tr>
					<tr>
				   		<td height="8"></td>
					</tr>
					<tr>
				    	<td>
							<%//=== 연락처 === %>
							<table class="sub_cube mob_9" style="height: 110px;" cellpadding="0" cellspacing="0"  border="0" ><tr>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_left.png') repeat-x"></div></td>
								<td><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_center.png') repeat-x">
						     		<a href="at.sh?_ps=voj/intro/show&id=rough">
										<img style="margin-top:20px;" src="voj/images/layout/way_info.png"  border="0">
									</a>
								</div></td>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_right.png') repeat-x"></div></td>
							</tr></table>
						</td>
					</tr>
				</tbody></table>
				<%//외쪽 끝 %>
				
			</td>
			<td valign="top"  style="padding-left: 5px;padding-right: 5px;width:${isMobile ? '0' : '570px'};">
			<%//============================================ 중앙 시작 ============================================%>
				<table cellpadding="0" cellspacing="0" align="center" border="0" width="100%">
					<tbody><tr>
				     	<td colspan="2">
							<%//=== 주일말씀 === %>
							<uf:organism >[
								<job:db id="rows" query="voj/vod/list" >
									defaultValues:{bd_cat: 'sun',listCount:1,pageNo:1}
								</job:db>
							]</uf:organism>
							<table class="main_cube mob_1" style="border:0; width: ${isMobile ? '100%' : '544px'};height: 163px;" cellpadding="0" cellspacing="0"><tr>
								<td width="178">
									<a href="at.sh?_ps=voj/vod/list&bd_cat=sun&vod_id=${vod_id }">
										<div style="width:100%;cursor:pointer;  height:163px; background: url('voj/images/layout/topracecube_left.png') repeat-x"></div>
									</a>
								</td>
								<td><div style="width:100%;height:163px; background: url('voj/images/layout/topracecube_center.png') repeat-x">
									<table style="margin:0 ;padding: 0;width:100%;height:158px; " cellpadding="0" cellspacing="0">
										<tr><td height="47" align="right" colspan="2">
											<img style="border: 0" src="voj/images/layout/bcm.png"  border="0">
										</td></tr>
										<tr>
											<td >
												<table style="margin-top: 0px; ">
													<c:forEach var="row" items="${rows }">
														<tr><td style="width: 70px;"><b>제목</b></td><td><div style=" width: 135px;overflow: hidden; text-overflow : ellipsis;"><nobr><b>${row.title }</b></nobr></div></td></tr>
														<tr><td style="width: 70px;"><b>설교자</b></td><td><b> ${row.preacher }</b></td></tr>
														<tr><td ><b>설교일</b></td><td>${row['wk_dt@yyyy-MM-dd'] }</b></td></tr>
														<tr><td ><b>본문</b></td><td><b> ${row.bible }</b></td></tr>
														<c:set var="vod_id" value="${row.vod_id }"/>
													</c:forEach>	
												</table>
											</td>
											<c:if test="${!isMobile }">
												<td >
													<a href="at.sh?_ps=voj/vod/list&bd_cat=sun&vod_id=${vod_id }">
														<img style="border: 0;margin-top: 17px;" src="voj/images/link.png"  border="0">
													</a>
												</td>
											</c:if>
										</tr>
									</table>
								</div></td>
								<td width="24"><div style="width:100%;height:163px; text-align:center;background: url('voj/images/layout/topracecube_right.png') repeat-x"></div></td>
							</tr></table>
						</td>
					</tr>
					<tr>
				   		<td height="20" colspan="2"></td>
					</tr>
					<tr>
				    	<td>
				    
							<%//=== 교회일정 === %>
							<uf:organism >[
								<job:db id="rows" query="voj/sch/main_list" >
									defaultValues:{listCount:4, start_date: '${uf:getDate('yyyy-MM-dd')}' }
								</job:db>
							]</uf:organism>

							<table class="main_cube mob_8" style="border:0;  width: ${isMobile ? '100%' : '270px'};height: 163px;" cellpadding="0" cellspacing="0" ><tr>
								<td width="27"><div style="width:100%;height:163px; background: url('voj/images/layout/racecube_left.png') repeat-x"></div></td>
								<td><div style="width:100%;height:163px;  background: url('voj/images/layout/racecube_center.png') repeat-x">

									<div style="width:100%;height:96px; overflow:hidden;padding-top: 14px; ">
									<table class="bd main_bd"  style="width:100%;margin:0 ;padding: 0;"  cellpadding="0" cellspacing="0">
										<c:forEach var="row" items="${rows }">
											<tr>
												<td style="padding:2px 3px 3px 3px;font-size: 12px; ">
													<a style="color: black;" href="at.sh?_ps=voj/sch/show&id=${row.bd_id }">${row.title }</a>
												</td>
												<td style="padding:2px 3px 3px 3px;font-size: 12px;width:35px;" align="right">
													${fn:substring(row.bd_key,5,11) }
												</td>
											</tr>
										</c:forEach>
									</table>

									</div>
									<div style="float: right;margin-top: 25px;"><a style="color: black;" href="at.sh?_ps=voj/sch/show"><img src="voj/images/layout/bt_t.png"></a></div>
								</div></td>
								<td width="26"><div style="width:100%;height:163px; text-align:center;background: url('voj/images/layout/racecube_right.png') repeat-x"></div></td>
							</tr></table>

						
						</td>
				    	<td style="padding-left: 4px;">
							<%//=== 갤러리 === %>
							<uf:organism >[
								<job:db id="rows" query="voj/gal/list" >
									defaultValues:{bd_cat: 'voj',listCount:10,pageNo:1}
								</job:db>
							]</uf:organism>
			    
							<table class="main_cube mob_7" style="border:0; width: ${isMobile ? '100%' : '270px'};height: 163px;" cellpadding="0" cellspacing="0" ><tr>
								<td width="27"><div style="width:100%;height:163px; background: url('voj/images/layout/racecube_left.png') repeat-x"></div></td>
								<td><div style="width:100%;height:163px; overflow:hidden; background: url('voj/images/layout/racecube_center.png') repeat-x">

									<div style="width:100%;height:90px; overflow:hidden; padding-top:15px;padding-left:0; ">
										
										<c:forEach var="row" items="${rows }">
											<div style="width:72px;;height:90px; float:left; overflow:hidden;text-align: center;vertical-align: middle;">
												<a href="at.sh?_ps=voj/gal/list&bd_cat=voj&gal_id=${row.gal_id }">
													<tp:img file_id="${row.file_id}" thum="160" style=" border: 1px solid #cccccc; height:100px;;"/>
												</a>
											</div>
										</c:forEach>
										
									</div>
									<div style="float: right;margin-top: 30px;"><a href="at.sh?_ps=voj/gal/list&bd_cat=voj"><img src="voj/images/layout/bt_g.png" border="0"></a></div>
								</div></td>
								<td width="26"><div style="width:100%;height:163px; text-align:center;background: url('voj/images/layout/racecube_right.png') repeat-x"></div></td>
							</tr></table>
						</td>
					</tr>
				 </tbody></table>


			<%//============================================ 중앙 끝 ============================================%>
			</td>
			<td width="215" valign="top">
			
				<table cellpadding="0" cellspacing="0" align="center" border="0" width="220">
					<tbody><tr>
				     	<td>
							<%//=== 맥처인 === %>
							<table class="sub_cube mob_4" style="height: 110px;" cellpadding="0" cellspacing="0"  border="0" ><tr>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_left.png') repeat-x"></div></td>
								<td><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_center.png') repeat-x">
						     		<a href="at.sh?_ps=voj/mc/day_view${isMobile ? 'm' : '' }">
										<img style="margin-top:20px;" src="voj/images/info/mc_info.png"  border="0"><br>
									</a>
								</div></td>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_right.png') repeat-x"></div></td>
							</tr></table>
						</td>
					</tr>
					<tr>
				   		<td height="8"></td>
					</tr>
					<tr>
				    	<td>
							<%//=== 카페 === %>
							<table class="sub_cube mob_5" style="height: 110px;" cellpadding="0" cellspacing="0"  border="0" ><tr>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_left.png') repeat-x"></div></td>
								<td><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_center.png') repeat-x">
						     		<a href="at.sh?_ps=voj/bd/list&bd_cat=cafe">
										<img style="margin-top:20px;" src="voj/images/layout/cafe_info.png"  border="0">
									</a>
								</div></td>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_right.png') repeat-x"></div></td>
							</tr></table>
						</td>
					</tr>
					<tr>
				   		<td height="8"></td>
					</tr>
					<tr>
				    	<td>
							<%//=== 우물가 === %>
							
							<table class="sub_cube mob_4" style="height: 110px;" cellpadding="0" cellspacing="0"  border="0" ><tr>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_left.png') repeat-x"></div></td>
								<td><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_center.png') repeat-x">
									<a href="at.sh?_ps=voj/well/well_list&bd_id=max">	
										<img style="margin-top:20px;" src="voj/images/layout/well_info.png"  border="0">
									</a>
									
								</div></td>
								<td width="18"><div style="width:100%;height:110px; text-align:center;background: url('voj/images/layout/cube_right.png') repeat-x"></div></td>
							</tr></table>
						</td>
					</tr>
				 </tbody></table>
  
			</td>
	
		</tr>
	</table>
</div>

