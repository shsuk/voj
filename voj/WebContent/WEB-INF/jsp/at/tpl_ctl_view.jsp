<%@ page contentType="text/html; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="user" uri="/WEB-INF/tlds/User.tld"%>
<c:set var="view_value">${row[attr.name] }</c:set>
<c:if test="${ui.link[attr.name]!=null }">
	<c:set var="link_info"><uf:tpl src="${ui.link[attr.name]}"/></c:set>
	<c:if test="${!fn:startsWith(link_info,'(') }"><a class="at_link" href="#"><div onclick="${link_info}"></c:if>
</c:if
><c:if test="${read_onlys[attr.name]!=null}">
	<input type="hidden" id="${attr.name}" name="${attr.name}" value="${row[attr.name]}">
</c:if>
<c:set var="value">val="<uf:tpl src="${ui.value[attr.name] }"/>"</c:set>
<c:choose><c:when test="${images[attr.name]!=null}">
		<c:set var="img_path">images/bg_img.png</c:set>
		<c:if test="${row[attr.name]!=null}">
			<c:set var="img_path">at.sh?_ps=at/upload/dl&thum=32&file_id=${row[attr.name]}</c:set>
		</c:if>
		<img style="height:40px;cursor: pointer;" src="${img_path }" ${value } onclick="showImg('${row[attr.name] }', this.src);"/>
	</c:when><c:when test="${files[attr.name]!=null}">
		<a href="at.sh?_ps=at/upload/dl&file_id=${row[attr.name] }" class="at_link">${files[attr.name]==true ? row[attr.name] : row[files[attr.name]] }</a>
	</c:when><c:when test="${hiddens[attr.name]!=null}">
		<input name="${attr.name }" value="${row[attr.name]}" type="hidden" />
	</c:when><c:when test="${attr.name == 'radio'}">
		<center><input type="radio" name="radiobutton" value="${row[attr.name]}"/></center>
	</c:when><c:when test="${attr.name == 'checkbox'}">
		<center><input type="checkbox" name="checkbox" value="${row[attr.name]}"/></center>
	</c:when><c:when test="${code:codeInfo('root', attr.name).edit_type=='icon'}">
		${ui.singleRow ? '' : '<center>'}
		<c:set var="img_id">${code:codeInfo(attr.name, row[attr.name]).code_img_id}</c:set>
		<c:if test="${img_id!=''}">
			<c:set var="img_path">at.sh?_ps=at/upload/dl&thum=32&file_id=${img_id}</c:set>
			<img src="${img_path}" height="16" title="${code:name(attr.name, row[attr.name], lang)}"/>
		</c:if>
		<c:if test="${ui.singleRow || img_id==''}">${code:name(attr.name, row[attr.name], lang)}</c:if>
		${ui.singleRow ? '' : '</center>'}
	</c:when><c:when test="${code:codeInfo('root', attr.name).edit_type=='tree'}">
		<div name="${attr.name }"  ${value } >${code:cName(attr.name,row[attr.name])}</div>
	</c:when><c:when test="${code:list(attr.name)!=null }">
		<c:set var="codeId" >${row[attr.name]}</c:set>
		<c:set var="codeName" value="${code:nameAuto(attr.name, codeId, lang)}"/>
		<div title="${codeId }" style=" ${ui.singleRow || codeName==codeId ? '' : 'text-align:center;' }" name="${attr.name }"  ${value } >${codeName }</div>
	</c:when><c:when test="${attr.type_name == 'NUMBER' && (fn:endsWith(attr.name,'_user_id') || fn:endsWith(attr.name,'_user'))}">
		<div name="${attr.name }"  ${value } >${user:id(row[attr.name]) }</div>
	</c:when><c:when test="${(attr.type_name == 'NUMBER' || attr.type_name == 'int') && (fn:indexOf(attr.name,'_id')>-1 || fn:indexOf(attr.name,'_num')>-1 || fn:indexOf(attr.name,'_no')>-1 || fn:indexOf(attr.name,'rank')>-1)}">
		<c:if test="${attr.name=='rid' }">
			<input name="${attr.name }" value="${row[attr.name]}" type="hidden" />
		</c:if>
		<div style=" ${ui.singleRow ? '' : 'text-align:center;' }"  name="${attr.name }"  ${value } >${row[attr.name]}</div>
	</c:when><c:when test="${attr.type_name == 'NUMBER' || attr.type_name == 'int'}">
		<div style=" ${ui.singleRow ? '' : 'text-align:right;' }"  name="${attr.name }"  ${value } ><fmt:formatNumber value="${row[attr.name]}"   type="number" /></div>
	</c:when><c:when test="${attr.type_name == 'DATE' || attr.type_name == 'datetime'}">
		<div style=" ${ui.singleRow ? '' : 'text-align:center;' }"  name="${attr.name }"  ${value } ><fmt:formatDate value="${row[attr.name]}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
	</c:when><c:when test="${fn:indexOf(attr.name,'date')>-1}">
		<div style=" ${ui.singleRow ? '' : 'text-align:center;' }">${row[attr.name]}</div>
	</c:when><c:when test="${attr.type_name == 'text'}">
		<div style="width: 100%;height: 100px;overflow-x:auto;overflow-y:auto; border:1px solid;">${code:name(attr.name, row[attr.name], lang) }</div>
	</c:when><c:when test="${ui.singleRow && fn:length(view_value) > 100}">
		<textarea name="${attr.name }"  ${value } style="width: 95%; height: 100px; overflow-x:auto;overflow-y:auto; border:1px solid #e0e1e3;" readonly="readonly">${row[attr.name] }</textarea>
	</c:when><c:otherwise>
		<div name="${attr.name }"  ${value } >${row[attr.name] }</div>
</c:otherwise></c:choose>
<c:if test="${ui.link[attr.name]!=null }"><c:if test="${!fn:startsWith(link_info,'(') }"></div></a></c:if></c:if>
