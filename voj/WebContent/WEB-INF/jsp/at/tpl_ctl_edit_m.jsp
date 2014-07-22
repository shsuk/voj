<%@ page contentType="text/html; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %>
<c:if test="${ui.link[attr.name]!=null }">
<c:set var="tabLink"><uf:tpl src="${ui.link[attr.name]}"/></c:set>
<a href="javascript:selectTab(${tabLink })"
></c:if>
<c:set var="edit_type" value="${code:codeInfo('root', attr.name).edit_type}"/>
<c:set var="valid"><uf:tpl src="${colMap[attr.name].valid}"/></c:set>
<c:set var="isReadOnlys" value="${read_onlys2[attr.name]!=null ? 'readonly=\"readonly\"' : '' }"/>
<c:choose><c:when test="${files[attr.name]!=null}">
	<div style="float: left;margin-top: 5px;"><span class="${attr.name}_info"  src="${img_path }"  name="${attr.name}" valid="[${valid}]"></span></div>
	<div name="${attr.name}" value="${row[attr.name]}" class="attachment" title="파일" end="uploadDefaultEnd" valid="[${valid}]" style="width: 80px;height: 25px;float: left; }" img="at.sh?_ps=at/upload/dl&file_id=${row[attr.name]}"></div>
</c:when><c:when test="${images[attr.name]!=null}">
	<c:set var="img_path">images/bg_img.png</c:set>
	<c:if test="${row[attr.name]!=null}">
		<c:set var="img_path">at.sh?_ps=at/upload/dl&thum=100&file_id=${row[attr.name]}</c:set>
	</c:if>
	<div style="float: left;"><a href="at.sh?_ps=at/view_img&file_id=${row[attr.name] }" data-rel="dialog" data-transition="pop"><img class="${attr.name}_info"  style="height:60px; border:1px solid #AAAAAA; cursor: pointer;margin-right: 5px;"  src="${img_path }"  name="${attr.name}" valid="[${valid}]" ></a></div>
	<div  name="${attr.name}" value="${row[attr.name]}" ref_tbl="${ui.id }" class="attachment ui-btn ui-shadow ui-btn-corner-all ui-first-child ui-last-child ui-btn-up-c"  title="사진" end="uploadDefaultEnd"  style="width: 150px;height: 30px;float: left; }" valid="[${valid}]" img="at.sh?_ps=co/upload/dl&file_id=${row[attr.name] }"></div>
</c:when><c:when test="${attr.name == 'rid'}">
	<input type="hidden" id="${attr.name}" name="${attr.name}" value="${row[attr.name]}">${row[attr.name] }
</c:when><c:when test="${attr.name == 'action_button'}">
	<center><div class="del_item" type="${row[attr.name]}" param="<uf:tpl src="${ui.params_delete}"/>">항목 삭제</div></center>
</c:when><c:when test="${code:list(attr.name)!=null}">
	<c:choose><c:when test="${edit_type=='radio'}">
		<c:set scope="request" var="group_id" value="${attr.name}"/>
		<c:set scope="request" var="name" value="${attr.name}"/>
		<c:set scope="request" var="selected" value="${row[attr.name]}"/>
		<c:set scope="request" var="att" value=" valid=\"[${valid}]\" "/>
		<jsp:include page="../system/tpl/radio_button_m.jsp"/>
	</c:when><c:when test="${edit_type=='check'}">
		<tp:check name="${attr.name}" groupId="${attr.name}" checked="${row[attr.name]}" valid="[${valid}]"/>
	</c:when><c:otherwise>
		<tp:select name="${attr.name}" groupId="${attr.name}" selected="${row[attr.name]}" emptyText="${code:lang(attr.name, lang, '') }을(를) 선택하세요." attr="data-native-menu=\"false\" className="button-l"  valid="[${valid}]"/>
	</c:otherwise></c:choose>
</c:when><c:when test="${edit_type!=null && edit_type!=''}">
	<c:choose>
		<c:when test="${edit_type=='path'}">
			<c:set var="__path"><uf:tpl src="${code:codeInfo('root', attr.name).reference_value}"/></c:set>
			<input type="text" id="${attr.name }" name="${attr.name }" value="${row[attr.name] }"  valid="[${valid}]" readonly="readonly" class="button-l">
			<div id="path_${attr.name }"  ></div>
			<script type="text/javascript">
/* 			
				function select_${attr.name} (ctl, return_fields){
					var tr = findParent(ctl, "TR");
					var flds = return_fields.split(',');

					for(var i =0; i< flds.length; i++){
						var fs = flds[i].split(':');
						var sf = fs[0].trim();
						var tf = fs.length>1 ? fs[1].trim() : sf;
						
						$('#'+tf).val($('div[name='+sf+']', tr).text().trim());
					}

					$( "#path_${attr.name }" ).dialog( "close" );
				};
 */								
				$(function() {
					
					$('#${attr.name }').click(path_${attr.name }_click);

					function path_${attr.name }_click(){
						$('#path_${attr.name }').load('${__path}', {_field: '${attr.name}'}, function(){

						});
					}
				});
			</script>
		</c:when><c:when test="${edit_type=='email'}">
			<input type="hidden" id="${attr.name }" name="${attr.name }" value="${row[attr.name] }"  valid="[${valid}]" >
			<c:set var="email" value="${fn:split(row[attr.name],'@')}"/>
			<table  style="margin: 0px;padding: 0px;width: 200px"><tr>
				</td><td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${attr.name }1" value="${email[0]}" style="width:100px;" >
				</td><td style="border:0px;padding:0 0 0 0;">
					@
				</td><td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${attr.name }2" value="${email[1]}" style="width:100px;" >
				<td style="border:0px;padding:0 0 0 0;">
					<tp:select name="${attr.name }3" groupId="email" selected="${email[1] }" emptyText="직접입력" className="btn-l"  />
				</td></tr></table>
				<script type="text/javascript">
					$(function() {
						$('[name=${attr.name }1]').keyup(function(){
							$('[name=${attr.name }1]').val($('[name=${attr.name }1]').val());
							changeEmail('#${attr.name }');
						});
						$('[name=${attr.name }2]').keyup(function(){
							$('[name=${attr.name }2]').val($('[name=${attr.name }2]').val());
							changeEmail('#${attr.name }');
						});
						$('[name=${attr.name }3]').change(function(){
							$('[name=${attr.name }2]').val($('[name=${attr.name }3]').val());
							changeEmail('#${attr.name }');
						});
						function changeEmail(id){
							$(id).val($('[name=${attr.name }1]').val()+'@'+$('[name=${attr.name }2]').val());
						}
					});
				</script>
		</c:when><c:when test="${edit_type=='hp'}">
			<input type="hidden" name="${attr.name }" value="${row[attr.name] }"  valid="[${valid}]" >
			<c:set var="hp" value="${fn:split(row[attr.name],'-')}"/>
			<table  style="margin: 0px;padding: 0px;width: 200px"><tr>
				<td style="border:0px;padding:0 0 0 0;">
					<tp:select name="${attr.name }1" groupId="hp" selected="${hp[0]}" style="width:50px;" className="btn-l"  />
				</td><td style="border:0px;padding:0 0 0 0;">
					&nbsp;-&nbsp;
				</td><td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${attr.name }2" value="${hp[1]}" style="width:50px;" valid="['minlen:3']"  maxlength="4">
				</td><td style="border:0px;padding:0 0 0 0;">
					&nbsp;-&nbsp;
				</td><td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${attr.name }3" value="${hp[2]}" style="width:50px;" valid="['minlen:3']"  maxlength="4">
				</td></tr></table>
		</c:when><c:when test="${code:codeInfo('root', attr.name).edit_type=='tel'}">
			<input type="hidden" name="${attr.name }" value="${row[attr.name] }"  valid="[${valid}]" >
			<c:set var="tel" value="${fn:split(row[attr.name],'-')}"/>
			<table  style="margin: 0px;padding: 0px;width: 200px"><tr>
				<td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${attr.name }1" value="${tel[0]}" style="width:50px;" valid="['minlen:2']"  maxlength="4">
				</td><td style="border:0px;padding:0 0 0 0;">
					&nbsp;-&nbsp;
				</td><td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${attr.name }2" value="${tel[1]}" style="width:50px;" valid="['minlen:3']"  maxlength="4">
				</td><td style="border:0px;padding:0 0 0 0;">
					&nbsp;-&nbsp;
				</td><td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${attr.name }3" value="${tel[2]}" style="width:50px;" valid="['minlen:3']"  maxlength="4">
				</td></tr></table>
		</c:when><c:when test="${edit_type=='time'}">
				<script type="text/javascript">
					$(function() {
						$('#${row.meta_id }').change(function(){
							changeDate('#${attr.name}');
						});
						$('#${attr.name}_day').change(function(){
							changeDate('#${attr.name}');
						});
						$('#${attr.name}_hh').change(function(){
							changeDate('#${attr.name}');
						});
						$('#${attr.name}_mm').change(function(){
							changeDate('#${attr.name}');
						});
						$('#${attr.name}_ss').change(function(){
							changeDate('#${attr.name}');
						});
			
						function changeDate(id){
							$(id).val($(id+'_day').val() + ' ' + $(id+'_hh').val() + ':' + $(id+'_mm').val() + ':' + $(id+'_ss').val());
						}
					});
				</script>
				<c:set var="datetime"><fmt:formatDate value="${row[attr.name]}" pattern="yyyy-MM-dd HH:mm:ss" /></c:set>
				<input type="hidden" id="${attr.name}" name="${attr.name}" value="${datetime }">
				<table  style="width: 200px"><tr>
					<c:set var="day_time" value="${datetime}" />
					<c:set var="tim" value="${fn:split(fn:substringAfter(day_time,' '),':')}" />
					<c:set var="day" value="${fn:split(row[attr.name],' ') }" />
					<td style="border:0px;"><input type="text" id="${attr.name}_day" name="${attr.name}_day" value="${day[0]}" ${isReadOnlys } valid="[${valid}]" class="datepicker"></td>
					<td style="border:0px;padding:0 0 0 0;">
						<select id="${attr.name}_hh" name="${attr.name}_hh"  >
						<c:forEach var="idx"  begin="0"  end="24">
							<c:set var="val" value="${uf:leftPad(idx,2,'0') }" />
							<option value="${val}" ${val==tim[0] ? 'selected=selected' : ''}">${val}</option>
						</c:forEach>
						</select>
					</td>
					<td style="border:0px;padding:0 0 0 0;">시</td>
					<td style="border:0px;padding:0 0 0 0;">
						<select id="${attr.name}_mm" name="${attr.name}_mm"  >
						<c:forEach var="idx"  begin="0"  end="59">
							<c:set var="val" value="${uf:leftPad(idx,2,'0') }" />
							<option value="${val}" ${val==tim[1] ? 'selected=selected' : ''}">${val}</option>
						</c:forEach>
						</select>
					</td>
					<td style="border:0px;padding:0 0 0 0;">분</td>
					<td style="border:0px;padding:0 0 0 0;">
						<select id="${attr.name}_ss" name="${attr.name}_ss"  >
						<c:forEach var="idx"  begin="0"  end="59">
							<c:set var="val" value="${uf:leftPad(idx,2,'0') }" />
							<option value="${val }" ${val==tim[2] ? 'selected=selected' : ''}">${val }</option>
						</c:forEach>
						</select>
					</td>
					<td style="border:0px;padding:0 0 0 0;">초</td> ${sec }
				</tr></table>
		</c:when>
	</c:choose>
</c:when><c:when test="${attr.type_name=='DATE' || attr.type_name=='datetime'}">
	<input type="date" id="${attr.name}" name="${attr.name}" value="${uf:formatDate(row[attr.name], 'yyyy-MM-dd')}" ${isReadOnlys } valid="[${valid}]" class="datepicker button-l">
</c:when><c:when test="${attr.type_name=='NUMBER'}">
	<c:set var="def_valid" value="['maxlen:${attr.precision==0 ? '22' : attr.precision }']"/>
	<input type="number" id="${attr.name}" name="${attr.name}" value="${row[attr.name]}" ${isReadOnlys } valid="[${def_valid }${valid=='' ? '' : ','}${valid}]" class="spinner">
</c:when><c:otherwise>
	<c:set var="def_valid" value="['maxlen:${attr.precision==0 ? '22' : attr.precision }']"/>
	<input type="text" id="${attr.name}" name="${attr.name}" value="${row[attr.name] }" ${isReadOnlys } valid="[${def_valid }${valid=='' ? '' : ','}${valid}]" class="button-l" >
</c:otherwise></c:choose>
<c:if test="${ui.link[attr.name]!=null }"></a></c:if>
<c:if test="${ui.edit_comment[attr.name] != null}">
	<c:set var="edit_comment"><uf:tpl src="${ui.edit_comment[attr.name]}"/></c:set>
	<div  class="button-l" style="line-height: 20px;">${edit_comment}</div>
</c:if>
