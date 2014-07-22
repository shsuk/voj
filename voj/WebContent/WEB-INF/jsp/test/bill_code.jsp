<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="ptu"  tagdir="/WEB-INF/tags/user" %> 
<table>
	<tr>
		<td>
			<input type="text" id="searchProject" onchange="searchBillCode()" value="${req.searchProject }" placeholder="프로젝트 검색">
		</td>
		<td>
			<ptu:select name="project" groupId="project" emptyText="프로젝트 선택" searchValue="${req.searchProject }" selected="${req.project }"/><br>
		</td>
	</tr>
	<tr>
		<td>
			<input type="text" id="searchAccount" onchange="searchBillCode()" value="${req.searchAccount }" placeholder="계정/적요 검색">
		</td>
		<td>
			<ptu:select name="account" groupId="account" emptyText="계정/적요 선택" searchValue="${req.searchAccount }" selected="${req.account }"/>
		</td>
	</tr>
</table>
