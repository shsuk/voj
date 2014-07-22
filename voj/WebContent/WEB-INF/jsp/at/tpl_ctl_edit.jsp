<%@ page contentType="text/html; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<c:if test="${ui.link[attr.name]!=null }">
<c:set var="tabLink"><uf:tpl src="${ui.link[attr.name]}"/></c:set>
<a href="javascript:selectTab(${tabLink })"
></c:if>
<c:set var="edit_type" value="${code:codeInfo('root', attr.name).edit_type}"/>
<c:set var="valid"><uf:tpl src="${colMap[attr.name].valid}"/></c:set>
<c:set var="isReadOnlys" value="${read_onlys2[attr.name]!=null ? 'readonly=\"readonly\"' : '' }"/>
<c:choose><c:when test="${!empty(files[attr.name])}">
	<div style="float: left;margin-top: 5px;"><span class="${attr.name}_info"  src="${img_path }"  name="${attr.name}" valid="[${valid}]"></span></div>
	<div name="${attr.name}" value="${row[attr.name]}" class="attachment" ref_tbl="${ui.id }"  title="파일" end="uploadDefaultEnd" valid="[${valid}]" style="width: 80px;height: 25px;float: left; }" img="at.sh?_ps=at/upload/dl&file_id=${row[attr.name]}"></div>
</c:when><c:when test="${!empty(images[attr.name])}">
	<c:set var="img_path">images/bg_img.png</c:set>
	<c:if test="${row[attr.name]!=null}">
		<c:set var="img_path">at.sh?_ps=at/upload/dl&thum=100&file_id=${row[attr.name]}</c:set>
	</c:if>
	<div style="float: left;"><img class="${attr.name}_info"  style="height:60px; border:1px solid #AAAAAA; cursor: pointer;margin-right: 5px;"  src="${img_path }"  name="${attr.name}" valid="[${valid}]" onclick="showImg('${row[attr.name] }', this.src);"></div>
	<div name="${attr.name}" value="${row[attr.name]}" class="attachment" ref_tbl="${ui.id }" title="사진" end="uploadDefaultEnd"  style="width: 80px;height: 60px;float: left; }" valid="[${valid}]" img="at.sh?_ps=co/upload/dl&file_id=${row[attr.name] }"></div>
</c:when><c:when test="${attr.name == 'rid'}">
	<input type="hidden" id="${attr.name}" name="${attr.name}" value="${row[attr.name] }">${row[attr.name] }
</c:when><c:when test="${attr.name == 'action_button'}">
	<center><div class="del_item" type="${row[attr.name]}" param="<uf:tpl src="${ui.params_delete}"/>">항목 삭제</div></center>
</c:when><c:when test="${!empty(code:list(attr.name))}">
	<c:choose><c:when test="${edit_type=='radio'}">
		<tp:radio name="${attr.name}" groupId="${attr.name}" checked="${row[attr.name]}" valid="[${valid}]"/>
	</c:when><c:when test="${edit_type=='check'}">
		<tp:check name="${attr.name}" groupId="${attr.name}" checked="${row[attr.name]}" valid="[${valid}]"/>
	</c:when><c:otherwise>
		<tp:select name="${attr.name}" groupId="${attr.name}" selected="${row[attr.name]}" emptyText="${code:lang(attr.name, lang, '') }을(를) 선택하세요." className="button-l" style="width:${ui.singleRow ? '200px' : '100px' };"  valid="[${valid}]"/>
	</c:otherwise></c:choose>
</c:when><c:when test="${!empty(edit_type)}">
	<c:choose>
		<c:when test="${edit_type=='query_id1'}">
			<tp:select_query name="${attr.name}" qyeryId="${code:ref('code_mapping', attr.name)}" selected="${row[attr.name]}" valid="[${valid}]" emptyText="${code:lang(attr.name, lang, '') }을(를) 선택하세요." style="width:${ui.singleRow ? '200px' : '100px' };" />
		</c:when>
		<c:when test="${edit_type=='path'}">
			<tp:path name="${attr.name }" value="${row[attr.name] }" valid="[${valid}]"/>
		</c:when>
		<c:when test="${edit_type=='email'}">
				<tp:email name="${attr.name }" value="${row[attr.name] }" valid="[${valid}]"/>
		</c:when>
		<c:when test="${edit_type=='hp'}">
				<tp:hp name="${attr.name }" value="${row[attr.name] }" valid="[${valid}]"/>
		</c:when>
		<c:when test="${code:codeInfo('root', attr.name).edit_type=='tel'}">
				<tp:tel name="${attr.name }" value="${row[attr.name] }" valid="[${valid}]"/>
		</c:when>
		<c:when test="${edit_type=='time'}">
				<tp:time name="${attr.name }" value="${row[attr.name] }" valid="[${valid}]"/>
		</c:when>
	</c:choose>
</c:when><c:when test="${attr.type_name=='DATE' || attr.type_name=='datetime'}">
		<input type="text" id="${attr.name}" name="${attr.name}" value="${uf:formatDate(row[attr.name], 'yyyy-MM-dd')}" ${isReadOnlys } valid="[${valid}]" class="datepicker button-l">
</c:when><c:when test="${attr.type_name=='NUMBER'}">
	<c:set var="def_valid" value="['maxlen:${attr.precision==0 ? '22' : attr.precision }']"/>
		<div class="button-l"><input type="text" id="${attr.name}" name="${attr.name}" value="${row[attr.name]}" ${isReadOnlys } valid="[${def_valid }${empty(valid) ? '' : ','}${valid}]" class="spinner"></div>
</c:when><c:when test="${attr.type_name=='text' || attr.type_name=='CLOB' || (attr.type_name=='VARCHAR2' && attr.precision>500 && attr.name != 'meta_data' || attr.name == 'meta_data' && row['meta_datalen']>500)}">
	<c:set var="def_valid" value="['maxlen:${attr.precision==0 ? '0' : attr.precision }']"/>
	<textarea id="${attr.name}" name="${attr.name}" valid="[${def_valid }${empty(valid) ? '' : ','}${valid}]" ${isReadOnlys } style="width: 95%; height: 100px">${row[attr.name] }</textarea>
</c:when><c:otherwise>
	<c:set var="def_valid" value="['maxlen:${attr.precision==0 ? '22' : attr.precision }']"/>
	<input type="text" id="${attr.name}" name="${attr.name}" value="${row[attr.name] }" ${isReadOnlys } valid="[${def_valid }${empty(valid) ? '' : ','}${valid}]" class="button-l" style="width: ${attr.precision>70 ? '90%' : (ui.singleRow ? '200px' : '100px')};">
</c:otherwise></c:choose>
<c:if test="${ui.link[attr.name]!=null }"></a></c:if>
<c:if test="${ui.edit_comment[attr.name] != null}">
	<c:set var="edit_comment"><uf:tpl src="${ui.edit_comment[attr.name]}"/></c:set>
	<div  class="button-l" style="line-height: 20px;">${edit_comment}</div>
</c:if>
