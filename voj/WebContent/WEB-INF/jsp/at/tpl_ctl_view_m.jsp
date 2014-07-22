<%@ page contentType="text/html; charset=utf-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="user" uri="/WEB-INF/tlds/User.tld"%>
<c:set var="view_value">${row[attr.name] }</c:set>
<c:set var="value">val="<uf:tpl src="${ui.value[attr.name] }"/>"</c:set>
<c:choose><c:when test="${images[attr.name]!=null}">
	<c:set var="img_path">images/bg_img.png</c:set>
	<c:if test="${row[attr.name]!=null}">
		<c:set var="img_path">at.sh?_ps=at/upload/dl&thum=100&file_id=${row[attr.name]}</c:set>
	</c:if>
	<a href="at.sh?_ps=at/view_img&file_id=${row[attr.name] }" data-rel="dialog" data-transition="pop"><img style="height:70px;" src="${img_path }" ${value } /></a>
	</c:when><c:when test="${files[attr.name]!=null}">
		<a href="at.sh?_ps=at/upload/dl&thum=100&file_id=${row[attr.name] }">${row[files[attr.name]] }</a>
	</c:when><c:when test="${hiddens[attr.name]!=null}">
	</c:when><c:when test="${attr.name == 'radio'}">
		<center><input type="radio" name="radiobutton" value="${row[attr.name]}"/></center>
	</c:when><c:when test="${attr.name == 'checkbox'}">
		<center><input type="checkbox" name="checkbox" value="${row[attr.name]}"/></center>
	</c:when><c:when test="${code:codeInfo('root', attr.name).edit_type=='icon'}">
		<span>
			<c:set var="img_id">${code:codeInfo(attr.name, row[attr.name]).code_img_id}</c:set>
			<c:if test="${img_id!=''}">
				<c:set var="img_path">at.sh?_ps=at/upload/dl&thum=32&file_id=${img_id}</c:set>
				<img src="${img_path}" height="16" />${code:name(attr.name, row[attr.name], lang)}
			</c:if>
			<c:if test="${img_id==''}">${code:name(attr.name, row[attr.name], lang)}</c:if>
		</span>
	</c:when><c:when test="${code:codeInfo('root', attr.name).edit_type=='tree'}">
		<span name="${attr.name }"  ${value } >${code:cName(attr.name,row[attr.name])}</span>
	</c:when><c:when test="${code:list(attr.name)!=null }">
		<c:set var="codeId" >${row[attr.name]}</c:set>
		<c:set var="codeName" value="${code:nameAuto(attr.name, codeId, lang)}"/>
		<c:set var="codeImgId" value="${code:codeInfo('root',attr.name)['code_img_id'] }"/>
		<span title="${codeId }" style=" ${ui.singleRow || codeName==codeId ? '' : 'text-align:center;' }" name="${attr.name }"  ${value } ><c:if test="${codeImgId!=null }"><img height="16" src="at.sh?_ps=at/upload/dl&thum=16&file_id=${codeImgId }"></c:if>${codeName}</span>
	</c:when><c:when test="${attr.type_name == 'NUMBER' && (fn:endsWith(attr.name,'_user_id') || fn:endsWith(attr.name,'_user'))}">
		<span name="${attr.name }"  ${value } >${user:id(row[attr.name]) }</span>
	</c:when><c:when test="${(attr.type_name == 'NUMBER' || attr.type_name == 'int') && (fn:indexOf(attr.name,'_id')>-1 || fn:indexOf(attr.name,'_num')>-1 || fn:indexOf(attr.name,'_no')>-1 || fn:indexOf(attr.name,'rank')>-1)}">
		<c:if test="${attr.name=='rid' }">
		</c:if>
		<span style=" ${ui.singleRow ? '' : 'text-align:center;' }"  name="${attr.name }"  ${value } >${row[attr.name]}</span>
	</c:when><c:when test="${attr.type_name == 'NUMBER' || attr.type_name == 'int'}">
		<span style=" ${ui.singleRow ? '' : 'text-align:right;' }"  name="${attr.name }"  ${value } ><fmt:formatNumber value="${row[attr.name]}" type="number" /></span>
	</c:when><c:when test="${attr.type_name == 'DATE' || attr.type_name == 'datetime'}">
		<span style=" ${ui.singleRow ? '' : 'text-align:center;' }"  name="${attr.name }"  ${value } ><fmt:formatDate value="${row[attr.name]}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
	</c:when><c:when test="${fn:indexOf(attr.name,'date')>-1}">
		<span style=" ${ui.singleRow ? '' : 'text-align:center;' }">${row[attr.name]}</span>
	</c:when><c:when test="${attr.type_name == 'text'}">
		<span style="width: 100%;height: 100px;overflow-x:auto;overflow-y:auto; border:1px solid;">${code:name(attr.name, row[attr.name], lang) }</span>
	</c:when><c:when test="${ui.singleRow && fn:length(view_value) > 100}">
		<textarea name="${attr.name }"  ${value } style="width: 95%; height: 100px; overflow-x:auto;overflow-y:auto; border:1px solid #e0e1e3;" readonly="readonly">${row[attr.name]}</textarea>
	</c:when><c:otherwise>
		<span name="${attr.name }"  ${value } >${row[attr.name]}</span>
</c:otherwise></c:choose>
